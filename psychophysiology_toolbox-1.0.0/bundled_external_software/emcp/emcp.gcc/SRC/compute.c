/****************************************************************************/
/* compute.c : handles all of the computational subroutines necessary for   */
/*             the regression performed (and described in the routines      */
/*                                                                          */
/* Current version written by James M. Turner : August 4, 1993.             */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "emcp.h"
#include "compute.h"
#include "allocate.h"

#define N_ELECT 65
extern short veogchannel, heogchannel, fzchannel;
extern short corflag[N_ELECT];
extern short logflag[N_ELECT];
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


/************************************************************************/
/*  computeCorrectedSingleTrials()  : corrects the trials               */
/*                                                                      */
/*  Follows same procedure as computeCorrectedAverageTrials expect      */
/*  loops through trials instead of through bins.                       */
/************************************************************************/
void computeCorrectedSingleTrials()
{
  int     trial,                       /* counters */
          point,
          channel;

  double  deltaBlinkVEOG,
          deltaBlinkHEOG,
          deltaSaccadeVEOG,
          deltaSaccadeHEOG,
          avgAdjustment;

  if((parameters.singleTrialOpt!=0)&&(parameters.singleTrialOpt!=2))
    terminate(NO_ERROR,"**** EMCP completed. ****");
  /* exit if this correction isn't desired */
  
  for(trial=1;trial<=parameters.numTrials;trial++)
  /* loop through all trials */
  {
    if(trialInfo[trial].status==0)
    /* if this is an accepted trial continue */
    { 
        computeTrialBaseline(REMOVE,trial);
        /* remove average activity from trial */
        checkBlink(trial);
        /* check for blinks sans trial baseline */
        for(point=1;point<=parameters.trialLength;point++)
        /* loop through length of trial */
        {
            if(markBlink[trial][point]==1.0)
            /* if blink at this point*/
            { 
                deltaBlinkVEOG=rawData[trial][point][veogchannel]-blink.channelMean[veogchannel];
                /* difference between average blink activity at bin and total average activity */
                deltaBlinkHEOG=rawData[trial][point][heogchannel]-blink.channelMean[heogchannel];
                /* difference between average saccade activity in bin and total average activity */
/* OLD VERSION             for(channel=fzchannel;channel<=parameters.eegChannels;channel++) */
                for(channel=1;channel<=parameters.eegChannels;channel++)
		
                /* loop through just the EEG channels */
                {
		     if(corflag[channel]){
			  avgAdjustment=blink.veogFactor[channel]*deltaBlinkVEOG+
                                  blink.heogFactor[channel]*deltaBlinkHEOG;
			  rawData[trial][point][channel]-=(avgAdjustment+blink.channelMean[channel]);
		     }
                } /* end channel */
            } /* end if blink */
            else
            /* must be saccade */
            {
                deltaSaccadeVEOG=rawData[trial][point][veogchannel]-saccade.channelMean[veogchannel];
                /* difference between average saccade activity at bin and total average activity */
                deltaSaccadeHEOG=rawData[trial][point][heogchannel]-saccade.channelMean[heogchannel];
                /* difference between average saccade activity in bin and total average activity */
/*  OLDVERSION               for(channel=fzchannel;channel<=parameters.eegChannels;channel++) BG: look at all channels, loop if you need to correct them*/
                for(channel=1;channel<=parameters.eegChannels;channel++)
                /* loop through the EEG channels */
                {
		     if(corflag[channel]){
			  avgAdjustment=saccade.veogFactor[channel]*deltaSaccadeVEOG+
                                  saccade.heogFactor[channel]*deltaSaccadeHEOG;
			  rawData[trial][point][channel]-=(avgAdjustment+saccade.channelMean[channel]);
		     }
                } /* end channel */
            } /* end if markBlink */
        } /* end point */
        computeTrialBaseline(RESTORE,trial);
        /* restore average activity in trial */
    for(point=1;point<=parameters.trialLength;point++)
            for(channel=1;channel<=parameters.eegChannels;channel++){ /* jt */
                if(logflag[channel])rawData[trial][point][channel]/=calibration[channel];
	   }
        /* factor in calibration values */
        if(parameters.mastoidOpt)
    {
      for(point=1;point<=parameters.trialLength;point++)
/*  OLD VERSION               for(channel=fzchannel;channel<=parameters.eegChannels;channel++) BG: look at all channels, loop if you need to correct them*/
             for(channel=1;channel<=parameters.eegChannels;channel++) /* jt */
/*                rawData[trial][point][channel]-=(rawData[trial][point][parameters.eegChannels]/2); */
        /* BG change:  now gets mastoid channel from mastoiOpt parameter */
    if(corflag[channel] && channel != parameters.mastoidOpt)rawData[trial][point][channel]-=(rawData[trial][point][parameters.mastoidOpt]/2);
                /* take out 1/2 of mastoid (last EEG channel) */
        } /* end if */
    } /*end if accepted */
  } /* end trial */
}

