/*
 * GETFLOPS
 *
 * Type          : MATLAB C-FUNCTIONS PROVIDER
 * Used By       : alg001c_.c
 * Comment       : Provides a mexGetFlops function.
 *
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 04-Sep-1998
 */

/* Addi - matlab 6 doesn't have these functions anymore */

#include "getflops.h" 


/*
 * program source code starts here
 */

#ifdef FAKE_FLOPS

static flops = 0;
void mexAddFlops(int count) {
	flops += count;
}

double mexGetFlops(void) {
	return flops;
}


#endif
#ifndef FAKE_FLOPS

double mexGetFlops(void) {

	int rt;         /* return value of call CallMATLAB */
   mxArray *op[1]; /* CallMATLAB output parameter */
   double flps;    /* number of flops */

	rt=mexCallMATLAB(1,op,0,NULL,"flops");
   if (rt != 0) mexErrMsgTxt("Cannot access flops.");
   flps=*mxGetPr(op[0]);
   mxDestroyArray(op[0]);
	return(flps);
}

#endif

