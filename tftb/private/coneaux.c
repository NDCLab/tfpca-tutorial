/*
 * CONEAUX
 *
 * Type          : MATLAB C-FUNCTIONS PROVIDER
 * Used By       : alg016c_.c
 * Comment       : Auxiliary functions for cone-kernel distributions.
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 25-Sep-1998
 */

/* required for mexAddFlops */
#include "mex.h"

#include "getflops.h"

/* minimum function */
#define MIN(A,B) (((A)<(B)) ? (A):(B))

/*
 * prototype definitions
 */

int IsOdd(int m);

void ReConv(double *xr, double *ar, int M, int L, int K);
void ReConvCx(double *xr, double *xi, double *ar, double *ai,
              int M, int L, int K);

void SubAuto(double *sr, double *xr, int N, int m, int K, double norm_fact);
void SubAutoCx(double *sr, double *si, double *xr, double *xi,
               double *yr, double *yi, int N, int m, int K, double norm_fact);

void BlockSum(double *xr, double *ar, int P, int L);
void BlockSumCx(double *xr, double *xi,
                double *ar, double *ai, int P, int L);

void FullAuto(double *xr, double *yr, int N, int m);
void FullAutoCx(double *xr, double *xi,
                double *yr, double *yi, int N, int m);

void Sprink(double *sr, double *xr, double norm_fact, int N, int m);
void SprinkCx(double *sr, double *si, double *xr, double *xi,
              double norm_fact, int N, int m);

void Toggle(char *flag);

void BiUpdate(double *bi, int L);

void BlockBin(double *xr, double *ar, double *bi, int P, int L);
void BlockBinCx(double *xr, double *xi, double *ar, double *ai,
                double *bi, int P, int L);

void BiConv(double *xr, double *ar, double *bi, int M, int L, int K, int P);
void BiConvCx(double *xr, double *xi, double *ar, double *ai, double *bi,
              int M, int L, int K, int P);

void TriUpdate(double *bi, int L);

/*
 * program source code starts here
 */

/*
 * check for odd case
 */

int IsOdd(int m)
{
	return (int)((unsigned int)m & 1);
}

/*
 * update triangular sequence
 */

void TriUpdate(double *bi, int L)
{
	/* bi pointer to triangular sequence
	 * L  current triangular length
	 */

	 /* local variable */
    int n, j;

	 bi[L]=0.0;
	 j=(int)((L+1)/2);
	 for (n=L; n>=j; n--) bi[n]=bi[n]+1.0;

    mexAddFlops(L-j+1); /* update flops */

	 return; /* end of TriUpdate() */
}

/*
 * binomial convolution for K<L and complex case
 */

void BiConvCx(double *xr, double *xi, double *ar, double *ai,
              double *bi, int M, int L, int K, int P)
{
	/* xr xi points to acf vector
	 * ar ai points into output array
	 * bi    binomial sequence of length K
	 * M     is length of xr vector
	 * L     is convolution length
	 * K     is subsampling factor
	 * P     is result array length
	 */

	/* local variables */
   int n, j, flps=0;

	/* recurse input sequence */
	for (n=0; n<L-K; n++) {
		xr[M+n]=0.0,xi[M+n]=0.0;
	 	for (j=M+n; j>0; j--) xr[j]=xr[j]+xr[j-1],xi[j]=xi[j]+xi[j-1];
      flps+=2*(M+n); /* update flops */
	}

   mexAddFlops(flps); /* update flops */

	/* fill in some zeros at end */
	j=MIN(M+L-1,K*(P-1)+1);
	for (n=M+L-K; n<j; n++) xr[n]=0.0,xi[n]=0.0;

	/* collect remaining terms */
	BlockBinCx(xr,xi,ar,ai,bi,P,K);

	return; /* end of BiConvCx() */
}

/*
 * binomial convolution for K<L and real case
 */