/************************************************************************/
/*  updateMeanIDs()  : sums up the ids for averaging                    */
/************************************************************************/
void updateRawIDs(int trial)
{
  int     id;
   
  for(id=1;id<=parameters.numIDs;id++)
    meanIDs[trialInfo[trial].classification][id]+=rawIDs[trial][id][veogchannel];
    /* sum trial ids into total ids, remember only need one channel */
}

/************************************************************************/
/*  computeMeanIDs()  : does the division for averages                  */
/************************************************************************/
void computeRawIDs()
{
  int     bin,
          id;                           /* counter */
  
  for(bin=1;bin<=parameters.numStorageBins;bin++)
      for(id=1;id<=parameters.numIDs;id++)
        if(trialsInBin[bin])
            meanIDs[bin][id]/=trialsInBin[bin];
            /* if there are trials in bin the divide for mean */
}

/************************************************************************/
/*  computeCorrectAvgs()  : corrects the averages for eye movements     */
/*                                                                      */
/*  In this function we compute the raw average for blink points and    */
/*  saccade points separately (based on blink.sum and saccade.sum)      */
/*  and then after subtracting the channel mean (blink.channelMean and  */
/*  saccade.channelMean) we regress every chan on VEOG and HEOG.        */
/*  Note, the regression model does not have the constant term.         */
/*  (intercept).                                                        */
/************************************************************************/
void computeCorrectAvgs()
{
  int     bin,                       /* counters */
          point,
          channel;

  double  deltaBlinkVEOG,
          deltaBlinkHEOG,
          deltaSaccadeVEOG,
          deltaSaccadeHEOG,
          avgAdjustment;

  for(bin=1;bin<=parameters.numStorageBins;bin++)
  {
  /* loop through each bin */
    if(trialsInBin[bin])
    {
    /* if there are trials in storage bin continue */
      for(point=1;point<=parameters.trialLength;point++)
      {
      /* loop through points */
    deltaBlinkVEOG=deltaBlinkHEOG=0;
    deltaSaccadeVEOG=deltaSaccadeHEOG=0;
    blink.weight=saccade.weight=0;
    if(blink.pointsInBin[point][bin]>=1.0)
    {
      for(channel=1;channel<=parameters.totalChannels;channel++)
          /* loop through all channels */
            blink.sum[point][channel][bin]/=blink.pointsInBin[point][bin];
          /* divide to give average activity */
    
          deltaBlinkVEOG=blink.sum[point][veogchannel][bin]-blink.channelMean[veogchannel];
          /* difference between average blink activity at bin and total average activity */
          deltaBlinkHEOG=blink.sum[point][heogchannel][bin]-blink.channelMean[heogchannel];
          /* difference between average saccade activity in bin and total average activity */
      
          blink.weight=(double)blink.pointsInBin[point][bin]/(double)trialsInBin[bin];
          /* determine weight of blink at time point */
        } /* end if (blink.pointsInBin) */

        if(saccade.pointsInBin[point][bin]>=1.0)
        {
          for(channel=1;channel<=parameters.totalChannels;channel++)
          /* loop through all channels EEG & nonEEG */    
          saccade.sum[point][channel][bin]/=saccade.pointsInBin[point][bin];
          /* divide to give average saccade activity */

          deltaSaccadeVEOG=saccade.sum[point][veogchannel][bin]-saccade.channelMean[veogchannel];
          /* difference between average saccade activity at bin and total average activity */
          deltaSaccadeHEOG=saccade.sum[point][heogchannel][bin]-saccade.channelMean[heogchannel];
          /* difference between average saccade activity in bin and total average activity */

          saccade.weight=(double)saccade.pointsInBin[point][bin]/(double)trialsInBin[bin];
          /* determine weight of saccade at time point */
        }

/*  OLD VERSION               for(channel=fzchannel;channel<=parameters.eegChannels;channel++) BG: look at all channels, doit only if corflag = 1*/
        for(channel=1;channel<=parameters.eegChannels;channel++)
        {
	if(corflag[channel]){
        /* loop through all EEG channels */
           blink.adjustment=blink.weight*(blink.veogFactor[channel]*deltaBlinkVEOG+
                            blink.heogFactor[channel]*deltaBlinkHEOG);
           /* calculate the adjustment for blinks */
           saccade.adjustment=saccade.weight*(saccade.veogFactor[channel]*deltaSaccadeVEOG+
                              saccade.heogFactor[channel]*deltaSaccadeHEOG);
           /* calculate the adjustment for saccades */
           avgAdjustment=blink.adjustment+saccade.adjustment;
           /* combine the two */
      
           rawAverage[point][channel][bin]-=(avgAdjustment+blink.weight*blink.channelMean[channel]+
                        saccade.weight*saccade.channelMean[channel]);
           /* make the correction */
      }  /* end if corflag */
    }/* end channel */
        for(channel=1;channel<=parameters.totalChannels;channel++)
    {
        /* loop through all channels */
           rawAverage[point][channel][bin]+=binBaseline[channel][bin];
           rawAverage[point][channel][bin]/=calibration[channel];
           /* add in the average activity for the bin (ERP wave) */
    } /* end channel */
      } /* end points */
    } /* end if */
  } /* end bin */
}

