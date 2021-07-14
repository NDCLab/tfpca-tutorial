/*
 *      modified slightly by Bill Gehring
 *      - TEEG-related code commented out
 *      - C++ style comments changed to C format
 *
 */
/******* OLD HEADERS ! ****/

/*
 * These can all be false, on AIX, for instance...
 */
#ifdef __BORLANDC__
#define TURBO_C 1
#else
#define TURBO_C 0
#endif

#ifdef _MSC_VER
#define MS_C 1
#else
#define MS_C 0
#endif

#ifdef __GNUC__
#define GNU_C 1
#else
#define GNU_C 0
#endif

#if defined(_AIX) && !__GNUC__
#define AIX_C 1
#else
#define AIX_C 0
#endif

#if !(TURBO_C || MS_C || AIX_C)
#ifndef BYTE
	#define BYTE char
#endif
#ifndef UBYTE
	#define UBYTE unsigned char
#endif 
#ifndef WORD
	#define WORD short
#endif
#ifndef UWORD
	#define UWORD unsigned short
#endif
#else
/* Borland or MS C++ */
#ifndef BYTE
	#define BYTE signed int
#endif
#ifndef UBYTE
	#define UBYTE unsigned int
#endif 
#ifndef WORD
	#define WORD signed int
#endif
#ifndef UWORD
	#define UWORD unsigned int
#endif
#endif

#if !GNU_C
/* Make this a do-nothing macro... */
#define __attribute__(x) /* x */
#endif

/*** STRUCTURE FOR ELECTRODE TABLE ***/ 
typedef struct {
	char lab[10] __attribute__ ((packed));
	float x_coord __attribute__ ((packed));
	float y_coord __attribute__ ((packed));
	float alpha_wt __attribute__ ((packed));
	float beta_wt __attribute__ ((packed));
}OLDELECTLOC;

/*** OLD STRUCTURE FOR ERP HEADER ***/ 
typedef struct{ 
	char   type __attribute__ ((packed));
	char   id[20] __attribute__ ((packed));
	char   oper[20] __attribute__ ((packed));
	char   doctor[20] __attribute__ ((packed));
	char   referral[20] __attribute__ ((packed));
	char   hospital[20] __attribute__ ((packed)); 
	char   patient[20] __attribute__ ((packed)); 
	short int    age __attribute__ ((packed));
	char   sex __attribute__ ((packed));
	char   hand __attribute__ ((packed));
	char   med[20] __attribute__ ((packed));
	char   class[20] __attribute__ ((packed));
	char   state[20] __attribute__ ((packed)); 
	char   label[20] __attribute__ ((packed));
	char   date[10] __attribute__ ((packed));
	char   time[12] __attribute__ ((packed));
	char   avgmode __attribute__ ((packed));
	char   review __attribute__ ((packed)); 
	short unsigned    nsweeps __attribute__ ((packed));
	short unsigned    compsweeps __attribute__ ((packed));
	short unsigned    pnts __attribute__ ((packed));
	short int    nchannels __attribute__ ((packed));
	short int    update __attribute__ ((packed));
	char   domain __attribute__ ((packed));
	unsigned short int    rate __attribute__ ((packed));
	double scale __attribute__ ((packed));
	char   veegcorrect __attribute__ ((packed));
	float  veogtrig __attribute__ ((packed));
	short int    veogchnl __attribute__ ((packed));
	float  heogtrig __attribute__ ((packed)); 
	short int    heogchnl __attribute__ ((packed)); 
	char   baseline __attribute__ ((packed));
	float  offstart __attribute__ ((packed));
	float  offstop __attribute__ ((packed));
	char   reject __attribute__ ((packed));
	char   rejchnl1 __attribute__ ((packed));
	char   rejchnl2 __attribute__ ((packed));
	char   rejchnl3 __attribute__ ((packed));
	char   rejchnl4 __attribute__ ((packed));
	float  rejstart __attribute__ ((packed));
	float  rejstop __attribute__ ((packed));
	float  rejmin __attribute__ ((packed));
	float  rejmax __attribute__ ((packed));
	char   trigtype __attribute__ ((packed));
	float  trigval __attribute__ ((packed));
	char   trigchnl __attribute__ ((packed));
	float  trigisi __attribute__ ((packed));
	float  trigmin __attribute__ ((packed));
	float  trigmax __attribute__ ((packed));
	float  trigdur __attribute__ ((packed));
	char   dir __attribute__ ((packed));
	float  dispmin __attribute__ ((packed));
	float  dispmax __attribute__ ((packed));
	float  xmin __attribute__ ((packed));
	float  xmax __attribute__ ((packed));
	float  ymin __attribute__ ((packed));
	float  ymax __attribute__ ((packed));
	float  zmin __attribute__ ((packed));
	float  zmax __attribute__ ((packed));
	float  lowcut __attribute__ ((packed));
	float  highcut __attribute__ ((packed));
	char   common __attribute__ ((packed));
	char   savemode __attribute__ ((packed));
	char   manmode __attribute__ ((packed));
	char   ref[20] __attribute__ ((packed));
	char   screen[80] __attribute__ ((packed));
	char   seqfile[80] __attribute__ ((packed));
	char   montage[80] __attribute__ ((packed));
	char   heegcorrect __attribute__ ((packed));
	char   variance __attribute__ ((packed));
	short int    acceptcnt __attribute__ ((packed));
	short int    rejectcnt __attribute__ ((packed));
	char   reserved[74] __attribute__ ((packed));
	OLDELECTLOC elect_tab[64] __attribute__ ((packed)); 
}OLDSETUP;