void BiConv(double *xr, double *ar, double *bi, int M, int L, int K,int P)
{
	/* xr points to acf vector
	 * ar points into output array
	 * bi binomial sequence of length K
	 * M  is length of xr vector
	 * L  is convolution length
	 * K  is subsampling factor
	 * P  is result array length
	 */

	/* local variables */
   int n, j, flps=0;

	/* recurse input sequence */
	for (n=0; n<L-K; n++) {
		xr[M+n]=0.0;
	 	for (j=M+n; j>0; j--) xr[j]=xr[j]+xr[j-1];
      flps+=M+n; /* update flops */
	}

   mexAddFlops(flps); /* update flops */

	/* fill in some zeros at end */
	j=MIN(M+L-1,K*(P-1)+1);
	for (n=M+L-K; n<j; n++) xr[n]=0.0;

	/* collect remaining terms */
	BlockBin(xr,ar,bi,P,K);

	return; /* end of BiConv() */
}

/*
 * sums binomially weightened blocks of length L, complex case
 */

void BlockBinCx(double *xr, double *xi, double *ar, double *ai,
                double *bi, int P, int L)
{
    /* xr xi sequence of block values
     * ar ai output result of block sum
     * bi    binomial sequence
     * P     number of blocks
     * L     size of blocks
     */

	/* local variables */
   int n, m, j, flps=0;	/* misc counter */

	ar[0]=xr[0],ai[0]=xi[0];
	for (n=1; n<P; n++) {
		j=(n-1)*L+1; ar[n]=xr[j],ai[n]=xi[j];
		for (m=1; m<L; m++) ar[n]=ar[n]+xr[j+m]*bi[m],
		                    ai[n]=ai[n]+xi[j+m]*bi[m];
      flps+=4*(L-1); /* update flops */
	}

   mexAddFlops(flps); /* update flops */

	return; /* end of BlockBinCx() */
}

/*
 * sums binomially weightened blocks of length L, real case
 */

void BlockBin(double *xr, double *ar, double *bi, int P, int L)
{
    /* xr sequence of block values
     * ar output result of block bin
     * bi binomial sequence
     * P  number of blocks
     * L  size of blocks
     */

	/* local variables */
   int n, m, j, flps=0;	/* misc counter */

	ar[0]=xr[0];
	for (n=1; n<P; n++) {
		j=(n-1)*L+1; ar[n]=xr[j];
		for (m=1; m<L; m++) ar[n]=ar[n]+xr[j+m]*bi[m];
      flps+=2*(L-1); /* update flops */
	}

   mexAddFlops(flps); /* update flops */

	return; /* end of BlockBin() */
}

/*
 * toggles flag between two states
 */

void Toggle(char *flag)
{
	if (*flag==0) *flag=1; else *flag=0;
	return; /* end of Toggle() */
}

/*
 * update binomial sequence
 */

void BiUpdate(double *bi, int L)
{
	/* bi pointer to binomial sequence
	 * L  current binomial length
	 */

	 /* local variable */
    int n;

	 bi[L]=0.0;
	 for (n=L; n>0; n--) bi[n]=bi[n]+bi[n-1];
    mexAddFlops(L); /* update flops */

	 return; /* end of BiUpdate() */
}

/*
 * sprinkling of normalization factor, complex case
 */

void SprinkCx(double *sr, double *si, double *xr, double *xi,
              double norm_fact, int N, int m)
{
    /* sr si pointer to signal vector
     * xr xi pointer to output vector of acf values
     * norm_fact is the current normalization factor
     * N     length of signal vector
     * m     current lag value
     */

    /* local variables */
    int n, j=0, flps=0; /* misc counter */
    char do_mult=0;	   /* sprinkle flag */

    for (n=0; n<N; n++) {
     	if (do_mult) xr[n]=sr[n]*norm_fact,
                   xi[n]=si[n]*norm_fact,
                   flps+=2; /* update flops */
     	   else      xr[n]=sr[n],xi[n]=si[n];
     	if (m==++j)  j=0, Toggle(&do_mult);
    }

    mexAddFlops(flps); /* update flops */

 	return; /* end of SprinkCx() */
}

/*
 * sprinkling of normalization factor, real case
 */

