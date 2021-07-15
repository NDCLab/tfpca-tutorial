/****************************************************************************/
/*                                                                          */
/* Originally written in Fortran by Gabriele Gratton : June 7, 1983.        */
/*      Revised : May 22, 1986                                              */
/*      Adapted to Microsoft Fortran : April 5, 1990. University of Illinois*/
/*      Dept. of Psychology, Cognitive Psychophysiology Lab.                */
/*                                                                          */
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/*                                                                          */
/* Thanks to Marten Scheffers for helping with comprehending and commenting */
/* the code.  Thanks to Brian Foote for lots of help with programming.      */
/* Thanks to Leun Otten for helping with the data formats and blink         */
/* criteria.  Thanks to Greg Miller and Fran Graham for explaining          */
/* critical parts of emcp.                                                  */
/*                                                                          */
/* Modified by Bill Gehring : February 2, 1996                              */
/*       For use with NeuroScan Inc. EEG files                              */
/*                                                                          */
/*       Bill Gehring                                                       */
/*       Human Brain Electrophysiology Laboratory                           */
/*       Department of Psychology                                           */
/*       University of Michigan                                             */
/*       Ann Arbor, Michigan  48109-1109                                    */
/*       wgehring@umich.edu                                                 */
/*                                                                          */
/* Bug fix by Bill Gehring : June 23, 1998:                                 */
/*     Now correctly retains rejection status for rejected                  */
/*     trials in Neuroscan files                                            */
/*                                                                          */
/* Modified by Bill Gehring : August 22, 2001                               */
/*      Changed header variable minor_rev to 11 on output                   */
/*          So that Neuroscan 4.1.x will recognize it as an old format File */
/*                                                                          */
/* Modified by Bill Gehring, June 22, 2007                                  */
/*      Fixed binary input so no more byte-swapping                         */
/*      Increased maximum number of channels to 512                         */
/*                                                                          */
/****************************************************************************/
/*   This code may be distributed freely as long as the acknowledgements    */
/*   above are included                                                     */
/****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include "allocate.h"       /* allocation of memory */
#include "emcp.h"           /* utility routines */
#include "compute.h"        /* computational subroutines */
#include "files.h"          /* input/output of data */
#include "selectc.h"        /* trial sorting based on id information */

#define   N_ELECT 513
#include "sethead.h"        /* NeuroScan header file */
ELECTLOC    *chanloc[N_ELECT];
SETUP       erp;              /* variable to contain NS header info */


typedef struct
{
      char     accept  __attribute__ ((packed));
      short    ttype __attribute__ ((packed));
      short    correct  __attribute__ ((packed));
      float    rt  __attribute__ ((packed));
      short    response  __attribute__ ((packed));
      short    reserved  __attribute__ ((packed));
} SWEEP_HEAD;

SWEEP_HEAD      *sweephead[1000]; /* limit of a thousand trials */

int     veogchannel,heogchannel,fzchannel;
char    *uncor_chans[N_ELECT];
short   NumUncorrected;
short   corflag[N_ELECT];     /* flag for channels to be corrected */
short   logflag[N_ELECT];    /* flag for chans' info to be output to logfile */

/* for neuroscan input format, veogchannel defined by labels in header,
        for other formats, taken from VEOG_CHANNEL in emcp.h */

/*** Variables ***/
FILE    *parameterFile,                     /* file containing params */
        *dataFile,                          /* raw data file */
        *calibrationFile,                   /* calibration values for AD conv */
        *correctedSngTrlFile,               /* corrected single trial file */
        *logFile;                           /* log of activity */


struct  Parameters parameters;              /* parameters for input file */

float   ***rawData,                         /* raw data array */
        ***rawIDs;                          /* raw IDs array     */

int     *trialsInBin,                       /* number of trials in each bin  */
        **markBlink;                        /* blink present at [point] */
                                            /* in curTrial   */

double  *curIDs,                            /* current IDs */
        *trialBaseline,                     /* buffer for baseline of trial */
        **binBaseline;                      /* buffer for baseline of bins */

struct  TrialInfo *trialInfo;               /* trial info array */

int     verbose = 1,                        /* display info on screen, default to yes */
        beckmanCalibration;                 /* Beckman calibration active */

/*** Structs for correlation determinations ***/
struct  Corr    blink,                      /* used to organize arrays  */
                saccade;                    /* associated with calculation */
                                            /* of correlations among */
                                            /* residual.heogCovar & HEOG channels */
                                            /* and Fz */

/*** Variables for blink detection  ***/
int     msTen,                              /* # samples (points) in 10 ms */
        thirdOfBlink,                       /* # pts in 1/3 of blink window */
        initBlinkScan,                      /* 1st pt to scan for blinks */
        endBlinkScan,                       /* last pt to scan for blinks */
        middleOfBlink;                      /* pt in middle of blink window */
double  blinkCriteria,                      /* criteria for blink */
        windVariance=2.0,                   /* window variance */
        lengthOfWind;                       /* # points in blink template */

/*** Variables for EEG rejection ***/
double  criteria;                           /* criteria for out-of-scale */

/*** Variables for artifact removal ***/
double  totalPoints;                        /* total # data points */
float   ***rawAverage;                      /* average wave in each bin */
double  *calibration,                       /* calibration vals for AD converters */
        **meanIDs;                          /* average of ID values */



