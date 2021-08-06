/*
 * ALG001C_
 *
 * Type          : MATLAB C-MEX DLL
 * MATLAB-Syntax : (see alg001c_.m)
 * Comment       : local autocorrelation function computation for full- and
 *                 half outer product tables - post averaging with window -
 *                 job monitoring - flops prediction
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 01-Sep-1998
 */

/* include object code */
#pragma use_object argchck
#pragma use_object average
#pragma use_object getflops

/* include MATLAB library */
#include "matrix.h"  /* matrix structures */
#include "mex.h"     /* mex functions */
#include <stdlib.h>  /* standard library */

#include "getflops.h"

/*
 * prototype definitions
 */

/* argchck functions */
int    argIsVector(const mxArray *array_pointer,int arg_num);
int     argIsIndex(const mxArray *array_pointer,int arg_num);
double argIsScalar(const mxArray *array_pointer,int arg_num);

/* average functions */
void Average(double *ar, double *vr, double *wr, int R, int M, int W);
void AverageCx(double *ar, double *ai, double *vr, double *vi,
               double *wr, int R, int M, int W);

/* get flops from MATLAB */
double mexGetFlops(void);

/* auxiliary functions */
int IsOdd(int m);
void FullAuto(double *sr, double *ar, int m, int N, int K, int A);
void FullAutoCx(double *sr, double *si, double *ar, double *ai,
                double *pl, double *mi, int m, int N, int K, int A);

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
    double *si, *sr;		 /* signal real and imag part */
	 int L;					 /* maximum lag */
	 int K;					 /* time-subsampling */
    int H;					 /* lag-subsampling */
    int M;					 /* window shift */
	 double *wr;			 /* averaging window */
    int RD;              /* array lag dimension */
    enum FlagType JobMon;/* job monitor flag */
    int tim;				 /* timer parameter */
    double MonHandle;    /* monitor handle */
    double Units;        /* job monitor units */

	/* output parameter */
	 double *vr, *vi;		 /* averaged acf array */
	 double *er;			 /* error flag */

    /* computation parameter */
    int N, P, Q, W, R;	 /* signal-, acf-, lag-, window, resulting-length */
    int Y, m, j;		    /* true signal length, lag-, misc-, loop-counter */
    double *ai, *ar;		 /* acf real and imag part */
    double *pl, *mi;		 /* auxiliary vectors for complex case */

    enum FlagType ComplexCase;/* complex case flag */
    enum FlagType FullOuter;	/* full outer product flag */

	/* job monitor parameter */
    int jmret;           /* CallMATLAB return value */
	 mxArray *jmop[1];    /* CallMATLAB output parameter */
    mxArray *jmip[2];    /* CallMATLAB input parameter */
    double *ax;          /* auxiliary pointer */
    double CurFlo;       /* current number of flops */

   /* check for proper number of arguments */
    if      (ni!=10) mexErrMsgTxt("Wrong number of input arguments.");
    else if (no!=2)  mexErrMsgTxt("Wrong number of output arguments.");

   /* check for proper type of input arguments */
    N=argIsVector(pi[0],1);
    L=argIsIndex(pi[1],2);
    K=argIsIndex(pi[2],3);
    H=argIsIndex(pi[3],4);
    M=argIsIndex(pi[4],5);
    W=argIsVector(pi[5],6);
    RD=argIsIndex(pi[6],7);
    tim=argIsIndex(pi[7],8);
    MonHandle=argIsScalar(pi[8],9);
    Units=argIsScalar(pi[9],10);

   /* check for empty signal and window */
    if (N==0) mexErrMsgTxt("Empty signal parameter.");
    if (W==0) mexErrMsgTxt("Empty window parameter.");

   /* check for complex or real case */
	 if (mxIsComplex(pi[0]))
         ComplexCase=FLAG_SET;
    else ComplexCase=FLAG_UNSET;

   /* get pointer to input arrays */
    si=mxGetPi(pi[0]);
    sr=mxGetPr(pi[0]);
    wr=mxGetPr(pi[5]);

   /* check for non-valid parameters */
    if (L<1) L=1; if (K<1) K=1; if (H<1) H=1; if (M<1) M=1;

   /* check for half outer product or full outer product case */
    Y=N; FullOuter=FLAG_UNSET;
    if (IsOdd(H)) { Y=(int)((N+1)/2); FullOuter=FLAG_SET; }

   /* check that L<=Y */
    if (L>Y) L=Y;

   /* set flag parameter */
    if (tim==1) JobMon=FLAG_SET;
    else			 JobMon=FLAG_UNSET;

   /* set current number of flops */
    CurFlo=mexGetFlops();

   /* set error control parameter */
    po[1]=mxCreateDoubleMatrix(1,1,mxREAL);
    er=mxGetPr(po[1]); *er=0.0; /* default return value */

   /* compute size of output array */
    P=(int)((Y-1)/K)+1;
    Q=(int)((L-1)/H)+1;
    R=(int)((P-1)/M)+1;
    if (RD<Q) RD=Q;

	/* check for return number of calls case */
    if (tim==2) {
   		po[0]=mxCreateDoubleMatrix(1,1,mxREAL);
   		vr=mxGetPr(po[0]);
         *vr=(double)Q;
         return; /* return to MATLAB */
    }

   /* allocate job monitor call parameters */
    jmip[0]=mxCreateDoubleMatrix(1,1,mxREAL);
    ax=mxGetPr(jmip[0]); *ax=MonHandle;
    jmip[1]=mxCreateDoubleMatrix(1,1,mxREAL);
    ax=mxGetPr(jmip[1]); *ax=Units;

   /* allocate space for output array */
    if (ComplexCase) {
    		po[0]=mxCreateDoubleMatrix(R,RD,mxCOMPLEX);
    			vi=mxGetPi(po[0]);
    			vr=mxGetPr(po[0]);
    	} else {
			po[0]=mxCreateDoubleMatrix(R,RD,mxREAL);
    			vi=NULL;
    			vr=mxGetPr(po[0]);
    	}

   /* allocate space for help vector */
    ar=(double *)mxCalloc(P+W,sizeof(double));
	 if (ComplexCase) {
		ai=(double *)mxCalloc(P+W,sizeof(double));
		pl=(double *)mxCalloc(N,sizeof(double));
		mi=(double *)mxCalloc(N,sizeof(double));

		/* initialize help vectors */
		for (j=0; j<N; j++) pl[j]=sr[j]+si[j],mi[j]=sr[j]-si[j];
      mexAddFlops(2*N);
    }

   /* set default value for the loop counter */
 	 j=0;

       /*
        * scan through each lag value
        ***************************************************************
        */
	 for (m=0; m<L; m+=H) {

    	 /* compute the ACF for each lag */
		  if (FullOuter) {
			  /* case of oversampled input */
			  if (ComplexCase)
                FullAutoCx(sr,si,ar,ai,pl,mi,m,N,2*K,P+W);
			  else FullAuto(sr,ar,m,N,2*K,P+W);
		  } else {
			  /* case of not oversampled input */
			  if (ComplexCase)
                FullAutoCx(sr,si,ar,ai,pl,mi,(int)(m/2),N,K,P+W);
			  else FullAuto(sr,ar,(int)(m/2),N,K,P+W);
    	  } /* end of (FullOuter) check */


       /* evaluate the averaging procedure */
        if (ComplexCase)
           AverageCx(ar,ai,vr+R*j,vi+R*j,wr,R,M,W);
        else
           Average(ar,vr+R*j,wr,R,M,W);

       /* increment loop counter */
        j++;

       /* call timer function */
		  if (JobMon) {

          if (Units==0.0) {
          		/* return number of flops as units */
               *ax=mexGetFlops()-CurFlo;
               CurFlo=mexGetFlops();
          }
          jmret=mexCallMATLAB(1,jmop,2,jmip,"job_mon");
          if (jmret != 0) mexErrMsgTxt("Cannot access job_mon.");
          *er=*mxGetPr(jmop[0]);
          mxDestroyArray(jmop[0]);
        }

       /* check for interrupt */
        if (*er != 0.0) break;

    }  /*
        * end of scan through each lag value
        ***************************************************************
        */

   /* free space of aux vector */
	 mxFree(ar); if (ComplexCase) { mxFree(ai); mxFree(pl); mxFree(mi); }
    mxDestroyArray(jmip[0]); mxDestroyArray(jmip[1]);

   /* return to MATLAB */
	 return;
}

