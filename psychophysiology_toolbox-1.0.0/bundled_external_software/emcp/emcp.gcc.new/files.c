/****************************************************************************/
/*                                                                          */
/* FILES.c: Handles input and output of data.  Checks for artifacts in data */
/*          during the input phase.                                         */
/*                                                                          */
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/*                                                                          */
/* NOTE:  Portions of this code are direct copies of code from previous     */
/*        version.                                                          */
/* Modified 08/21/2001 Bill Gehring                                         */
/*        Make output single trial format in Neuroscan mode compatible with */
/*        Neuroscan's 4.1.x software                                        */
/****************************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "emcp.h"
#include "files.h"
#include "allocate.h"
#include "selectc.h"
#include "compute.h"
#define     N_ELECT 513

/*** NeuroScan specific variables ***/

#include "sethead.h"

extern ELECTLOC    *chanloc[N_ELECT];
extern SETUP       erp;              /* variable to contain NS header info */

typedef struct
{
      char     accept __attribute__ ((packed));
      short      ttype  __attribute__ ((packed));
      short   correct  __attribute__ ((packed));
      float    rt  __attribute__ ((packed));
      short    response  __attribute__ ((packed));
      short  reserved  __attribute__ ((packed));
} SWEEP_HEAD;

extern SWEEP_HEAD *sweephead[1000];

extern  short veogchannel, heogchannel, fzchannel;
extern  char *uncor_chans[N_ELECT];
extern  short NumUncorrected;
extern  short corflag[N_ELECT];
extern  short logflag[N_ELECT];
char    tempstring[80], *str;

/*** Variables ***/
extern FILE    *parameterFile,                /* file containing params */
               *dataFile,                     /* raw data file */
               *calibrationFile,              /* calibration values for AD conv */
               *correctedSngTrlFile,          /* corrected single trial file */
               *logFile;                      /* log of activity */


extern struct  Parameters parameters;         /* parameters for input file */

extern float   ***rawData,                    /* raw data array */
               ***rawIDs;                     /* raw IDs array     */

extern int     *trialsInBin,                  /* number of trials in each bin  */
                **markBlink;                  /* blink present at [point] */
                                              /* in curTrial   */
extern double  *curIDs,                       /* current IDs */
               *trialBaseline,                /* buffer for baseline of trial */
               **binBaseline;                 /* buffer for baseline of bins */

extern struct  TrialInfo *trialInfo;          /* trial info array */

extern int     verbose;                       /* display info on screen, default to yes */

/*** Structs for correlation determinations ***/
extern struct  Corr    blink,                 /* used to organize arrays  */
                       saccade;               /* associated with calculation */
                                              /* of correlations among */
                                              /* residual.heogCovar & HEOG channels */
                                              /* and Fz */

/*** Variables for blink detection  ***/
extern int     msTen,                         /* # samples (points) in 10 ms */
               thirdOfBlink,                  /* # pts in 1/3 of blink window */
               initBlinkScan,                 /* 1st pt to scan for blinks */
               endBlinkScan,                  /* last pt to scan for blinks */
               middleOfBlink;                 /* pt in middle of blink window */
extern double  blinkCriteria,                 /* criteria for blink */
               windVariance,              /* window variance */
               lengthOfWind;                  /* # points in blink template */

/*** Variables for EEG rejection ***/
extern double  criteria;                      /* criteria for out-of-scale */

/*** Variables for artifact removal ***/
extern double  totalPoints;                   /* total # data points */
extern float   ***rawAverage;                 /* average wave in each bin */
extern double  *calibration,                  /* calibration vals for AD converters */
               **meanIDs;                     /* average of ID values */

int     numVEOGoffScale=0,  /* num consecutive VEOG points of scale */
        firstVEOGoffScale=0;/* used for recovery of consecutive off scale VEOG */
                            /* defined globally because can't be reinitialized */
                            /* at each call of checkData(); */

/* char *temp; */

/*****************************************************************************/
/*  readCalibrations()  : reads in calibration values for AD converters      */
/*****************************************************************************/
void readCalibrations(char *calibrationFileName)
{
    int     channel;                                /* counter */

    FILE    *calibrationFile;
    char    temp[255];

    calibration=doublesVector(1,parameters.totalChannels);
    /* allocate array space */
    if(strlen(calibrationFileName)>0)
    {
         calibrationFile=openFile(calibrationFileName,"r");
        /* open calibrationFile */
        display(logFile,verbose,1,">> Reading in calibration values:",1);
        for(channel=1;channel<=parameters.totalChannels;channel++)
        {
            fscanf(calibrationFile,"%lf",&calibration[channel]);
            /* read in the calibration value for channel */
            sprintf(temp,"%d: %7.2f",channel,calibration[channel]);
            display(logFile,verbose,1,temp,1);
            /* output it to screen and file if necessary */
        }
        display(logFile,verbose,1,">> Finished reading in calibration values.",1);
        /* say it is done */
        closeFile(calibrationFile, calibrationFileName);
        /* closethe file */
    }
    else
    {
        for(channel=1;channel<=parameters.totalChannels;channel++)
            calibration[channel]=1.0;
    }
    return;
}



/*****************************************************************************/
/*  readParameters()  : function that reads parameters from paramefile       */
/*****************************************************************************/
int readParameters(char *parametersName, char *dataName)
{
    int     x,y;                                            /* counters */
    char    rootName[255],                                  /* root of dataName */
            temp[255];
    int channel;                                            /* another counter-BG */
    parameterFile = fopen(parametersName, "r");             /* open param file */
    if (parameterFile == NULL)                              /* open? */
        {
            terminate(ERROR, "Unable to open parameters file");
        }
   fscanf(parameterFile, "%d %d %d %d %d %lf %lf %d %d %d %d %d %d %s %d\n",
                                                &parameters.trialLength,
                                                &parameters.numIDs,
                                                &parameters.totalChannels,
                                                &parameters.numEEGChannels,
                                                &parameters.mastoidOpt,
                                                &parameters.digitizingRate,
                                                &parameters.EOGSensitivity,
                                                &parameters.singleTrialOpt,
                                                &parameters.vectorsOpt,
                                                &parameters.ADBits,
                                                &parameters.inputFormat,
                                                &parameters.inputType,
                                                &parameters.outputFormat,
                                           &parameters.outputSpecification,
                                           &parameters.numTrials);
    fgets(tempstring,80,parameterFile);
    sprintf(temp,"%%%s",parameters.outputSpecification);
    /* adds the % sign to the front of the string */
    for(x=0; x<80; x++)
    {
        if (temp[x] == '\n')
            temp[x] = 0;
    }
    strcpy(parameters.outputSpecification,temp);
    parameters.eegChannels = parameters.totalChannels;
    /* EEG channels + 2 for VEOG and HEOG */
    strcpy(parameters.fileNameOf.parameters, parametersName);
    /* get parameter file name */
    strcpy(parameters.fileNameOf.data, dataName);
    /* get data file name */

    for (x=strlen(dataName); x>0; x--)
    {
        if (dataName[x] == '.') break;
        /* search for last '.' in data name */
    }
    if (dataName[x] != '.')
    /* valid root name */
        terminate(ERROR, "Invalid data file name.\ncorrect: name.suffix");

    /* add check for 7 letter rootname (BG) */
    if (x > 7)
        terminate(ERROR, "Root file name greater than 7 letters.\n");

    for (y=0; y<x; y++)
        rootName[y] = dataName[y];
    /* copy root over */
    rootName[y] = 0;
    /* terminate string */

    /**** make file names by adding suffixes to rootName ****/
    sprintf(parameters.fileNameOf.correctedAvgs,"%s%s",rootName,".cav");
    sprintf(parameters.fileNameOf.uncorrectAvgs,"%s%s",rootName,".rav");
    sprintf(parameters.fileNameOf.correctedSingleTrials,"%s%s",
            rootName,".sng");
    /* Do Kevin's .sngb name change... BF */
    if (parameters.outputFormat==3){
                sprintf(parameters.fileNameOf.correctedSingleTrials,
                        "%s%s",rootName,".sngb") ;
    }
    else if (parameters.outputFormat == 0){  /* add Neuroscan option BG */
                sprintf(parameters.fileNameOf.correctedSingleTrials,
                        "%s%s%s",rootName,"c",".eeg") ;
                              /* name format:  orig:  FILENAM.EEG
                                               corrected: FILENAMC.EEG */
    }

    sprintf(parameters.fileNameOf.log,"%s%s",rootName,".log");

    logFile = openFile(parameters.fileNameOf.log, "w");

    /* figure out which channels to leave uncorrected - parse the
            string into substrings */
     str=strtok(tempstring," ,\n\r");
     channel=0;
     while(str!= NULL){
             uncor_chans[++channel] = (char *) malloc(80*sizeof(char));
             strcpy(uncor_chans[channel],str);
             str=strtok(NULL," ,\n\r");
        }
    NumUncorrected = channel;
    /* open log file */
    writeParameters();
    /* write out parameters (file.c) */
    parameters.numStorageBins = scread();
    /* scread() is defined in selectc.c */
    fprintf(logFile,"Number of storage bins           : %d\n",
        parameters.numStorageBins); /* write out to logFile */
    if (verbose) printf("Number of storage bins           : %d\n",
        parameters.numStorageBins); /* write out to screen */
    return 1;
}