void Sprink(double *sr, double *xr, double norm_fact, int N, int m)
{
    /* sr pointer to signal vector
     * xr pointer to output vector of acf values
     * norm_fact is the current normalization factor
     * N  length of signal vector
     * m  current lag value
     */

    /* local variables */
    int n, j=0, flps=0;	/* misc counter */
    char do_mult=0;	   /* sprinkle flag */

    for (n=0; n<N; n++) {
     	if (do_mult) xr[n]=sr[n]*norm_fact, flps++; /* update flops */
     	   else      xr[n]=sr[n];
     	if (m==++j)  j=0, Toggle(&do_mult);
    }

    mexAddFlops(flps); /* update flops */

 	 return; /* end of Sprink() */
}

/*
 * sums blocks of length L, real case
 */

void BlockSum(double *xr, double *ar, int P, int L)
{
    /* xr sequence of block values
     * ar output result of block sum
     * P  number of blocks
     * L  size of blocks
     */

	/* local variables */
   int n, m, j;	/* misc counter */

	ar[0]=xr[0];
	for (n=1; n<P; n++) {
		j=(n-1)*L+1; ar[n]=xr[j];
		for (m=1; m<L; m++) ar[n]=ar[n]+xr[j+m];
	}

   mexAddFlops((P-1)*(L-1)); /* update flops */

	return; /* end of BlockSum() */
}

/*
 * sums blocks of length L, complex case
 */

void BlockSumCx(double *xr, double *xi, double *ar, double *ai, int P, int L)
{
    /* xr xi sequence of block values
     * ar ai output result of block sum
     * P     number of blocks
     * L     size of blocks
     */

	/* local variables */
   int n, m, j;	/* misc counter */

	ar[0]=xr[0],ai[0]=xi[0];
	for (n=1; n<P; n++) {
		j=(n-1)*L+1; ar[n]=xr[j],ai[n]=xi[j];
		for (m=1; m<L; m++) ar[n]=ar[n]+xr[j+m],ai[n]=ai[n]+xi[j+m];
	}

   mexAddFlops(2*(P-1)*(L-1)); /* update flops */

	return; /* end of BlockSumCx() */
}

/*
 * computation of the full real acf
 */

void FullAuto(double *xr, double *yr, int N, int m)
{
    /* xr pointer to signal vector
     * yr pointer to output vector of acf values
     * N  length of signal vector
     * m  current lag value
     */

    /* local variables */
    int n;		/* misc counter */

    for (n=0; n<N-m; n++) yr[n]=xr[n]*xr[n+m];

    mexAddFlops(N-m); /* update flops */

	return; /* end of FullAuto() */
}

/*
 * computation of the full complex acf
 */

void FullAutoCx(double *xr, double *xi, double *yr, double *yi, int N, int m)
{
    /* xr xi pointer to signal vector and output sequence
     * yr yi pointer to temporary work area
     * N     length of signal vector
     * m     current lag value
     */

    /* local variables */
    int n;		/* misc counter */
    double x;	/* aux storage */

    /* precompute help vectors */
    for (n=0; n<N; n++)
     	yr[n]=xr[n]+xi[n],yi[n]=xr[n]-xi[n];
    /* compute acf */
    for (n=0; n<N-m; n++) {
    	x=-xi[n]*yi[n+m];
    	xr[n]=x+xr[n+m]*yr[n];
    	xi[n]=x+xi[n+m]*yi[n];
    }

    mexAddFlops(7*N-5*m); /* update flops */

    return; /* end of FullAutoCx() */
}

/*
 * computation of the subsampled acf if K>m, real case
 */