/****************************************************************************/
/*  Main                                                                    */
/****************************************************************************/

int main(int argc,char *argv[])
{
        time_t startTime,finishTime ;                   /* Let's clock this thing... */
        char msgBuf[256] ;
        double elapsedTime ;
    extern  int     msTen,                  /* # samples (points) in 10 ms */
                    thirdOfBlink,           /* # pts in 1/3 of blink window */
                    middleOfBlink,          /* pt in middle of blink window */
                    initBlinkScan,          /* 1st pt to scan for blinks */
                    endBlinkScan;           /* last pt to scan for blinks */
    extern double   blinkCriteria,          /* criteria for blink */
                    windVariance,           /* window variance */
                    lengthOfWind;           /* # points in blink template */


    int     i,                      /* counter added by BG */
            trial,                          /* counters */
            point,
            channel,
            bin,
            id,
            numTrials,                      /* used to count total #trials */
            curTrial = 0,                   /* trial being analyzed */
            rejectionCount[7]={0,0,0,0,0,0,0};  /* why trials are rejected */
            /* note: there are five possible tags for each trial which
               correspond to rejectionCount[0...4].
               case 0:  trial accepted
               case 1:  AD point out-of-scale in an EEG channel
               case 2:  10 consecutive AD points out-of-scale
               case 3:  more than 10 VEOG points out-of-scale
               case 4:  unable to recover VEOG
               case 6:  Previously rejected by Neuroscan
            */

    double  tempNum;                        /* temp storage for numbers */
    char    temp[255];                      /* temp storage for strings */

        /*
         * Start here.  First, create a time stamp...
         */
        startTime = time(NULL) ;

    readInitString(argv);
    /* defined in <files.c> -- checks input string */
    /* reads in the +v xx.crd xx.dat xx.cal */
    readParameters(argv[2], argv[3]);
    /* read the parameters in <files.c> */
    /* eg. num trials, num points, num channels etc. */

    /* readCalibrations moved from here to follow NS input stuff */

/*    readCalibrations(argv[4]);*/

    /* read the calibration for AD converters in */
    /* pass arg[4] as the file name */
    if (parameters.inputType==1 || parameters.inputFormat == 0)
    /* if binary data */
        strcpy(temp,"rb");
        /* open the file for read as binary below */
    else
        strcpy(temp,"r");

        /* other wise just read ascii text */

    dataFile=openFile(parameters.fileNameOf.data,temp);

    /*  read header information (NeuroScan only) */

    if(parameters.inputFormat == 0){
      fread(&erp, sizeof (SETUP), 1, dataFile);

/*  set up defaults to be channels specified in emcp.h */

        veogchannel=0;
        heogchannel=0;
        fzchannel=0;

      for (channel=1; channel<=erp.nchannels; channel++){
         chanloc[channel] = (ELECTLOC*) malloc(sizeof(ELECTLOC) );
         fread (chanloc[channel], sizeof (ELECTLOC), 1, dataFile);
         /* figure out which channels are which, and also which should be
                left alone */
         if(strcmp("FZ",chanloc[channel]->lab)==0) fzchannel = channel;
         corflag[channel] = 1;          /* determine whether to correct it */
         logflag[channel] = 1;
         for(i=1; i<=NumUncorrected; i++){
              if(strcmp(uncor_chans[i],chanloc[channel]->lab)==0){
                   corflag[channel] = 0;
                   logflag[channel] = 0;
              }
         }
         if(strcmp("VEOG",chanloc[channel]->lab)==0){
              veogchannel=channel;
         }
         if(strcmp("HEOG",chanloc[channel]->lab)==0){
              heogchannel=channel;
         }
    }

/*      if veog, heog, and fz still not specified, set to emcp.h defaults */

      if(!veogchannel)veogchannel=VEOG_CHANNEL;
      if(!heogchannel)heogchannel=HEOG_CHANNEL;
      if(!fzchannel)fzchannel=FZ_CHANNEL;
      corflag[veogchannel]=0;
      logflag[veogchannel]=1;
      corflag[heogchannel]=0;
      logflag[heogchannel]=1;
      corflag[fzchannel]=1;
      logflag[fzchannel]=1;

      if(parameters.EOGSensitivity <= 0){
           parameters.EOGSensitivity = 204.8 / (chanloc[veogchannel]->sensitivity * chanloc[veogchannel]->calib);
      }
      parameters.trialLength = erp.pnts;   /* points per wave */
      parameters.totalChannels = erp.nchannels; /* all channels */
      parameters.eegChannels = erp.nchannels;
      parameters.numIDs = 3;  /* 3 ids: 1=trial 2=bin 3=channel */
      parameters.numEEGChannels = erp.nchannels; /* not used */
      parameters.digitizingRate = 1000.0 / (float) erp.rate; /* erp.rate is Hz */
      parameters.inputType = 1;
      parameters.numTrials = erp.compsweeps;
      fprintf(logFile,"\n Data from NeuroScan Header:\n\n");
      fprintf(logFile,"\tNumber of Sweeps          = %d\n",erp.nsweeps);
      fprintf(logFile,"\tCompSweeps                = %d\n",erp.compsweeps);
      fprintf(logFile,"\tAccepted Trials           = %d\n",erp.acceptcnt);
      fprintf(logFile,"\tRejected Trials           = %d\n",erp.rejectcnt);
      fprintf(logFile,"\tNumber of Points          = %d\n",erp.pnts);
      fprintf(logFile,"\tNumber of Channels        = %d\n",erp.nchannels);
      fprintf(logFile,"\tDigitization Rate         = %d\n",erp.rate);
      fprintf(logFile,"\tDigitization Rate in msec = %f\n",parameters.digitizingRate);
      fprintf(logFile,"\tEOG Sensitivity (AD/uV)  = %f\n",parameters.EOGSensitivity);
      fprintf(logFile,"\n\n** NeuroScan Header Individual Channel Information **\n");
      fprintf(logFile,"\tChannel   Baseln Sensitivity Calibrtion\n");
      for(i=1; i<=erp.nchannels; i++){
           fprintf(logFile,"\t%9.9s %6d  %9.3f  %9.3f\n",chanloc[i]->lab,
                   chanloc[i]->baseline,
                   chanloc[i]->sensitivity,
                   chanloc[i]->calib);
      }
 }
else if(parameters.inputFormat != 0){
      NumUncorrected = 0;

      /* BG: n.b. for non-neuroscan files, this code allows
         veogchannel and heogchannel and eeg channels to be
         any channels up to and including numEEGChannels + 2.
         the first channel does not have to be veog, 2nd heog etc.,
         but all channels that will NOT be corrected must follow
         numEEGChannels + 2
         */

        veogchannel=VEOG_CHANNEL;
        heogchannel=HEOG_CHANNEL;
        fzchannel=FZ_CHANNEL;
        for(channel=1; channel<= parameters.numEEGChannels + 2; channel++){
            if(channel==veogchannel || channel == heogchannel){
                corflag[channel]=0;
                logflag[channel]=1;
           }
            else {
                 corflag[channel]=1;
                 logflag[channel]=1;
            }
       }
       for(channel=parameters.numEEGChannels + 3; channel <=parameters.totalChannels; channel++){
            NumUncorrected++;
            corflag[channel]=0;
            logflag[channel]=0;

       }
        fprintf(logFile," Number of uncorrected channels is %d:\n\t",NumUncorrected);
        if(NumUncorrected)fprintf(logFile," Uncorrected channels are %d through %d\n",parameters.numEEGChannels + 3, parameters.totalChannels);
 }

     if(argc>4) readCalibrations(argv[4]) ;
     else readCalibrations("");         /* kludge */

/* read the calibration for AD converters in now that totalChannels is known*/
/* pass arg[4] as the file name */

    /* open up the data file; openFile defined in <files.c> */
    /* with rb or r as specified above */

    fprintf(logFile," \nChannel assignments used:\n");
    fprintf(logFile," VEOG = %d, HEOG = %d, FZ = %d\n",veogchannel,heogchannel,fzchannel);

    /**** Preliminary pass through data file ****/
    /* second parameter to readTrial is just to */
    /* count the trials -- used to allocate     */
    /* necessary array space. Checks to see if  */
    /* # of trials was defined in card file.    */
    /********************************************/

    if(parameters.inputFormat == 0 && parameters.numTrials==-1){
        numTrials=erp.compsweeps;
    }
    else
        numTrials=parameters.numTrials;

    /* set this variable to numTrials read from parameters */

    if (parameters.numTrials==0)
    /* if numTrials == 0 then we want to count number of trials */
    /* manually                                                 */
    {
        if (verbose)
            printf(">> Counting trials.\n"
                   ">> Note:  Enter the number of trials in the data set as the\n"
                   "          last parameter before the selection rules.  By doing\n"
                   "          so EMCP is not required to scan the entire file to\n"
                   "          count them.  Therefore, by entering the number of trials\n"
                   "          into the card file EMCP will finish more quickly.\n");
        while (readTrial(numTrials,COUNT_ONLY,criteria)!=5)
        /* readTrial from <files.c> -- return 5 means at EOF */
        {
            ++numTrials;
            /* determine number of trials in data file */
        }
    parameters.numTrials=numTrials;
    rewind(dataFile);
        /* reset dataFile to start so we can readTrial and store data */
    }
    /* NB numtrials incremented here for the sake of array sizes */
    sprintf(temp, "%s %d %s %s", ">> Counted", numTrials++,"in data file", parameters.fileNameOf.data);
    display(logFile,verbose,1,temp,1);

    /* send string temp to display defined in <emcp.c> */
    /********************************************/
    /*                                          */
    /****     End of preliminary pass        ****/


    /****  Allocation of memory for arrays   ****/
    /*                                          */
    /********************************************/
    /* note -- added 1 to each dimension because data reading  */
    /* algorithm reads until it finds an EOF; therefore it is allowed */
    /* to spill over an extra cell in each dimension */
    rawData=floatTensor(1, (numTrials),
                     1, (parameters.trialLength),
                     1, (parameters.totalChannels));
    /* declare 3-D matrix (tensor) using floatTensor from<nrutil.c> */
    tempNum=(4*(double)numTrials*(double)parameters.trialLength*
            (double)parameters.totalChannels)/1024;
    /* determine memory used     */
    sprintf(temp, "%s %g%s", ">> Declared array for data (",tempNum,"k).");
    display(logFile,verbose,1,temp,1);
    /* status update */
    rawIDs =floatTensor(1, numTrials,
                     1, parameters.numIDs,
                     1, parameters.totalChannels);
    /* declare 3-D matrix (tensor) using floatTensor from<nrutil.c> */
    tempNum=(4*(double)numTrials*(double)parameters.numIDs*
            (double)parameters.totalChannels)/1024;
    /* determine memory used */
    sprintf(temp, "%s %g%s", ">> Declared array for IDs (",tempNum,"k).");
    display(logFile,verbose,1,temp,1);

    /*  declare array for NeuroScan Sweep headers -- BG */

    for(trial=1; trial<=parameters.numTrials; trial++){
    sweephead[trial] = (SWEEP_HEAD*) malloc(sizeof(SWEEP_HEAD) );
    }
    tempNum = parameters.numTrials*sizeof(SWEEP_HEAD);
    sprintf(temp, "%s %g%s", ">> Declared array for NeuroScan sweep headers (?) (",tempNum,"k).");
    display(logFile,verbose,1,temp,1);

    /* status update */

    trialInfo=trialVector(1,numTrials);
    /* declare vector of TrialInfo nrutil.c and emcp.h */
    tempNum=(sizeof(struct TrialInfo)*(double)(numTrials))/1024;
    sprintf(temp, "%s %g%s", ">> Declared array for trial"
            "info (",tempNum,"k).");
    display(logFile,verbose,1,temp,1);
    /* status update */

    parameters.numStorageBins+=1;
    /* increment to provide for a trash bin */
    trialsInBin=intVector(1,parameters.numStorageBins);
    /* number of trials classified to each storage bin */
    for(bin=1;bin<=parameters.numStorageBins;bin++)
        trialsInBin[bin]=0;
    /* initialize array; necessary sense used as a counter   */

    curIDs=doublesVector(1,parameters.numIDs);
    /* transfers each trials ids to this vector for scard() */

    markBlink=intMatrix(1,numTrials,
                      1,parameters.trialLength);
    /* declare matrix of ints for blink analysis -- a 1 where there is a */
    /* blink present so initialize to all 0's later in checkBlink()*/

    trialBaseline=doublesVector(1,parameters.totalChannels);
    /* the baseline for a trial is stored here  */

    binBaseline=doublesMatrix(1,parameters.totalChannels,
                        1,parameters.numStorageBins);
    /* declare matrix of doubles too */
    /* store baseline sums for each channel by bin */
    for(channel=1;channel<=parameters.totalChannels;channel++)
        for(bin=1;bin<=parameters.numStorageBins;bin++)
            binBaseline[channel][bin]=0;
    /* initialize matrix for use */

    meanIDs=doublesMatrix(1,parameters.numStorageBins,
                    1,parameters.numIDs);
    for(bin=1;bin<=parameters.numStorageBins;bin++)
        for(id=1;id<=parameters.numIDs;id++)
            meanIDs[bin][id]=0;
    /* initialize and allocate matrix for average id values */

    blink.pointsInBin=intMatrix(1,parameters.trialLength,
                            1,parameters.numStorageBins);
    /* allocate space used to determine correlation */
    blink.sum=floatTensor(1,parameters.trialLength,
                       1,parameters.totalChannels,
                       1,parameters.numStorageBins);
    blink.raw.variance=doublesVector(1,parameters.totalChannels);
    blink.raw.veogCovar=doublesVector(1,parameters.totalChannels);
    blink.raw.heogCovar=doublesVector(1,parameters.totalChannels);
    /* all array above used to calculate variance for blinks */

    saccade.pointsInBin=intMatrix(1,parameters.trialLength,
                              1,parameters.numStorageBins);
    /* allocate space used to determine correlation */
    saccade.sum=floatTensor(1,parameters.trialLength,
                               1,parameters.totalChannels,
                               1,parameters.numStorageBins);
    saccade.raw.variance=doublesVector(1,parameters.totalChannels);
    saccade.raw.veogCovar=doublesVector(1,parameters.totalChannels);
    saccade.raw.heogCovar=doublesVector(1,parameters.totalChannels);
    /* all array above used to calculate variance for saccades */
    for(channel=1;channel<=parameters.totalChannels;channel++)
    {
      blink.raw.veogCovar[channel]=0;
      blink.raw.heogCovar[channel]=0;
      blink.raw.variance[channel]=0;
      saccade.raw.veogCovar[channel]=0;
      saccade.raw.heogCovar[channel]=0;
      saccade.raw.variance[channel]=0;
      for(point=1;point<=parameters.trialLength;point++)
      {
        for(bin=1;bin<=parameters.numStorageBins;bin++)
        {
            blink.pointsInBin[point][bin]=0;
            blink.sum[point][channel][bin]=0;
            saccade.pointsInBin[point][bin]=0;
            saccade.sum[point][channel][bin]=0;
        }
       }
 }


    /**** Set up some preliminary variables for accept/reject ****/
    /*                                                           */
    /*************************************************************/
    if (0!=parameters.ADBits)
    /* if AD level used to reject trial during input */
    {
        criteria = pow(2.0,(double)parameters.ADBits);
        /* square ADBits */
        criteria = criteria/2.0-1-47*(double)beckmanCalibration;
        /* (ADBits/2) */
        /* subtract 47 more if Beckman Calibration is necessary */
    }
    blinkCriteria = 14.0*(double)parameters.EOGSensitivity;

    /* determine criteria for blinks */
    /* value of 14 determined by gmiller@s.psych.uiuc.edu */
    /* in file emf11p.txt based on Gabrielle Gratton's original */
    /* code */

    msTen = (10.0/parameters.digitizingRate)+0.5;
    /* # points = 10 ms */
    if(!((thirdOfBlink = msTen*7)%2)) thirdOfBlink++;
    /* # points in 1/3 of blink template, make odd */
    middleOfBlink = (thirdOfBlink+1)/2;
    /* point in middle of blink window */
    lengthOfWind = (double)thirdOfBlink*3.0;
    /* # points in blink template */
    initBlinkScan = thirdOfBlink+middleOfBlink;
    /* first point to scan for blinks */
    endBlinkScan = parameters.trialLength-initBlinkScan-thirdOfBlink+1;
    /* last point to scan for blink */

    /**** Begin loop through trials -- accept/reject ****/
    /*                                                  */
    /* NOTES:  In this section of the program each      */
    /* trial is read into the arrays pointed to by      */
    /* rawData and rawIDs.  The VEOG channel (1) is     */
    /* checked to see if there are:                     */
    /*  1.  Ten consecutive points out-of-scale         */
    /*      rawData[t][p][veogchannel]>criteria         */
    /*  2.  If < 10 then program recovers epoch that    */
    /*      is out-of-scale.                            */
    /*                                                  */
    /*  The remaining channels are checked to see if:   */
    /*  1.  If 1 AD points is out-of-scale.             */
    /*  2.  If 10 consecutive equal data points are     */
    /*      in a channel.                               */
    /*  This rejection/acception loop is optimized for  */
    /*  speed -- not memory conservation (as memory is  */
    /*  in abundance these days).  Therefore these four */
    /*  criteria are checked for simultaneously,        */
    /*  which inherently makes the code more difficult  */
    /*  to read.                                        */
    /*  The criteria are checked in <files.c> using the */
    /*  routine checkData() which in turn checks all    */
    /*  four criteria.                                  */
    /*  The values returned are used to assess the      */
    /*  the status of the trial.                        */
    /****************************************************/
    /* modification by BG:  checks that current trial is less than or
       equal to numTrials, in case there is anything between the end of the
       last trial and the EOF */
while(++curTrial <= parameters.numTrials &&
      (trialInfo[curTrial].status=readTrial(curTrial,READ_DATA,criteria))!=5)
    /* readTrial from <files.c> second parameter "0" means to store trials */
    /* in data arrays this time through. */
    /* returns a # from 0...5 where 0 means trial accepted, 1..4 means */
    /* trial rejected and 5 means EOF has been reached. */
    /* BG:  added 6/23/98:  rejection status of 6 means that trial was rejected
            in Neuroscan format prior to EMCP */
    {

        /*  added by BG 6/23/98 - retains Neuroscan rejection format */

        if(parameters.outputFormat == 0 && sweephead[curTrial]->accept == 0){
                trialInfo[curTrial].status = 1;
        }

        ++rejectionCount[trialInfo[curTrial].status];

         /* update NeuroScan accept info */
        if(parameters.outputFormat == 0){
             if(trialInfo[curTrial].status == 0){
                  sweephead[curTrial]->accept = 1;
             }
             else {
                  sweephead[curTrial]->accept = 0;
             }
        }
        /* update rejection count [0...4] as mentioned in prev comment */
        if (trialInfo[curTrial].status==0)
        /* if trial accepted */
        {
            if (classified(curTrial)==0 &&parameters.singleTrialOpt!=-1)
            /* if  says to check blinks (==0) */
            /* and single trial opt is not averaging only */
            /* if returns 1 for classified then means not to check for */
            /* blinks */
            {
                checkBlink(curTrial);
                /* check for blinks */
                computeTrialBaseline(REMOVE, curTrial);
                /* compute && subtract average of each channel */
                /* from that channel */
                sumTrial(curTrial);
                /* sums for correlation values */
                computeTrialBaseline(RESTORE, curTrial);
                /* restores the mean of the channel to the */
                /* channel */
            }
            updateRawIDs(curTrial);
            /* add values of ids to mean ids sum */
       }
        else /* if trial not accepted */
        {
            trialInfo[curTrial].classification=parameters.numStorageBins;
            /* toss bad trials in trash bin (always the last bin) */
        } /* end {if (trialInfo[curTrial].status==0)} */
    ++trialsInBin[trialInfo[curTrial].classification];
    /* increment counter for # trials in each bin */
    outputBins(curTrial);
    /* provide status of each bin */
    }/* end {while (readTrial(++curTrial,0,criteria))} */
    /****    End of accept/rejection pass   *****/
    /*       and preliminary summming           */
    /********************************************/


    /****       Free space from arrays       ****/
    /*          that are no longer needed       */
    /********************************************/
    --parameters.numStorageBins;
    /* removes the trash bin from the calculations */
    /* by subtracting 1 from # of bins */
    free_doublesVector(curIDs,1,parameters.numIDs);
    /* free up some memory, used in classified() */

    /****   Status of accept/rejection pass  ****/
    /*                                          */
    /********************************************/
    sprintf(temp, "# of trials accepted: %d",rejectionCount[0]);
    display(logFile,verbose,1,temp,0);
    sprintf(temp, "Status 1:  # of trials with EEG out-of-scale: %d",rejectionCount[1]);
    display(logFile,verbose,1,temp,0);
    sprintf(temp, "Status 2:  # of trials EEG flat: %d",rejectionCount[2]);
    display(logFile,verbose,1,temp,0);
    sprintf(temp, "Status 3:  # of trials 10 EOG points out-of-scale: %d",rejectionCount[3]);
    display(logFile,verbose,1,temp,0);
    sprintf(temp, "Status 4:  # of trials EOG recovery failed: %d",rejectionCount[4]);
    display(logFile,verbose,1,temp,1);

    /* BG:  added 6/29/98 to retain Neuroscan rejection criteria */
    if (parameters.outputFormat == 0 ){
    sprintf(temp, "Status 6:  # of trials rejected prior to EMCP (Neuroscan only): %d",rejectionCount[6]);
    display(logFile,verbose,1,temp,1);
    }

    /* write bin totals to logFile */
    fprintf(logFile," \nNumber of trials per bin: \n");
    for(bin=1;bin<=parameters.numStorageBins;bin++){
         fprintf(logFile,"%3d ",bin);
         if(bin%10 == 0 || bin == parameters.numStorageBins)fprintf(logFile,"\n");
    }
    for(bin=1;bin<=parameters.numStorageBins;bin++){
         fprintf(logFile,"%3d ",trialsInBin[bin]);
         if(bin%10 == 0 || bin == parameters.numStorageBins)fprintf(logFile,"\n");
    }

    /********************************************/
    /*                                          */
    /*        Compute the average blink         */
    /*****    and saccade activity by ch    *****/
    blink.channelMean=baseline(&blink.ptsInBase,blink.pointsInBin,blink.sum);
    /* compute average blink activity for each channel blink.channelMean[# ch] */

    saccade.channelMean=baseline(&saccade.ptsInBase,saccade.pointsInBin,saccade.sum);
    /* compute average saccade activity for each channel saccade.channelMean [# ch] */

    totalPoints=saccade.ptsInBase+blink.ptsInBase;
    /* saccade.ptsInBase + blink.ptsInBase = total # of points */

    outputProportions(totalPoints);
    /* prints out info on % blink data % saccade data */

    /********************************************/
    /*                                          */
    /*****    Compute the raw average blink *****/

     rawAverage=computeBinAvg(blink.sum, saccade.sum);
    /* computes the average wave and baseline in each bin by combining */
    /* blink and saccade components to form total sum of raw waveforms */
    /* and then divide by number of trials in each bin                 */

     computeRawIDs();
    /* compute the average id values */

  /*   outputBinAvg(); */

    /* converts to microvolts, removes binBaseline, outputs to file */

    if(parameters.singleTrialOpt==-1) terminate(NO_ERROR,">> EMCP is finished.");
    /* if no correction is desired then exit the program */
    /* note that this doesn't free up array space or close data file (yet) */

    /********************************************/
    /*                                          */
    /****     Compute correction factors     ****/

    computeVarForTrialWaves(blink.channelMean, blink.ptsInBase,&blink.raw);
    /* compute the total variance and covariance for blink data */
    /* across trials                                            */

    computeVarForTrialWaves(saccade.channelMean, saccade.ptsInBase,&saccade.raw);
    /* compute the total variance and covariance for saccade data */
    /* across trials                                              */

    blink.adjust=computeVarForRawWaves(blink.sum,
                       rawAverage,
                       blink.ptsInBase,
                       blink.channelMean,
                       blink.pointsInBin);
    /* adjustments to variance due to the averages */
#ifdef NEVER
{
        int iii;
for (iii=1 ; iii<=parameters.eegChannels ; iii++)
{
    fprintf(stderr,"%d veogc %12.9f heogc %12.9f\n",
        iii,
        blink.adjust.veogCovar[iii],
        blink.adjust.heogCovar[iii]) ; /* Ehehehehehehehe */
}
}
#endif

    saccade.adjust=computeVarForRawWaves(saccade.sum,
                       rawAverage,
                       saccade.ptsInBase,
                       saccade.channelMean,
                       saccade.pointsInBin);
    /* adjustments to variance due to the averages */

    blink.residual=computeResidualVariance(blink.raw,
                             blink.adjust,
                             &blink.stanDev);
#ifdef NEVER
{
        int jjj ;
for (jjj=1 ; jjj<=parameters.eegChannels ; jjj++)
{
        fprintf(stderr,"standev %d %12.9f \n",
                jjj,
                blink.stanDev[jjj]) ;
}
}
#endif
    saccade.residual=computeResidualVariance(saccade.raw,
                                             saccade.adjust,
                                             &saccade.stanDev);

    /* computes the difference between the results */
    /* of the previous two functions */

    outputVarianceTables();
    /* outputs variance/covariance tables to file */

    computeCorrWithEOG(blink.stanDev,
                        blink.residual,
                        &blink.veogCorr,
                        &blink.heogCorr);
#ifdef NEVER
{
        int iii;
fprintf(stderr,"after corr with eog\n") ;
for (iii=1 ; iii<=parameters.eegChannels ; iii++)
{
    fprintf(stderr,"%d veogc %12.9f heogc %12.9f\n",
        iii,
        blink.veogCorr[iii],
        blink.heogCorr[iii]) ; /* Ehehehehehehehe */
}
}
#endif
    /* computes corr between residual variance and EOG */

    computeCorrWithEOG(saccade.stanDev,
                        saccade.residual,
                        &saccade.veogCorr,
                        &saccade.heogCorr);
    /* computes corr between residual variance and EOG */

    computePropogation(blink.veogCorr,
                        blink.heogCorr,
                        blink.stanDev,
                        &blink.veogFactor,
                        &blink.heogFactor);
#ifdef NEVER
{
        int iii;
fprintf(stderr,"after prop\n") ;
for (iii=1 ; iii<=parameters.eegChannels ; iii++)
{
    fprintf(stderr,"%d veogc %12.9f heogc %12.9f\n",
        iii,
        blink.veogCorr[iii],
        blink.heogCorr[iii]) ; /* Ehehehehehehehe */
        blink.veogCorr[iii]=iii/10.0 ;
}
}
#endif
    /* computes the propogation factor for correction */

    computePropogation( saccade.veogCorr,
                        saccade.heogCorr,
                        saccade.stanDev,
                        &saccade.veogFactor,
                        &saccade.heogFactor);
    /* computes the propogation factor for correction */

#ifdef NEVER
{ int iii;
fprintf(stderr,"after prop\n") ;
for (iii=1 ; iii<=parameters.eegChannels ; iii++)
{
    fprintf(stderr,"%d veogc %12.9f heogc %12.9f\n",
        iii,
        blink.veogCorr[iii],
        blink.heogCorr[iii]) ; /* Ehehehehehehehe */
        blink.veogCorr[iii]=iii/10.0 ;
}
}
#endif

    outputPropogation();
#ifdef NEVER
{ int  iii;
fprintf(stderr,"after prop\n") ;
for (iii=1 ; iii<=parameters.eegChannels ; iii++)
{
    fprintf(stderr,"%d veogc %12.9f heogc %12.9f\n",
        iii,
        blink.veogCorr[iii],
        blink.heogCorr[iii]) ; /* Ehehehehehehehe */
        blink.veogCorr[iii]=iii/10.0 ;
}
}
#endif
    /* outputs the progogation factors to file */

/*      computeCorrectAvgs();*/

/*      outputCorrectedAvgs(); */

     computeCorrectedSingleTrials();

     outputCorrectedSingleTrials();

    /********************************************/
    /*                                          */
    /****      Single trial corrections      ****/
    /****       Free space from arrays       ****/
    /*          that are no longer needed       */
    /********************************************/
    free_floatTensor(rawAverage,1,parameters.trialLength,
                            1,parameters.totalChannels,
                            1,parameters.numStorageBins);
    free_floatTensor(rawData,1,numTrials,
                  1,parameters.trialLength,
                  1,parameters.totalChannels);
    free_floatTensor(rawIDs,1,numTrials,
                 1,parameters.numIDs,
                 1,parameters.totalChannels);
    free_trialVector(trialInfo,1,numTrials);
    free_intVector(trialsInBin,1,(parameters.numStorageBins)+1);
    free_intMatrix(markBlink,1,numTrials,
                   1,parameters.trialLength);
    free_doublesVector(trialBaseline,1,parameters.totalChannels);
    free_doublesMatrix(binBaseline,1,parameters.totalChannels,
                     1,parameters.numStorageBins);
    free_doublesMatrix(meanIDs,1,parameters.numStorageBins,
                 1,parameters.numIDs);

    /****  Gracefully close out the program  ****/
    /*                                          */
    /********************************************/
    closeFile(dataFile,parameters.fileNameOf.data);
    /* close the data file <files.c> */

        finishTime = time(NULL) ;
        elapsedTime = difftime(finishTime,startTime) ;
        sprintf(msgBuf,
                "**** EMCP completed.  Elapsed time:  %5.0lf sec. ****",
                        (double) elapsedTime) ;

    /* terminate(NO_ERROR, "**** EMCP completed. ****"); */
    terminate(NO_ERROR,msgBuf);
    return 0 ; /* Keep the clever flow checking compilers happy... */
    /* terminate program <emcp.c> */
}

