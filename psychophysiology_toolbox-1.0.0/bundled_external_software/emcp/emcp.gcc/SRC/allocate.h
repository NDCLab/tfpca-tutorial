/****************************************************************************/
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/****************************************************************************/


/* memory routines */

double  *doublesVector(int start, int end);
void    free_doublesVector(double *v, int start, int end);
int     *intVector(int start, int end);
void    free_intVector(int *v, int start, int end);
void    readInitString(char *arg[]);
struct  TrialInfo *trialVector(int start, int end);
float   ***floatTensor(int rowI, int rowE, int colI, int colE, int dimI, int dimE);
void    free_floatTensor(float ***t, int rowI, int rowE, int colI, int colE,
                      int dimI, int dimE);
void    free_trialVector(struct TrialInfo *v, long start, long end);
void    free_doublesMatrix(double **m, int rowI, int rowE, int colI, int colE);
int     **intMatrix(int rowI, int rowE, int colI, int colE);
double  **doublesMatrix(int rowI, int rowE, int colI, int colE);
void    free_intMatrix(int **m, int rowI, int rowE, int colI, int colE);