/*** CURRENT VERSION 3.0 STRUCTURE FOR ELECTRODE TABLE ***/ 

typedef struct {                /* Electrode structure  ------------------- */
	char  lab[10] __attribute__ ((packed));          /* Electrode label - last bye contains NULL */
	char  reference __attribute__ ((packed));        /* Reference electrode number               */
	char  skip __attribute__ ((packed));             /* Skip electrode flag ON=1 OFF=0           */
	char  reject __attribute__ ((packed));           /* Artifact reject flag                     */
	char  display __attribute__ ((packed));          /* Display flag for 'STACK' display         */
	char  bad __attribute__ ((packed));              /* Bad electrode flag                       */
	unsigned short int n __attribute__ ((packed));   /* Number of observations                   */
	char  avg_reference __attribute__ ((packed));    /* Average reference status                 */
	char  ClipAdd __attribute__ ((packed));          /* Automatically add to clipboard           */
	float x_coord __attribute__ ((packed));          /* X screen coord. for 'TOP' display        */
	float y_coord __attribute__ ((packed));          /* Y screen coord. for 'TOP' display        */
	float veog_wt __attribute__ ((packed));          /* VEOG correction weight                   */
	float veog_std __attribute__ ((packed));         /* VEOG std dev. for weight                 */
	float snr __attribute__ ((packed));              /* signal-to-noise statistic                */
	float heog_wt __attribute__ ((packed));          /* HEOG Correction weight                   */
	float heog_std __attribute__ ((packed));         /* HEOG Std dev. for weight                 */
	short int baseline __attribute__ ((packed));     /* Baseline correction value in raw ad units*/
	char  Filtered __attribute__ ((packed));         /* Toggel indicating file has be filtered   */
	char  Fsp __attribute__ ((packed));              /* Extra data                               */
	float aux1_wt __attribute__ ((packed));          /* AUX1 Correction weight                   */ 
	float aux1_std __attribute__ ((packed));         /* AUX1 Std dev. for weight                 */
	float sensitivity __attribute__ ((packed));      /* electrode sensitivity                    */
	char  Gain __attribute__ ((packed));             /* Amplifier gain                           */
	char  HiPass __attribute__ ((packed));           /* Hi Pass value                            */
	char  LoPass __attribute__ ((packed));           /* Lo Pass value                            */
	unsigned char Page __attribute__ ((packed));     /* Display page                             */
	unsigned char Size __attribute__ ((packed));     /* Electrode window display size            */
	unsigned char Impedance __attribute__ ((packed));/* Impedance test                           */
	unsigned char PhysicalChnl __attribute__ ((packed)); /* Physical channel used                */
	char  Rectify __attribute__ ((packed));           /* Free space                              */
	float calib __attribute__ ((packed));            /* Calibration factor                       */
}ELECTLOC;

