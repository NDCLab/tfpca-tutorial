/*
 * ALG016C_
 *
 * Type          : MATLAB C-MEX DLL
 * MATLAB-Syntax : (see alg016c_.m)
 * Comment       : smoothed local autocorrelation function computation for
 *                 the time-lag domain kernels: Born-Jordan (0), binomial (1),
 *                 triangular (2), Page (3), Levin (4), and Margenau-Hill (5).
 *                 full- and half outer product tables - post averaging with
 *                 window - job monitoring - flops prediction
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 21-Sep-1998
 */

/* include object code */
#pragma use_object argchck
#pragma use_object average
#pragma use_object getflops
#pragma use_object coneaux

/* include MATLAB library */
#include "matrix.h"  /* matrix structures */
#include "mex.h"     /* mex functions */
#include <stdlib.h>  /* standard library */

#include "getflops.h"

/* minimum function */
#define MIN(A,B) (((A)<(B)) ? (A):(B))

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

void ReConv(double *xr, double *ar, int M, int L, int K);
void ReConvCx(double *xr, double *xi, double *ar, double *ai,
              int M, int L, int K);

void SubAuto(double *sr, double *xr, int N, int m, int K, double norm_fact);
void SubAutoCx(double *sr, double *si, double *xr, double *xi,
               double *yr, double *yi, int N, int m, int K, double norm_fact);

void BlockSum(double *xr, double *ar, int P, int L);
void BlockSumCx(double *xr, double *xi, double *ar, double *ai, int P, int L);

void FullAuto(double *xr, double *yr, int N, int m);
void FullAutoCx(double *xr, double *xi, double *yr, double *yi, int N, int m);

void Sprink(double  *sr, double  *xr, double norm_fact, int N, int m);
void SprinkCx(double *sr, double *si, double *xr, double *xi,
              double norm_fact, int N, int m);

void Toggle(char *flag);

void BiUpdate(double *bi, int L);

void BlockBin(double *xr, double *ar, double *bi, int P, int L);
void BlockBinCx(double *xr, double *xi, double *ar, double *ai,
                double  *bi, int P, int L);

void BiConv(double *xr, double *ar, double *bi, int M, int L, int K, int P);
void BiConvCx(double *xr, double *xi, double *ar, double *ai, double *bi,
              int M, int L, int K, int P);

void TriUpdate(double *bi, int L);

void LevinRe(double *sr, double *ar, int N, int K, int m, int P, int W);
void LevinCx(double *sr, double *si, double *ar, double *ai,
             int N, int K, int m, int P, int W);

void PageRe(double *sr, double *ar, int N, int K, int m, int P, int W);
void PageCx(double *sr, double *si, double *ar, double *ai,
             int N, int K, int m, int P, int W);