/************************************************************************/
/*  computePropogation()  : computes contribution of EOG to EEG chans   */
/*                                                                      */
/*  This routine returns veogFactors and heogFactors which are beta     */
/*  weights for a multivariate linear regression of every EEG chan      */
/*  on VEOG and HEOG.  The standardized beta weights are computed using */
/*  computational formulas based on the correlations between EEG and    */
/*  VEOG and HEOG and between VEOG and HEOG.  The formula is:           */
/*                                        Ry1-Ry2*R12                   */
/*  standardized B weights = xeogFactor= --------------                 */
/*                                        1 - R12*R12                   */
/*                                                                      */
/*  After this the standardized B weights are converted into            */
/*  unstandardized B weights which are propogation factors used for     */
/*  correcting the data.                                                */
/************************************************************************/
void computePropogation(double *veogCorr,
						/* veog corr w/ all channels from computeCorrEOG */
                        double *heogCorr,
                        /* heog corr w/ all channels from computeCorrEOG */
                        double *stanDev,
                        /* standard deviation from computeResVar */
                        double **veogFactor,
                        /* pass pnt to array of correction factors */
                        double **heogFactor
                        /* pass pnt to array of correction factors */
                        )
{
    int     channel;                            /* counters */
    
    double  *rawVEOGCorr,                       /* temp storage for raw */
            *rawHEOGCorr;                       /* correlations */

    (*veogFactor)= doublesVector(1,parameters.eegChannels);
    (*heogFactor)= doublesVector(1,parameters.eegChannels);
    rawVEOGCorr= doublesVector(1,parameters.eegChannels);
    rawHEOGCorr= doublesVector(1,parameters.eegChannels);
    /* allocate memory for temporary storage */
    
    /*** for blinks ***/
    for(channel=1;channel<=parameters.eegChannels;channel++)
    {
	 if(logflag[channel]){
	      rawVEOGCorr[channel]=veogCorr[channel];
	      /* copy over blink corr to temp variable */
	      rawHEOGCorr[channel]=heogCorr[channel];
	      /* copy over blink corr to temp variable */
	 }
    }
   
/*
 * Brian Foote  3/9/95 -- Added the else parts to the computations below...
 */ 
    for(channel=1;channel<=parameters.eegChannels;channel++)
    {
        if(rawVEOGCorr[heogchannel]!=1 && logflag[channel])
        /* compute the standardized Beta Weights */
            veogCorr[channel]=(rawVEOGCorr[channel]-
                               rawHEOGCorr[channel]*rawVEOGCorr[heogchannel])/
                              (1.0-(rawVEOGCorr[heogchannel]*rawVEOGCorr[heogchannel]));
	else veogCorr[channel]=0.0 ; /* Is this reasonable? */

        if(rawHEOGCorr[veogchannel]!=1 && logflag[channel])
            heogCorr[channel]=(rawHEOGCorr[channel]-
                               rawVEOGCorr[channel]*rawHEOGCorr[veogchannel])/
                              (1.0-(rawHEOGCorr[veogchannel]*rawHEOGCorr[veogchannel]));
	else heogCorr[channel]=0.0 ; /* Is this reasonable? */
        
        /* compute the propogation factors (unstandardized B weights) */
        if(stanDev[veogchannel] && logflag[channel])
            (*veogFactor)[channel]=veogCorr[channel]*stanDev[channel]/
                                   stanDev[veogchannel];
	else (*veogFactor)[channel]=0.0 ;

        if(stanDev[heogchannel] && logflag[channel])
            (*heogFactor)[channel]=heogCorr[channel]*stanDev[channel]/
                                   stanDev[heogchannel];
	else (*heogFactor)[channel]=0.0 ;

    } /* end channel */

/* <*BF*> 27 March 1995  He really didn't want to free these...        
    free_doublesVector(stanDev,1,parameters.eegChannels);
    free_doublesVector(veogCorr,1,parameters.eegChannels);
*/
    free_doublesVector(rawHEOGCorr,1,parameters.eegChannels);
    free_doublesVector(rawVEOGCorr,1,parameters.eegChannels);
}
                    