/*** STRUCTURE FOR ERP HEADER ***/ 
typedef struct{ 
	char   rev[20] __attribute__ ((packed));         /* Revision string                         */
	char   type __attribute__ ((packed));            /* File type AVG=1, EEG=0                  */
	char   id[20] __attribute__ ((packed));          /* Patient ID                              */
	char   oper[20] __attribute__ ((packed));        /* Operator ID                             */
	char   doctor[20] __attribute__ ((packed));      /* Doctor ID                               */
	char   referral[20] __attribute__ ((packed));    /* Referral ID                             */
	char   hospital[20] __attribute__ ((packed));    /* Hospital ID                             */
	char   patient[20] __attribute__ ((packed));     /* Patient name                            */
	short  int age __attribute__ ((packed));         /* Patient Age                             */
	char   sex __attribute__ ((packed));             /* Patient Sex Male='M', Female='F'        */
	char   hand __attribute__ ((packed));            /* Handedness Mixed='M',Rt='R', lft='L'    */
	char   med[20] __attribute__ ((packed));         /* Medications                             */
	char   class[20] __attribute__ ((packed));       /* Classification                          */
	char   state[20] __attribute__ ((packed));       /* Patient wakefulness                     */
	char   label[20] __attribute__ ((packed));       /* Session label                           */
	char   date[10] __attribute__ ((packed));        /* Session date string                     */
	char   time[12] __attribute__ ((packed));        /* Session time strin                      */
	float  mean_age __attribute__ ((packed));        /* Mean age (Group files only)             */
	float  stdev __attribute__ ((packed));           /* Std dev of age (Group files only)       */
	short int n __attribute__ ((packed));            /* Number in group file                    */
	char   compfile[38] __attribute__ ((packed));    /* Path and name of comparison file        */
	float  SpectWinComp __attribute__ ((packed));    /* Spectral window compensation factor     */
	float  MeanAccuracy __attribute__ ((packed));    /* Average respose accuracy                */
	float  MeanLatency __attribute__ ((packed));     /* Average response latency                */
	char   sortfile[46] __attribute__ ((packed));    /* Path and name of sort file              */
	int    NumEvents __attribute__ ((packed));       /* Number of events in eventable           */
	char   compoper __attribute__ ((packed));        /* Operation used in comparison            */
	char   avgmode __attribute__ ((packed));         /* Set during online averaging             */
	char   review __attribute__ ((packed));          /* Set during review of EEG data           */
	short unsigned nsweeps __attribute__ ((packed));      /* Number of expected sweeps          */
	short unsigned compsweeps __attribute__ ((packed));   /* Number of actual sweeps            */ 
	short unsigned acceptcnt __attribute__ ((packed));    /* Number of accepted sweeps          */
	short unsigned rejectcnt __attribute__ ((packed));    /* Number of rejected sweeps          */
	short unsigned pnts __attribute__ ((packed));         /* Number of points per waveform      */
	short unsigned nchannels __attribute__ ((packed));    /* Number of active channels          */
	short unsigned avgupdate __attribute__ ((packed));    /* Frequency of average update        */
	char  domain __attribute__ ((packed));           /* Acquisition domain TIME=0, FREQ=1       */
	char  variance __attribute__ ((packed));         /* Variance data included flag             */
	unsigned short rate __attribute__ ((packed));    /* D-to-A rate                             */
	double scale __attribute__ ((packed));           /* scale factor for calibration            */
	char  veogcorrect __attribute__ ((packed));      /* VEOG corrected flag                     */
	char  heogcorrect __attribute__ ((packed));      /* HEOG corrected flag                     */
	char  aux1correct __attribute__ ((packed));      /* AUX1 corrected flag                     */
	char  aux2correct __attribute__ ((packed));      /* AUX2 corrected flag                     */
	float veogtrig __attribute__ ((packed));         /* VEOG trigger percentage                 */
	float heogtrig __attribute__ ((packed));         /* HEOG trigger percentage                 */
	float aux1trig __attribute__ ((packed));         /* AUX1 trigger percentage                 */
	float aux2trig __attribute__ ((packed));         /* AUX2 trigger percentage                 */
	short int heogchnl __attribute__ ((packed));     /* HEOG channel number                     */
	short int veogchnl __attribute__ ((packed));     /* VEOG channel number                     */
	short int aux1chnl __attribute__ ((packed));     /* AUX1 channel number                     */
	short int aux2chnl __attribute__ ((packed));     /* AUX2 channel number                     */
	char  veogdir __attribute__ ((packed));          /* VEOG trigger direction flag             */
	char  heogdir __attribute__ ((packed));          /* HEOG trigger direction flag             */
	char  aux1dir __attribute__ ((packed));          /* AUX1 trigger direction flag             */ 
	char  aux2dir __attribute__ ((packed));          /* AUX2 trigger direction flag             */
	short int veog_n __attribute__ ((packed));       /* Number of points per VEOG waveform      */
	short int heog_n __attribute__ ((packed));       /* Number of points per HEOG waveform      */
	short int aux1_n __attribute__ ((packed));       /* Number of points per AUX1 waveform      */
	short int aux2_n __attribute__ ((packed));       /* Number of points per AUX2 waveform      */
	short int veogmaxcnt __attribute__ ((packed));   /* Number of observations per point - VEOG */
	short int heogmaxcnt __attribute__ ((packed));   /* Number of observations per point - HEOG */
	short int aux1maxcnt __attribute__ ((packed));   /* Number of observations per point - AUX1 */
	short int aux2maxcnt __attribute__ ((packed));   /* Number of observations per point - AUX2 */
	char   veogmethod __attribute__ ((packed));      /* Method used to correct VEOG             */
	char   heogmethod __attribute__ ((packed));      /* Method used to correct HEOG             */
	char   aux1method __attribute__ ((packed));      /* Method used to correct AUX1             */
	char   aux2method __attribute__ ((packed));      /* Method used to correct AUX2             */
	float  AmpSensitivity __attribute__ ((packed));  /* External Amplifier gain                 */
	char   LowPass __attribute__ ((packed));         /* Toggle for Amp Low pass filter          */
	char   HighPass __attribute__ ((packed));        /* Toggle for Amp High pass filter         */
	char   Notch __attribute__ ((packed));           /* Toggle for Amp Notch state              */
	char   AutoClipAdd __attribute__ ((packed));     /* AutoAdd on clip                         */
	char   baseline __attribute__ ((packed));        /* Baseline correct flag                   */
	float  offstart __attribute__ ((packed));        /* Start point for baseline correction     */
	float  offstop __attribute__ ((packed));         /* Stop point for baseline correction      */
	char   reject __attribute__ ((packed));          /* Auto reject flag                        */
	float  rejstart __attribute__ ((packed));        /* Auto reject start point                 */
	float  rejstop __attribute__ ((packed));         /* Auto reject stop point                  */
	float  rejmin __attribute__ ((packed));          /* Auto reject minimum value               */
	float  rejmax __attribute__ ((packed));          /* Auto reject maximum value               */
	char   trigtype __attribute__ ((packed));        /* Trigger type                            */
	float  trigval __attribute__ ((packed));         /* Trigger value                           */
	char   trigchnl __attribute__ ((packed));        /* Trigger channel                         */
	short int trigmask __attribute__ ((packed));     /* Wait value for LPT port                 */
	float trigisi __attribute__ ((packed));          /* Interstimulus interval (INT trigger)    */
	float trigmin __attribute__ ((packed));          /* Min trigger out voltage (start of pulse)*/
	float trigmax __attribute__ ((packed));          /* Max trigger out voltage (during pulse)  */
	char  trigdir __attribute__ ((packed));          /* Duration of trigger out pulse           */
	char  Autoscale __attribute__ ((packed));        /* Autoscale on average                    */
	short int n2 __attribute__ ((packed));           /* Number in group 2 (MANOVA)              */
	char  dir __attribute__ ((packed));              /* Negative display up or down             */
	float dispmin __attribute__ ((packed));          /* Display minimum (Yaxis)                 */
	float dispmax __attribute__ ((packed));          /* Display maximum (Yaxis)                 */
	float xmin __attribute__ ((packed));             /* X axis minimum (epoch start in sec)     */
	float xmax __attribute__ ((packed));             /* X axis maximum (epoch stop in sec)      */
	float AutoMin __attribute__ ((packed));          /* Autoscale minimum                       */
	float AutoMax __attribute__ ((packed));          /* Autoscale maximum                       */
	float zmin __attribute__ ((packed));             /* Z axis minimum - Not currently used     */
	float zmax __attribute__ ((packed));             /* Z axis maximum - Not currently used     */
	float lowcut __attribute__ ((packed));           /* Archival value - low cut on external amp*/ 
	float highcut __attribute__ ((packed));          /* Archival value - Hi cut on external amp */ 
	char  common __attribute__ ((packed));           /* Common mode rejection flag              */
	char  savemode __attribute__ ((packed));         /* Save mode EEG AVG or BOTH               */
	char  manmode __attribute__ ((packed));          /* Manual rejection of incomming data      */
	char  ref[10] __attribute__ ((packed));          /* Label for reference electode            */
	char  Rectify __attribute__ ((packed));          /* Rectification on external channel       */
	float DisplayXmin __attribute__ ((packed));      /* Minimun for X-axis display              */
	float DisplayXmax __attribute__ ((packed));      /* Maximum for X-axis display              */
	char  phase __attribute__ ((packed));            /* flag for phase computation              */
	char  screen[16] __attribute__ ((packed));       /* Screen overlay path name                */
	short int CalMode __attribute__ ((packed));      /* Calibration mode                        */
	short int CalMethod __attribute__ ((packed));    /* Calibration method                      */
	short int CalUpdate __attribute__ ((packed));    /* Calibration update rate                 */
	short int CalBaseline __attribute__ ((packed));  /* Baseline correction during cal          */
	short int CalSweeps __attribute__ ((packed));    /* Number of calibration sweeps            */
	float Calattenuator __attribute__ ((packed));    /* attenuator value for calibration        */
	float CalPulseVolt __attribute__ ((packed));     /* Voltage for calibration pulse           */
	float CalPulseStart __attribute__ ((packed));    /* Start time for pulse                    */
	float CalPulseStop __attribute__ ((packed));     /* Stop time for pulse                     */  
	float CalFreq __attribute__ ((packed));          /* Sweep frequency                         */  
	char  taskfile[34] __attribute__ ((packed));     /* Task file name                          */
	char  seqfile[34] __attribute__ ((packed));      /* Sequence file path name                 */
	char  SpectMethod __attribute__ ((packed));      /* Spectral method                         */
	char  SpectScaling __attribute__ ((packed));     /* Scaling employed                       */
	char  SpectWindow __attribute__ ((packed));      /* Window employed                        */
	float SpectWinLength __attribute__ ((packed));   /* Length of window %                     */
	char  SpectOrder __attribute__ ((packed));       /* Order of Filter for Max Entropy method  */
	char  NotchFilter __attribute__ ((packed));      /* Notch Filter in or out                 */
	short HeadGain __attribute__ ((packed));         /* Current head gain for SYNAMP                   */
	char  unused[9] __attribute__ ((packed));        /* Free space                             */
	short  FspStopMethod __attribute__ ((packed));   /* FSP - Stoping mode                      */
	short  FspStopMode __attribute__ ((packed));     /* FSP - Stoping mode                      */
	float FspFValue __attribute__ ((packed));        /* FSP - F value to stop terminate         */
	short int FspPoint __attribute__ ((packed));     /* FSP - Single point location             */
	short int FspBlockSize __attribute__ ((packed)); /* FSP - block size for averaging          */
	unsigned short FspP1 __attribute__ ((packed));   /* FSP - Start of window                   */
	unsigned short FspP2 __attribute__ ((packed));   /* FSP - Stop  of window                   */
	float FspAlpha __attribute__ ((packed));         /* FSP - Alpha value                       */
	float FspNoise __attribute__ ((packed));         /* FSP - Signal to ratio value             */
	short int FspV1 __attribute__ ((packed));        /* FSP - degrees of freedom                */   
	char  montage[40] __attribute__ ((packed));      /* Montage file path name                  */   
	char  EventFile[40] __attribute__ ((packed));    /* Event file path name                    */   
	float fratio __attribute__ ((packed));           /* Correction factor for spectral array    */
	char  minor_rev __attribute__ ((packed));        /* Current minor revision                  */
	short int eegupdate __attribute__ ((packed));    /* How often incomming eeg is refreshed    */ 
	char   compressed __attribute__ ((packed));      /* Data compression flag                   */
	float  xscale __attribute__ ((packed));          /* X position for scale box - Not used     */
	float  yscale __attribute__ ((packed));          /* Y position for scale box - Not used     */
	float  xsize __attribute__ ((packed));           /* Waveform size X direction               */
	float  ysize __attribute__ ((packed));           /* Waveform size Y direction               */
	char   ACmode __attribute__ ((packed));          /* Set SYNAP into AC mode                  */
	unsigned char   CommonChnl __attribute__ ((packed));      /* Channel for common waveform    */
	char   Xtics __attribute__ ((packed));           /* Scale tool- 'tic' flag in X direction   */ 
	char   Xrange __attribute__ ((packed));          /* Scale tool- range (ms,sec,Hz) flag X dir*/ 
	char   Ytics __attribute__ ((packed));           /* Scale tool- 'tic' flag in Y direction   */ 
	char   Yrange __attribute__ ((packed));          /* Scale tool- range (uV, V) flag Y dir    */ 
	float  XScaleValue __attribute__ ((packed));     /* Scale tool- value for X dir             */
	float  XScaleInterval __attribute__ ((packed));  /* Scale tool- interval between tics X dir */
	float  YScaleValue __attribute__ ((packed));     /* Scale tool- value for Y dir             */
	float  YScaleInterval __attribute__ ((packed));  /* Scale tool- interval between tics Y dir */
	float  ScaleToolX1 __attribute__ ((packed));     /* Scale tool- upper left hand screen pos  */
	float  ScaleToolY1 __attribute__ ((packed));     /* Scale tool- upper left hand screen pos  */
	float  ScaleToolX2 __attribute__ ((packed));     /* Scale tool- lower right hand screen pos */
	float  ScaleToolY2 __attribute__ ((packed));     /* Scale tool- lower right hand screen pos */
	short int port __attribute__ ((packed));         /* Port address for external triggering    */
	long  NumSamples __attribute__ ((packed));       /* Number of samples in continous file     */
	char  FilterFlag __attribute__ ((packed));       /* Indicates that file has been filtered   */
	float LowCutoff __attribute__ ((packed));        /* Low frequency cutoff                    */
	short int LowPoles __attribute__ ((packed));     /* Number of poles                         */
	float HighCutoff __attribute__ ((packed));       /* High frequency cutoff                   */ 
	short int HighPoles __attribute__ ((packed));    /* High cutoff number of poles             */
	char  FilterType __attribute__ ((packed));       /* Bandpass=0 Notch=1 Highpass=2 Lowpass=3 */
	char  FilterDomain __attribute__ ((packed));     /* Frequency=0 Time=1                      */
	char  SnrFlag __attribute__ ((packed));          /* SNR computation flag                    */
	char  CoherenceFlag __attribute__ ((packed));    /* Coherence has been  computed            */
	char  ContinousType __attribute__ ((packed));    /* Method used to capture events in *.cnt  */ 
	long  EventTablePos __attribute__ ((packed));    /* Position of event table                 */ 
	float ContinousSeconds __attribute__ ((packed)); /* Number of seconds to displayed per page */
	long  ChannelOffset __attribute__ ((packed));    /* Block size of one channel in SYNAMPS  */
	char  AutoCorrectFlag __attribute__ ((packed));  /* Autocorrect of DC values */
	unsigned char DCThreshold __attribute__ ((packed)); /* Auto correct of DC level  */
/*         ELECTLOC elect_tab[N_ELECT] __attribute__ ((packed));*/
}SETUP;