void MargenRe(double *sr, double *ar, int N, int K, int m, int P, int W);
void MargenCx(double *sr, double *si, double *ar, double *ai,
             int N, int K, int m, int P, int W);

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
    int Kern;				 /* kernel number */

    enum FlagType BornJordan=FLAG_UNSET; /* kernel flags */
    enum FlagType   Binomial=FLAG_UNSET;
    enum FlagType Triangular=FLAG_UNSET;
    enum FlagType       Page=FLAG_UNSET;
    enum FlagType      Levin=FLAG_UNSET;
    enum FlagType   Margenau=FLAG_UNSET;

	/* output parameter */
	 double *vr, *vi;		 /* averaged acf array */
	 double *er;			 /* error flag */

    /* computation parameter */
    int N, P, Q, W, R; /* signal-, acf-, lag-, window, resulting-length */
    int m, n, j;		  /* lag counter, misc counter, loop counter */
    double *ai, *ar;	  /* acf real and imag part */
    double *xi, *xr;	  /* auxiliary vectors */
    double *yi, *yr;	  /* auxiliary vectors */
    double norm_fact;  /* lag normalization factor */
    double *bi;		  /* binomial or triangular sequence */

    enum FlagType ComplexCase;/* complex case flag */

    /* Note that L is used as the maximum lag in the gateway
     * routine, but L can also mean convolution length in
     * subroutines defined below.
     */

	/* job monitor parameter */
    int jmret;           /* CallMATLAB return value */
	 mxArray *jmop[1];    /* CallMATLAB output parameter */
    mxArray *jmip[2];    /* CallMATLAB input parameter */
    double *ax;          /* auxiliary pointer */
    double CurFlo;       /* current number of flops */

   /* counting flops */
    int flps=0;

   /* check for proper number of arguments */
    if      (ni!=11) mexErrMsgTxt("Wrong number of input arguments.");
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
    Kern=argIsIndex(pi[10],11);

   /* set kernel flags */
    switch (Kern) {
		case 1:    Binomial=FLAG_SET; break;
      case 2:  Triangular=FLAG_SET; break;
      case 3:        Page=FLAG_SET; break;
      case 4:       Levin=FLAG_SET; break;
      case 5:    Margenau=FLAG_SET; break;
		default: BornJordan=FLAG_SET, Kern=0;
	 }

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

   /* check that L<=N */
    if (L>N) L=N;

   /* set flag parameter */
    if (tim==1) JobMon=FLAG_SET;
    else			 JobMon=FLAG_UNSET;

   /* set current number of flops */
    CurFlo=mexGetFlops();

   /* set error control parameter */
    po[1]=mxCreateDoubleMatrix(1,1,mxREAL);
    er=mxGetPr(po[1]); *er=0.0; /* default return value */

   /* compute size of output array */
    P=(int)((N-1)/K)+1;
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
    xr=(double *)mxCalloc(N,sizeof(double));
    yr=(double *)mxCalloc(N,sizeof(double));
	 if (ComplexCase) {
		ai=(double *)mxCalloc(P+W,sizeof(double));
      yi=(double *)mxCalloc(N,sizeof(double));
		xi=(double *)mxCalloc(N,sizeof(double));
    }
    if (Binomial)   bi=(double *)mxCalloc(K,sizeof(double)),bi[0]=1.0;
	 if (Triangular) bi=(double *)mxCalloc(K,sizeof(double)),bi[0]=1.0;

   /* set default value for the norm factor and the loop counter */
 	 norm_fact=1.0; j=0;

       /*
        * scan through each lag value
        ***************************************************************
        */
	 for (m=0; m<L; m+=H) {

		/* compute the normalization factor */
		if (BornJordan) norm_fact=1/(double)(m+1), flps++;
		if (Triangular) {
			if (IsOdd(m)) norm_fact=4.0/((double)(m+1)*(double)(m+3));
			else			  norm_fact=4.0/((double)(m+2)*(double)(m+2));
         flps+=2;
		}

      if (Kern>2) {

     /*
      **********************************
      * Page, Levin, and Margenau Case *
      **********************************
      */

      if (Page) {
      	if (ComplexCase) PageCx(sr,si,ar,ai,N,K,m,P,W);
      	else             PageRe(sr,ar,N,K,m,P,W);
      }

      if (Levin) {
      	if (ComplexCase) LevinCx(sr,si,ar,ai,N,K,m,P,W);
      	else             LevinRe(sr,ar,N,K,m,P,W);
      }

      if (Margenau) {
      	if (ComplexCase) MargenCx(sr,si,ar,ai,N,K,m,P,W);
      	else             MargenRe(sr,ar,N,K,m,P,W);
      }

     /*
      *****************************************
      * End of Page, Levin, and Margenau Case *
      *****************************************
      */

      } /* end from if (Kern>2) {} */
      else {

     /*
      *********************************************
      * BornJordan, Binomial, and Triangular Case *
      *********************************************
      */

		if (K>m) {

      	/*
          * time subsampling >= convolution length
          */

         /* compute the normalized sub acf */
          if (ComplexCase) SubAutoCx(sr,si,xr,xi,yr,yi,N,m,K,norm_fact);
          else             SubAuto(sr,xr,N,m,K,norm_fact);

         /*
          * convolve with kernel
          */

          if (BornJordan) {
          	if (ComplexCase) BlockSumCx(xr,xi,ar,ai,P,m+1);
            else             BlockSum(xr,ar,P,m+1);
          }

          if (Binomial) {
          	if (ComplexCase) BlockBinCx(xr,xi,ar,ai,bi,P,m+1);
            else             BlockBin(xr,ar,bi,P,m+1);
            for (n=0; n<H; n++) if (K>m+1+n) BiUpdate(bi,m+1+n);
          }

          if (Triangular) {
          	if (ComplexCase) BlockBinCx(xr,xi,ar,ai,bi,P,m+1);
            else             BlockBin(xr,ar,bi,P,m+1);
            for (n=0; n<H; n++) if (K>m+1+n) TriUpdate(bi,m+1+n);
          }
		}
		else 	 {

      	/*
          * time subsampling < convolution length
          */

         /* normalize via sprinkling */
          if (ComplexCase) SprinkCx(sr,si,xr,xi,norm_fact,N,m);
          else             Sprink(sr,xr,norm_fact,N,m);

         /* compute the normalized acf */
          if (ComplexCase) FullAutoCx(xr,xi,yr,yi,N,m);
          else             FullAuto(xr,xr,N,m);

         /*
          * compute the convolution
          */

          if (BornJordan) {
          	if (ComplexCase) ReConvCx(xr,xi,ar,ai,N-m,m+1,K);
            else             ReConv(xr,ar,N-m,m+1,K);
          }

          if (Triangular) {
          	if (ComplexCase)
            	if (IsOdd(m)) ReConvCx(xr,xi,yr,yi,N-m,(m+1)>>1,1),
		            			  ReConvCx(yr,yi,ar,ai,N-((m+1)>>1),(m+3)>>1,K);
               else          ReConvCx(xr,xi,yr,yi,N-m,(m>>1)+1,1),
		            			  ReConvCx(yr,yi,ar,ai,N-(m>>1),(m>>1)+1,K);
            else
            	if (IsOdd(m)) ReConv(xr,yr,N-m,(m+1)>>1,1),
		            			  ReConv(yr,ar,N-((m+1)>>1),(m+3)>>1,K);
               else          ReConv(xr,yr,N-m,(m>>1)+1,1),
		            			  ReConv(yr,ar,N-(m>>1),(m>>1)+1,K);
          }

          if (Binomial) {
          	if (ComplexCase) BiConvCx(xr,xi,ar,ai,bi,N-m,m+1,K,P);
            else             BiConv(xr,ar,bi,N-m,m+1,K,P);
          }
		} /* end from if (K>m) */

     /*
      ****************************************************
      * End of BornJordan, Binomial, and Triangular Case *
      ****************************************************
      */

      } /* end from if (Kern>2) {} else {} */

     /* recurse the binomial norm factor */
      if (Binomial) for (n=0; n<H; n++) norm_fact=norm_fact*0.5, flps++;

     /* evaluate the averaging procedure */
      if (ComplexCase) AverageCx(ar,ai,vr+R*j,vi+R*j,wr,R,M,W);
      else             Average(ar,vr+R*j,wr,R,M,W);

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

    mexAddFlops(flps); /* update flops */

   /* free space of aux vector */
	 mxFree(xr); if (ComplexCase) mxFree(xi);
	 mxFree(yr); if (ComplexCase) mxFree(yi);
	 mxFree(ar); if (ComplexCase) mxFree(ai);
	 if (Binomial) mxFree(bi);if (Triangular) mxFree(bi);
    mxDestroyArray(jmip[0]); mxDestroyArray(jmip[1]);

   /* return to MATLAB */
	 return;
}