/************************************************************************/
/*  computeResidualVariance() : computes residual variance and stan dev */
/*                                                                      */
/*  Returns the difference between the variance over trials and the     */
/*  variance over raw averages (computed in computeVarForTrialWaves and */
/*  computeVarForRawWaves).                                             */
/*  Note also that variance refers to covariance for heog and veog.     */
/************************************************************************/
struct Variance computeResidualVariance(struct Variance raw,
										/* trial based co/variance */
                                        struct Variance adjust,
                                        /* average based co/variance */
                                        double **stanDev)
                                        /* pass pnt to array of stan dev */
{
    struct Variance res;
    int     channel;                            /* counters */

    (*stanDev)= doublesVector(1,parameters.eegChannels);
    res.variance= doublesVector(1,parameters.eegChannels);
    res.veogCovar= doublesVector(1,parameters.eegChannels);
    res.heogCovar=  doublesVector(1,parameters.eegChannels);

    for(channel=1;channel<=parameters.eegChannels;channel++)
    {
    if(logflag[channel]){
        res.variance[channel]=raw.variance[channel]-adjust.variance[channel];
        res.veogCovar[channel]=raw.veogCovar[channel]-adjust.veogCovar[channel];
        res.heogCovar[channel]=raw.heogCovar[channel]-adjust.heogCovar[channel];
        /* take the differences to get the residual variance */
                
        if(res.variance[channel]<0) res.variance[channel]=0;
        /* if negative then make positive */
        (*stanDev)[channel]=sqrt(res.variance[channel]);
        /* take sqroot for standard deviation */
   }  /* end if corflag */
    } /* end channel */
    return res;
}

/************************************************************************/
/*  computeCorrWithEOG() : computes corr between every chan & EOG       */
/*                                                                      */
/*  Compute all pair-wise correlations between the EEG channels and     */
/*  VEOG and HEOG.  These correlations are based on residual covars     */
/*  and standard deviations which were both computed in                 */
/*  computeResidualVar()                                                */
/************************************************************************/
void computeCorrWithEOG(double *stanDev,
						/* stan dev from computeResVar */
                        struct Variance res,
                        /* residual variance from computeResVar */
                        double **veogCorr,
                        /* pointer to array of correlations for return */
                        double **heogCorr)
                        /* pointer to array of correlations for return */
{
  int channel;                             /* counter */

  (*veogCorr)= doublesVector(1,parameters.eegChannels);
  (*heogCorr)= doublesVector(1,parameters.eegChannels);
  /* allocate memory */

  for(channel=1;channel<=parameters.eegChannels; channel++)
  /* loop through EOG and EEG channels */
  /* computes correlation by taking covariance/(stan dev*stan dev) */
  {
  if(logflag[channel]){
    /* if no negatives in denom then determine corr w/ HEOG */
    /* Added the else parts <*BF*> 27 March 1995 */
    if((stanDev[channel])&&(stanDev[veogchannel]))
      (*veogCorr)[channel]=res.veogCovar[channel]/
                            (stanDev[channel]*stanDev[veogchannel]);
    else (*veogCorr)[channel] = 0.0 ;
    /* if no negatives in denom then determine corr w/ VEOG */
    if((stanDev[channel])&&(stanDev[heogchannel]))
      (*heogCorr)[channel]=res.heogCovar[channel]/
                            (stanDev[channel]*stanDev[heogchannel]);
    else (*veogCorr)[channel] = 0.0 ;
    /* if no negatives in denom then determine corr w/ HEOG */
  } /* end if corflag */
  } /* end channel */
}

