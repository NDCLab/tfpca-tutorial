/*
 * GETFLOPS
 *
 * Type          : HEADER FILE TO FIX MISSING FLOPS SUPPORT IN MATLAB 6
 * Used By       : alg001c_.c
 * Comment       : Provides a fake mexGetFlops function.
 *
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 05-Mar-2001
 */

#include "mex.h"
#include "matrix.h"

#ifdef mexAddFlops

#define FAKE_FLOPS
#undef mexAddFlops
#define mexAddFlops mexAddFlopsFake

#endif

/*
 * prototype definitions and documentation
 */

double mexGetFlops(void);
/* returns current number of flops */


#ifdef FAKE_FLOPS
void mexAddFlopsFake(int count);
#endif


