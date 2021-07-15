/****************************************************************************/
/*                                                                          */
/* scard.c:   This file is part of the parser for the id expressions        */
/*              used to sort trials.                                        */
/*                                                                          */
/* Current version written by James M. Turner : August 4, 1993.             */
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
#include <stdlib.h>

/*
 *  Recoded to C from Gabriele's SCREAD
 *  by Bill Gehring
 *     September 17, 1991
 *
 *  changes: 1) I/O changed to read from EMCP's cardfile
 *           2) atoi substituted for xvalue subroutine.
 */

int scard(double *xids);

/*
 *  xids is a double array of undetermined length that
 *  contains the ids against which the selection cards
 *   are compared
 */

/*
 *  Description of program function:
 *
 *  These routines read from an ascii file a set of 
 *  up to 24 selection cards, or fortran-like (or BASIC-like)
 *  descriptions that the calling program can use 
 *  to classify an ID vector.   Each selection card appearing on
 *  a line corresponds to one selection criterion.  The ID
 *  vector is classified with the number of the first
 *  selection criterion it meets.
 *  
 *  The cards can appear in a variety of formats.  Parentheses
 *  (but not brackets) are assumed to be AND-ed together.  
 *
 *  The program will recode the selection card
 *  as the BASIC-like (<= > etc.) format.  It will write
 *  to corrfile the re-interpreted selection cards. 
 *
 *    ID can be denoted as I
 *
 *    .eq. =
 *    .lt. <
 *    .gt. >
 *    .le. <=   
 *    .ge. >=   
 *    .ne. <> or ><
 *    .and. &
 *    .or. |
 *
 *    note:  <= and >= do not seem to work properly.........
 *
 *  TWO IMPORTANT NOTES:
 *
 *  DO NOT ALLOW ANY BLANKS INTO THE PROGRAM...
 *    [I1=1|I1=2]  IS OKAY BUT [i1 = 1 | i1 = 2] IS NOT
 *
 *  ALSO, BE CAREFUL WHEN USING ANDS AND ORS TOGETHER:
 *    (i1=1|i1=2)(i2=3) will give you [i1=1|i1=2&i2=3]
 *    but [i1=1|i1=2]&[i2=3]  will work fine.
 *
 *  FINALLY, I1=-I2 will not work
 *
 *   Below are some examples
 *
 *  (id1.eq.1)(id2.eq.1)
 *  [i1=1&i2=1]  
 *
 *      selects are trials for which ID1 is equal to 1 
 *      and ID2 eqauls 2
 *
 *  (i1=i2)
 *      selects trials on which id1 = id2
 *
 *  [i1=1|i1=2]&[i2=3]
 *          trials on which id1 is 1 or 2 and
 *      id2 is 3
 *
 *  BUG:  do not do this as (i1=1|i1=2)(i2=3) because
 *      you will get [i1=1|i1=2&i2=3]
 *
 *
 */

/*  
 * The rest of these are only of interest internally
 */

void xbrck(int *line, int *ibrckb, int *ibrcke);

void elbrck(int *line, int *ibrckb, int *ibrcke, int *ivalue);

extern void xtrans(char *line);                             /* in selectc.c */

int xexchk(int *ibeg, int *iend, int *buff, double *xids,
           int *printv);
     
void fend(int *ibeg, int *iend, int *line, int *epos, int *etype);

void fsign(int *sbeg, int *send, int *line, int *spos, int *stype);

void xexpr(int *bx, int *ex, int *card, double *xids, int *value);

void xexpr1(int *b, int *e, int *line, double *xids, int *val);

void xins1(int *lpar, int *rpar, int *line);


void xins(int *b, int *e, int *line, int *value, int *shift);

void xopval(int *b, int *e, int *opos, int optyp, int *line,
        double *xids, int *val);

void xneg(int i, int *line, int *val);

void xparen(int *line);                                     /* in selectc.c */

#define CARDS 64
extern int icards[80][CARDS];                                  /* in selectc.c */
extern int ncards;                                          /* in selectc.c */

/******************************************************
             functions...
 ******************************************************/

