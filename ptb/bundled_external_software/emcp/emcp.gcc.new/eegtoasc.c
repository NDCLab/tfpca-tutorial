#include <stdio.h>
#include <stdlib.h>
#define N_ELECT 513
#include "sethead.h"

ELECTLOC	*channel[N_ELECT];
SETUP		erp;
FILE		*fp, *fp2;
short data[3000][64], i, j, k;
typedef struct
{
      char     accept __attribute__ ((packed));
      short      ttype  __attribute__ ((packed));
      short      correct  __attribute__ ((packed));
      float    rt  __attribute__ ((packed));
      short      response  __attribute__ ((packed));
      short      reserved  __attribute__ ((packed));
} SWEEP_HEAD;

SWEEP_HEAD sweephead;

main(int argc, char *argv[]){

short i;

if(argc != 3){
     fprintf(stderr," Incorrect syntax:  eegtoasc <input file> <output>\n");
     exit(1);
}

fp = fopen(argv[1], "rb");
fp2 = fopen(argv[2], "w");
fread(&erp,sizeof(SETUP), 1, fp);
for (i=0; i<erp.nchannels; i++){
     channel[i] = (ELECTLOC*)malloc(sizeof(ELECTLOC));
     fread(channel[i],sizeof(ELECTLOC),1,fp);
}
for (i=1; i<= erp.compsweeps; i++){
     fread(&sweephead,sizeof(SWEEP_HEAD),1,fp);
     for(j=1; j<=erp.pnts; j++){
	  for(k=1; k<=erp.nchannels; k++){
	       fread(&data[j][k],2,1,fp);
	  }
     }
     for(k=1; k<=erp.nchannels; k++){
	  fprintf(fp2,"%6d%6d%6d\n",i,sweephead.ttype,k);
	  for(j=1; j<=erp.pnts; j++){
	       fprintf(fp2,"%6d",data[j][k]);
	       if(j%10==0)fprintf(fp2,"\n");
	  }
	  if((j-1)%10!=0)fprintf(fp2,"\n");
     }
}
fclose(fp);
fclose(fp2);
}
