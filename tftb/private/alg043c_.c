/* 
 * ALG043C_
 * 
 * Type          : MATLAB C-MEX DLL
 * MATLAB-Syntax : [A,FLG] = ALG043C_(X,Y,L,T,N,S,MonHan)
 * Comment       : Short time shift statistics moldule. See function
 *                 ALG043M_ for a detailed description of the algorithm.
 *                 
 */

/* 
 *   Copyright (c) 1999 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 23-Oct-1999
 */

/* include object code */
#pragma use_object argchck

/* include MATLAB library */
#include "matrix.h"  /* matrix structures */
#include "mex.h"     /* mex functions */
#include <math.h>    /* required for SQRT function */

#include "getflops.h"

/* prototype definitions */
void   argIsMatrix(const mxArray *array_pointer,int arg_num);
int    argIsVector(const mxArray *array_pointer,int arg_num);
int    argIsIndex(const mxArray *array_pointer,int arg_num);

/*
 * MATLAB - GATEWAY
 */

void mexFunction(
   int no,       mxArray *po[],
   int ni, const mxArray *pi[])
{
	/* declare flag type */
   enum FlagType { FLAG_UNSET, FLAG_SET };

 	/* input parameter */
   double *Xr, *Xi;    /* signal X real and imag part */
   double *Yr, *Yi;    /* signal Y real and imag part */
   double *L;          /* lag vector */
   double *T;          /* time vector */
   double *Q;          /* window half length vector */
   int S;              /* internal algorithm number (S=-1 is extern) */

   /* definition of flags */
   enum FlagType ComplexCase; /* complex case flag */
   enum FlagType ExtCase;     /* external statistics case */
   enum FlagType MonCase;     /* job monitor requested */
   enum FlagType Xigf, Yigf;  /* flags for artificial imag part */
   enum FlagType NotNaNCase;  /* indicates that no NaN case is expected */
   enum FlagType ComplexOut;  /* complex output flag */

   /* size and dimension parameter */
   int NX, NY;         /* length of X and Y vector */
   int NL;             /* length of the lag vector */
   int NT;             /* size(T,1) */
   int MXQ=0;          /* maximum required window half length */
   double QO=0.0;      /* old window half length */
   int q;              /* current window half length */

   /* miscellaneous */
   int xl, x, y, p;      /* counter and array indices */
   int P, l, t;
   int cc, rc, oc;       /* flops counter */
   double ANr, ANi, ANn; /* normalization factor */
   double XVr, XVi;      /* intermediate values and segment elements */
   double YVr, YVi;
   double Zr, Zi;
   double Z, G;

   /* system constants */
   double SysEps, SysNaN; /* system specific eps and NaN value */

   /* output parameter */
   double *Ar, *Ai;    /* result matrix */
   double *FLG;        /* interrupt flag */

   /* Call MATLAB I/O handling */
   int err_stat;       /* returned error status for MATLAB calls */

   /* calling ALG005M_ (return window vector) */
   mxArray *waop[1];   /* returned window vector */
   mxArray *waip[5];   /* input parameter */
   double *QS, *TQS;   /* current window half and full length */
   double *W;          /* real part of window function */

   /* calling ALG044M_ (external computation) */
   mxArray *eaop[1];   /* returned scalar value */
   mxArray *eaip[5];   /* input parameter */
   double *XSr, *XSi;  /* segment pointer */
   double *YSr, *YSi;  /* segment pointer */

   /* calling job monitor */
   mxArray *jmop[1];    /* output parameter */
   mxArray *jmip[2];    /* input parameter */

   /* initialize system values */
   SysEps=mxGetEps(); SysNaN=mxGetNaN();

   /* check for proper number of arguments */
   if      (ni!=7) mexErrMsgTxt("Wrong number of input arguments.");
   else if (no!=2) mexErrMsgTxt("Wrong number of output arguments.");

   /* set default for real and monitor case */
   ComplexCase=FLAG_UNSET; MonCase=FLAG_UNSET;

   /* set flags for artificial imag parts */
   Xigf=FLAG_UNSET; Yigf=FLAG_UNSET;

   /* check for proper type of input arguments */

   /* X */
   NX=argIsVector(pi[0],1); if (mxIsComplex(pi[0])) ComplexCase=FLAG_SET;
   Xr=mxGetPr(pi[0]); Xi=mxGetPi(pi[0]);

	/* Y */
   NY=argIsVector(pi[1],2); if (mxIsComplex(pi[1])) ComplexCase=FLAG_SET;
   Yr=mxGetPr(pi[1]); Yi=mxGetPi(pi[1]);

   /* check if artificial imag part is necessary */
   if (ComplexCase)
   {
   	if (!mxIsComplex(pi[0]))
      { Xigf=FLAG_SET; Xi=(double *)mxCalloc(NX,sizeof(double)); }
      if (!mxIsComplex(pi[1]))
      { Yigf=FLAG_SET; Yi=(double *)mxCalloc(NY,sizeof(double)); }
   }

   /* L */
   NL=argIsVector(pi[2],3); L=mxGetPr(pi[2]);

   /* T */
	argIsMatrix(pi[3],4); NT=mxGetM(pi[3]); P=mxGetN(pi[3]);
   if (P!=2) mexErrMsgTxt("Wrong size of T argument.");
   T=mxGetPr(pi[3]); Q=T+NT;

	/* N */
   argIsIndex(pi[4],5);

   /* S */
   ExtCase=FLAG_UNSET; S=-1;
   if (mxIsChar(pi[5])) ExtCase=FLAG_SET;
   else S=argIsIndex(pi[5],6);

   /* MonHan */
   if (!mxIsEmpty(pi[6]))
   {
      jmip[0]=pi[6];
      jmip[1]=mxCreateDoubleMatrix(1,1,mxREAL);
      FLG=mxGetPr(jmip[1]); *FLG=1.0;
   	MonCase=FLAG_SET;
   }

   /* determine type of output */
   ComplexOut=((ComplexCase && (S==1 || S==4)) || ExtCase);

   /* create space for output arrays */
   if (ComplexOut) po[0]=mxCreateDoubleMatrix(NL,NT,mxCOMPLEX);
   else 	          po[0]=mxCreateDoubleMatrix(NL,NT,mxREAL);
   po[1]=mxCreateDoubleMatrix(1,1,mxREAL); /* FLG */
   Ar=mxGetPr(po[0]); Ai=mxGetPi(po[0]); FLG=mxGetPr(po[1]);

   /* find the maximum required segment size */
   for (t=0; t<NT; t++)
   {
   	if ((int)Q[t]<1) mexErrMsgTxt("Negative or zero window half length.");
   	if (MXQ<(int)Q[t]) MXQ=(int)Q[t];
   }

   /* initialize window fetch arguments */
   waop[0]=mxCreateDoubleMatrix(1,1,mxREAL);
   waip[4]=mxCreateString("center");
   waip[3]=mxCreateDoubleMatrix(1,1,mxREAL); TQS=mxGetPr(waip[3]); TQS[0]=1.0;
   waip[2]=mxCreateDoubleMatrix(1,1,mxREAL); TQS=mxGetPr(waip[2]);
   waip[1]=mxCreateDoubleMatrix(1,1,mxREAL); QS=mxGetPr(waip[1]);
   waip[0]=pi[4];

   /* prepare I/O handling in external case */
   if (ExtCase)
   {

      /* allocate space for the segment vectors */
   	if (ComplexCase)
   	{
   		eaip[0]=mxCreateDoubleMatrix(1,2*MXQ-1,mxCOMPLEX);
   		eaip[1]=mxCreateDoubleMatrix(1,2*MXQ-1,mxCOMPLEX);
		}
   	else
   	{
   		eaip[0]=mxCreateDoubleMatrix(1,2*MXQ-1,mxREAL);
   		eaip[1]=mxCreateDoubleMatrix(1,2*MXQ-1,mxREAL);
   	}

   	/* assign access to segments */
   	XSr=mxGetPr(eaip[0]); XSi=mxGetPi(eaip[0]);
   	YSr=mxGetPr(eaip[1]); YSi=mxGetPi(eaip[1]);

      /* redirect pointers to window number and string */
      eaip[3]=pi[4]; eaip[4]=pi[5];

   }

   /*
    * MAIN LOOP
    */
   /* scan through all time indices */
   for (t=0; t<NT; t++)
   {

   	/* get current window half length */
      q=(int)Q[t];

      /* check if new window is required */
      if (QO!=Q[t])
      {
      	/* allocate new window function parameters */
         QS[0]=Q[t]; TQS[0]=2*Q[t]-1; QO=Q[t];

         /* eliminate old window */
         mxDestroyArray(waop[0]);

			/* call window fetch function */
         if (q>1)
         {
         	err_stat=mexCallMATLAB(1,waop,5,waip,"alg005m_");
				if (err_stat != 0) mexErrMsgTxt("Cannot access ALG005M_.");
            W=mxGetPr(waop[0]);
         }
         else
         {
         	waop[0]=mxCreateDoubleMatrix(1,1,mxREAL);
            W=mxGetPr(waop[0]);
            W[0]=1.0;
         }

         /* compute normalization weight and normalize */
         Z=0.0; for (l=0; l<2*q-1; l++) Z=Z+W[l];
         for (l=0; l<2*q-1; l++) W[l]=W[l]/Z;

         /* make window accessible externally */
         if (ExtCase) eaip[2]=waop[0];

      }

   	/* scan through all lag indices */
   	for (l=0; l<NL; l++)
      {

         /* find segment start index for current window */
         xl=((int)T[t])-q;

			/* check for internal or external case */
         if (ExtCase)
         {

         	/* EXTERNAL CASE */

            /* copy segment into argument vectors */
            for (p=0; p<2*q-1; p++)
            {

             	x=xl+p; y=x-(int)L[l];
               XVr=0.0; YVr=0.0; XVi=0.0; YVi=0.0;

               /* get value from X segment */
               if (x>=0 && x<NX)
               { XVr=Xr[x]; if (ComplexCase) XVi=Xi[x]; }

               /* get value from Y segment */
               if (y>=0 && y<NY)
               { YVr=Yr[y]; if (ComplexCase) YVi=Yi[y]; }

               XSr[p]=XVr; YSr[p]=YVr;
               if (ComplexCase) { XSi[p]=XVi; YSi[p]=YVi; }

            }

            /* call external evaluation function */
            err_stat=mexCallMATLAB(1,eaop,5,eaip,"alg044m_");
				if (err_stat != 0) mexErrMsgTxt("Cannot access ALG044M_.");

            /* read out result */
            Ar[t*NL+l]=*mxGetPr(eaop[0]);
            if (ComplexCase && mxIsComplex(eaop[0]))
            	Ai[t*NL+l]=*mxGetPi(eaop[0]);

            /* clear result from memory */
            mxDestroyArray(eaop[0]);

         }
         else
         {

         	/* INTERNAL CASE */

            /* reset normalization factor accumulators */
            ANr=0.0; ANi=0.0; ANn=0.0; NotNaNCase=FLAG_SET;

            /* check if SMDF normalization factor is needed */
            if (S==3 || S==5)
            {
            	/* compute SMDF normalization factor */
            	for (p=0; p<2*q-1; p++)
            	{
                  /* get indices to X and Y segment */
               	x=xl+p; y=x-(int)L[l];
               	XVr=0.0; YVr=0.0; XVi=0.0; YVi=0.0;

               	/* get value from X segment */
               	if (x>=0 && x<NX)
               	{ XVr=Xr[x]; if (ComplexCase) XVi=Xi[x]; }

               	/* get value from Y segment */
               	if (y>=0 && y<NY)
               	{ YVr=Yr[y]; if (ComplexCase) YVi=Yi[y]; }

                  /* accumulate into normalization factor */
                  if (ComplexCase)
                  {
                  	ANr=ANr+W[p]*(XVr*YVr+XVi*YVi);
                     ANi=ANi+W[p]*(XVi*YVr-XVr*YVi);
                     ANn=ANn+W[p]*(YVr*YVr+YVi*YVi);
                  }
                  else
                  {
                     ANr=ANr+W[p]*XVr*YVr;
                     ANn=ANn+W[p]*YVr*YVr;
                  }
               }

               /* check for NaN case*/
               if (fabs(ANn)<SysEps)
               {
               	/* NaN case */
                  NotNaNCase=FLAG_UNSET;
               }
               else
               {
                  /* Normalize in non-NaN case */
                  ANr=ANr/ANn; ANi=ANi/ANn;
               }

            } /* end of SMDF normalization factor check */

            /* reset accumulators */
            Zr=0.0; Zi=0.0; if (!NotNaNCase) { Zr=SysNaN; Zi=Zr; }

            /* compute result only if not NaN case */
            if (NotNaNCase)
            {

            /* scan through entire window */
            for (p=0; p<2*q-1; p++)
            {

             	x=xl+p; y=x-(int)L[l];
               XVr=0.0; YVr=0.0; XVi=0.0; YVi=0.0;

               /* get value from X segment */
               if (x>=0 && x<NX)
               { XVr=Xr[x]; if (ComplexCase) XVi=Xi[x]; }

               /* get value from Y segment */
               if (y>=0 && y<NY)
               { YVr=Yr[y]; if (ComplexCase) YVi=Yi[y]; }

               /* check on algorithm */
               switch (S) {

               case 0 :						/* AMDF */
                  if (ComplexCase)
                  {
                  	Z=XVr-YVr; Z=Z*Z; G=XVi-YVi; G=G*G;
                     Zr=Zr+W[p]*sqrt(Z+G);
                  }
                  else
                  {
                     Z=XVr-YVr; if (Z<0) Z=-Z; Zr=Zr+W[p]*Z;
                  }
               	break;

               case 1 :						/* XCORR */
                  if (ComplexCase)
                  {
                  	Zr=Zr+W[p]*(XVr*YVr+XVi*YVi);
                     Zi=Zi+W[p]*(XVi*YVr-XVr*YVi);
                  }
                  else
                  {
                  	Zr=Zr+W[p]*XVr*YVr;
                  }
                  break;

               case 2 :						/* SMDF */
                  if (ComplexCase)
                  {
                  	Z=XVr-YVr; Z=Z*Z; G=XVi-YVi; G=G*G;
                     Zr=Zr+W[p]*(Z+G);
                  }
                  else
                  {
                     Z=XVr-YVr; Z=Z*Z; Zr=Zr+W[p]*Z;
                  }
               	break;

               case 3 :						/* Normalized SMDF */
                  if (ComplexCase)
                  {
                  	Z=XVr-ANr*YVr+ANi*YVi; Z=Z*Z;
                     G=XVi-ANr*YVi-ANi*YVr; G=G*G;
                     Zr=Zr+W[p]*(Z+G);
                  }
                  else
                  {
                     Z=XVr-ANr*YVr; Z=Z*Z; Zr=Zr+W[p]*Z;
                  }
               	break;

            	case 4 :						/* Normalized XCORR */
                  if (ComplexCase)
                  {
                  	Zr=Zr+W[p]*(XVr*YVr+XVi*YVi);
                     Zi=Zi+W[p]*(XVi*YVr-XVr*YVi);
                     ANn=ANn+W[p]*(XVr*XVr+XVi*XVi);
                  }
                  else
                  {
                  	Zr=Zr+W[p]*XVr*YVr;
                     ANn=ANn+W[p]*XVr*XVr;
                  }
                  break;

               case 5 :						/* Normalized AMDF */
                  if (ComplexCase)
                  {
                  	Z=XVr-ANr*YVr+ANi*YVi; Z=Z*Z;
                     G=XVi-ANr*YVi-ANi*YVr; G=G*G;
                     Zr=Zr+W[p]*sqrt(Z+G);
                  }
                  else
                  {
                     Z=XVr-ANr*YVr; if (Z<0) Z=-Z; Zr=Zr+W[p]*Z;
                  }
               	break;

               } /* end of switch (S) */

            } /* end of scan through window */

            } /* end of not NaN case check */

            /* check if XCORR normalization factor is needed */
            if (S==4)
            {
               /* check for NaN case*/
               if (fabs(ANn)<SysEps)
               {
               	/* NaN case */
                  Zr=SysNaN; Zi=SysNaN;
               }
               else
               {
               	/* regular case */
                  Zr=Zr/ANn; Zi=Zi/ANn;
               }

            } /* end of XCORR normalization factor check */

            /* save result */
            Ar[t*NL+l]=Zr; if (ComplexOut) Ai[t*NL+l]=Zi;

            /* update the flops counter */
            cc=0; rc=0; oc=0;
            switch (S) {
            case 0 : cc=8;  rc=3;  oc=0; break;
            case 1 : cc=10; rc=3;  oc=0; break;
            case 2 : cc=7;  rc=4;  oc=0; break;
            case 3 : cc=28; rc=11; oc=2; break;
            case 4 : cc=15; rc=6;  oc=2; break;
            case 5 : cc=29; rc=10; oc=2; break; }
            if (ComplexCase) mexAddFlops(cc*(2*q-1)+oc);
            else             mexAddFlops(rc*(2*q-1)+oc);

         }
      }

      /* call the job monitor */
      if (MonCase)
      {
			err_stat=mexCallMATLAB(1,jmop,2,jmip,"job_mon");
      	if (err_stat != 0) mexErrMsgTxt("Cannot access job_mon.");
         *FLG=*mxGetPr(jmop[0]); mxDestroyArray(jmop[0]);
      }

      /* check for interrupt case */
      if (*FLG != 0.0) break;

   }
   /*
    * END OF MAIN LOOP
    */

   /* clean up allocated matrices */

   /* do not destroy waip[0] here! */
   mxDestroyArray(waip[1]);
   mxDestroyArray(waip[2]);
   mxDestroyArray(waip[3]);
   mxDestroyArray(waip[4]);
   mxDestroyArray(waop[0]);

   if (ExtCase)
   {
   	mxDestroyArray(eaip[0]);
   	mxDestroyArray(eaip[1]);
   }

   if (MonCase) mxDestroyArray(jmip[1]);

   if (Xigf) mxFree(Xi);
   if (Yigf) mxFree(Yi);

   /* return to MATLAB */
   return;
}

/*
 * END OF MATLAB - GATEWAY
 */

