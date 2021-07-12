/*
 * ARGCHCK
 *
 * Type          : MATLAB C-FUNCTIONS PROVIDER
 * Comment       : Contains several functions which facilitate
 *                 proper argument-check for the MATLAB-GATEWAY.
 */

/*
 *   Copyright (c) 1998 by Robert M. Nickel
 *   Revision : 1.0
 *   Date     : 08-Mar-1998
 */

#include <limits.h>
#include "mex.h"
#include "matrix.h"

#define MIN(A,B) (((A)<(B)) ? (A):(B))
#define MAX(A,B) (((A)>(B)) ? (A):(B))

/*
 * prototype definitions and documentation
 */
 
void   argIsMatrix(const mxArray *aptr,int n);
/*
 * Error Check Utility:
 * Returns only if *aptr refers to a valid non-sparse
 *	double-precision two-dimensional matrix. A MATLAB error
 * is generated otherwise. The parameter n is used
 * to denote the argument number in the error message.
 */

int    argIsVector(const mxArray *aptr,int n);
/*
 * Error Check Utility:
 * Returns only if *aptr denotes a valid non-sparse
 * double-precision one-dimensional vector. A MATLAB error
 * is generated otherwise. The parameter n is used
 * to denote the argument number in the error message.
 * The function returns the length of the vector.
 */

double argIsScalar(const mxArray *aptr,int n);
/*
 * Error Check Utility:
 * Returns only if *aptr denotes a double-precision
 * scalar. A MATLAB error is generated otherwise. The parameter
 * n is used to denote the argument number in the error
 * message. The function returns the real part of the scalar.
 */

int    argIsIndex(const mxArray *aptr,int n);
/*
 * Error Check Utility:
 * Returns only if *aptr denotes a double-precision
 * scalar. A MATLAB error is generated otherwise. The parameter
 * n is used to denote the argument number in the error
 * message. The function returns the real integer part of the
 * scalar.
 */

/*
 * program source code starts here
 */

/* argument check for double matrices */
void argIsMatrix(const mxArray *aptr,int n)
{
	/* aptr	points to input array object
    * n     number of the argument in argument-list
    */

	if      (mxDOUBLE_CLASS != mxGetClassID(aptr))
   {
		mexPrintf("??? Argument #%d must be a numeric",n);
      mexPrintf(" double-precision non-sparse matrix.\n");
      mexErrMsgTxt("Wrong type of input argument.");
	}
   else if (mxGetNumberOfDimensions(aptr)>2)
   {
   	mexPrintf("??? Argument #%d must be a two-dimensional matrix.\n",n);
      mexErrMsgTxt("Wrong type of input argument.");
   }
   return;
}

/* argument check for double vectors */
int argIsVector(const mxArray *aptr,int n)
{
	/* aptr	points to input array object
    * n     number of the argument in argument-list
    *
    * returns : length of vector
    */

   int rows;				/* number of rows in vector */
   int cols;				/* number of columns in vector */
   int maxval,minval;   /* max and min of rows and cols */

	if      (mxDOUBLE_CLASS != mxGetClassID(aptr))
   {
		mexPrintf("??? Argument #%d must be a numeric",n);
      mexPrintf(" double-precision non-sparse vector.\n");
      mexErrMsgTxt("Wrong type of input argument.");
	}
   else if (mxGetNumberOfDimensions(aptr)>2)
   {
   	mexPrintf("??? Argument #%d must be a one-dimensional vector.\n",n);
      mexErrMsgTxt("Wrong type of input argument.");
   }
   else
   {
      rows=mxGetM(aptr); cols=mxGetN(aptr);
      maxval=MAX(rows,cols); minval=MIN(rows,cols);
      if (minval>1)
      {
      	mexPrintf("??? Argument #%d must be a one-dimensional vector.\n",n);
      	mexErrMsgTxt("Wrong type of input argument.");
      }
      else
      {
         if (minval==0) maxval=0;
      	return(maxval);
      }
   }
   return(-1);
}

/* argument check for double scalars */
double argIsScalar(const mxArray *aptr,int n)
{
	/* aptr	points to input array object
    * n     number of the argument in argument-list
    * 
    * returns : real scalar value
    */

	if      (mxDOUBLE_CLASS != mxGetClassID(aptr))
   {
		mexPrintf("??? Argument #%d must be a numeric",n);
      mexPrintf(" double-precision scalar.\n");
      mexErrMsgTxt("Wrong type of input argument.");
	}
   else if (mxGetNumberOfDimensions(aptr)>2)
   {
   	mexPrintf("??? Argument #%d must be a scalar.\n",n);
      mexErrMsgTxt("Wrong type of input argument.");
   }
   else
   {
      if (!(mxGetM(aptr)==1 && mxGetN(aptr)==1))
      {
      	mexPrintf("??? Argument #%d must be a scalar.\n",n);
      	mexErrMsgTxt("Wrong type of input argument.");
      }
      else return((double)mxGetScalar(aptr));
   }
   return(0.0);
}

/* argument check for integer index */
int argIsIndex(const mxArray *aptr,int n)
{
	/* aptr	points to input array object
    * n     number of the argument in argument-list
    *
    * returns : integer index value
    */

   double idx; /* scalar value */

	if      (mxDOUBLE_CLASS != mxGetClassID(aptr))
   {
		mexPrintf("??? Argument #%d must be a numeric (double) scalar.\n",n);
      mexErrMsgTxt("Wrong type of input argument.");
	}
   else if (mxGetNumberOfDimensions(aptr)>2)
   {
   	mexPrintf("??? Argument #%d must be a scalar.\n",n);
      mexErrMsgTxt("Wrong type of input argument.");
   }
   else
   {
      if (!(mxGetM(aptr)==1 && mxGetN(aptr)==1))
      {
      	mexPrintf("??? Argument #%d must be a scalar.\n",n);
      	mexErrMsgTxt("Wrong type of input argument.");
      }
      else
      {
      	idx=mxGetScalar(aptr);
         /* make sure index is within integer range */
         if ( idx<(double)INT_MIN || idx>(double)INT_MAX )
         {
           	mexPrintf("??? Argument #%d is too large.\n",n);
      		mexErrMsgTxt("Input argument out of integer-range.");
         }
         else return((int)idx);
      }
   }
   return(0);
}

