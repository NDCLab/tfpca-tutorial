/*
 * ALG023CX
 *
 * Type          : MATLAB C-MEX DLL
 * MATLAB-Syntax : (see alg023cx.m)
 * Comment       : short time statistics obtained from a scalar signal - can
 *                 be used for direct segmentation mapping (FL=0), or other
 *                 statistics (FL=1...9) to evaluate stats functions
 *                 ALG024M1 to ALG024M9 - note the special syntax of ALG024M1
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 26-Oct-1998
 */

/* include object code */
#pragma use_object argchck
#pragma use_object getflops

/* include MATLAB library */
#include "matrix.h"  /* matrix structures */
#include "mex.h"     /* mex functions */

#include "getflops.h"


/* prototype definitions */
int    argIsVector(const mxArray *array_pointer,int arg_num);
double argIsScalar(const mxArray *array_pointer,int arg_num);
int    argIsIndex(const mxArray *array_pointer,int arg_num);

/* get flops from MATLAB */
double mexGetFlops(void);

/*
 * MATLAB - GATEWAY
 */

void mexFunction(
   int no,       mxArray *po[],
   int ni, const mxArray *pi[])
{
	/*
	 * variable and array declarations
	 */

   /* declare flag type */
    enum FlagType { FLAG_UNSET, FLAG_SET };

 	/* input parameter */
    double *si, *sr;	/* signal real and imag part */
    int N;				/* signal length */
	 int L;				/* segment length */
	 int K;				/* time-subsampling */
    int R;				/* segment number */
    int FL;				/* stats type */
    int TI;				/* timer parameter */
    double MonHandle;/* monitor handle */
    double Units;		/* job monitor units */

    enum FlagType JobMon;	/* job monitor flag */

	/* output parameter */
	 double *ar, *ai;	/* output array */
	 double *er;	  	/* error flag */

   /* computation parameter */
    int D,J;			/* size of output array */
    int m,n;			/* segment/sample counter */
    double *xr, *xi;	/* auxiliary vectors */
    double *yr, *yi;	/* auxiliary vectors */
    double CF;			/* complex output flag */

    enum FlagType ComplexCase;   /* complex case flag */
    enum FlagType ComplexOutput; /* complex output flag */

   /* statistics function call parameter */
    int stret;       /* CallMATLAB return value */
    mxArray *stop[3];/* CallMATLAB output parameter */
    mxArray *stip[3];/* CallMATLAB input parameter */

   /* job monitor parameter */
    int jmret;       /* CallMATLAB return value */
	 mxArray *jmop[1];/* CallMATLAB output parameter */
    mxArray *jmip[2];/* CallMATLAB input parameter */
    double *ax;      /* auxiliary pointer */
    double CurFlo;   /* current number of flops */

   /* check for proper number of arguments */
    if     (ni!=10) mexErrMsgTxt("Wrong number of input arguments.");
    else if (no!=2) mexErrMsgTxt("Wrong number of output arguments.");

   /* check for proper type of input arguments */
    N=argIsVector(pi[0],1);
    L=argIsIndex(pi[1],2);
    K=argIsIndex(pi[2],3);
    R=argIsIndex(pi[3],4);
    FL=argIsIndex(pi[4],5);
    TI=argIsIndex(pi[7],8);
    MonHandle=argIsScalar(pi[8],9);
    Units=argIsScalar(pi[9],10);

   /* check for empty signal */
    if (N==0) mexErrMsgTxt("Empty signal parameter.");

   /* check for complex or real case */
	 if (mxIsComplex(pi[0]))
         ComplexCase=FLAG_SET;
    else ComplexCase=FLAG_UNSET;

   /* get pointer to input arrays */
    si=mxGetPi(pi[0]); sr=mxGetPr(pi[0]);

   /* check for non-valid parameters */
    if (L<1) L=1; if (K<1) K=1; if (R<1) R=1;

   /* set flag parameter */
    if (TI==1) JobMon=FLAG_SET;
    else			JobMon=FLAG_UNSET;

   /* set current number of flops */
    CurFlo=mexGetFlops();

	/* check for sufficient signal length */
	 if (N<((R-1)*K+L)) mexErrMsgTxt("Signal too short.");

   /* set error control parameter */
    po[1]=mxCreateDoubleMatrix(1,1,mxREAL);
    er=mxGetPr(po[1]); *er=0.0; /* default return value */

	/* check for return number of calls case */
    if (TI==2) {
   		po[0]=mxCreateDoubleMatrix(1,1,mxREAL);
   		ar=mxGetPr(po[0]);
         *ar=(double)R;
         return; /* return to MATLAB */
    }

   /* allocate job monitor call parameters */
    jmip[0]=mxCreateDoubleMatrix(1,1,mxREAL);
    ax=mxGetPr(jmip[0]); *ax=MonHandle;
    jmip[1]=mxCreateDoubleMatrix(1,1,mxREAL);
    ax=mxGetPr(jmip[1]); *ax=Units;

   /* allocate statistics function parameter */
    if (ComplexCase) stip[0]=mxCreateDoubleMatrix(1,L,mxCOMPLEX);
    else             stip[0]=mxCreateDoubleMatrix(1,L,mxREAL);
    xr=mxGetPr(stip[0]); xi=mxGetPi(stip[0]);
    xr[0]=1.0; if (ComplexCase) xi[0]=1.0;
    stip[1]=mxDuplicateArray(pi[6]);
    stip[2]=mxDuplicateArray(pi[5]);

	/* set default value for complex output */
    ComplexOutput=FLAG_SET;

	/* compute size of output array */

    if (FL == 0) {
     /* output dimensions for FL=0 are fixed */
	   D=L; ComplexOutput=ComplexCase;
    }

    if (FL == 1) {
     /* call ALG024M1 for output dimensions */
	   stret=mexCallMATLAB(3,stop,3,stip,"alg024m1");
      if (stret != 0) mexErrMsgTxt("Cannot access alg024m1.");
      /* length of output vector */
      *er=*mxGetPr(stop[2]);
      if (*er != 0.0) { D=1; mexWarnMsgTxt("Invalid evaluation."); }
      else              D=argIsVector(stop[0],0);
      /* complex or real output? */
      CF=argIsScalar(stop[1],0);
      if (CF == 0.0) ComplexOutput=FLAG_UNSET;
      /* remove arrays */
      mxDestroyArray(stop[0]);
      mxDestroyArray(stop[1]);
      mxDestroyArray(stop[2]);
    }

    if (FL > 1) {
      switch (FL) {
      	case 2: stret=mexCallMATLAB(2,stop,2,stip,"alg024m2"); break;
      	case 3: stret=mexCallMATLAB(2,stop,2,stip,"alg024m3"); break;
      	case 4: stret=mexCallMATLAB(2,stop,2,stip,"alg024m4"); break;
      	case 5: stret=mexCallMATLAB(2,stop,2,stip,"alg024m5"); break;
      	case 6: stret=mexCallMATLAB(2,stop,2,stip,"alg024m6"); break;
      	case 7: stret=mexCallMATLAB(2,stop,2,stip,"alg024m7"); break;
      	case 8: stret=mexCallMATLAB(2,stop,2,stip,"alg024m8"); break;
      	case 9: stret=mexCallMATLAB(2,stop,2,stip,"alg024m9"); break;
			default: mexErrMsgTxt("Illegal flag parameter.");
	 	}
	   if (stret != 0) mexErrMsgTxt("Cannot access alg024m[x].");
      /* length of output vector */
      D=argIsVector(stop[0],0);
      /* complex or real output? */
      CF=argIsScalar(stop[1],0);
      if (CF == 0.0) ComplexOutput=FLAG_UNSET;
      /* remove arrays */
      mxDestroyArray(stop[0]);
      mxDestroyArray(stop[1]);
    }

   /* allocate space for output array */
    if (ComplexOutput) {
    		po[0]=mxCreateDoubleMatrix(D,R,mxCOMPLEX);
    			ai=mxGetPi(po[0]);
    			ar=mxGetPr(po[0]);
    	} else {
			po[0]=mxCreateDoubleMatrix(D,R,mxREAL);
    			ai=NULL;
    			ar=mxGetPr(po[0]);
    	}

   /* check for zero dimension */
    if (D < 1) { *er=2.0; mexWarnMsgTxt("Invalid evaluation."); }

	/*
    * scan through each segment
    ***************************************************************
    */
    if (*er == 0.0)
    for (m=0; m<R; m++) {

     /* process according to flag */

     /* direct segmentation mapping */
     if (FL == 0) {
		for (n=0; n<L; n++) { ar[m*L+n]=sr[m*K+n];
         if (ComplexOutput) ai[m*L+n]=si[m*K+n];
      }
     }

     /* custom external statistics */
     if (FL == 1) {
      /* move values into input argument */
      for (n=0; n<L; n++) { xr[n]=sr[m*K+n];
           if (ComplexCase) xi[n]=si[m*K+n]; }
      /* call stats function */
      stret=mexCallMATLAB(3,stop,3,stip,"alg024m1");
      if (stret != 0) mexErrMsgTxt("Cannot access alg024m1.");
      /* check for error */
      *er=*mxGetPr(stop[2]);
      if (*er != 0.0) mexWarnMsgTxt("Invalid evaluation.");
      else { /* check for consistent output dimension */
             J=argIsVector(stop[0],0);
             if (D == J) { /* copy result into output array */
                           yr=mxGetPr(stop[0]); yi=mxGetPi(stop[0]);
                           for (n=0; n<D; n++) { ar[m*D+n]=yr[n];
                              if ((ComplexOutput)&&(mxIsComplex(stop[0])))
                                                 ai[m*D+n]=yi[n]; }
                         }
             else { *er=2.0; mexWarnMsgTxt("Invalid evaluation."); }
      }
      /* remove arrays */
      mxDestroyArray(stop[0]);
      mxDestroyArray(stop[1]);
      mxDestroyArray(stop[2]);
     }

     /* fixed statistics */
     if (FL > 1) {
      /* move values into input argument */
      for (n=0; n<L; n++) { xr[n]=sr[m*K+n];
           if (ComplexCase) xi[n]=si[m*K+n]; }
      /* call stats function */
      switch (FL) {
      	case 2: stret=mexCallMATLAB(1,stop,2,stip,"alg024m2"); break;
         case 3: stret=mexCallMATLAB(1,stop,2,stip,"alg024m3"); break;
         case 4: stret=mexCallMATLAB(1,stop,2,stip,"alg024m4"); break;
         case 5: stret=mexCallMATLAB(1,stop,2,stip,"alg024m5"); break;
         case 6: stret=mexCallMATLAB(1,stop,2,stip,"alg024m6"); break;
         case 7: stret=mexCallMATLAB(1,stop,2,stip,"alg024m7"); break;
         case 8: stret=mexCallMATLAB(1,stop,2,stip,"alg024m8"); break;
         case 9: stret=mexCallMATLAB(1,stop,2,stip,"alg024m9"); break;
		} /* end of switch (FL) */
      if (stret != 0) mexErrMsgTxt("Cannot access alg024m[x].");
      /* copy result into output array */
      yr=mxGetPr(stop[0]); yi=mxGetPi(stop[0]);
      for (n=0; n<D; n++) {                           ar[m*D+n]=yr[n];
         if ((ComplexOutput)&&(mxIsComplex(stop[0]))) ai[m*D+n]=yi[n]; }
      /* remove output array */
      mxDestroyArray(stop[0]);
     }  /* end of if (FL > 1) */

     /* check for evaluation error */
     if (*er != 0.0) break;

     /* call timer function */
     if (JobMon) {

          if (Units==0.0) {
          		/* return number of flops as units */
               *ax=mexGetFlops()-CurFlo;
               CurFlo=mexGetFlops();
          }
          jmret=mexCallMATLAB(1,jmop,2,jmip,"job_mon");
          if (jmret != 0) mexErrMsgTxt("Cannot access job_mon.");
          *er=*mxGetPr(jmop[0]); mxDestroyArray(jmop[0]);
     }

     /* check for interrupt */
      if (*er != 0.0) break;

    }
   /*
    * end of scan through each segment
    ***************************************************************
    */

    /* clean up */
    mxDestroyArray(jmip[0]);
    mxDestroyArray(jmip[1]);
    mxDestroyArray(stip[0]);
    mxDestroyArray(stip[1]);
    mxDestroyArray(stip[2]);

   /* return to MATLAB */
	 return;
}

/*
 * END OF MATLAB - GATEWAY
 */