int scard(double *xids)
{ 
/*
     This function interprets the selection cards

     xids   = IDs (double)

     returns value to report back (-1=none)

     Allowed separations between logical statements:
          blank    is end of IF statement
            |      is  OR
            &      is AND
     Allowed sign types
            =      equal to
            >      greater than
            <      less than
            >=     greater or equal
            <=     less or equal
            ><     not equal
            <>     not equal
     Operation allowed: + add
                        - subtract
                        * multiply
                        / divide
                        ^ exponential
     IDs are addressed by I or i and the ID number
*/
     int i,j,k,
         line[80],
         index,
         printv,
     ibeg, iend,
     ibegp1, iendm1,
         ivalue;

     ivalue = 1;
     if(ncards != 0){
    ivalue = -1;
        index = 0;
        for (k=0; k<ncards; k++){ /* for each selection card */
        for(j=0; j<80; j++)  /* copy card to temporary buffer*/
                 line[j] = icards[j][k];

        index++;
            printv = -1;

        for(i=0; i<26; i++){  /* examine each expression */
        xbrck(line, &ibeg, &iend);
        ibegp1 = ibeg + 1;
                iendm1 = iend - 1;
        xexchk(&ibegp1,&iendm1,line,xids,&printv);
        if(ibeg >= 0 && iend <= 79){
           elbrck(line,&ibeg,&iend,&printv); 
             }
                 else{
                if(printv == 1){
            ivalue=index;
                        goto A2;
            }
            else
                goto A1;
             }  
        }
A1:      continue;
    }
     }  
     A2:
return ivalue;
  }

void xbrck(int *line, int *ibrckb, int *ibrcke)

/* this function isolates bracketed sequences */

{
int i, ib;
    *ibrckb = -1;
    *ibrcke = 80;

    for (i=79; i>=0; --i){
        if (line[i] == 91){
       *ibrckb=i;
           goto L50;
        }
    }

    L50: ib = *ibrckb + 1;

    for (i=ib; i<80; i++){
        if(line[i] == 93){
       *ibrcke = i;
       return;
        }
    }
return;
}


void elbrck(int *line, int *ibrckb, int *ibrcke, int *ivalue)
{

/*  this function substitutes a "T" or an "F" for a bracketed
    sequence */

   int i,j,
       buff[80];

   for (i=0; i<80; i++){
      if( i < *ibrckb || i > *ibrcke){
     buff[i]=line[i];
      }
      else if(i==*ibrckb){
     if(*ivalue == 1){
        buff[i] = 1;
     }
     if(*ivalue != 1){
        buff[i] = -1;
         }
      }
      else{
     buff[i]=0;
      }
   }


   j= -1;

   for (i=0; i<80; i++){  /*  add linefeed check */
      if(buff[i] != 0 && buff[i] != 32 && buff[i] !=10){
     j++;
     line[j]=buff[i];
      }
   }

   j++;

   for(i=j; i<80; i++){
      line[i]=0;
   }
return;
}


int xexchk(int *ibeg, int *iend, int *buff, double *xids,
           int *printv)
