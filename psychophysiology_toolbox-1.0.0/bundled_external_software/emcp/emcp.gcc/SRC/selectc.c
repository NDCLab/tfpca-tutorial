/****************************************************************************/
/*                                                                          */
/* selectc.c:   This file is part of the parser for the id expressions      */
/*              used to sort trials.                                        */
/*                                                                          */
/* Current version written by James M. Turner : June 17, 1993.              */
/*      jturner@p300.cpl.uiuc.edu                                           */
/*      Neuroscience, Washington & Lee University                           */
/*      for the Dept. of Psychology, Cognitive Psychophysiology Lab.        */
/*      Champaign, Illinois.                                                */
/*                                                                          */
/* NOTE:  Portions of this code are direct copies of code from previous     */
/*        version.                                                          */
/****************************************************************************/

#include <stdio.h>
#include <math.h>
#include <string.h>
#include "emcp.h"
#include "selectc.h"

extern  FILE    *parameterFile,                 /* declared in emcp.c */
                *logFile;                       /* file containing params */

#define CARDS 64
int icards[80][CARDS];
int dummy[1024] ;
int ncards;

void xtrans(char *line);                                
void xparen(int *line);                                 

int scread()
{
      int i,k;
      char line[256];
      int n_cards;

      ncards = 0;
      for(i=0; i<CARDS ; i++)
         for (k=0; k<80; k++)
           icards[k][i]=0;

      for(k=0; k<80; k++){
         line[k]='\0';
      }

      i=-1;
      
      fprintf(logFile," Selection cards:\n");
          while(fgets(line,79,parameterFile)!=NULL)
          {
             if( (int) line[0]!=69 && (int) line[0]!=101 && 
                 (int) line[0] != 0 && (int) line[0]!=32 &&
         		(int) line[0] != 10)
             {
                i++;
                ncards = ncards + 1;
                xtrans(line);
                for(k=0; k<80; k++)
		{
                   icards[k][i] = (int) line[k];
        	}
                fprintf(logFile," Card #%d, Index: %d: ",ncards,i);
                fputs(line,logFile);
                fprintf(logFile,"\n");
             }
          }
  fprintf(logFile,"\n\n");
  n_cards = ncards;
  return n_cards;
}

void xtrans(char *line)
/*
    this function transforms a selection card written in
    FORTRAN-like form into a more compact (BASIC-like) form.
 */

{
   int iline[80],oline[80], opos, 
       i,ind;
   for(i=0; i<80; i++){
      iline[i]= (int) line[i];
   }
   /* initialize scanner position */

   opos = -1;

/*  initialize output line */
   for(i=0; i<80; i++){
      oline[i]=0;
   }

/*  Begin scanning */
   i=-1;
   
   for(ind=0; ind<80; ind++){
      i++;
      if(i > 79)goto R995;
      if(iline[i]==41){
     if(i <= 73){
        if(iline[i+1]==40){
           opos++;
           oline[opos]=38;
           i++;
        }
        else{
           opos++;
           oline[opos]=41;
        }
     }
      }
/* if an 'o' put an '|' */
      else if(iline[i]==79 || iline[i] == 111){
        opos++;
        oline[opos]=124;
     }

/*  if an 'a', put an '&' */
      else if(iline[i]==65 || iline[i] == 97){
        opos++;
        oline[opos]=38;
        i+=2;
     }

/* if an 'i', leave it */
      else if(iline[i]==73 || iline[i] == 105){
         opos++;
         oline[opos]=73;
     }
/* if an 'r', ignore it */
      else if(iline[i]==82 || iline[i] == 114){
         goto R1;
      }
     
/*  if a 'd', ignore it */
      else if(iline[i]==68 || iline[i] == 100){
         goto R1;
      }

/* if a period ignore it*/
      else if(iline[i]==46){
        goto R1;
     }

/*  if an 'e', make it '=' */
      else if(iline[i]==69 || iline[i]==101){
        opos++;
        oline[opos]=61;
        i++;
     }

/* if a 'g', make it '>' */
      else if(iline[i]==71 || iline[i]==103){
        opos++;
        oline[opos]=62;
     }
/* if an 'l', make it '<' */
      else if(iline[i]==76 || iline[i]==108){
        opos++;
        oline[opos]=60;
     }
/* if a 't', ignore it */
      else if(iline[i]==84 || iline[i]==116){
         goto R1;
      }
/* if an 'n' make it not equal  */

      else if(iline[i] == 78 || iline[i] == 110){
         opos++;
         oline[opos]=62;
         opos++;
         oline[opos]=60;
         i++;
      }

/* eliminate blank spaces */ /* add linefeed check */

      else if(iline[i]==0 || iline[i]==32 || line[i]==10){
         opos++;
         oline[opos]=0;
      }
      else if(iline[i]==44 && i<79){
         opos++;
         oline[opos]=44;
         }
      else if(iline[i]==42 && iline[i+1]==42){
         opos++;
         oline[opos]=94;
         i++;
     }
      else{
         opos++;
         oline[opos]=iline[i];
     }
R1: continue;
   }
   R995:
   xparen(oline);
   for(i=0; i<80; i++){
      line[i]= (char) oline[i];
   }
return;
}

void xparen(int *line)
{

/*  this one transforms parentheses that enclose an & or |
    sign with square brackets 
 */

   int buff[80], i, index, ii, j;
   
   for(i=0; i<80; i++){
      buff[i]=line[i];
   }

   for(i=79; i>=0; i--){
      if(buff[i] == 40){
     index = 0;
     ii= i+1;
     for(j=ii; j<80; j++){
        if(buff[j]==61 || buff[j] == 62)index = 1;
        if(buff[j]==60)index = 1;
        if(buff[j]==38 || buff[j] == 124)index = 1;
        if(buff[j] == 41){
           if(index == 0){
          buff[i] = 123;
          buff[j] = 125;
           }
           else if(index == 1){
          buff[i]=91;
          buff[j]=93;
           }
           goto R1;
        }
     }
     R1: continue;
      }
   }

   for(i=0; i<80; i++){
      line[i] = buff[i];
      if(line[i] == 123)line[i] = 40;
      if(line[i] == 125)line[i] = 41;
   }
return;
}