/************************************************************************/
/*  computeVarForRawWaves()  : computes adjustments due to averages     */
/*                                                                      */
/*  You compute the variance around an estimate of the systematic       */
/*  activity in the data.  Where systematic activity is the raw         */
/*  average wave form computed across raw single trials, for all bins   */
/*  and channels.  The variance is computed across all bins, points     */
/*  for channels.                                                       */
/*                                                                      */
/************************************************************************/
struct Variance computeVarForRawWaves(float  ***sum,						  /* blink/sac component of rawAvg */
		/*from sumTrials			       */
                                      float  ***rawAverage,
                                      /* raw average for each bin      */
                                      double ptsInBase,
                                      /* number of blink/saccade pts   */
                                      double *baseline,
                                      /* mean total activity by channel */
                                      int    **pointsInBin)
                                      /* # of blink/sac pts by pts by bin */
{
    int     point,                          /* counters */
            channel,
            bin;
            
    struct Variance adjust;
    
    double  *weightedAvg;

    weightedAvg= doublesVector(1,parameters.eegChannels);
    adjust.variance= doublesVector(1,parameters.eegChannels);
    adjust.veogCovar= doublesVector(1,parameters.eegChannels);
    adjust.heogCovar= doublesVector(1,parameters.eegChannels);

    for(channel=1;channel<=parameters.eegChannels;channel++)
    {
    if(logflag[channel]){
        adjust.variance[channel]=0;
        adjust.veogCovar[channel]=0;
        adjust.heogCovar[channel]=0;
        weightedAvg[channel]=0;
        /* zero out the arrays prior to use */
   }  /* end if corflag */
    }
                
    for(bin=1;bin<=parameters.numStorageBins;bin++)
    /* loop through each bin */
    {
        for(point=1;point<=parameters.trialLength;point++)
        /* loop through all points */
        {
            if(pointsInBin[point][bin]>=1.0)
            /* if there are points for correction */
            {
                for(channel=1;channel<=parameters.eegChannels;channel++)
                /* loop through VEOG,HEOG and EEG channels */
                {
                if(logflag[channel]){
               adjust.variance[channel]+=rawAverage[point][channel][bin]*
((2.0*sum[point][channel][bin])-
(pointsInBin[point][bin]*rawAverage[point][channel][bin]));
                    adjust.veogCovar[channel]+=(rawAverage[point][channel][bin]*
                                                   sum[point][veogchannel][bin])
                                                   +(rawAverage[point][veogchannel][bin]*
                                                   sum[point][channel][bin])-
                                                   (pointsInBin[point][bin]*
                                                   rawAverage[point][channel][bin]*
                                                   rawAverage[point][veogchannel][bin]);
                    adjust.heogCovar[channel]+=(rawAverage[point][channel][bin]*
                                                   sum[point][heogchannel][bin])
                                                   +(rawAverage[point][heogchannel][bin]*
                                                   sum[point][channel][bin])-
                                                   (pointsInBin[point][bin]*
                                                   rawAverage[point][channel][bin]*
                                                   rawAverage[point][heogchannel][bin]);
                    weightedAvg[channel]+=(pointsInBin[point][bin]*
                                                   rawAverage[point][channel][bin]);
                    /* weighted average based on number of saccade points used later */
                }  /* end if corflag */
                } /* end channel */
            } /* end if points */           
        } /* end points */
    } /* end bin */
    
    /*** Compute covariance with total mean ***/
    for(channel=1;channel<=parameters.eegChannels;channel++)
    /* loop through VEOG,HEOG and EEG channels */
    {
        if(logflag[channel]){
	/* Added the else part...  <*BF*> 27 March 1995 */
        if(ptsInBase) weightedAvg[channel]/=ptsInBase;
	else weightedAvg[channel] = 0 ;
        /* make average based on total blink points */
    } /* end if */
    } /* end channel */
    
    /*** Compute actual adjustment values of the variance and ***/
    /*** covariance due to the averages                       ***/
    for(channel=1;channel<=parameters.eegChannels;channel++)
    /* loop through VEOG,HEOG and EEG channels */
    {
        if(ptsInBase && logflag[channel])
        {
            adjust.variance[channel]=(adjust.variance[channel]/ptsInBase)-
                                     weightedAvg[channel]*((2.0*
                                     baseline[channel])-weightedAvg[channel]);
            adjust.veogCovar[channel]=(adjust.veogCovar[channel]/ptsInBase)+
                                         (weightedAvg[channel]*weightedAvg[veogchannel])-
                                         (weightedAvg[channel]*baseline[veogchannel])-
                                         (weightedAvg[veogchannel]*baseline[channel]);
            adjust.heogCovar[channel]=(adjust.heogCovar[channel]/ptsInBase)+
                                         (weightedAvg[channel]*weightedAvg[heogchannel])-
                                         (weightedAvg[channel]*baseline[heogchannel])-
                                         (weightedAvg[heogchannel]*baseline[channel]);
        }
    } /* end channel */

    free_doublesVector(weightedAvg,1,parameters.eegChannels);
    return adjust;
}


    
/************************************************************************/
/*  computeVarForTrialWaves()  : computes the total variance in raw data        */
/*  That is,                                                            */
/*  variance across trials, points and bins by channel.  Note the       */
/*  distinction between computeVarForTrialWaves() and computeAdjustVar() is     */
/*  that this is a measure of total variance in the uncorrected trial   */
/*  whereas computeAdjustVar() is the measure of total variance based   */
/*  on the rawAverage array.                                            */
/************************************************************************/
void computeVarForTrialWaves(double *baseline,
                             /* [# ch] mean activity in each channel */
                             double ptsInBase,
                             /* total # of blink or saccade points in data set */
                             struct Variance *raw)
                             /* ptr to trial based co/variance for return */
{
    int     channel;                        /* counter */

    struct Variance total;

    total.variance= doublesVector(1,parameters.eegChannels);
    total.veogCovar= doublesVector(1,parameters.eegChannels);
    total.heogCovar= doublesVector(1,parameters.eegChannels);
    /* allocate memory for total data */

    for(channel=1;channel<=parameters.eegChannels;channel++)
    {
        if(logflag[channel]){
        total.variance[channel]=baseline[channel]*baseline[channel];
        total.veogCovar[channel]=baseline[channel]*baseline[veogchannel];
        total.heogCovar[channel]=baseline[channel]*baseline[heogchannel];
        /* baseline from baseline(), average blink activity by channel */
        }
    }
    
    /* computer total variance and covariance using the formula */
    /* variance=sqrt[(SUM(i=1..N)(Xi*Xi/N)-(Xbar*Xbar))] */
    for(channel=1;channel<=parameters.eegChannels;channel++)
    {
        if (ptsInBase && logflag[channel])
        /* make sure we don't divide by zero */
        {
            (*raw).variance[channel]=(*raw).variance[channel]/
                              ptsInBase-total.variance[channel];
            (*raw).veogCovar[channel]=(*raw).veogCovar[channel]/
                                    ptsInBase-total.veogCovar[channel];
            (*raw).heogCovar[channel]=(*raw).heogCovar[channel]/
                                    ptsInBase-total.heogCovar[channel];
        }
	else /* <*BF*> 27 March 1995 */
        {
            (*raw).variance[channel]= 0.0 ;
            (*raw).veogCovar[channel]=0.0 ; 
            (*raw).heogCovar[channel]=0.0 ;
        }
    } /* end channel */

    free_doublesVector(total.variance,1,parameters.eegChannels);
    free_doublesVector(total.veogCovar,1,parameters.eegChannels);
    free_doublesVector(total.heogCovar,1,parameters.eegChannels);
} 
        