/**********************************************************************/
/*  openFile()  : function that opens file for writing                */
/**********************************************************************/
FILE *openFile(char *fileName, char *readOrWrite)
{
    FILE *file;
    char temp[256] ;

    file = fopen(fileName, readOrWrite);
    if (file == NULL)
    {
        sprintf(temp,"Unable to open file %s",fileName);
        terminate(ERROR, temp);
    }
    return file;
}


/**********************************************************************/
/*  closeFile()  : function that closes log file after writing        */
/**********************************************************************/
int closeFile(FILE *file, char *fileName)
{
        char temp[256] ;
        sprintf(temp, ">> File closed: %s.", fileName);
        display(logFile, verbose, 1, temp, 1);
        fclose(file);
        return 0 ;
}


/**********************************************************************/
/*  writeParameters(): f(x) that writes params to logfile and screen  */
/**********************************************************************/
int writeParameters()
{
    short channel;
    fprintf(logFile,"            EMCP.EXE  Compiled August 22,2001  \n");
    fprintf(logFile," ** Parameters as specified in card file **\n");
    fprintf(logFile,"Length of each trial             : %d\n",
        parameters.trialLength);
    fprintf(logFile,"Number of trials                 : %d\n",
        parameters.numTrials);
    fprintf(logFile,"\t\t(0=get from read, -1=get from .EEG file)\n"); /* BG */
    fprintf(logFile,"Number of ID words               : %d\n",
        parameters.numIDs);
    fprintf(logFile,"Number of channels               : %d\n",
        parameters.totalChannels);
    fprintf(logFile,"Number of EEG channels           : %d\n",
        parameters.numEEGChannels);
    fprintf(logFile,"Mastoid substraction option      : %d\n",
        parameters.mastoidOpt);
    fprintf(logFile,"Digitizing rate (ms)             : %.3f\n",
        parameters.digitizingRate);
    fprintf(logFile,"EOG Sensitivity (A/D per uvolt)  : %.3f\n",
        parameters.EOGSensitivity);
    fprintf(logFile,"Single-trial option              : %d\n",
        parameters.singleTrialOpt);
    fprintf(logFile,"ID vectors in output (0=FULL)    : %d\n",
        parameters.vectorsOpt);
    fprintf(logFile,"A/D bits (USUALLY 12 or 16)      : %d\n",
        parameters.ADBits);
    fprintf(logFile,"Input file format (0=NeuroScan 1=CPL, 2=PC)  : %d\n",
        parameters.inputFormat); /* BG */
    fprintf(logFile,"Input type (1=binary/NS 2=ascii)    : %d\n",
        parameters.inputType);
    fprintf(logFile,"Output file format (0=NeuroScan 1=CPL, 2=PC, 3=binary) : %d\n",
        parameters.outputFormat); /* BG */
    fprintf(logFile,"Output Specification for ASCII (e.g. 7.1f) : %.10s\n",
        parameters.outputSpecification);
    fprintf(logFile,"Parameters file              : %s\n",
        parameters.fileNameOf.parameters);
    fprintf(logFile,"Data file                    : %s\n",
        parameters.fileNameOf.data);
    fprintf(logFile,"Channels not corrected:\n\t");
    for(channel = 1; channel <= NumUncorrected; channel++){
         fprintf(logFile,"%s ",uncor_chans[channel]);
    }
    fprintf(logFile,"\n");

    if (verbose)
    {
        printf("\n\n**** EMCP Started ****\n\n PARAMETERS ENTERED\n");
        printf("Length of each trial             : %d\n",
        parameters.trialLength);
        printf("Number of ID words               : %d\n",
            parameters.numIDs);
        printf("Number of trials                 : %d\n",
            parameters.numTrials);
        printf("\t\t(0=get from read, -1=get from .EEG file)\n"); /* BG */
        printf("Number of channels               : %d\n",
            parameters.totalChannels);
        printf("Number of EEG channels           : %d\n",
            parameters.numEEGChannels);
        printf("Mastoid substraction option      : %d\n",
            parameters.mastoidOpt);
        printf("Digitizing rate (ms)             : %.3f\n",
            parameters.digitizingRate);
        printf("EOG Sensitivity (A/D per uvolt)  : %.3f\n",
            parameters.EOGSensitivity);
        printf("Single-trial option              : %d\n",
            parameters.singleTrialOpt);
        printf("ID vectors in output (0=FULL)    : %d\n",
            parameters.vectorsOpt);
        printf("A/D bits (USUALLY 12)            : %d\n",
            parameters.ADBits);
        printf("Input file format (0=NeuroScan 1=CPL, 2=PC)  : %d\n", /* BG */
            parameters.inputFormat);
        printf("Input type (1=binary/NS 2=ascii)    : %d\n",
            parameters.inputType);
        printf("Output file format (0=NeuroScan 1=CPL, 2=PC, 3=binary) : %d\n",
            parameters.outputFormat);
        printf("Output Specification for ASCII (e.g. 7.1f) : %.10s\n",
            parameters.outputSpecification);
        printf("Parameters file          : %s\n",
            parameters.fileNameOf.parameters);
        printf("Data file            : %s\n",
            parameters.fileNameOf.data);
    printf("Channels not corrected:\n\t");
    for(channel = 1; channel <= NumUncorrected; channel++){
         printf("%s ",uncor_chans[channel]);
    }
    printf("\n");
    }

    switch (parameters.singleTrialOpt)
    {
        case -1:
            fprintf(logFile,"Averaging only -- No eye movement "
                "correction\n\n");
            if (verbose) printf("Averaging only -- No eye movement "
                "correction\n\n");
            break;
        case 0:
            fprintf(logFile,"Classified single trials written\n\n");
            if (verbose) printf("Classified single trials written\n\n");
            break;
        case 1:
            fprintf(logFile,"No single trials written\n\n");
            if (verbose) printf("No single trials written\n\n");
            break;
        case 2:
            fprintf(logFile,"All single trials written.\n\n");
            if (verbose) printf("All single trials written.\n\n");
            break;
    }
        return 0 ;
}