/*
 * END OF MATLAB - GATEWAY
 */

/*
 * Levin subsampled local ACF computation
 */

void LevinRe(double *sr, double *ar, int N, int K, int m, int P, int W)
{
	/* sr points to signal vector
	 * ar points into output vector
	 * N is length of sr vector
	 * K is subsampling factor
    * m is current lag value
	 * P is result array length
    * W is averaging window length
	 */

    /* local variables */
   int n, i;

   for (n=0,i=0; n<N-m; n+=K) ar[i++]=sr[n]*sr[n+m];
   mexAddFlops(i);                /* update flops */
   for ( ; i<P+W; i++) ar[i]=0.0; /* pad with zeros */

   return;
}

/*
 * Levin subsampled local ACF computation (complex)
 */

void LevinCx(double *sr, double *si, double *ar, double *ai,
             int N, int K, int m, int P, int W)
{
	/* sr si points to signal vector
	 * ar ai points into output vector
	 * N     is length of sr vector
	 * K     is subsampling factor
    * m     is current lag value
	 * P     is result array length
    * W     is averaging window length
	 */

    /* local variables */
   int n, i;

   for (n=0,i=0; n<N-m; n+=K) {
    	  ar[i]=sr[n+m]*sr[n]+si[n+m]*si[n];
    	ai[i++]=si[n+m]*sr[n]-si[n]*sr[n+m];
   }
   mexAddFlops(6*i); /* update flops */
   for ( ; i<P+W; i++) ar[i]=0.0,ai[i]=0.0; /* pad with zeros */

   return;
}