/*
 *  this function checks an elmentary logical expression and
 *  returns a value
 */
{
   int i,j,k, 
      line[80],
      pretyp, ibeg2, iend2,
      epos, etype, sbeg, send,
      spos, stype, lpbeg, lpend,
      rpbeg, rpend,
      lvalue, rvalue, intval,
      tempvl, icond;

   char aline[80];

/*  copy the relevant part of the expression to a buffer */

   for(i=0; i<80; i++){
      line[i] = 0;
   }

   for(i=*ibeg; i<=*iend; i++){
      line[i] = buff[i];
   }

/*  initialize values */

   intval = 0 ;
   pretyp = 0;
   ibeg2 = *ibeg;
   iend2 = *iend;

/*  for each iteration */
   for (k=0; k<27; k++){

/*      find the end of the subsection */

      if(ibeg2 > iend2)goto R999; 
      fend(&ibeg2, &iend2, line, &epos, &etype);

/*  mark the beginning and end of the subsection */

      sbeg = ibeg2;
      send = epos - 1;
      if(send < sbeg)goto R999;
      ibeg2 = send + 2;

/*  decode the statement */
/*   if a "T" statment   */
      if(line[sbeg]==1){
     intval=1;
     goto R18;
      }
/*  if an "F" statement  */
      else if(line[sbeg] == -1){
     intval = -1;
     goto R18;
      }

      intval = -1;

/*  find the sign statement (=, <>, etc.) */

      fsign(&sbeg, &send, line, &spos, &stype);


      if(spos == 0)goto R18;

/*  Mark the beginning and end of the left and right part 
    (e.g. before and after the =) */
      lpbeg = sbeg;
      lpend = spos - 1;
      rpbeg = spos + 1;
      if(abs(stype) >= 2){
     rpbeg = spos +2;
      }
      rpend = send;
      if(lpend < lpbeg || rpend < rpbeg)goto R1;

/*  determine the value of the left part of the statment */

      xexpr(&lpbeg, &lpend, line, xids, &lvalue);

/*  if a comma within the right part  */
      icond = 0;
R140: for(i=rpbeg; i<=rpend; i++){
     if(line[i] == 44){
        icond = 1;
        rpend = i - 1;
        goto R150;
     }
     icond = 0;
      }

/*   determine the value of the right part of the statement */

      if(rpend < rpbeg)goto R1;
      R150: xexpr(&rpbeg, &rpend, line, xids, &rvalue);

/*
 * compare the two values
 *  if equal..
 */
      if(stype == 0){
     if(lvalue == rvalue)intval = 1;
      }
/* if not equal */
      else if(stype == 3 || stype == -3){
     if(lvalue != rvalue)intval = 1;
      }
/* if greater than */
      else if(stype == 1){
     if(lvalue > rvalue)intval = 1;
      }
/*  if .ge. */
      else if(stype == 2){
     if(lvalue <= rvalue)intval = 1;
      }
/* if .lt. */
      else if(stype == -1){
     if(lvalue < rvalue)intval = 1;
      }
/*  if .le. */
      else if(stype == -2){
     if(lvalue <= rvalue)intval = 1;
      }
/*
 * if a comma, repeat the operation with a new value 
 */
      if(icond == 1){
     rpbeg = rpend + 2;
     rpend = send;
     goto R140;
      }
 R18: if(pretyp == 0){
     *printv = intval;
      }
      else if(pretyp == 2){
     if(*printv==1 || intval ==1)*printv=1;
      }
      else if(pretyp == 3){
     tempvl = -1;
     if(*printv == 1 && intval == 1)tempvl=1;
     *printv = tempvl;
      }
      if(etype == 1)goto R999;
      pretyp = etype;
   }


R1:    aline[79]='\0';
       for(j=0; j<79; j++)
       aline[j]= (char) line[j];
       printf(" invalid syntax: \n   %s",aline);
R999: return intval ;
}
     

void fend(int *ibeg, int *iend, int *line, int *epos, int *etype)

/* 
 * This function scans a line and finds the next blank, |
 * or & character or linefeed
 *
 *   ibeg  = Starting point of scanning
 *   iend  = End point of scanning
 *   line  = Line (ASCII codes)
 *   epos  = Character position
 *   etype = Character type (1=blank, 2=or, 3=and)
 */

{   
   int i;
   *epos = *iend + 1;
   *etype = 1;
   
   for (i = *ibeg; i<= *iend; i++){
      if(line[i]==0 || line[i]==32 || line[i] == 124 ||
     line[i]==38 || line[i]==10){
     *epos = i;
     if(line[i]==0 || line[i]==32 || line[i]==10)*etype = 1;
     if(line[i]==124)*etype = 2;
     if(line[i]==38)*etype = 3;
     goto A1;
      }
   }
   A1: 
   return;
}
      

void fsign(int *sbeg, int *send, int *line, int *spos, int *stype)

/*
 *  this function scans a line and finds the position and type of t
 *  the relationship sign

     SBEG   =      beginning of the scanning
     SEND   =      end of the scanning
     LINE   =      line (ASCII codes)
     SPOS   =      sign position
     STYPE  =      sign type
                   0      =      equal to
                   1      >      greater than
                   2      >=     greater or equal
                  -1      <      less than
                  -2      <=     less or equal
                   3      ><     not equal
                  -3      <>     not equal

 */