/**********************************************************************/
/*  readTrial() :function that reads data from data file by one trial */
/**********************************************************************/
/* if return 0 then good trial */
/* if return 1 then bad trial */
int readTrial(int numTrials,int countOnly,
              double criteria)
{
    int     j, k;                           /* counters */
    int     accept=0;                       /* status of trial */
    short   kbyte;                          /* byte for binary read */
    int     ibyte, jbyte;                   /* bytes for binary read */
    float   buffer;                         /* temp for count=1 mode and fscanf */
    short   data;                       /* data for input (BG) */

      if (parameters.inputFormat == 0){  /* NeuroScan file --BG */
      /* read sweep header */
      fread (sweephead[numTrials], sizeof(SWEEP_HEAD), 1, dataFile);
      /* copy relevant parameters to id vector for EOG */
      for(k=1; k<= erp.pnts; k++){
         for(j=1; j<= erp.nchannels; j++){
           fread(&data,2,1,dataFile);
           /* add some ids to be compatible with eegtoasc.c */
           if(k == 1){
                rawIDs[numTrials][1][j] = (float) numTrials;
                rawIDs[numTrials][2][j] = (float) sweephead[numTrials]->ttype;
                rawIDs[numTrials][3][j] = (float) j;
           }
/*
 *  Now reads in data on both good and bad trials.
 *       Note that input code for the other formats do not fill
 *       the rawData array once the trial is found to be rejectable.
 *       A modification of this code is necessary, however, to ensure
 *       that bad trials are retained and included in the output.  See
 *       EMCP.DOC for the rationale for this.
 */
            rawData[numTrials][k][j] = data;
            if(!countOnly){
                 if (  (accept=checkData(numTrials,k,j,criteria)) !=0 ){
                      countOnly=COUNT_ONLY;
                 }
            }
      }
      }
    }
    if (parameters.inputFormat == 1)
    /* CPL input or ASCIIinput file */
    {
        if(parameters.inputType == 1)
        /* Binary byte swapped data? */
        {
          for (j=1; j<=parameters.totalChannels; j++)
          {
            for (k=1; k<=parameters.numIDs; k++)
            {
                /* ibyte = fgetc(dataFile);
                if (ibyte == EOF) return 5;
                jbyte = fgetc(dataFile);
                if (jbyte == EOF) return 5;
                kbyte=(jbyte<<8)|ibyte;
				if (!countOnly) rawIDs[numTrials][k][j] = kbyte;*/
				if (!countOnly) fread(&rawIDs[numTrials][k][j],sizeof(float),1,dataFile);
					
            }/* end k */
            for (k=1; k<=parameters.trialLength; k++)
            {
                /* ibyte = fgetc(dataFile);
                if (ibyte == EOF) return 5;
                jbyte = fgetc(dataFile);
                if (jbyte == EOF) return 5;
                kbyte=(jbyte<<8)|ibyte;
                if (!countOnly)
                {
                    rawData[numTrials][k][j] = kbyte;
                    if (  (accept=checkData(numTrials,k,j,criteria)) !=0 )
                        countOnly=COUNT_ONLY;
                } */
			    if (!countOnly)
                {
                    fread(&rawData[numTrials][k][j],sizeof(float),1,dataFile);
					if (  (accept=checkData(numTrials,k,j,criteria)) !=0 )
                        countOnly=COUNT_ONLY;
                }
            } /* end k */
          } /* end j */
       } /* end if (parameters.inputType) */
       else
       {  /* if ascii data */
          for (j=1; j<=parameters.totalChannels; j++)
          {
            for (k=1; k<=parameters.numIDs; k++)
            {
                if (!countOnly)
                {
                    if(fscanf(dataFile,"%f ",&rawIDs[numTrials][k][j])==EOF) return 5;
                }
                else
                {
                    if(fscanf(dataFile,"%f ",&buffer)==EOF) return 5;
                }
      } /* end j */
          for (k=1; k<=parameters.trialLength; k++)
          {
            if (!countOnly)
            {
                if(fscanf(dataFile,"%f",&rawData[numTrials][k][j])==EOF) return 5;
            }
           else
            {
                if(fscanf(dataFile,"%f",&buffer)==EOF) return 5;
            }
            if (!countOnly)
            {
                if (  (accept=checkData(numTrials,k,j,criteria))!=0)
                    countOnly=COUNT_ONLY;
            } /* end if (!countOnly) */
      }
          } /* end k */
       } /* end else (parameters.inputType) */
    } /* end if (parameters.inputFormat) */
    else if (parameters.inputFormat == 2)
    {
       if (parameters.inputType == 1)
       /* if binary (byte-swapped)  */
       {
          for (k=1; k<=parameters.numIDs; k++)
          {
            ibyte = fgetc(dataFile);
            if (ibyte == EOF) return 5;
            jbyte = fgetc(dataFile);
            if (jbyte == EOF) return 5;
            kbyte=(jbyte<<8)|ibyte;
            if (!countOnly)
            {
                for (j=1;j<=parameters.totalChannels;j++)
                    rawIDs[numTrials][k][j]=kbyte;
            }
          } /* end k */

         for (k=1; k<=parameters.trialLength; k++)
         {
            for (j=1; j<=parameters.totalChannels; j++)
            {
                ibyte = fgetc(dataFile);
                if (ibyte == EOF) return 5;
                jbyte = fgetc(dataFile);
                if (jbyte == EOF) return 5;
                kbyte=(jbyte<<8)|ibyte;
                if (!countOnly)
                {
                    rawData[numTrials][k][j] = kbyte;
                    /* read in data */
                    if (  (accept=checkData(numTrials,k,j,criteria))   !=0)
                    /* put checkData into trial */
                       countOnly=COUNT_ONLY;
                        /* if trial not okay then reject trial */
                } /* end (!countOnly) and only scan data */
                  /* (no need to store bad trials) */
            } /* end j */
        } /* end k */
     } /* end if (parameters.inputType) */
     else   /* if ascii */
     {
        for (j=1,k=1; k<=parameters.numIDs; k++) /* Added j=1 !!! BF 1/31/94 */
        {
            if (!countOnly)
            {
                if(fscanf(dataFile,"%lf",&rawIDs[numTrials][k][j])==EOF) return 5;
            }
            else
            {
                if(fscanf(dataFile,"%lf",&buffer)==EOF) return 5;
            }
        } /* end k */
        for (j=2; j<=parameters.totalChannels; j++)
            /* copies over so each channel has id numbers */
            for (k=1; k<=parameters.numIDs; k++)
                 rawIDs[numTrials][k][j] = rawIDs[numTrials][k][veogchannel];
        for (k=1; k<=parameters.trialLength; k++)
        {
            for (j=1; j<=parameters.totalChannels; j++)
            {
                if (!countOnly)
                {
                    if(fscanf(dataFile,"%lf",&rawData[numTrials][k][j])==EOF) return 5;
                }
                else
                {
                    if(fscanf(dataFile,"%lf",&buffer)==EOF) return 5;
                }
                if (!countOnly)
                {
          accept=checkData(numTrials,k,j,criteria);
          if (accept !=0)
            {/* put checkData into trial */
                        countOnly=COUNT_ONLY;
                     /* end if (!countOnly) */
              }
        }
            }/* end for j= */
        } /* end for k= */
     }/* end else (parameters.inputType) */
    }/* end if (parameters.inputFormat) */
  numVEOGoffScale=0;
  return accept;
}