void SubAuto(double *sr, double *xr, int N, int m, int K, double norm_fact)
{
    /* sr pointer to signal vector
     * xr pointer to output vector of acf values
     * N  length of signal vector
     * m  current lag value
     * K  time-subsampling
     * norm_fact is the current normalization factor
     */

    /* local variables */
    int n=0, j=1, i=0, flps=0;	/* misc counter */

    if (m+1>K-m-1) { /* normalize by sprinkling */
    				 Sprink(sr,xr,norm_fact,N,m);
    				 while (n<N-m) {
    				 	xr[i++]=xr[n]*xr[n+m], flps++;
    				 	if (--j==0) { j=m+1; n+=(K-m); }
    				 	else n++;
    				 }
    }
    else 		 { /* normalize directly */
    			     while (n<N-m) {
    				 	xr[i++]=sr[n]*sr[n+m], flps++;
    				 	if (--j==0) { j=m+1; n+=(K-m); }
    				 	else n++;
    				 }
    				 for (n=0; n<i; n++) xr[n]=xr[n]*norm_fact;
                flps+=i;
    }

    mexAddFlops(flps); /* update flops */

    /* fill in some zeros at end */
    j=MIN(i+K,N); for (n=i; n<j; n++) xr[n]=0.0;

	 return;  /* end of SubAuto() */
}

/*
 * computation of the subsampled acf if K>m, complex case
 */

void SubAutoCx(double *sr, double *si, double *xr, double *xi, double *yr,
               double *yi, int N, int m, int K, double norm_fact)
{
    /* sr si pointer to signal vector
     * xr xi pointer to output vector of acf values
     * yr yi aux workspace
     * N     length of signal vector
     * m     current lag value
     * K     time-subsampling
     * norm_fact is the current normalization factor
     */

    /* local variables */
    int n, j=1, i=0, flps=0; /* misc counter */
    double x;				       /* intermediate result */

    if (m+1>K-m-1) { /* normalize by sprinkling */
    				 SprinkCx(sr,si,xr,xi,norm_fact,N,m);
    				 /* precompute help vectors */
    				 for (n=0; n<N; n++)
    				 	yr[n]=xr[n]+xi[n],yi[n]=xr[n]-xi[n];
                flps+=2*N;
    				 /* compute acf */
    				 n=0;
    				 while (n<N-m) {
    				 	x=-xi[n]*yi[n+m];
    				 	xr[i]=x+xr[n+m]*yr[n];
    				 	xi[i++]=x+xi[n+m]*yi[n];
                  flps+=5;
    				 	if (--j==0) { j=m+1; n+=(K-m); }
    				 	else n++;
    				 }
    }
    else 		 { /* normalize directly */
    				 /* precompute help vectors */
    				 for (n=0; n<N; n++)
    				 	yr[n]=sr[n]+si[n],yi[n]=sr[n]-si[n];
                flps+=2*N;
    				 /* compute acf */
    				 n=0;
    				 while (n<N-m) {
    				 	x=-si[n]*yi[n+m];
    				 	xr[i]=x+sr[n+m]*yr[n];
    				 	xi[i++]=x+si[n+m]*yi[n];
                  flps+=5;
    				 	if (--j==0) { j=m+1; n+=(K-m); }
    				 	else n++;
    				 }
    				 for (n=0; n<i; n++)
    				 	xr[n]=xr[n]*norm_fact,xi[n]=xi[n]*norm_fact;
                flps+=2*i;
    }

    mexAddFlops(flps); /* update flops */

    /* fill in some zeros at end */
    j=MIN(i+K,N); for (n=i; n<j; n++) xr[n]=0.0,xi[n]=0.0;

	return;  /* end of SubAutoCx() */
}

/*
 * born jordan convolution for K<L and real case
 */