{
   int i;
   *spos = 0;
   *stype = 0;

   for(i= *sbeg; i<= *send; i++){
      if(line[i]==61 || line[i]==60 || line[i]==62){
     *spos = i;
     if(line[i]==61){
        *stype = 0;
     }
     else if(line[i]==62){
        *stype = 1;
        if(line[i+1] == 61)*stype = 2;
        if(line[i+1] == 60)*stype = 3;
     }
     else if(line[i] == 60){
        *stype = -1;
        if(line[i+1] == 61)*stype = -2;
        if(line[i+1] == 62)*stype = -3;
     }
     return;
      }
   }

}


void xexpr(int *bx, int *ex, int *card, double *xids, int *value)
/*
     This function scans an expression and obtains a value

     BX     = point to begin of scanning
     EX     = point to end of scanning
     LINE   = line (ASCII codes) containing the expression
     XIDS   = IDs
     VALUE  = value to return (integer)

     Operation allowed: + add
                        - subtract
                        * multiply
                        / divide
                        ^ exponential

     Priorities should follow the usual algebraic rules.  Parenthesis
     are allowed

     I indicates ID
*/

{
   int line[80];
   int i, b, e, x, j, k,
       parind, lpar, rpar,
       xbeg, xend, shft;
   char aline[80];

   x = 0 ;
   
   b = *bx;
   e = *ex;

/* blank the line */

   for(i=0; i<80; i++){
      line[i]=0;
   }

/* copy the relevant section of the card */
   
   for(i=b; i<=e; i++){
      line[i] = card[i];
   }

/*  find the end of the line */    /* add linefeed check */
R1:
   for(i=e; i>=b; i--){
      if(line[i] != 0 && line[i] != 32 && line[i]!=10){
     x = i;
     goto R1101;
      }
   }

R1101:

   e = x;

/* find the position of the last left parenthesis */

   parind = 0; 

   for(i=b; i<=e; i++){
      if(line[i] == 40){
     parind = 1;
     lpar = i;
      }
   }

/* if no left parenthesis */

   if(parind == 0){
      xexpr1(&b, &e, line, xids, value);
      R999: return;
   }

/* find the positions of the next right parenthesis */

   for(j=lpar; j<=e; j++){
      if(line[j] == 41){
     rpar = j;
     goto R1200;
      }
   }

/* if right parenthesis missing */

   for(k=1; k<=80; k++){
      aline[k] = (char) line[k];
   }


   printf(" Right Parenthesis Missing:  %s \n",aline);
   goto R999;

/* compute the value of the expression */
   R1200: 
   xbeg = lpar + 1;
   xend = rpar -1;
   xexpr1(&xbeg, &xend, line, xids, value);
   shft = rpar - 1 - xend;
   rpar = rpar - shft;

/* delete the two parentheses */

   xins1(&lpar, &rpar, line);
   e = e - 2;

/* start the whole operation again */
   goto R1;
}
   


void xexpr1(int *b, int *e, int *line, double *xids, int *val)

/*
     This subroutine scans an expression and obtains a value

     B      = point to begin of scanning
     E      = point to end of scanning
     LINE   = line (ASCII codes) containing the expression
     XIDS   = IDs
     LVALUE = value to return (integer)

     Operation allowed: + add
                        - subtract
                        * multiply
                        / divide
                        ^ exponential

     Priorities should follow the usual algebraic rules

*/