/*
#define  TEEG_EVENT_TAB1 1          
#define  TEEG_EVENT_TAB2 2       

typedef unsigned char TEEG_TYPE __attribute__ ((packed));    

typedef struct{
	TEEG_TYPE Teeg __attribute__ ((packed));
	long Size __attribute__ ((packed));
	union {
	    void *Ptr __attribute__ ((packed));      
	    long Offset __attribute__ ((packed));    
	};
} TEEG;
*/

typedef struct{
	UWORD StimType __attribute__ ((packed));
	UBYTE KeyBoard __attribute__ ((packed)); 
	BYTE  KeyPad:4 __attribute__ ((packed)); 
	UBYTE Accept:4 __attribute__ ((packed)); 
	long Offset __attribute__ ((packed));
} EVENT1;





typedef struct{
	EVENT1  Event1 __attribute__ ((packed)); 
	WORD    Type __attribute__ ((packed));
	WORD    Code __attribute__ ((packed));       
	float   Latency __attribute__ ((packed));
	BYTE    EpochEvent __attribute__ ((packed));
	BYTE    Accept __attribute__ ((packed));
	BYTE    Accuracy __attribute__ ((packed));
} EVENT2;


			

#define ADINDEX(CHNL,PNT) ((float)(ad_buff[((CHNL)+(int)erp.nchannels*(PNT))]-erp.elect_tab[(CHNL)].baseline))