/*
 * Page subsampled local ACF computation
 */

void PageRe(double *sr, double *ar, int N, int K, int m, int P, int W)
{
	/* sr points to signal vector
	 * ar points into output vector
	 * N is length of sr vector
	 * K is subsampling factor
    * m is current lag value
	 * P is result array length
    * W is averaging window length
	 */

    /* local variables */
   int n, i, flps=0;

   for (n=0,i=0; n<N; n+=K) {
   	if (n<m) ar[i++]=0.0;
   	else     ar[i++]=sr[n]*sr[n-m], flps++;
   }
   mexAddFlops(flps);             /* update flops */
   for ( ; i<P+W; i++) ar[i]=0.0; /* pad with zeros */

   return;
}

/*
 * Page subsampled local ACF computation (complex)
 */

void PageCx(double *sr, double *si, double *ar, double *ai,
            int N, int K, int m, int P, int W)
{
  /* sr si points to signal vector
   * ar ai points into output vector
   * N     is length of sr vector
   * K     is subsampling factor
   * m     is current lag value
   * P     is result array length
   * W     is averaging window length
   */

  /* local variables */
   int n, i, flps=0;

   for (n=0,i=0; n<N; n+=K) {
   	if (n<m) ar[i]=0.0,ai[i++]=0.0;
   	else ar[i]=sr[n]*sr[n-m]+si[n]*si[n-m],
    	   ai[i++]=si[n]*sr[n-m]-si[n-m]*sr[n], flps+=6;
   }
   mexAddFlops(flps); /* update flops */
   for ( ; i<P+W; i++) ar[i]=0.0,ai[i]=0.0; /* pad with zeros */

   return;
}

/*
 * Margenau-Hill subsampled local ACF computation
 */

void MargenRe(double *sr, double *ar, int N, int K, int m, int P, int W)
{
	/* sr points to signal vector
	 * ar points into output vector
	 * N is length of sr vector
	 * K is subsampling factor
    * m is current lag value
	 * P is result array length
    * W is averaging window length
	 */

    /* local variables */
   int n, i;

   for (n=0,i=0; n<N-m; n+=K) ar[i++]=0.5*sr[n]*sr[n+m];
   mexAddFlops(i);                 /* update flops */
   for ( ; i<P+W; i++) ar[i]=0.0;  /* pad with zeros */
   for (n=0,i=0; n<N; n+=K)
   	{ if (n>=m) ar[i]=ar[i]+0.5*sr[n]*sr[n-m]; i++; }
   mexAddFlops(2*i);              /* update flops */

   return;
}

/*
 * Margenau-Hill subsampled local ACF computation (complex)
 */

void MargenCx(double *sr, double *si, double *ar, double *ai,
             int N, int K, int m, int P, int W)
{
	/* sr si points to signal vector
	 * ar ai points into output vector
	 * N     is length of sr vector
	 * K     is subsampling factor
    * m     is current lag value
	 * P     is result array length
    * W     is averaging window length
	 */

    /* local variables */
   int n, i, flps=0;

   for (n=0,i=0; n<N-m; n+=K) {
    	  ar[i]=0.5*(sr[n+m]*sr[n]+si[n+m]*si[n]);
    	ai[i++]=0.5*(si[n+m]*sr[n]-si[n]*sr[n+m]);
   }
   mexAddFlops(6*i); /* update flops */
   for ( ; i<P+W; i++) ar[i]=0.0,ai[i]=0.0; /* pad with zeros */
   for (n=0,i=0; n<N; n+=K,i++) {
   	if (n>=m) { ar[i]=ar[i]+0.5*(sr[n]*sr[n-m]+si[n]*si[n-m]);
    	            ai[i]=ai[i]+0.5*(si[n]*sr[n-m]-si[n-m]*sr[n]);
                  flps+=6;
      }
   }
   mexAddFlops(flps); /* update flops */

   return;
}