{
   int i, bb, j, value, idsign, shift;
   char temp[80];

/* scan the line for all the power signs */

   R1:
   for(i=*b; i<=*e; i++){
      if(line[i] == 94){
     xopval(b, e, &i, 5, line, xids, val);
     goto R1;
      }
   }

/*  Scan the line for all the multiplier signs */
   R2:
   for(i=*b; i<=*e; i++){
      if(line[i] == 42){
     xopval(b, e, &i, 3, line, xids, val);
     goto R2;
      }
   }

/*  Scan the line for all the division signs */
   R3:
   for(i= *b; i<= *e; i++){
      if(line[i] == 47){
     xopval(b, e, &i, 4, line, xids, val);
     goto R3;
      }
   }

/* Scan the line for all the addition signs */
   R4:
   for(i= *b; i<= *e; i++){
      if(line[i] == 43){
         xopval(b, e, &i, 1, line, xids, val);
         goto R4;
      }
   }

/* Scan the line for all subtraction signs */
   R5:
   for(i= *b; i<= *e; i++){
      if(line[i] == 45){   
     value = 1;
     xneg(i+1, line, &value); /*  check if minus sign */

/*  if the - sign indicates subtraction, then subtract
     value will remain 1 if - sign is the subraction operator */

     if(value == 1){
        xopval(b, e, &i, 2, line, xids, val);
        goto R5;
     }
      }
   }

/*  Get the value back */
   bb = *b;

   idsign = 0;

/*  if this character is an i or an I (for an i.d.) move it ahead
     and denote that its and id */

   if(line[bb] == 73 || line[bb] == 105){
      bb = bb + 1;
      idsign = 1;
   }

/* use atoi instead of gab's subtroutine */

   j=0;


/*  THIS SECTION NOW INCLUDES A - SIGN, DIDN'T USED TO */

   for(i=bb; i<=*e; i++){
     temp[j]= (char) line[i];
     j++;
   }

   temp[j]='\0';
   *val = atoi(temp);

/*  this next line moved from before 73/105 check above to here */

   if(line[*b] == 45)bb = *b +1;  /* move it ahead if it's a minus sign */

/*    xvalue(&bb, e, line, val); */

   if(idsign == 1) *val = (int) xids[*val-1]; 
   /* changed to get appropriate array location!!*/

   xins(b, e, line, val, &shift);  /* substitute value into line */

   *e = *e - shift;

/*  
     GREAT BIG IMPROVEMENT:  IF THE VALUE COMES FROM THE
     ID ARRAY, DON'T NEED TO CHANGE ITS SIGN, SIGN IS
     CORRECT ALREADY!!!  
*/

   if(idsign == 0)xneg(bb, line, val);
/* printf("val is: %d\n",*val) ; */
/* R999: */
   return;
}


void xins1(int *lpar, int *rpar, int *line)
/*  this function deletes pairs of parentheses 
 *  lpar, rpar = position of the two parentheses
 *  line = line of ascii codes where expression is
 */

{
   int buff[80],
       j, sp, xx;

   sp = 0;
   for(j = 0; j < 80; j++){
      if(j != *lpar && j != *rpar){
     sp++;
     buff[sp] = line[j];
      }
   }

   for(j=0; j<sp; j++){
      line[j]=buff[j];
   }

   xx = sp + 1;
  
/*  blank the remaining spaces */
   for(j = xx; j< 80; j++)
      line[j] = 0;

return;
}

void xins(int *b, int *e, int *line, int *value, int *shift)

/* This function substitues an operation with the corresponding 
 *  value
 *  b,e = beginning and ending position of the operation
 *  line = line where expression is (ascii)
 *  value = value to insert (integer 
 */
{
   int buff[80], temp[7], 
       xxval, iflag, aaa, sp, tb,
       te, lenbuf, lenlin, xx, j;

/* copy the value in a buffer (keep temp array
     dimensioned from 1 to 6) */

   xxval = abs(*value);
   if(xxval > 99999)xxval = 99999;
   iflag = 0;

   for (j = 1; j <=6; j++){
      if(xxval >= pow(10, 6-j)){
     aaa = xxval/(pow(10, 6-j));
     xxval = xxval - aaa;
     temp[j] = aaa + 48;
     iflag = 1;
      }
      else{
     if(j == 6 || iflag == 1){
        temp[j] = 48;
         }
     else{
        temp[j] = 0;
     }
      }
   }

/*  If a negative number, add a minus sign at the beginning */

   if(*value < 0){
      temp[1] = 45;
   }

/* blank the temporary buffer */

   for(j = 0; j<80; j++){
      buff[j] = 0;
   }

   sp = -1;

/* Copy the left part of the formula */
      
   te = *b - 1;
   for(j=0; j<te; j++){
      sp++;
      buff[sp] = line[j];
   }

/* Insert the new value */
   for(j = 0; j< 6; j++){
      if(temp[j+1] != 0){
     sp++;
     buff[sp] = temp[j+1];  
      }
   }

/* Copy the right part of the formula */

   tb = *e + 1;
   for(j = tb; j <80; j++){
      if(line[j] != 0){
     sp++;
     if(sp <= 79)buff[sp] = line[j];
      }
   }

/* Compute shift */

   lenbuf = 80;
   for (j=79; j >= 0; j--){
      if(buff[j] != 0 && buff[j] != 32){
     lenbuf = j+1;
     goto R105;
      }
   }

   R105:
   lenlin = 80;
   for (j= 79; j>= 0; j--){
      if(line[j] != 0 && line[j] != 32){
     lenlin = j + 1;
     goto R106;
      }
   }

   R106:
   *shift = lenlin - lenbuf;

/* copy in the old buffer */
   if(sp < 79){
      for(j=0; j <= sp; j++)
         line[j] = buff [j];
      xx = sp+1;
      for(j = xx; j<80; j++)
         line[j] = 0;
   }
   else{
      for(j=0; j< 80; j++)
        line[j] = buff[j];
   }
return;   
}


