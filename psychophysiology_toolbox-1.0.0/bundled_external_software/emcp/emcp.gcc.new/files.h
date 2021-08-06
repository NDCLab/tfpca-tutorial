/****************************************************************************/
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/****************************************************************************/

int     readParameters(char *parameterFile, char *dataName);
        /* reads the parameters for analysis in struct parameters */
int     writeParameters(void);
        /* writes these parameters to disk and screen if verbose */
FILE    *openFile(char *fileName, char *readOrWrite);
        /* opens the files specified, verifies, and creates error message */
int     closeFile(FILE *file, char *fileName);
        /* closes the file specified, verifies, and creates error message */
int     readTrial(int numTrials,int countOnly, double criteria);
        /* reads a trial, calls checkData */
int     checkData(int curTrial, int point, int channel, double criteria);
        /* called by readTrial, calls recoverVEOG, accepts/rejects trials */
int     recoverVEOG(int number, int start,int curTrial, double criteria);
        /* recovers VEOG if necessary due to out-of-range readings */
int     covariance(int curTrial, int x, int y, int start, int end,
               double *rSq, double *slope);
        /* called by recoverVEOG to check covariance between VEOG and Fz  */
void    readCalibrations(char *calibrationFileName);
        /* called by emcp.c in beginning to read in calibration data */

/* output routines */
void    outputCorrectedSingleTrials(void);
void    outputVarianceTables(void);
void    outputPropogation(void);
void    outputCorrectedAvgs(void);
void    outputBinAvg(void);
void    outputProportions(double totalPoints);
void    outputBins(int trial);
void	outputYoyo(void) ;
int	checkoverflow(int trial) ;
void	outputNeuroScan(void);