/************************************************************************/
/*  computeBinAvg()  : produces the average wave form in each bin       */
/*                                                                      */
/*  Computes the raw average for each bin.  The mean activity in each   */
/*  trial has been removed since based on .sum.                         */
/*                                                                      */
/*  Dependent on:                                                       */
/************************************************************************/
float ***computeBinAvg(float ***bComponent, float ***sComponent)
{
    int     point,                          /* counters */
            channel,
            bin;
    
    float   ***rawAverage;
    
    rawAverage= (float ***) floatTensor(1,parameters.trialLength,
                        1,parameters.totalChannels,
                        1,parameters.numStorageBins);
    /* array to hold raw average wave for each bin */
 
    for(bin=1;bin<=parameters.numStorageBins;bin++)
    {
        for(channel=1;channel<=parameters.totalChannels;channel++)
        {
            for(point=1;point<=parameters.trialLength;point++)
            {
                if (trialsInBin[bin])
                {
                    rawAverage[point][channel][bin]=
                        bComponent[point][channel][bin]+sComponent[point][channel][bin];
                    rawAverage[point][channel][bin]/=(double)trialsInBin[bin];
                }
		else /* <*BF*> 27 March 1995 */
                {
                    rawAverage[point][channel][bin]= 0.0 ;
                }
            } /* end point */
        if(trialsInBin[bin])
	{
                    binBaseline[channel][bin]/=(double)trialsInBin[bin];
	}
	else   /*  BG */
        {
             binBaseline[channel][bin] = 0.0;
	}
        /* compute avg baseline activity in bin also */
        } /* end channel */
    } /* end bin */
    return rawAverage;
}