/**********************************************************************/
/*  checkData()  : checks to see if incoming data in channels is okay */
/**********************************************************************/
int checkData(int curTrial, int point, int channel, double criteria)
{
    /*    return 0 means data point okay                          *
     *    return 1 means EEG data point out-of-range              *
     *    return 2 means ten consecutive equal EEG data points    *
     *    return 3 means 10 VEOG points out-of-range              *
     *    return 4 means VEOG points unrecoverable                */

    int         i=9;                        /* counters */
    if (0 == criteria)
    {
        return 0;                       /* if told not to reject trials */
                                        /* then exit nicely */
    }
    else
    {
        if (veogchannel == channel)
        /* if VEOG channel */
        {
            if ((point<=2)||(point>=(parameters.trialLength-1)))
            /* if first two or last */
            {
                if (fabs(rawData[curTrial][point][veogchannel])
                    >=criteria){
                /* two points in VEOG >=criteria then exit */
                   fprintf(logFile," Trial %d rejected status 4:  point %d channel %d, value=%.1f\n",curTrial,point,channel,rawData[curTrial][point][channel]);
                        return 4;
              }
                /* VEOG unrecoverable */
                if (numVEOGoffScale>0)
                {
                    return recoverVEOG(numVEOGoffScale,
                                       firstVEOGoffScale,curTrial,criteria);
                    /* if at 2 points then time to correct   */
                    /* if there are off-scale points */
                } /* this was forgotten in first version */
                return 0;
                /* then point is okay */
            }
            else /*to{if((point<=2)||(point>=(parameters.trialLength-1)))} */
            {
            /*********************************************************/
            /*  NOTE:  This section attempts to recover VEOG points  */
            /*         if a series of continuous equal points        */
            /*         exists that is > 1 but < 10 points long.      */
            /*********************************************************/
                if ((fabs(rawData[curTrial][point][veogchannel])
                    >= criteria) && (numVEOGoffScale<10))
                    /* if VEOG points>=criteria save them */
                    {
                        if (++numVEOGoffScale==1)
                            firstVEOGoffScale=point;
                            /* if first point off scale then mark  */
                            /* it for reference */
                        return 0;
                        /* continue reading points */
                    }
                    else if (numVEOGoffScale==10)
                    /* stop if > 10 VEOG points off scale */
                    {
                   fprintf(logFile," Trial %d rejected status 3:  point %d channel %d, value=%.1f\n",curTrial,point,channel,rawData[curTrial][point][channel]);
                        return 3;
                    }
                    else if ((fabs(rawData[curTrial][point][veogchannel])
                             <criteria)&&(numVEOGoffScale>0))
                             /* if VEOG points>=criteria && if > 0 points */
                             /* off scale try to  */
                    {        /* recover them */
                        return recoverVEOG(numVEOGoffScale,
                               firstVEOGoffScale,curTrial,criteria);
                        /* return whether recovery successful */
                    }
            } /* end if {if ((point<=2)||(point>=(parameters.trialLength-1)))} */
        }
        /*      only check channels that need to be corrected -- BG */
        else if (veogchannel != channel && corflag[channel])
        /* else to {if (veogchannel == channel)} */
        {
            if (fabs(rawData[curTrial][point][channel])>=criteria)
          {
                   fprintf(logFile," Trial %d rejected status 1:  point %d channel %d, value=%.1f\n",curTrial,point,channel,rawData[curTrial][point][channel]);
        return 1;
          }
                /* if data point out-of-range && is not in VEOG */
            if (point>9 && channel<=parameters.eegChannels)
            /* if read in 10 points and EEG data channel */
            {
          if (heogchannel!=channel)
          /* can't be VEOG and don't want HEOG because they are frequently */
          /* flat when there is not eye movement */
          {
                  while (rawData[curTrial][point-i][channel]==
            rawData[curTrial][point][channel])
                  /* check backwards for 10 consecutive equal data points */
                  {
                    if (--i==0) break;
                    /* if i==0 stop checking */
                  }
              if (i==0) {
                   fprintf(logFile," Trial %d rejected status 2:  point %d channel %d, value=%.1f\n",curTrial,point-9,channel,rawData[curTrial][point-9][channel]);
                   return 2;
              }
        }
                /* if counter reaches 0 then must be 9 equal pts -- return 2 */
            }
        } /* end {if (veogchannel == channel)} */
    } /* end {if (0 == criteria)} */
    return 0;
    /* rawData[curTrial][point][channel] is okay -- return 0 */
}

/**********************************************************************/
/*  recoverVEOG()  : attempts to recover out-of-scale VEOG points     */
/**********************************************************************/
int recoverVEOG(int number,int start, int curTrial, double criteria)
{
    int     point,              /* counter */
            end,                /* last point */
            status;             /* used to assess results of cov f(x) */
    double  scalingFactor,      /* scaling factor based on length  */
                                /* of out-of-scale epoch */
            deltaUp,                    /* rate of change before epoch */
            deltaDown,                  /* rate of change after epoch */
            incrementUp,                /* increment up */
            incrementDown,              /* increment down */
            constantUp,         /* * constant based on dist from start */
            constantDown,       /* * constant based on dist from end */
            rSq,                /* squared correlation value */
            slope;              /* slope value based on  */
                                /* covariance/variance of VEOG to Fz */
    double  *changeUp,          /* storage for est. up component */
                                /* of new points */
            *changeDown;        /* storage for est. down component */
                                /* of new points */
    char    temp[255];          /* buffer for output string */

    end=number+start;
    changeUp=doublesVector(start,end);
    changeDown=doublesVector(start,end);
    scalingFactor=sqrt((number+1)/2);
        /* determine scaling factor */
    deltaUp=rawData[curTrial][start-1][veogchannel]-
            rawData[curTrial][end-2][veogchannel];
    /* difference between preceding 2 points */
    deltaDown=rawData[curTrial][end+1][veogchannel]-
              rawData[curTrial][end+2][veogchannel];
    /* difference between following 2 points */

    for(point=start;point<=end;point++)
    {
        constantUp=1+sin((double)(point+1-start)*PI/number);
        incrementUp=deltaUp*constantUp*scalingFactor;
        changeUp[point]=rawData[curTrial][start-1][veogchannel]+
                        incrementUp;

        constantDown=1+sin((double)(end+1-point)*PI/number);
        incrementDown=deltaDown*constantDown*scalingFactor;
        changeDown[point]=rawData[curTrial][end+1][veogchannel]+
                          incrementDown;

        if ((rawData[curTrial][point][veogchannel] =
            (changeUp[point]+changeDown[point])/2) < criteria)
            /* take average for estimatedVEOG and substitute in */
            /* to VEOG channel */
        {
            free_doublesVector(changeUp,start,end);
            /* free memory */
            free_doublesVector(changeDown,start,end);
            /* free memory */
           fprintf(logFile," Trial %d rejected status 4:  point %d channel %d, value=%.1f\n",curTrial,point,veogchannel,rawData[curTrial][point][veogchannel]);
            return 4;
            /* return rejection */
        }
    } /* end {for(point=start;point<=end;point++)} */
    status = covariance(curTrial,veogchannel,fzchannel,
                        start,end,&rSq,&slope);
    /* get rSq and slope based on VEOG and Fz correlations */
    if (1==status){
         fprintf(logFile," Trial %d rejected status 4:  point %d channel %d, value=%.1f\n",curTrial,point,veogchannel,rawData[curTrial][point][veogchannel]);
         return 4;
    }
    /* if xVariance*yVariance<0 unrecoverable */
    slope=slope/parameters.EOGSensitivity;
    /* convert slope */
    if ((rSq<.81)||(fabs(slope)>.40)||(fabs(slope)<.10)){
         fprintf(logFile," Trial %d rejected status 4:  point %d channel %d, value=%.1f\n",curTrial,point,veogchannel,rawData[curTrial][point][veogchannel]);
         return 4;
    }
    /* recovered successfully? */
    sprintf(temp,"Recovered VEOG-- trial %d, point %d to %d.",
                  curTrial,start,end);
    display(logFile,verbose,1,temp,1);
    sprintf(temp,"R-square= %6.4f, slope= %6.4f",
            (float)rSq,(float)slope);
    display(logFile,verbose,0,temp,1);
    for(point=start;point<=end;point++)
    /* output info to log */
    {
        fprintf(logFile," %7.1f\n",rawData[curTrial][point][veogchannel]);
        if (verbose) printf(" %7.1f\n",
                            rawData[curTrial][point][veogchannel]);
    }
    free_doublesVector(changeUp,start,end);   /* free memory */
    free_doublesVector(changeDown,start,end); /*  free memory */
    return 0;                           /* return that it worked */
}

