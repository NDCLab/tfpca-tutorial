/****************************************************************************/
/* allocate.c : utility routines for allocating memory                      */
/****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include "memory.h"
#include "emcp.h"

/************************************************************************/
/*  floatTensor()  : create 3d matrix of floats                             */
/************************************************************************/
float ***floatTensor(int rowI, int rowE, int colI, int colE, int dimI, int dimE)
{
    long i,j,rowN=rowE-rowI+1,colN=colE-colI+1,depN=dimE-dimI+1;
    float ***t;

    /* allocate pointers to pointers to rows */
    t=(float ***) malloc((size_t)((rowN+END)*sizeof(float**)));
    if (!t) terminate(ERROR,"There has been a memory allocation error " 
                            "# 1 in floatTensor()");
    t += END;
    t -= rowI;

    /* allocate pointers to rows and set pointers to them */
    t[rowI]=(float **) malloc((size_t)((rowN*colN+END)*sizeof(float*)));
    if (!t[rowI]) terminate(ERROR,"There has been a memory allocation error " 
                                  "# 2 in floatTensor()");
    t[rowI] += END;
    t[rowI] -= colI;

    /* allocate rows and set pointers to them */
    t[rowI][colI]=(float *) malloc((size_t)((rowN*colN*depN+END)*
                sizeof(float)));
    if (!t[rowI][colI])
        terminate(ERROR,"There has been a memory allocation error " 
                        "# 3 in floatTensor()");
    t[rowI][colI] += END;
    t[rowI][colI] -= dimI;

    for(j=colI+1;j<=colE;j++) t[rowI][j]=t[rowI][j-1]+depN;
    for(i=rowI+1;i<=rowE;i++) {
        t[i]=t[i-1]+colN;
        t[i][colI]=t[i-1][colI]+colN*depN;
        for(j=colI+1;j<=colE;j++) t[i][j]=t[i][j-1]+depN;
    }

    /* return pointer to array of pointers to rows */
    return t;
}

/************************************************************************/
/*  trialVector()  : create an array of struct TrialInfo                */
/************************************************************************/
struct TrialInfo *trialVector(int start, int end)
{
    struct TrialInfo *v;

    v=(struct TrialInfo *)malloc((size_t) ((end-start+1+END)*
       sizeof(struct TrialInfo)));
    if (!v)terminate(ERROR,
        "There has been a memory allocation error "
        "in vector() of struct TrialInfo");
    return v-start+END;
}

/************************************************************************/
/*  free_floatTensor()  : free 3d matrix of floats                          */
/************************************************************************/
void free_floatTensor
    (float ***t,int rowI,int rowE,int colI,int colE,int dimI,int dimE)
{
    free((FREE_ARG) (t[rowI][colI]+dimI-END));
    free((FREE_ARG) (t[rowI]+colI-END));
    free((FREE_ARG) (t+rowI-END));
}

/************************************************************************/
/*  free_trialVector()  : free array of struct TrialInfo                */
/************************************************************************/
void free_trialVector(struct TrialInfo *v, long start, long end)
{
    free((FREE_ARG) (v+start-END));
}

/************************************************************************/
/*  doublesVector()  : declare an array of doubles range [start...end]      */
/************************************************************************/
double *doublesVector(int start, int end)
/* allocate a double vector with subscript range v[start..end] */
{
    double *v;

    v=(double *)malloc((size_t) ((end-start+1+END)*sizeof(double)));
    if (!v) terminate(ERROR,"There has been a memory allocation error "
                            "in doublesVector()");
    return v-start+END;
}

/************************************************************************/
/*  free_doublesVector()  : free an array of doubles range [start...end]*/
/************************************************************************/
void free_doublesVector(double *v, int start, int end)
/* free a double vector allocated with doublesVector() */
{
    free((FREE_ARG) (v+start-END));
}

/************************************************************************/
/*  intVector()  : create an array of ints range [start...end]          */
/************************************************************************/
int *intVector(int start, int end)
/* allocate an int vector with subscript range v[start..end] */
{
    int *v;

    v=(int *)malloc((size_t) ((end-start+1+END)*sizeof(int)));
    if (!v) terminate(ERROR,"There has been a memory allocation error " 
                            "in intVector()");
    return v-start+END;
}

/************************************************************************/
/*  free_intVector()  : free an array of ints range [start...end]       */
/************************************************************************/
void free_intVector(int *v, int start, int end)
/* free an int vector allocated with intVector() */
{
    free((FREE_ARG) (v+start-END));
}
/***********************************************************************/
/*  doublesMatrix()  : make doubles range [rowI...rowE][colI..colE]    */
/***********************************************************************/
double **doublesMatrix(int rowI, int rowE, int colI, int colE)
{
    long i, rowN=rowE-rowI+1,colN=colE-colI+1;
    double **m;

    /* allocate pointers to rows */
    m=(double **) malloc((size_t)((rowN+END)*sizeof(double*)));
    if (!m) terminate(ERROR,"There has been a memory allocation error " 
                            "#1 in matrix()");
    m += END;
    m -= rowI;

    /* allocate rows and set pointers to them */
    m[rowI]=(double *) malloc((size_t)((rowN*colN+END)*sizeof(double)));
    if (!m[rowI]) terminate(ERROR,"There has been a memory allocation error "
                                  "#2 in matrix()");
    m[rowI] += END;
    m[rowI] -= colI;

    for(i=rowI+1;i<=rowE;i++) m[i]=m[i-1]+colN;

    /* return pointer to array of pointers to rows */
    return m;
}

/************************************************************************/
/*  free_doublesMatrix(): make doubles range [rowI...rowE][colI..colE]  */
/************************************************************************/
void free_doublesMatrix(double **m, int rowI, int rowE, int colI, int colE)
/* free a double matrix allocated by doublesMatrix() */
{
    free((FREE_ARG) (m[rowI]+colI-END));
    free((FREE_ARG) (m+rowI-END));
}

/************************************************************************/
/*  intMatrix()  : make ints range [rowI...rowE][colI..colE]            */
/************************************************************************/
int **intMatrix(int rowI, int rowE, int colI, int colE)
{
    long i, rowN=rowE-rowI+1,colN=colE-colI+1;
    int **m;

    /* allocate pointers to rows */
    m=(int **) malloc((size_t)((rowN+END)*sizeof(int*)));
    if (!m) terminate(ERROR,"There has been a memory allocation error "
                            "#1 in matrix()");
    m += END;
    m -= rowI;


    /* allocate rows and set pointers to them */
    m[rowI]=(int *) malloc((size_t)((rowN*colN+END)*sizeof(int)));
    if (!m[rowI]) terminate(ERROR,"There has been a memory allocation error "
                                  "#2 in matrix()");
    m[rowI] += END;
    m[rowI] -= colI;

    for(i=rowI+1;i<=rowE;i++) m[i]=m[i-1]+colN;

    /* return pointer to array of pointers to rows */
    return m;
}

/************************************************************************/
/*  free_intMatrix()  : free ints range [rowI...rowE][colI..colE]       */
/************************************************************************/
void free_intMatrix(int **m, int rowI, int rowE, int colI, int colE)
{
    free((FREE_ARG) (m[rowI]+colI-END));
    free((FREE_ARG) (m+rowI-END));
}


