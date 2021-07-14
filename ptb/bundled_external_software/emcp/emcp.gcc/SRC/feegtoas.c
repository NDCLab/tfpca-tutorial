#include <stdio.h>
#include <stdlib.h>
#define N_ELECT 64
#include "sethead.h"

/* special test version - for neuroscan files in Float format */


ELECTLOC	*channel[N_ELECT];
SETUP		erp;
FILE		*fp, *fp2;
float data[1000][20];
short i, j, k;
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
short cnt;

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
	       fread(&data[j][k],sizeof(float),1,fp);
	  }
     }
     for(k=1; k<=erp.nchannels; k++){
	  fprintf(fp2,"%9.3f%9.3f%9.3f",(float) i,(float) sweephead.ttype, (float) k);
	  cnt=3;
	  for(j=1; j<=erp.pnts; j++){
	       fprintf(fp2,"%9.3f", data[j][k]);
	       cnt++;
	       if(cnt%10==0)fprintf(fp2,"\n");
	  }
	  if(cnt%10!=0)fprintf(fp2,"\n");
     }
}
fclose(fp);
fclose(fp2);
}