void xopval(int *b, int *e, int *opos, int optyp,  int *line,
        double *xids, int *val)
/* this function determines the right and left values
 * around an elementary operation
 *
 *   b,e, = first and last position of expression
 *   opos = operation sign position
 *   lval = left value of the operation
 *   rval = right value of the operation
 */

{

   int le, lb, i, lval, rval, rb, sign, idsign, re, shift;
   char tempchar[80];

   le = *opos - 1;
   lb = *b;
   
   for (i= le; i>= *b; i--){
      if(line[i] < 48 || line[i] > 57){
     lb = i+1;
     goto R2;
      }
   }
   R2: 
   
   for(i=lb; i<=le; i++){
     tempchar[i]= (char) line[i];
   }
   tempchar[le + 1] = '\0';
   lval = atoi(tempchar);

/* xvalue(&lb, &le, line, &lval); */

   if(lb >= 1){
      if(line[lb-1] == 73 || line[lb-1] == 105){
     lval = xids[lval];
     lb--;
      }
   }

/*  check if a negative value */
   xneg(lb, line, &lval);
   if(lval < 0)lb--;
   
/* determine right value */
   rb = *opos + 1;
   sign = 1;

/* if a negative value */
   if(line[rb] == 45 && i <= 78){
      if(line[i+1] >= 48 && line[i+1] <= 57){
     rb = rb + 1;
     sign = -1;
      }
      else if(line[i+1] == 73 || line[i+1] == 105){
     rb = rb + 1;
     sign = -1;
      }
   }

/* if an ID */
   idsign = 0;
   if(line[rb] == 73 || line[rb] == 105){
      idsign = 1;
      rb = rb +1;
   }
   re = *e;
   for (i=rb; i<=*e; i++){
      if(line[i] <  48 || line[i] > 57){
     re = i -1;
     goto R3;
      }
   }

   R3:
   
   for(i=rb; i<=re; i++){
     tempchar[i]= (char) line[i];
   }
   tempchar[re + 1] = '\0';
   rval = atoi(tempchar);

/*    xvalue(&rb, &re, line, &rval); */
   if(idsign == 1)rval = xids[rval];
   rval = rval * sign;

   if(optyp == 1)*val = lval + rval;
   if(optyp == 2)*val = lval - rval;
   if(optyp == 3)*val = lval * rval;
   if(optyp == 4)*val = lval/rval;
   if(optyp == 5)*val = pow(lval, rval);
   xins(&lb, &re, line, val, &shift);
   *e = *e - shift;
return;
}


void xneg(int i, int *line, int *val){

/*  this function checks if a value in a line is negative.
 *  if so it changes the sign 
 *  i = starting position of the number (1st significant digit)
 *  line = line of ascii codes
 *  val = value of number
 */

   int sign;
   sign = 1;

   if(i >= 1){
/*  if the value is preceded by a negative sign */
      if(line[i-1] == 45){
     if(i == 1){   /* if first column */
        sign = -1;
         }
     else if(i >= 2){
/* if preceded by an operation sign or left parenthesis */
        if(line[i-2]==43 || line[i-2]==45 ||
           line[i-2]==42 || line[i-2]==47 ||
           line[i-2]==94 || line[i-2]==40 ||
           line[i-2]==0)sign = -1;
     }
      }
   }
   *val = *val * sign;
   return;
}