/*********************************************************************/
/*  covariance()  : computers covariance between two channels        */
/*********************************************************************/
int covariance(int curTrial, int x, int y, int start, int end,
               double *rSq, double *slope)
{
    int     point,          /* counter */
            numPoints,          /* total number of points */
            status=0;       /* status */

    double  sumX=0,         /* sum of x */
            sumY=0,         /* sum of y */
            sumXX=0,        /* sum of x*x */
            sumYY=0,        /* sum of y*y */
            sumXY=0,        /* sum of x*y */
            xMean,          /* calculated later */
            yMean,          /* calculated later */
            xVariance,      /* calculated later */
            yVariance,      /* calculated later */
            xyCovariance;   /* calculated later */

    for (point=start;point<=end;point++)
    /* sum points up */
    {
        sumX+=rawData[curTrial][point][x];
        sumY+=rawData[curTrial][point][y];
        sumXX+=rawData[curTrial][point][x]*rawData[curTrial][point][x];
        sumYY+=rawData[curTrial][point][y]*rawData[curTrial][point][y];
        sumXY+=rawData[curTrial][point][x]*rawData[curTrial][point][y];
    }

    numPoints=start-end+1;          /* number of points for average */
    xMean=sumX/numPoints;           /* calculate x average */
    yMean=sumY/numPoints;           /* calculate y average */

    xVariance=(sumXX/numPoints)-(xMean*xMean);/* calculate xVariance */
    yVariance=(sumYY/numPoints)-(yMean*yMean);/* calculate yVariance */
    xyCovariance=(sumXY/numPoints)-(xMean*yMean);/* calc xyCovariance */

    if ((xVariance*yVariance)<=0) status=1;
    /* conciliation to previous version */
    *rSq=(xyCovariance*xyCovariance)/(xVariance*yVariance);
    /* calculate r squared */
    *slope=xyCovariance/xVariance;
    /* calculate slope */

    return status;
}

void outputNeuroScan()
{
    FILE    *sngTrFile;                   /* corrected averages file */

    int     point,                      /* counter */
            channel,
            trial ;

    short   data;

    char    temp[255],                  /* temp string buffer */
            spec[255];                  /* temp output format */

    strcpy(spec,parameters.outputSpecification);

    /* set pointer to start of string */

    sngTrFile=openFile(parameters.fileNameOf.correctedSingleTrials, "wb");
    sprintf(temp,">> Opened corrected single trial file: %s",parameters.fileNameOf.correctedSingleTrials);

    display(logFile,verbose,1,temp,1);
    /* output status */


        /*  BG modification new 08/22/2001
         *      Make Neuroscan 4.1.x recognize this as an old 3.0 format file
         */
    erp.minor_rev=11;

    /* write header */
    fwrite(&erp, sizeof(SETUP), 1, sngTrFile);
    for (channel=1; channel<= erp.nchannels; channel++)
    {
                fwrite(chanloc[channel], sizeof(ELECTLOC), 1, sngTrFile);
           }

    /*
        integer overflows can happen after correction if the digitizer was
        close to saturated before correction and then correction pushed the
        data over the top.  here we scan data for output overflow:
        if overflow detected, try subtracting a baseline consisting of the
        average activity during the entire epoch.  if there is still an
        overflow, set the accept byte to 0 and set all the data to 0
        */

    for (trial=1; trial<=parameters.numTrials; trial++){
         if(checkoverflow(trial)){
              fprintf(logFile," \t Overflow at trial %d",trial);
              computeTrialBaseline(REMOVE, trial);
              if(checkoverflow(trial)){
                   fprintf(logFile,"...Recovery impossible \n");
                   sweephead[trial]->accept = 0;
                   for(channel=1; channel <= erp.nchannels; channel++){
                        for(point=1; point<=erp.pnts; point++){
                             rawData[trial][point][channel] = 0.0;
                        }
                   }
              }
              else fprintf(logFile,"...Recovery successful\n");
         }
    }

    data=0;
    for (trial=1; trial<=parameters.numTrials; trial++)
    {
    /* write each trial - rejected trials are written but status is included */
            fwrite(sweephead[trial], sizeof(SWEEP_HEAD), 1, sngTrFile);
            for(point=1; point<= erp.pnts; point++)
            {
                 for(channel=1; channel<= erp.nchannels; channel++)
                 {
                      data= (short) rawData[trial][point][channel];
                      fwrite(&data,2,1,sngTrFile);
/* special purpose for test
                     fwrite(&rawData[trial][point][channel],sizeof(float),1,sngTrFile);
 */

                 }
            }
    }
    closeFile(sngTrFile,parameters.fileNameOf.correctedSingleTrials);
    /* close the file when done */
    if (verbose) printf(">> Single trials output in NeuroScan format\n");
}

int checkoverflow(int trial){

    int     point,                      /* counter */
            channel;

              for(channel=1; channel<= erp.nchannels; channel++){
                   for (point=1; point<=erp.pnts; point++){
                if( rawData[trial][point][channel] > (float) SHRT_MAX ||
                            rawData[trial][point][channel] < (float) SHRT_MIN){
                             fprintf(logFile," data overflow at tr%d ch%d pt%d raw: %f\n", trial, channel, point,rawData[trial][point][channel]);
                                  return 1;
                        }
                   }
              }
    return 0;

}