void ReConv(double *xr, double *ar, int M, int L, int K)
{
	/* xr points to acf vector
	 * ar points into output array
	 * M  is length of xr vector
	 * L  is convolution length
	 * K  is subsampling factor
	 */

	/*
	 * local variables
	 */

    int n_zero, k_zero, P;  /* Z-sequence index */
    int n_one;				    /* V-sequence index */
    int a, b, m, n, Q, p;	 /* miscellaneous counter */
    int flps=0;

    /*
     * compute P-sequence into xr vector
     */

    n_zero=(int)((L-1)/K)+1;
    k_zero=K*n_zero-L+1;
    a=k_zero-1;   /* length of first pack */
    b=K-k_zero+1; /* length of second pack */
    p=b;				/* initialize in-pack counter */
    n=0;          /* initialize pack counter */
    Q=b;				/* initalize first pack length */
    m=1;				/* counter in sequence */
    P=M;				/* default value for P-sequence length */

    /* P-sequence is same as sequence for K=1 */
    if (K>1) {

	/* check for special case a=0 */
	if (a>0) {
      while (m<M) {
		if (p>=Q) { /* start new pack */
					xr[++n]=xr[m++]; p=1; if (Q==a) Q=b; else Q=a; }
		else      { /* sum in current pack */
					xr[n]=xr[n]+xr[m++]; p++; flps++; }
      }
    }
    else {
	  while (m<M) {
	  	if (p>=b) { /* start new pack */
					xr[++n]=xr[m++]; p=1; }
		else      { /* sum in current pack */
					xr[n]=xr[n]+xr[m++]; p++; flps++; }
      }
    }
    P=n+1; /* length of P-sequence if (K>1) */
    }      /* end of block of (K>1) check */

    /*
     * compute recursion
     */

	/* set initial values */
    ar[0]=xr[0]; 				 /* initialize recursion */
    Q=(int)((M+L-2)/K)+1;   /* length of output array */

    if (M==1)     { /* special case for sequence length = 1 */
                    for ( n=1; n<Q; ar[n++]=xr[0] );
    }
    else if (a>0) { /*
                     * regular case with V- and Z-sequence being different
                     */

    				n_one=(int)((M-2)/K)+1;
    				if (n_one<n_zero) {
    					/* non-overlapping */
    					for (p=1, n=1; n<n_one; n++,p+=2)
    					  ar[n]=ar[n-1]+xr[p]+xr[p+1];
    					 ar[n]=ar[n-1]+xr[p], flps+=1+2*(n_one-1);
    					 if ((p+1)<=(P-1)) ar[n]=ar[n]+xr[p+1], flps++;
    					if (n_zero<Q) {
    						/* if n_zero within boundary */
    						for (n++; n<n_zero; n++)
    						  ar[n]=ar[n-1];
    						for (p=0; n<Q-1; n++,p+=2)
    						  ar[n]=ar[n-1]-xr[p]-xr[p+1], flps+=2;
    						 ar[n]=ar[n-1]-xr[p], flps++;
    						 if ((p+1)<=(P-1)) ar[n]=ar[n]-xr[p+1], flps++;
    					} else {
    						/* if n_zero out of boundary */
    						for (n++; n<Q; n++)
    						  ar[n]=ar[n-1];
    					}
    				}
    				else {
    					/* overlapping */
    					for (p=1, n=1; n<n_zero; n++,p+=2)
    					  ar[n]=ar[n-1]+xr[p]+xr[p+1], flps+=2;
    					for (m=0; n<n_one; n++,p+=2,m+=2)
    					  ar[n]=ar[n-1]+xr[p]+xr[p+1]-xr[m]-xr[m+1], flps+=4;
    					if (n<Q) { /* check for n within boundary */
    					  ar[n]=ar[n-1]+xr[p]-xr[m]-xr[m+1], flps+=3;
    					  if ((p+1)<=(P-1)) ar[n]=ar[n]+xr[p+1], flps++; }
    					for (n++,m+=2; n<Q-1; n++,m+=2)
    					  ar[n]=ar[n-1]-xr[m]-xr[m+1], flps+=2;
    					if (n<Q) { /* check for n within boundary */
    					  ar[n]=ar[n-1]-xr[m], flps++;
    					  if ((m+1)<=(P-1)) ar[n]=ar[n]-xr[m+1], flps++;}
    				}
    }
    else { /*
            * special case with P,V,Z-sequence being the same
            */
            	n_one=(int)((M-2)/K)+1;
    				if (n_one<n_zero) {
    					/* non-overlapping */
    					for (n=1; n<=n_one; n++)
    					  ar[n]=ar[n-1]+xr[n], flps++;
    					if (n_zero<Q) {
    						/* if n_zero within boundary */
    						for ( ; n<n_zero; n++)
    						  ar[n]=ar[n-1];
    						for (p=0; n<Q; n++)
    						  ar[n]=ar[n-1]-xr[p++], flps++;
    					} else {
    						/* if n_zero out of boundary */
    						for ( ; n<Q; n++)
    						  ar[n]=ar[n-1];
    					}
    				}
    				else {
    					/* overlapping */
    					for (n=1; n<n_zero; n++)
    					  ar[n]=ar[n-1]+xr[n], flps++;
    					for (m=0; n<=n_one; n++)
    					  ar[n]=ar[n-1]+xr[n]-xr[m++], flps+=2;
    					for ( ; n<Q; n++)
    					  ar[n]=ar[n-1]-xr[m++], flps++;
    				}
    }

    mexAddFlops(flps); /* update flops */

	 return; /* end of ReConv() */
}