/************************************************************************/
/*  checkBlink()  : subroutine checks to see if there is a blink        */
/************************************************************************/
void checkBlink(int trial)
{
    extern  int     msTen,                  /* # samples (points) in 10 ms */
                    thirdOfBlink,           /* # pts in 1/3 of blink window */
                    middleOfBlink,          /* pt in middle of blink window */
                    initBlinkScan,          /* 1st pt to scan for blinks */
                    endBlinkScan;           /* last pt to scan for blinks */
    extern double   blinkCriteria,          /* criteria for blink */
                    windVariance,           /* window variance */
                    lengthOfWind;          /* # points in blink template */

    int     refPoint,                       /* center of blink window */
            checkPoint,                     /* point in blink window */
            beginWind,                      /* beginning of blink window */
            endWind,                        /* end of blink window */
            posInTemplate,                  /* position in window */
            startMark,                      /* start marking blink here */
            endMark,                        /* stop marking as blink here */
            point;                          /* just a counter */
    double  covar,                          /* covariance in window */
            slope;                          /* slope in window */

    for (point=1;point<=parameters.trialLength;point++)
        markBlink[trial][point]=2;
    /* clear blink record */

    for (refPoint=initBlinkScan;refPoint<=endBlinkScan;refPoint++)
    /* define scan template around refPoint */
    {
        beginWind=refPoint-(initBlinkScan-1);
        /* beginning of scan template */
        endWind=refPoint+(initBlinkScan-1);
        /* end of scan template */
        covar=0;
        /* init covariance */

        for (checkPoint=beginWind;checkPoint<=endWind;checkPoint++)
        {
            posInTemplate=checkPoint-beginWind+1;
            /* current location in window */
            if(posInTemplate<=(thirdOfBlink+1)||posInTemplate>(2*thirdOfBlink+1))
                covar-=(double)rawData[trial][checkPoint][veogchannel];
            else
                covar+=2.0*(double)rawData[trial][checkPoint][veogchannel];
        } /* end for (checkPoint) */
        covar/=(double)lengthOfWind;
        /* determine covariance */
        slope=covar/(windVariance*windVariance);
        /* determine slope */

        if (fabs(slope)>blinkCriteria)
        /* if the slope exceeds the maximum rate of range mark as blink */
        {
            startMark = refPoint-middleOfBlink+1;
            /* this range is a blink */
            endMark = refPoint+middleOfBlink-1;
            /* stop marking here */
            for(checkPoint=startMark;checkPoint<=endMark;checkPoint++)
                markBlink[trial][checkPoint]=1;
                /* mark blink at checkPoint */
        } /* end if slope > blinkCriteria */
    } /* end for (refPoint) */
}