void outputYoyo()
{
    FILE    *sngTrFile;                   /* corrected averages file */

    int     point,                      /* counter */
            channel,
            trial,
            id;

    char    temp[255],                  /* temp string buffer */
            spec[255];                  /* temp output format */

    float   *temp_ids,                  /* temp buffer for id array */
            *temp_data;                 /* temp buffer for data array */

    strcpy(spec,parameters.outputSpecification);
    /* set pointer to start of string */

    sngTrFile=openFile(parameters.fileNameOf.correctedSingleTrials, "wb");
    sprintf(temp,">> Opened corrected single trial file: %s",parameters.fileNameOf.correctedSingleTrials);
    display(logFile,verbose,1,temp,1);
    /* output status */

    temp_ids = malloc(sizeof(float) * parameters.numIDs);
    temp_data = malloc(sizeof(float) * parameters.trialLength);

    for (trial=1; trial<=parameters.numTrials;trial++)
        if (trialInfo[trial].status==0)
        {
           for (channel=1; channel<=parameters.totalChannels; channel++)
           /* For each channel */
           {
               for (id=0; id<parameters.numIDs; id++)
                   temp_ids[id] = rawIDs[trial][id+1][channel];
               fwrite(temp_ids, sizeof(float), parameters.numIDs, sngTrFile);
               for (point=0; point<parameters.trialLength; point++)
                   temp_data[point] = rawData[trial][point+1][channel];
               fwrite(temp_data, sizeof(float), parameters.trialLength, sngTrFile);
           }
        }

    closeFile(sngTrFile,parameters.fileNameOf.correctedSingleTrials);
    /* close the file when done */
    if (verbose) printf(">> Single trials output in binary CPL format\n");
}


/************************************************************************/
/*  outputCorrectedSingleTrials()  : outputs the corrected averages     */
/************************************************************************/
void outputCorrectedSingleTrials()
{
    FILE    *sngTrFile;                   /* corrected averages file */

    int     point,                      /* counter */
            channel,
            trial,
            id;

    char    temp[255],                  /* temp string buffer */
            spec[255];                  /* temp output format */

/*
 * NeuroScan output:
 */

    if (parameters.outputFormat==0)
    {
         outputNeuroScan() ;
         return;
    }
/*
 * Interject Kevin's binary code here, and beat it when
 * we are done...
 */

    else if (parameters.outputFormat==3)
    {
        outputYoyo() ;
        return ;
    }

    strcpy(spec,parameters.outputSpecification);
    /* set pointer to start of string */

    sngTrFile=openFile(parameters.fileNameOf.correctedSingleTrials, "w");
    sprintf(temp,">> Opened corrected single trial file: %s",parameters.fileNameOf.correctedSingleTrials);
    display(logFile,verbose,1,temp,1);
    /* output status */

    for (trial=1; trial<=parameters.numTrials;trial++)
    {
        /* For all these bins */
        if ((parameters.outputFormat == 1) && (trialInfo[trial].status==0))
    {
            for (channel=1; channel<=parameters.totalChannels; channel++)
            /* For each channel */
            {
                for (id=1; id<=parameters.numIDs; id++)
                {
                    if ((((id-1) % 10) == 0) &&  (id!=1)) fprintf(sngTrFile,"\n");
                    fprintf(sngTrFile,spec,rawIDs[trial][id][channel]);
                }
                for (point=(parameters.numIDs);point<((parameters.trialLength)+(parameters.numIDs));point++)
                {
                    if (((point % 10) == 0) &&  (point!=0)) fprintf(sngTrFile,"\n");
                    fprintf(sngTrFile,spec,rawData[trial][point-parameters.numIDs+1][channel]);
               }
                fprintf(sngTrFile,"\n");
           }
       }
        else if ((parameters.outputFormat==2) && (trialInfo[trial].status==0))
        {
            for (id=1;id<=parameters.numIDs;id++)
            {
                if ((((id-1)%10)==0)&&(id!=1)) fprintf(sngTrFile,"\n");
                fprintf(sngTrFile,spec,rawIDs[trial][id][veogchannel]);
            }
            fprintf(sngTrFile,"\n");
            for (point=1;point<=parameters.trialLength;point++)
            {
                for (channel=1; channel<=parameters.totalChannels;channel++)
                    fprintf(sngTrFile,spec,rawData[trial][point][channel]);
        fprintf(sngTrFile," -- %4d%4d%4d",trial-1,point-1,markBlink[trial][point]);
                fprintf(sngTrFile,"\n");
            } /* end point */
        } /* end else if */
        if(verbose)printf(">> Output single trial: %d\n",trial);
    } /* end trial */
    closeFile(sngTrFile,parameters.fileNameOf.correctedSingleTrials);
    /* close the file when done */
}


/************************************************************************/
/*  outputCorrectedAvgs()  : outputs the corrected averages             */
/************************************************************************/
void outputCorrectedAvgs()
{
    FILE    *avgFile;                   /* corrected averages file */

    int     point,                      /* counter */
            channel,
            bin,
            id;

    char    temp[255],                  /* temp string buffer */
            spec[255];                  /* temp output format */

    strcpy(spec,parameters.outputSpecification);
    /* set pointer to start of string */

    avgFile=openFile(parameters.fileNameOf.correctedAvgs, "w");
    sprintf(temp,">> Opened corrected averages file: %s",parameters.fileNameOf.correctedAvgs);
    display(logFile,verbose,1,temp,1);
    /* output status */

    for (bin=1; bin<=parameters.numStorageBins;bin++)
    /* For all these bins */
    if (parameters.outputFormat == 1 || parameters.outputFormat ==3) {
        for (channel=1; channel<=parameters.totalChannels; channel++)
        {
        /* For each channel */
            fprintf(avgFile,spec,(float)bin);
            fprintf(avgFile,spec,(float)channel);
            fprintf(avgFile,spec,(float)trialsInBin[bin]);  /* number of trials in bin */

        if (0==parameters.vectorsOpt)
            for (id=3; id<((parameters.numIDs)+3); id++)
            {
                if (((id % 10) == 0) &&  (id!=0))
                    fprintf(avgFile,"\n");
                fprintf(avgFile,spec,meanIDs[bin][id-3+1]);
            }
            for (point=(parameters.numIDs)+3;point<((parameters.trialLength)+(parameters.numIDs)+3);point++)
            {
                if (((point % 10) == 0) &&  (point!=0))
                    fprintf(avgFile,"\n");
                fprintf(avgFile,spec,rawAverage[point-(parameters.numIDs+3)+1][channel][bin]);
            }
        fprintf(avgFile,"\n");
        }
    }
    /* else if (parameters.outputFormat==2) //3 is binary */
    else if (parameters.outputFormat<=2)
    {
       /* number of trials in bin */
       /* output trials in bin */
       for (id=2;id<parameters.numIDs+2;id++)
        {
            if (((id%10)==0)&&(id!=0)) fprintf(avgFile,"\n");
            fprintf(avgFile,spec,meanIDs[bin][id-2+1]);
        }
        fprintf(avgFile,"\n");
        for (point=1;point<=parameters.trialLength;point++)
        {
            for (channel=1; channel<=parameters.totalChannels;channel++)
                fprintf(avgFile,spec,rawAverage[point][channel][bin]);
            fprintf(avgFile,"\n");
        } /* end point */
    } /* end else if */
    closeFile(avgFile,parameters.fileNameOf.correctedAvgs);
    /* close the file when done */
}

