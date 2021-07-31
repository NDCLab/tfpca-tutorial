/****************************************************************************/
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/****************************************************************************/


#define NO_ERROR                0       /* for terminate function */
#define ERROR                   1       /* for terminate function */
#define VEOG_CHANNEL            1       /* position of VEOG in rawData */
#define HEOG_CHANNEL            2       /* position of HEOG in rawData */
#define FZ_CHANNEL              3       /* position of Fz channel in rawData */
#ifndef PI
#define PI                      3.1415 
#endif
#define REMOVE                  1       /* remove baseline? */
#define RESTORE                 0       /* restore baseline? */
#define END                     1       /* for array declaration */
#define FREE_ARG                char*   /* for array declaration */
#define COUNT_ONLY              1       /* only count number of trials */
#define READ_DATA               0       /* actually read data */

/* structures */

struct  Variance
{
        double  *variance,
                *veogCovar,
                *heogCovar;
};

struct  FileNames
{
    char    data[255],                  /* name of data file */
            parameters[255],            /* of parameter file */
            correctedAvgs[255],         /* of corrected averages file */
            uncorrectAvgs[255],         /* of uncorrected averages file */
            correctedSingleTrials[255], /* of corrected single trials file */
            log[255];                   /* of log file */
};
    
struct  Parameters
{       struct  FileNames fileNameOf;   /* all file names */
        int     trialLength,            /* number of time points in trial */
                numTrials,              /* number of trial in original data set */
                numIDs,                 /* number of ID words */
                numStorageBins,         /* numStorageBins */
                totalChannels,          /* number of all channels */
                numEEGChannels,         /* number of EEG channels */
                eegChannels,            /* all  EEG channels */
                                        /* + 2 (for VEOG and HEOG) */
                mastoidOpt,             /* mastoid option */
               /*  digitizingRate,         / * digitizing rate (ms) */
                singleTrialOpt,         /* single trial option   */
                vectorsOpt,             /* ID vectors in output */
                ADBits,                 /* A/D Bits (usually 12) */
                inputFormat,            /* Input file format */
                inputType,              /* Input type */
                outputFormat;           /* Output file format */
        char    outputSpecification[80];/* ???? */
        double  EOGSensitivity;         /* A/D units per microvolt */
	double  digitizingRate ;	/* digitizing rate (ms) */
};

struct  TrialInfo
{       int     status,                 /* 1 if is trial accepted or  */
                                        /* 0 if rejected */
                classification,         /* classification based on IDs */
                blink;                  /* 1 if blink in trial */
};

struct  Corr
{
        int     **pointsInBin;          /* num points in each bin */
        float   ***sum;                 /* sum for mean [# points][channels][bins]*/

        struct Variance raw,
                        adjust,
                        residual;
        
        double  *channelMean,              /* average activity in all trials */
                ptsInBase;              /* # points in the baseline */
        
        double  *stanDev;               /* standard deviation for residual vars */

        double  *weightedAvg;

        double  *veogCorr,              /* correlation of residual variance w/ VEOG */
                *heogCorr;              /* correlation of residual variance w/ HEOG */

        double  *veogFactor,            /* correction factor for VEOG */
                *heogFactor;            /* correction factor for HEOG */

    double  weight,                     /* temp weight of blink at time point */
            adjustment;                 /* temp adjust for point */
};




/* trial classification routines */
int     classified(int curTrial);
void    checkBlink(int trial);

/* utility routines */

void    display(FILE *file, int screen, int before, char *text, int after);
void    terminate(int error, char *message);