/************************************************************************/
/*  baseline()  :  average blink/saccade activity in each channel       */
/*                                                                      */
/*  Get mean blink and saccade activity collapsing over bins and        */
/*  points.  The average activity of each trial has been removed,       */
/*  since this is based on .sum which is determined in sumTrial.        */
/*                                                                      */
/*  Dependent on:                                                       */
/************************************************************************/
double *baseline(double   *ptsInBase,
                 /* # pts used in calc *baseline */
                 int     **pointsInBin, 
                 /* [# pts][# bins] # pts in each bin over all pts */
                 /* in trial */
                 float   ***sum 
                 /* [# pts][# ch][# bins] contribution to raw average */
                 /* of blink or saccade data */
                )                    
{
  int      channel,     /* counters */
           bin,
           point;
           
  double   *baseline;   /* [channels] stores mean activity */
                
  baseline = (double *) doublesVector(1,parameters.totalChannels);
  /* declare space for array */
  
  for(channel=1;channel<=parameters.totalChannels;channel++)
    baseline[channel]=0;
  /* zero the array */
  
  (*ptsInBase)=0;
  /* zero denominators */
   
  for(bin=1;bin<=parameters.numStorageBins;bin++)
  /* go through each storage bin */
  {
    for(point=1;point<=parameters.trialLength;point++)
    /* go through each point in a trial */
    {
        if (pointsInBin[point][bin])
        /* determined in sumTrial */
        /* if there are points in this bin @ this point do...*/
        {
            (*ptsInBase)+=(double)pointsInBin[point][bin];
            /* add # pts to total for denominator */
            for(channel=1;channel<=parameters.totalChannels;channel++)
            /* go through each channel */
            {
                baseline[channel]+=(double)sum[point][channel][bin];
                /* add activity to baseline */
                /* sum determined in sumTrial */
            }
        }
	else /* <*BF*> 27 March 1995 */
	{
	/*
		22 June 1996 <*BF*>  This may not have been
			what we wanted after all...
		for(channel=1;channel<=parameters.totalChannels;channel++)
			baseline[channel] = 0 ;
	*/
	}
    } /* end if points */
  } /* end for storage bins */
  for(channel=1;channel<=parameters.totalChannels;channel++)
  /* go through each channel */
  {
    if ((*ptsInBase)>0)
        baseline[channel]/=(double)(*ptsInBase);
        /* gives average activity in each channel */
  } /* end for channel */
  return baseline;
}

        