/************************************************************************/
/*  outputPropogation()  : outputs the progogation factors              */
/************************************************************************/
void outputPropogation()
{
    short channel;

    fprintf(logFile,"\n\n\n>>>>Correction factor for blinks \n");

    /* Write table to correlation file */
    fprintf(logFile,"\n                  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);

         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n>>Standard Dev:  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.0f ",blink.stanDev[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile, "\n>>Beta weights:\n      Vertical_bb    \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",blink.veogCorr[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile, "\n      Horizontal_bb  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",blink.heogCorr[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n>>Propagation factors:\n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);

         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n\n      Vertical_bp    \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",blink.veogFactor[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile, "\n      Horizontal_bp  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",blink.heogFactor[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n\n>>>>Correction factor for saccades \n");

    /* Write table to correlation file */
    fprintf(logFile,"\n                  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);
         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n>>Standard Dev:  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.0f ",saccade.stanDev[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile, "\n>>Beta weights:\n      Vertical_sb    \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",saccade.veogCorr[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile, "\n      Horizontal_sb  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",saccade.heogCorr[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n>>Propagation factors:\n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);

         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n\n      Vertical_sp    \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",saccade.veogFactor[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile, "\n      Horizontal_sp  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile, "%6.2f ",saccade.heogFactor[channel]);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
}

/************************************************************************/
/*  outputBinAvg()  : converts to microv, removes binBaseline, to file  */
/************************************************************************/
void outputBinAvg()
{
    int     point,                              /* counters */
            channel,
            bin,
            id;
    FILE    *avgFile;                           /* uncorrected averages file */
    char    temp[255];                          /* string buffer */

    /*** Prepare for output ***/
    for(point=1;point<=parameters.trialLength;point++)
    {
        for(bin=1;bin<=parameters.numStorageBins;bin++)
        {
            for(channel=1;channel<=parameters.totalChannels;channel++)
            {
                rawAverage[point][channel][bin]+=binBaseline[channel][bin];
                /* take out the baseline for bin */
                if (channel<=parameters.eegChannels) /* Avoid non-EEG BF */
                    if(logflag[channel])rawAverage[point][channel][bin]/=calibration[channel];
                /* convert to microvolts */
            } /* end channel */
        } /* end bin */
    } /* end point */

    /*** Output raw averages file ***/
    avgFile=openFile(parameters.fileNameOf.uncorrectAvgs,"w");
    /* open file for uncorrected averages output */
    sprintf(temp,">> Opened raw average file: %s",parameters.fileNameOf.uncorrectAvgs);
    display(logFile,verbose,1,temp,1);
    /* output status */
    fprintf(logFile," after display \n");

    for(bin=1;bin<=parameters.numStorageBins;bin++)
    {
        if(parameters.outputFormat==1)
        {
            for(channel=1;channel<=parameters.totalChannels;channel++)
            {
                fprintf(avgFile,parameters.outputSpecification,(float)bin);
                fprintf(avgFile,parameters.outputSpecification,(float)channel);
                fprintf(avgFile,parameters.outputSpecification,(float)trialsInBin[bin]);
                if(parameters.vectorsOpt==0)
                {
                    for(id=3;id<parameters.numIDs+3;id++)
                    {
                        if(((id%10)==0)&&(id!=0)) fprintf(avgFile,"\n");
                        fprintf(avgFile,parameters.outputSpecification,meanIDs[bin][id-3+1]);
                    } /* end for id */
                } /* end if parameters vectorsOpt */
                for(point=parameters.numIDs+3;point<parameters.trialLength+parameters.numIDs+3;point++)
                {
                    if(((point%10)==0)&&(point!=0)) fprintf(avgFile,"\n");
                    fprintf(avgFile,parameters.outputSpecification,
                            rawAverage[point-(parameters.numIDs+3)+1][channel][bin]);
                } /* end point */
                fprintf(avgFile,"\n");
            } /* end channel */
        } /* if */
        else if (parameters.outputFormat==2)
        {
            fprintf(avgFile,parameters.outputSpecification,(float)bin);
            fprintf(avgFile,parameters.outputSpecification,(float)trialsInBin[bin]);
            for(id=2;id<parameters.numIDs+2;id++)
            {
                if(((id%10)==0)&&(id!=0)) fprintf(avgFile,"\n");
                fprintf(avgFile,parameters.outputSpecification,meanIDs[bin][id-2+1]);
            }
            fprintf(avgFile,"\n");
            for(point=1;point<=parameters.trialLength;point++)
            {
                for(channel=1;channel<=parameters.totalChannels;channel++)
                {
                    fprintf(avgFile,parameters.outputSpecification,
                            rawAverage[point][channel][bin]);
                } /* end channel */
                fprintf(avgFile,"\n");
            } /* end point */
        } /* end else if */
    } /*end bin */

    /*** Readjust now that files is outputted ***/
    for(point=1;point<=parameters.trialLength;point++)
    {
        for(bin=1;bin<=parameters.numStorageBins;bin++)
        {
            for(channel=1;channel<=parameters.totalChannels;channel++)
            {
                rawAverage[point][channel][bin]*=calibration[channel];
                /* convert back to AD values */
                rawAverage[point][channel][bin]-=binBaseline[channel][bin];
                /* put back the baseline for bin */
            } /* end channel */
        } /* end bin */
    } /* end point */

    closeFile(avgFile,parameters.fileNameOf.uncorrectAvgs);

}

/************************************************************************/
/*  outputProportions()  :  output info on % blinks % saccades in data  */
/*                                                                      */
/*  Dependent on:                                                       */
/*     totalPoints, .ptsInBase                                          */
/************************************************************************/
void outputProportions(double totalPoints)
{
    double  blinkRatio=0.0,                 /* % blink data points */
            saccadeRatio=0.0;               /* % saccade data points */

    if (totalPoints)
    {
        blinkRatio=blink.ptsInBase/totalPoints;
        /* # blink data points over total points */
        saccadeRatio=saccade.ptsInBase/totalPoints;
        /* # saccade data points over total points */
    }
    /* write proportions to correlation file */
    fprintf(logFile,"\n    Sample size for regression computation: \n");
    fprintf(logFile,"\nREGRESSION     # OF POINTS  PROPORTION\n");
    fprintf(logFile,"\nSACCADES       %10.0f  %10.5f", saccade.ptsInBase, saccadeRatio);
    fprintf(logFile,"\nBLINKS         %10.0f  %10.5f", blink.ptsInBase, blinkRatio);
    if (verbose)
    {
        printf("\n>>    Sample size for regression computation: \n");
        printf("\n>> REGRESSION     # OF POINTS  PROPORTION\n");
        printf("\n>> SACCADES       %10.0f  %10.5f", saccade.ptsInBase, saccadeRatio);
        printf("\n>> BLINKS         %10.0f  %10.5f", blink.ptsInBase, blinkRatio);
    }
}

/************************************************************************/
/*  outputBins()  : output status                                       */
/************************************************************************/
void outputBins(int trial)
{
    int bin;                    /* counter */

    /* prints out some standard info that looks likes this:

    + 1 #/bin 0 0 0 0 0 0 0 0 0 ... num of bins

    */
    if (verbose)
    /* if we are display to screen then do it */
    {
        printf("+ trl# %4d  #/bin:",trial);
        for(bin=1;bin<=parameters.numStorageBins;bin++)
            printf("%3d ",trialsInBin[bin]);
        printf("\n");
    }
}

