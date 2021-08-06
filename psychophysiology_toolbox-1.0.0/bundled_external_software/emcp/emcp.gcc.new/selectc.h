/****************************************************************************/
/*                                                                          */
/* selectc.h:Program to correct EEG for vertical and horizontal eye-        */
/* movements artifacts.  The correction is made separately for vertical and */
/* horizontal artifacts.  This program uses computational formulae. Vertical*/
/* EOG is assumed to be channel 0.  Horizontal EOG is assumed to be channel */
/* 1.  First EEG channel is assumed to be channel 3 (Fz).                   */
/*                                                                          */
/* Current version written by James M. Turner : June 17, 1993.              */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/****************************************************************************/

int scread(void);                   /* determines rules for selection */ 
int scard(double *xids);        /* determines classification of trial */