/************************************************************************/
/*  computeTrialBaseline()  : removes or adds baseline to trial         */
/*                                                                      */
/*  This routine takes average activity in each channel for the trial   */
/*  and subtracts it from each point.  It also restores this data when  */
/*  remove = 0.                                                         */
/************************************************************************/
void computeTrialBaseline(int remove,int trial)
{
    int channel,
        point;                                              /* counters */
    
    if (remove)
    /* if we are removing the baseline then do: */
    {
        for(channel=1;channel<=parameters.totalChannels;channel++) /* jt */
            trialBaseline[channel]=0.0;

            /* clear baseline buffer */
        for(point=1;point<=parameters.trialLength;point++)
        for(channel=1;channel<=parameters.totalChannels;channel++)
               trialBaseline[channel]+=(double)rawData[trial][point][channel];
            /* sum up for each channel */
    for(channel=1;channel<=parameters.totalChannels;channel++)
            trialBaseline[channel]/=(double)parameters.trialLength;
        /* get baseline for each channel by taking average */
        /* activity during the entire trial in each channel */

        for(channel=1;channel<=parameters.totalChannels;channel++)
            binBaseline[channel][trialInfo[trial].classification]+=
            trialBaseline[channel];
        /* also sum up so we can create averages later by adding */
        /* up now instead of later */
    }
    for(point=1;point<=parameters.trialLength;point++)  /* jt */
    {
        for(channel=1;channel<=parameters.totalChannels;channel++)
        {
            if (remove) rawData[trial][point][channel]-=
                (float)trialBaseline[channel]; 
            /* substract average if we are removing baseline */
            else rawData[trial][point][channel]+=
                (float)trialBaseline[channel];         
            /* add averages back in */
        } 
   }
}
            
/************************************************************************/
/*  sumTrial()  : sum up a trial for correlation figures                */
/*                                                                      */
/*  The variance of each channel and the covariance between VEOG, HEOG  */
/*  and each channel is computed.  This is done separately for blink    */
/*  points and saccade points.                                          */
/*  The average of each channel for each trial has already been removed */
/*  thus this is based on the data - its average                        */
/*                                                                      */
/*  Dependent on:                                                       */
/*    rawData, markBlink, .sum, .variance, .veogCovar, .heogCovar        */
/*    for blinks and saccade                                            */
/*                                                                      */
/************************************************************************/
void sumTrial(int trial)            
{
    int ch,                                 /* counters */
        pt;         
        
    for(pt=1;pt<=parameters.trialLength;pt++)
    {
        for(ch=1;ch<=parameters.totalChannels;ch++) /* jt */
        {
            if(markBlink[trial][pt]==1)
            /* if point is marked as a blink */
            {
                if(veogchannel==ch)
                    ++blink.pointsInBin[pt][trialInfo[trial].classification];
                /* increment counter */
                blink.sum[pt][ch][trialInfo[trial].classification]+=
                     rawData[trial][pt][ch];
        /* (blink.sum + saccade.sum)/# points in bin = raw average */
                blink.raw.variance[ch]+=(double)rawData[trial][pt][ch]*
                     (double)rawData[trial][pt][ch];
    /* NOTE:  Variance labelling below is inaccurate.  In        */
    /*        computeVarForTrialWaves() further operations are performed */
        /*        which result in the variances and covariances      */
        /* standard variance computation, mean x was removed earlier */
                blink.raw.veogCovar[ch]+=(double)rawData[trial][pt][ch]*
                     (double)rawData[trial][pt][veogchannel];
        /* standard covariance computation, mean x was removed ealier */
                blink.raw.heogCovar[ch]+=(double)rawData[trial][pt][ch]*
                     (double)rawData[trial][pt][heogchannel];
        /* standard covariance computation, mean x was removed earlier */
            }
            else
        /* point is a saccade point if not a blink point */
            {
                if(veogchannel==ch)
                    ++saccade.pointsInBin[pt][trialInfo[trial].classification];
                saccade.sum[pt][ch][trialInfo[trial].classification]+=
                    rawData[trial][pt][ch];
        /* (blink.sum + saccade.sum)/# points in bin = raw average */
                saccade.raw.variance[ch]+=(double)rawData[trial][pt][ch]*
                    (double)rawData[trial][pt][ch];
        /* NOTE:  Variance labelling below is inaccurate.  In        */
        /*        computeVarForTrialWaves() further operations are performed */
        /*        which result in the variances and covariances      */
        /*  standard variance computation, mean x was removed earlier */
                saccade.raw.veogCovar[ch]+=(double)rawData[trial][pt][ch]*
                    (double)rawData[trial][pt][veogchannel];
        /* standard covariance computation, mean x was removed earlier */
                saccade.raw.heogCovar[ch]+=(double)rawData[trial][pt][ch]*
                    (double)rawData[trial][pt][heogchannel];
        /* standard covariance computation, mean x was removed earlier */
            }
        } /* end for(pt) */
    } /* end for(ch) */
}


