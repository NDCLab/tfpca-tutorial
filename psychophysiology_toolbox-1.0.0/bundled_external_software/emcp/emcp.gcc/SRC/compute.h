/****************************************************************************/
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/****************************************************************************/

/* computational routines */
void    sumTrial(int trial);
void    computeTrialBaseline(int remove,int trial);
double  *baseline(double *ptsInBase, int **pointsInBin, float ***sum);
float   ***computeBinAvg(float ***bComponent, float ***sComponent);
struct 	Variance computeResidualVariance(struct Variance raw,
		struct Variance adjust, double **stanDev);
void 	computeVarForTrialWaves(double *baseline,double ptsInBase,
	 	struct Variance *raw);
struct 	Variance computeVarForRawWaves(float ***sum,float ***binAverage,
		double ptsInBase,double *baseline,int **pointsInBin);
void 	computeCorrWithEOG(double *stanDev,struct Variance res,
		double **veogCorr,double **heogCorr);
void 	computePropogation(double *veogCorr,double *heogCorr,double *stanDev,
		double **veogFactor,double **heogFactor);
void    computeCorrectAvgs(void);
void	updateRawIDs(int trial);
void    computeRawIDs(void);
void	computeCorrectedSingleTrials(void);