/*
 * END OF MATLAB - GATEWAY
 */

/*
 * check for odd case
 */

int IsOdd(int m)
{
	return (int)((unsigned int)m & 1);
}

/*
 * computation of the full real acf
 */

void FullAuto(double *sr, double *ar, int m, int N, int K, int A)
{
    /* sr pointer to signal vector
     * ar pointer to output vector of acf values
     * m  current lag value
     * N  length of signal vector
     * K  time subsampling factor
     * A  length of ar vector
     */

    /* local variables */
    int n, j;	/* misc counter */

    /* count through entire length of ar vector */
    for (j=0,n=0; j<A; j++,n+=K) {
    	if ((n>=m) && (n+m<N)) ar[j]=sr[n-m]*sr[n+m];
    	else                   ar[j]=0.0;
    }

    /* update flops */
    mexAddFlops(N-2*m+1);

	 return; /* end of FullAuto() */
}


/*
 * computation of the full complex acf
 */

void FullAutoCx(double *sr, double *si,
                double *ar, double *ai,
                double *pl, double *mi,
                int m, int N, int K, int A)
{
    /* sr si pointer to signal vector
     * ar ai pointer to output vector of acf values
     * pl mi auxiliary vectors to speed up computation
     * m     current lag value
     * N     length of signal vector
     * K     time subsampling factor
     * A     length of ar vector
     */

    /* local variables */
    int n, j;	/* misc counter */
    double x;

    /* count through entire length of ar vector */
    for (j=0,n=0; j<A; j++,n+=K) {
    	if ((n>=m) && (n+m<N)) {
             x=pl[n-m]*si[n+m];
             ar[j]=x+mi[n+m]*sr[n-m];
             ai[j]=x-pl[n+m]*si[n-m];
    	} else ar[j]=0.0,ai[j]=0.0;
    }

	 /* update flops */
    mexAddFlops((N-2*m+1)*5);

	 return; /* end of FullAutoCx() */
}