/* Conversion for microvolts without channel-specific calibration */
#define GETADVAL(CHNL,PNT) ((ADINDEX(CHNL,PNT)/204.8)*erp.elect_tab[CHNL].sensitivity)

/* Complete conversion to microvolts */
#define GETADuV(CHNL,PNT)  (GETADVAL(CHNL,PNT)*erp.elect_tab[(CHNL)].calib)


#define PUTADVAL(CHNL,PNT) ((elect[CHNL]->v[PNT]*204.8)/erp.elect_tab[CHNL].sensitivity)

/* Conversion for scaled ad value  with calibration */
#define GETADRAW(CHNL,PNT) ((ADINDEX(CHNL,PNT))*erp.elect_tab[(CHNL)].calib)

/* Conversion for scaled int value  with baseline but no calibration */
#define GETADINT(CHNL,PNT) ((ADINDEX(CHNL,PNT))/204.8)

#define GETVAL(CHNL,PNT) ((elect[CHNL]->v[PNT]/(float)erp.elect_tab[CHNL].n)*erp.elect_tab[CHNL].calib)

#define GETRVAL(CHNL,PNT) ((result[CHNL]->v[PNT]/(float)rslterp.elect_tab[CHNL].n)*rslterp.elect_tab[CHNL].calib)

#define GETCVAL(CHNL,PNT) ((compelect[CHNL]->v[PNT]/(float)comperp.elect_tab[CHNL].n)*comperp.elect_tab[CHNL].calib)