/************************************************************************/
/*  outputVariance()  : writes out variance-covariance tables           */
/************************************************************************/
void outputVarianceTables()
{
    double  xmax,                           /* temp variable for scale factor */
            scal;                           /* scale factor */

    int     channel;                        /* counter */

    /***  Total variance ***/
    fprintf(logFile, "\n\n>>Total variance-covariance table ");

    xmax = 0.0;                 /* determine scaling factor */
    for (channel=1; channel<=parameters.eegChannels; channel++) {
    if (blink.raw.variance[channel] > xmax && logflag[channel])
        xmax = blink.raw.variance[channel];
    if (blink.raw.veogCovar[channel] > xmax && logflag[channel])
        xmax = blink.raw.veogCovar[channel];
    if (blink.raw.heogCovar[channel] > xmax && logflag[channel])
        xmax = blink.raw.heogCovar[channel];
    if (saccade.raw.variance[channel] >xmax && logflag[channel])
        xmax = saccade.raw.variance[channel];
    if (saccade.raw.veogCovar[channel] >xmax && logflag[channel])
        xmax = saccade.raw.veogCovar[channel];
    if (saccade.raw.heogCovar[channel] >xmax && logflag[channel])
        xmax = saccade.raw.heogCovar[channel];
    }

    scal = 1.0;

    if (xmax >= 1000000.0)
    scal = 10000.0;
    else if (xmax >= 100000.0)
    scal = 1000.0;
    else if (xmax >= 10000.0)
    scal = 100.0;
    else if (xmax >= 1000.0)
    scal = 10.0;

    fprintf(logFile,"\n>>Scaling factor = %6.0f\n",scal);

    /* blinks */
    fprintf(logFile,"\n Blinks\n                 \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write channel ind */

    }

    fprintf(logFile,"\n Variance        \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write variance for blinks */
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.raw.variance[channel]/scal);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n covar chn-Veog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write covariance for blinks */
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.raw.veogCovar[channel]/scal);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n covar chn-Heog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.raw.heogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    /* Saccades */
    fprintf(logFile,"\n\n Saccades\n                 \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write channel index */
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);
         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n Variance        \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write variance for saccades */
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.raw.variance[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n covar chn-Veog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write covariance for saccades */
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.raw.veogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n covar chn-Heog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.raw.heogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    /*****************************/
    /*  Adjustments to variance  */
    fprintf(logFile, "\n\n\n>>Adjustments to the variance-covariance table due to the variance subtraction\n");

    xmax = 0.0;                 /* determine scaling factor */
    for (channel=1; channel<=parameters.eegChannels; channel++) {
        if(logflag[channel]){
    if (blink.adjust.variance[channel] > xmax)
        xmax = blink.adjust.variance[channel];
    if (blink.adjust.veogCovar[channel] > xmax)
        xmax = blink.adjust.veogCovar[channel];
    if (blink.adjust.heogCovar[channel] > xmax)
        xmax = blink.adjust.heogCovar[channel];
    if (saccade.adjust.variance[channel] > xmax)
        xmax = saccade.adjust.variance[channel];
    if (saccade.adjust.veogCovar[channel] > xmax)
        xmax = saccade.adjust.veogCovar[channel];
    if (saccade.adjust.heogCovar[channel] > xmax)
        xmax = saccade.adjust.heogCovar[channel];
        }
    }

    scal = 1.0;

    if (xmax >= 1000000.0)
    scal = 10000.0;
    else if (xmax >= 100000.0)
    scal = 1000.0;
    else if (xmax >= 10000.0)
    scal = 100.0;
    else if (xmax >= 1000.0)
    scal = 10.0;

    fprintf(logFile,"\n Scaling factor = %6.0f\n",scal);

    /* blinks */
    fprintf(logFile,"\n Blinks\n                 \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write channel index */
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);
         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n Variance        \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write variance for blinks */
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.adjust.variance[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n covar chn-Veog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write covariance for blinks */
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.adjust.veogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n covar chn-Heog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.adjust.heogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    /* Saccades */
    fprintf(logFile,"\n\n Saccades\n                 \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write channel index */
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);
         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n Variance        \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write variance for saccades */
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.adjust.variance[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n covar chn-Veog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write covariance for saccades */
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.adjust.veogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n covar chn-Heog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.adjust.heogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    /************************/
    /*  Residual variance   */
    fprintf(logFile, "\n\n Residual variance-covariance table ");

    xmax = 0.0;                 /* determine scaling factor */
    for (channel=1; channel<=parameters.eegChannels; channel++) {
         if(logflag[channel]){
    if (blink.residual.variance[channel] > xmax)
        xmax = blink.residual.variance[channel];
    if (blink.residual.veogCovar[channel] > xmax)
        xmax = blink.residual.veogCovar[channel];
    if (blink.residual.heogCovar[channel] > xmax)
        xmax = blink.residual.heogCovar[channel];
    if (saccade.residual.variance[channel] > xmax)
        xmax = saccade.residual.variance[channel];
    if (saccade.residual.veogCovar[channel] > xmax)
        xmax = saccade.residual.veogCovar[channel];
    if (saccade.residual.heogCovar[channel] > xmax)
        xmax = saccade.residual.heogCovar[channel];
         }
    }

    scal = 1.0;

    if (xmax >= 1000000.0)
    scal = 10000.0;
    else if (xmax >= 100000.0)
    scal = 1000.0;
    else if (xmax >= 10000.0)
    scal = 100.0;
    else if (xmax >= 1000.0)
    scal = 10.0;

    fprintf(logFile,"\n Scaling factor = %6.0f\n",scal);

    /* blinks */
    fprintf(logFile,"\n Blinks\n                 \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write channel index */
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);
         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n Variance        \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write variance for blinks */
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.residual.variance[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n covar chn-Veog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write covariance for blinks */
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.residual.veogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n covar chn-Heog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile,"%6.0f ", blink.residual.heogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    /* Saccades */
    fprintf(logFile,"\n\n Saccades\n                 \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write channel index */
         if(parameters.inputFormat == 0 && logflag[channel]){
              fprintf(logFile,"%6.6s ",chanloc[channel]->lab);
         }
         else if(logflag[channel])fprintf(logFile, "%6d ",channel);
         if(channel%10 == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n Variance        \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write variance for saccades */
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.residual.variance[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    fprintf(logFile,"\n covar chn-Veog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){    /* write covariance for saccades */
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.residual.veogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }
    fprintf(logFile,"\n covar chn-Heog  \n");
    for (channel=1; channel<=parameters.eegChannels; channel++){
         if(logflag[channel])fprintf(logFile,"%6.0f ", saccade.residual.heogCovar[channel]/scal);
         if((channel%10) == 0)fprintf(logFile,"\n");
    }

    free_doublesVector(saccade.raw.variance,1,parameters.eegChannels);
    free_doublesVector(saccade.raw.veogCovar,1,parameters.eegChannels);
    free_doublesVector(saccade.raw.heogCovar,1,parameters.eegChannels);
    free_doublesVector(blink.raw.variance,1,parameters.eegChannels);
    free_doublesVector(blink.raw.veogCovar,1,parameters.eegChannels);
    free_doublesVector(blink.raw.heogCovar,1,parameters.eegChannels);
    free_doublesVector(saccade.adjust.variance,1,parameters.eegChannels);
    free_doublesVector(saccade.adjust.veogCovar,1,parameters.eegChannels);
    free_doublesVector(saccade.adjust.heogCovar,1,parameters.eegChannels);
    free_doublesVector(blink.adjust.variance,1,parameters.eegChannels);
    free_doublesVector(blink.adjust.veogCovar,1,parameters.eegChannels);
    free_doublesVector(blink.adjust.heogCovar,1,parameters.eegChannels);
}