/************************************************************************/
/*  terminate()  : write log about error                                */
/************************************************************************/
void terminate(int error, char *message)
{
    switch(error)
    {
        case NO_ERROR:
            display(logFile, verbose, 1, message, 1);
            break;
        case ERROR:
            display(logFile, verbose, 1, message, 1);
            display(logFile, verbose, 1, "****Terminating EMCP****", 1);
            exit(1);
            break;
    }
    closeFile(logFile, parameters.fileNameOf.log);
    /* close log file <files.c> */
}

/*************************************************************************/
/*  display  : function that prints text to screen and file as designated*/
/*************************************************************************/
void display(FILE *file, int screen, int before, char *text, int after)
{
    int x;              /* counter */
    for (x=0; x < before; x++)
    {
        if (screen) printf("\n");
        if (file != NULL) fprintf(file, "\n");
    }
    /* loop through number of newlines to insert */
    /* before text */

    if (screen) printf("%s", text);
    /* if output to screen the print it */
    if (file != NULL) fprintf(file, "%s", text);
    /* if there is a log file print to it */

    for (x=0; x < after; x++)
    {
        if (screen) printf("\n");
        if (file != NULL) fprintf(file, "\n");
    }
    /* loop through number newlines to insert */
    /* after text */
}


/***********************************************************************/
/*  readInitString(): f(x) that checks for verbosity and beckman flag  */
/***********************************************************************/
void readInitString(char *argv[])
{

    if (argv[1][1] == 'v')
    /* start out with a v? */
    {
        if (argv[1][0] == '-')
            verbose = 0;
        /* if it goes -v then not verbose */
        else if (argv[1][0] == '+')
            verbose = 1;
        /* if it goes +v then it is verbose */
        else terminate(ERROR, "Unable to read initialization string\n\n"
                              "correct: <+/->v<b> <param file name> <data "
                              "file name> <calibration file name>\nexample: +vb run05.crd test"
                              ".bin\n");
        /* if not +v or -v then terminate with error <emcp.c>    */
        if (argv[1][2] == 'b') { beckmanCalibration = 1; }
        /* check for Beckman flag (need to subtract 47 for accurate AD */
        /* range if b present (-vb or +vb) */
        else { beckmanCalibration = 0; }
        /* else must be (-v or +v) */
    }
    else terminate(ERROR, "Unable to read initialization string\n"
                          "correct: <+/->v<b> <param file name> "
                          "<data file name>\nexample: +vb run05.crd "
                          "test.bin\n");
    /* if it doesn't start with a v then terminate <emcp.c> */
}

