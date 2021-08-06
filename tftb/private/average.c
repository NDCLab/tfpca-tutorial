/*
 * AVERAGE
 *
 * Type          : MATLAB C-FUNCTIONS PROVIDER
 * Used By       : alg001c_.c
 * Comment       : Window averaging for vectors.
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 01-Sep-1998
 */

/* required for mexAddFlops */
#include "mex.h"

#include "getflops.h"
/*
 * prototype definitions and documentation
 */

void Average(double *ar, double *vr, double *wr, int R, int M, int W);
/*
 * Window *wr is shifted in steps determined by M over the sequence in *ar.
 * The elements of *ar that are in the window are weighted with the window,
 * summed and stored in output vector *vr. R denotes the size of the pre-
 * allocated memory in *vr. W denotes the length of the window *wr.
 */

void AverageCx(double *ar, double *ai, double *vr, double *vi,
               double *wr, int R, int M, int W);
/*
 * Same as Average() but for complex vectors.
 */

/*
 * program source code starts here
 */

/* average for real vectors */
void Average(double *ar, double *vr, double *wr, int R, int M, int W)
{
	/* ar acf vector
	 * vr averaged output vector
	 * wr windowing function
	 * R  size of output vector
	 * M  shift distance of averaging
	 * W  length of window
	 */

    /* local variables */
    int n, m, j; /* counter */

    /* check for trivial case */
    if ( (M==1) && (W==1) && (wr[0]==1.0) )
    	for (n=0; n<R; n++) vr[n]=ar[n];
    else {
    	for (n=0; n<R; n++) {
    		j=n*M; vr[n]=ar[j]*wr[0];
    		for (m=1; m<W; m++) vr[n]=vr[n]+ar[j+m]*wr[m];
    	} mexAddFlops((2*W-1)*R);
    }
	return; /* end of Average() */
}

/* average for complex vectors */
void AverageCx(double *ar, double *ai, double *vr, double *vi,
               double *wr, int R, int M, int W)
{
	/* ar ai acf vector
	 * vr vi averaged output vector
	 * wr    windowing function
	 * R     size of output vector
	 * M     shift distance of averaging
	 * W     length of window
	 */

    /* local variables */
    int n, m, j; /* counter */

    /* check for trivial case */
    if ( (M==1) && (W==1) && (wr[0]==1.0) )
    	for (n=0; n<R; n++) vr[n]=ar[n],vi[n]=ai[n];
    else {
    	for (n=0; n<R; n++) {
    		j=n*M; vr[n]=ar[j]*wr[0],vi[n]=ai[j]*wr[0];
    		for (m=1; m<W; m++) vr[n]=vr[n]+ar[j+m]*wr[m],
                             vi[n]=vi[n]+ai[j+m]*wr[m];
    	} mexAddFlops(2*(2*W-1)*R);
    }
	return; /* end of AverageCx() */
}