/*
 * born jordan convolution for K<L and complex case
 */

void ReConvCx(double *xr, double *xi,
              double *ar, double *ai, int M, int L, int K)
{
	/* xr xi points to real/imag acf vector
	 * ar ai points into real/imag output array
	 * M     is length of xr vector
	 * L     is convolution length
	 * K     is subsampling factor
	 */

	/*
	 * local variables
	 */

    int n_zero, k_zero, P;	/* Z-sequence index */
    int n_one;					/* V-sequence index */
    int a, b, m, n, Q, p;	/* miscellaneous counter */
    int flps=0;

    /*
     * compute P-sequence into xr vector
     */

    n_zero=(int)((L-1)/K)+1;
    k_zero=K*n_zero-L+1;
    a=k_zero-1;   /* length of first pack */
    b=K-k_zero+1; /* length of second pack */
    p=b;				/* initialize in-pack counter */
    n=0;          /* initialize pack counter */
    Q=b;				/* initalize first pack length */
    m=1;				/* counter in sequence */
    P=M;				/* default value for P-sequence length */

    /* P-sequence is same as sequence for K=1 */
    if (K>1) {

	/* check for special case a=0 */
	if (a>0) {
      while (m<M) {
		if (p==Q) { /* start new pack */
					xi[++n]=xi[m];
					xr[n]=xr[m++]; p=1; if (Q==a) Q=b; else Q=a; }
		else      { /* sum in current pack */
					xi[n]=xi[n]+xi[m];
					xr[n]=xr[n]+xr[m++]; p++; flps+=2; }
      }
    }
    else {
	  while (m<M) {
	  	if (p==b) { /* start new pack */
	  				xi[++n]=xi[m];
					xr[n]=xr[m++]; p=1; }
		else      { /* sum in current pack */
					xi[n]=xi[n]+xi[m];
					xr[n]=xr[n]+xr[m++]; p++; flps+=2; }
      }
    }
    P=n+1; /* length of P-sequence if (K>1) */
    }      /* end of block of (K>1) check */

    /*
     * compute recursion
     */

	/* set initial values */
    ar[0]=xr[0]; 				 /* initialize recursion */
    ai[0]=xi[0];
    Q=(int)((M+L-2)/K)+1;   /* length of output array */

    if (M==1)     { /* special case for sequence length = 1 */
                    for ( n=1; n<Q; ai[n]=xi[0],ar[n++]=xr[0] );
    }
    else if (a>0) { /*
                     * regular case with V- and Z-sequence being different
                     */

    				n_one=(int)((M-2)/K)+1;
    				if (n_one<n_zero) {
    					/* non-overlapping */
    					for (p=1, n=1; n<n_one; n++,p+=2)
    					  ar[n]=ar[n-1]+xr[p]+xr[p+1],
    					  ai[n]=ai[n-1]+xi[p]+xi[p+1], flps+=4;
    					 ar[n]=ar[n-1]+xr[p],
    					 ai[n]=ai[n-1]+xi[p], flps+=2;
    					 if ((p+1)<=(P-1)) ar[n]=ar[n]+xr[p+1],
    					 				       ai[n]=ai[n]+xi[p+1], flps+=2;
    					if (n_zero<Q) {
    						/* if n_zero within boundary */
    						for (n++; n<n_zero; n++)
    						  ar[n]=ar[n-1],ai[n]=ai[n-1];
    						for (p=0; n<Q-1; n++,p+=2)
    						  ar[n]=ar[n-1]-xr[p]-xr[p+1],
    						  ai[n]=ai[n-1]-xi[p]-xi[p+1], flps+=4;
    						 ar[n]=ar[n-1]-xr[p],
    						 ai[n]=ai[n-1]-xi[p], flps+=2;
    						 if ((p+1)<=(P-1)) ar[n]=ar[n]-xr[p+1],
    						                   ai[n]=ai[n]-xi[p+1], flps+=2;
    					} else {
    						/* if n_zero out of boundary */
    						for (n++; n<Q; n++)
    						  ar[n]=ar[n-1],ai[n]=ai[n-1];
    					}
    				}
    				else {
    					/* overlapping */
    					for (p=1, n=1; n<n_zero; n++,p+=2)
    					  ar[n]=ar[n-1]+xr[p]+xr[p+1],
    					  ai[n]=ai[n-1]+xi[p]+xi[p+1], flps+=4;
    					for (m=0; n<n_one; n++,p+=2,m+=2)
    					  ar[n]=ar[n-1]+xr[p]+xr[p+1]-xr[m]-xr[m+1],
    					  ai[n]=ai[n-1]+xi[p]+xi[p+1]-xi[m]-xi[m+1], flps+=8;
    					if (n<Q) { /* check for n within boundary */
    					  ar[n]=ar[n-1]+xr[p]-xr[m]-xr[m+1],
    					  ai[n]=ai[n-1]+xi[p]-xi[m]-xi[m+1], flps+=6;
    					  if ((p+1)<=(P-1)) ar[n]=ar[n]+xr[p+1],
    					                    ai[n]=ai[n]+xi[p+1], flps+=2; }
    					for (n++,m+=2; n<Q-1; n++,m+=2)
    					  ar[n]=ar[n-1]-xr[m]-xr[m+1],
    					  ai[n]=ai[n-1]-xi[m]-xi[m+1], flps+=4;
    					if (n<Q) { /* check for n within boundary */
    					  ar[n]=ar[n-1]-xr[m],
    					  ai[n]=ai[n-1]-xi[m], flps+=2;
    					  if ((m+1)<=(P-1)) ar[n]=ar[n]-xr[m+1],
    					  					     ai[n]=ai[n]-xi[m+1], flps+=2; }
    				}
    }
    else { /*
            * special case with P,V,Z-sequence being the same
            */
    				n_one=(int)((M-2)/K)+1;
    				if (n_one<n_zero) {
    					/* non-overlapping */
    					for (n=1; n<=n_one; n++)
    					  ar[n]=ar[n-1]+xr[n],
    					  ai[n]=ai[n-1]+xi[n], flps+=2;
    					if (n_zero<Q) {
    						/* if n_zero within boundary */
    						for ( ; n<n_zero; n++)
    						  ar[n]=ar[n-1],ai[n]=ai[n-1];
    						for (p=0; n<Q; n++)
    						  ar[n]=ar[n-1]-xr[p],
    						  ai[n]=ai[n-1]-xi[p++], flps+=2;
    					} else {
    						/* if n_zero out of boundary */
    						for ( ; n<Q; n++)
    						  ar[n]=ar[n-1],ai[n]=ai[n-1];
    					}
    				}
    				else {
    					/* overlapping */
    					for (n=1; n<n_zero; n++)
    					  ar[n]=ar[n-1]+xr[n],
    					  ai[n]=ai[n-1]+xi[n], flps+=2;
    					for (m=0; n<=n_one; n++)
    					  ar[n]=ar[n-1]+xr[n]-xr[m],
    					  ai[n]=ai[n-1]+xi[n]-xi[m++], flps+=4;
    					for ( ; n<Q; n++)
    					  ar[n]=ar[n-1]-xr[m],
    					  ai[n]=ai[n-1]-xi[m++], flps+=2;
    				}
    }

    mexAddFlops(flps); /* update flops */

	 return;  /* end of ReConvCx() */
}