/***********************************************************************/
/*  classified()  : classifies the trials based on their ids           */
/***********************************************************************/
/* return 0: check blinks */
/* return 1: don't check for blinks */
int classified(int curTrial)
{
    int id;                                         /* counter */
    for(id=1;id<=parameters.numIDs;id++)
        curIDs[id]=(double)rawIDs[curTrial][id][veogchannel];
    /* copy IDs over to temp array */

    trialInfo[curTrial].classification=scard(curIDs+1);
    /* send off to parser for classification <scard.c> */
    if (trialInfo[curTrial].classification<=-1 &&
        parameters.singleTrialOpt==2)
    /* if doesn't fit in any bin and need to correct all trial toss */
    /* it in last bin */
    {
            trialInfo[curTrial].classification=parameters.numStorageBins;
            /* tell trialInfo it is in the last bin */
            return 0;
            /* tell it to check for blinks -- return 0 */
       }
    if (trialInfo[curTrial].classification<=-1&&
        parameters.singleTrialOpt!=2){
        return 1;
    /* if doesn't fit in any bin and no need to correct all trials */
    /* then don't mark blinks -- return 1 */
    }
    if (trialInfo[curTrial].classification<0 ||
        trialInfo[curTrial].classification>parameters.numStorageBins)
  /* fix BG 10/11/99, substitute || for &&  -- doesn't make sense otherwise: */
        /* if fits no where put it in last bin */
            trialInfo[curTrial].classification=parameters.numStorageBins;
        /* tell trialInfo it is in the last bin */
    return 0;
    /* tell it to check blinks -- return 0 */
}


