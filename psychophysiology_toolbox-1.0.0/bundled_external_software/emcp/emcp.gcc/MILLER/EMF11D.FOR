	PROGRAM emf11d
C
C  Fortran IV for RT11XM or TSX --
C  	Compile via:  FORT/EXTEND/UNITS:8 EMF11D
C  	Link via:     LINK EMF11D,VIRP
C
C  Fortran 77 for RT11XM or TSX --
C	F77XM
C	*EMF11D=EMF11D/A/E/I/S:ALL/F:200./N:8.
C	^C
C	R LINK
C	*EMF11D=EMF11D,VIRTXM,F77OTS
C	^C
C
C  4/4/87  G. Miller
C	Created EMF11D from 11/9/86 version of EMF11C -- (a) customized for
C	experiment DT1; (b) have user specify more of filename template
C	(filenames no longer forced to "T1xnn"); & (c) changed a few variable
C	names back to more generic names used in EMF11B ('e' instead of 'f'
C	in, e.g., nexte1 & lune1), consistent with more general filenaming.
C	See EMF11C for lineage.
C
C  3/8/88  C. Yee
C	Changed coding of modality to handle semi-randomized presentation of
C	two-character stimuli.
C
C  3/6/89  G. Miller
C	Debugging.  Renamed 'check' to 'checkb' to allow use of 'check'
C	debugging subroutine (from Brian Foote; check for program corruption).
C	In CLEAR and VCLEAR calls, changed args to 'max???' to allow
C	successful use with smaller data set than dimensioned for.
C
C  3/15/89  C. Yee
C	Added tracking (via subroutine 'blklst') and printout of which trial
C	blocks contributed to each bin.
C
C  6/16/89  C. Yee
C	Added bins 19-23, allowing for auditory correct rejections (previous
C	versions varied in # bins; this appears to be the final structure).
C
C  7/9/89   G. Miller
C	Development/debugging under F77 (though should still be fully
C	compatible with Fortran IV compiler):
C	(a) Change in parend location in a FLOAT, required by F77 compiler.
C	(b) Found bug where subroutine 'blklst' can be called even though
C	'icl' (bin #) = 0; in 'blklst', array 'blocks' is written into using
C	subscript 'icl', so subcript could be out of bounds.  Fix is to move
C	call to 'blklst' to after 'GOTO 5100' skip-out if trial is to be
C	excluded.
C	(c) Found main bug, causing floating overflow problem -- the 'length'
C	arg passed to 'VCLEAR' needed to be larger than 32767, with the recent
C	increase in # bins.  The computation of 'length' produced a negative
C	value, causing the clearing of 'BS' and 'SS' not to occur.  Fix is to
C	change 'VCLEAR' to work on REAL*4 arrays instead of INTEGER*2, thus
C	cutting in half the number of logical "locations" needing to be
C	cleared and thus the value of 'length'.
C	(d) Found a tab in the .SPD spec file in a place F77 code didn't like
C	it; changed it to spaces.
C	Also:
C	- Changed all 'CL' usage to 'ICL' (bin #).
C	- Changed read of .SP? spec file from DK: to SPC:.
C	- Converted lower-case input for file "output code' to upper-case
C	  (Fortran IV did this automatically).
C	- Slightly generalized some things about how filenames are reported.
C	- Changed read of spec file so that all specs are read from the first
C	  10 columns of a line (previously, the two REAL*4 values were read
C	  F16.0; now, F10.0, consistent with the INTEGER*2 values at I10).
C	- Made variable 'blockn' INTEGER*2 instead of REAL*4.
C	- Initialized (to 0) array 'blocks' at program start.
C	- Minor changes to comments.
C
C  7/17/89  G. Miller
C	Added capability for user to specify a range of contiguous trials to
C	drop (7/15/89) and changed single-trial output format from formatted
C	back to unformatted direct-access.  Also entered, but commented out:
ccc	IF(D(NIDS-1,1).EQ.-1)  nout(nt)=3   !Marked rejected prior to this run
C	This is a way to make use of a given trial having already been marked
C	as "dropped" by a previous pass of EMF11D or by a previous program.
C	Setting nout(nt) to 3 means broadening the meaning of '3' from
C	'rejected by user' to 'rejected by user or previous software'.
C
C  8/14/89  G. Miller
C	Added explicit clearing of array 'binmem'.
C
C-----------------------------------------------------------------------------
C
C    Array sizes:  125, 6, 23, 20, 2100 = points, channels, bins, IDs, trials
C
	INTEGER*2	hem,outopt,eof,fchan
	INTEGER*2	countr(4),XX(125)
C
	REAL*4		XID(20),D(20,6)
	VIRTUAL		XIDS(20,6,23),X(125,6)
	REAL*4		XN(23),BASE(6,23)
	REAL*4		BSLN(6),	V(6)
	VIRTUAL		BN(125,23),	SN(125,23)
	REAL*4		BCORR(6),	SCORR(6),
     +			BCX(6),		SCX(6),
     +			BCXT(6),	SCXT(6),
     +			BCXAVG(6),	SCXAVG(6),
     +			BCXRES(6),	SCXRES(6),
     +			BRX(6),		SRX(6),
     +			BSD(6),		SSD(6),
     +			BSTOT(6),	SSTOT(6),
     +			BS2(6),		SS2(6),
     +			BS2AVG(6),	SS2AVG(6),
     +			BS2RES(6),	SS2RES(6),
     +			BVAR(6),	SVAR(6),
     +			BXM(6),		SXM(6)
C
	VIRTUAL		AVG(125,6,23),BS(125,6,23),SS(125,6,23)
	BYTE		nout,binmem
	VIRTUAL		nout(2100),binmem(2100)
	BYTE		daytim(18),file(16),spec(16)
C   
C  Arrays needed for SELECT/CHECKB subroutine communication
	INTEGER*2	ncrit(23)
	REAL*4		idlist(8,23),idvalu(8,23)
C
C  Needed for BLKLST subroutine
	INTEGER*2	blockn,blocks(5,23)		!([maxblk,maxbin])
C
C  General COMMONS (first character gives data type)
	COMMON  /FILES/	lunti, lunto, lunin, lune1, lune2, lune3, lune4,
     +				     nextin,nexte1,nexte2,nexte3
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /RPARAM/	adcrit,eogsen
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C
C    Max allowed parameter values, reflecting array dimensions
	DATA   maxpts /125/
	DATA   maxchn /6/
	DATA   maxbin /23/
	DATA   maxids /20/
	DATA   maxtrl /2100/
	DATA   maxblk /5/		!Max # block #s per bin in 'BLKLST'
	DATA   blocks /115*0/		![maxblk,maxbin]
C   
C    Use variables for file LUNs & for user terminal LUNs
	DATA   lunsp,lunin,lune1,lune2,lune3,lune4  /8,8,1,2,3,4/
	DATA   lunti,lunto  /5,7/
C
	DATA	spec			!Specification file
     +		 /'S','P','C',':','E','M','F','1','1','D','.','S','P',3*0/
	DATA	daytim	/18*' '/	!Run date & time array
C
C*******************************  SAY HELLO  *******************************
C
	CALL date(daytim(1))		!Get start date & time
	CALL time(daytim(11))
C
	WRITE(lunto,5000)  daytim		!Greeting
 5000	FORMAT(	 25X,'***  Program  EMF11D  ***'
     +	       	/25X,'Last update:      8/14/89'
     +	       	/25X,'Run:   ',18A1/
     +		/' DEC Fortran implementation of Gratton EMCP algorithm.'
     +		/' EMF11D set up for experiment DT1, processing 2100 trials.'
     +		/' Files assumed:'
     +		/10X,'SPC:EMF11D.SPs    Specifications (s = D, E, or F)'
     +		/10X,'INP:sszzzf.in     Input (M = midline; L = lateral)'
     +		/10X,'OUT:sszzzf.o1     Corrected averages'
     +		/10X,'OUT:sszzzf.o2     Uncorrected averages'
     +		/10X,'OUT:sszzzf.o3     Corrected single trials'
     +		/10X,'OUT:sszzzf.o4     Log file')
C
ccc	WRITE(lunto,50051)
ccc	READ(lunti,5005)  (file(i),i=5,6)		!Study code
ccc	IF(file(5).GT.96)  file(5)=file(5)-32		!Lower to upper case
ccc	IF(file(6).GT.96)  file(6)=file(6)-32		!Lower to upper case
C
	file(5)='D'					!Study code
	file(6)='2'
	WRITE(lunto,50052)
	READ(lunti,5005)  (file(i),i=7,9)		!Subject code
	WRITE(lunto,50054)
	READ(lunti,5005)   file(16)			!Hide it here for now
	IF(file(16).GT.96) file(16)=file(16)-32		!Lower to upper case
50052	FORMAT( '$Subject code    (nnn = 3A1)?           ')
50054	FORMAT( '$Output code     (D,E,F   = 1A1)?       ')
 5005	FORMAT(5A1)
C
	IF(file(16).EQ.'D')  file(10)='M'
	IF(file(16).EQ.'D')  file(12)='R'
	IF(file(16).EQ.'D')  file(13)='E'
	IF(file(16).EQ.'D')  spec(14)='D'
C
	IF(file(16).EQ.'E')  file(10)='L'
	IF(file(16).EQ.'E')  file(12)='R'
	IF(file(16).EQ.'E')  file(13)='E'
	IF(file(16).EQ.'E')  spec(14)='E'
C
	IF(file(16).EQ.'F')  file(10)='L'
	IF(file(16).EQ.'F')  file(12)='E'
	IF(file(16).EQ.'F')  file(13)='3'
	IF(file(16).EQ.'F')  spec(14)='F'
C
ccc	WRITE(lunto,50053)
ccc	READ(lunti,5005)  (file(i),i=12,13)		!Input extension
ccc 50051	FORMAT(/'$Study code      (ss  = 2A1)?           ')
ccc 50053	FORMAT( '$Input extension (in  = 2A1)?           ')
C
	DO 5006 nt=1,maxtrl		!Clear trial flags
	  binmem(nt)=0
 5006	  nout(nt)  =0
	WRITE(lunto,5007)
 5007	FORMAT(' Enter trial numbers to drop (0 to quit, <0 for range):')
C
 5008	WRITE(lunto,5009)
 5009	FORMAT('$  ? ')
	READ(lunti,5010)  nt
 5010	FORMAT(I6)
	IF(nt.EQ.0)  GOTO 5011		!Done with trial-drop-list entry
	IF(nt.GT.0)  nout(nt)=3		!Set 'drop' flag for this trial
	IF(nt.GT.0)  GOTO 5008		!Get next trial to drop
C
	  WRITE(lunto,50102)		!Drop a range of trials
50102	  FORMAT('$  First trial # in range? ')
	  READ(lunti,5010)  ntf
	  WRITE(lunto,50104)
50104	  FORMAT('$  Last  trial # in range? ')
	  READ(lunti,5010)  ntl
	  DO 50106 nt=ntf,ntl	!Set 'drop' flag for this range of trials
50106	    nout(nt)=3
	  GOTO 5008
C
C******************  READ SPEC FILE AND OPEN OTHER FILES  ******************
C
 5011	WRITE(lunto,5012)  (spec(i),i=1,14)
 5012	FORMAT(' Opening specification input file:',          T50,14A1)
	OPEN (UNIT=lunsp,NAME=spec,TYPE='OLD',READONLY,ERR=5900)
	READ(lunsp,300)   NPTS,NIDS,NCHAN,NCHAN1,hem,
     +			  msec,eogsen,outopt,IDALL,ADCRIT
300	FORMAT(I10/I10/I10/I10/I10/I10/F10.0/I10/I10/F10.0)
C
	CALL select(lunto,lunsp,nbin,ncrit,idlist,idvalu)
	CLOSE (UNIT=lunsp)
C
	ndwin   = (nids+npts)/2. + .5		!# double-words/input record
	ndwout  = ndwin				!  & per average output record
	CALL opnfil(file)			!Open most files
C
	WRITE(lune4,5000)  daytim
	WRITE(lune4,4444)  (file(i),i=1,13),(file(i),i=7,9),spec(14),
     +		nids,npts,nchan1,nchan,hem,msec,eogsen,outopt,idall,adcrit
4444	FORMAT(
     +	/' This listing is the job log file:  ',13A1,'  for subject  ',
     +     3A1,'  for run  ',A1/
     +	/' PARAMETERS FROM SPEC FILE',53('-')/
     +	/' # ID words:',                        T40,I10
     +	/' # A/D data points:',                 T40,I10
     +	/' # EEG channels:',                    T40,I10
     +	/' # total channels:',                  T40,I10
     +	/' HEM channel option:',                T40,I10
     +	/' # msec/sample (A/D sample period):', T40,I10
     +	/' EOG digitization sensitivity:',	T40,G10.3
     +  /' Single-trial output option:',        T40,I10
     +  /' Retain-IDs option:',                 T40,I10
     +	/' Edge-of-channel criterion:',         T40,G10.3/)
C
	IF(hem   .GE.0)    WRITE(lune4,5013)	!Log what we're up to
	IF(hem   .EQ.-1)   WRITE(lune4,5014)
	IF(hem   .EQ.0)    WRITE(lune4,5015)
	IF(hem   .EQ.1)    WRITE(lune4,5016)
	IF(hem   .EQ.2)    WRITE(lune4,5017)
C
	IF(eogsen.EQ.0.0)  WRITE(lune4,5018)  nids-1,nids
	IF(eogsen.LT.0.0)  WRITE(lune4,5019)  nids-1,nids
C
	IF(adcrit.EQ.0.0)  WRITE(lune4,4443)  NIDS-3
C
	IF(outopt.EQ.0)    WRITE(lune4,4445)  (file(i),i=5,12)
	IF(outopt.EQ.1)    WRITE(lune4,4446)  (file(i),i=5,12)
	IF(outopt.EQ.2)    WRITE(lune4,4447)  (file(i),i=5,12)
C
 5013	FORMAT(' HEM parameter:'
     +	     /'   VEM blink and saccade correction.')
 5014	FORMAT(' HEM parameter:'
     +	     /'   HEM saccade correction, not VEM blink+saccade correction.')
 5015	FORMAT('   No HEM channel included.')
 5016	FORMAT('   Exclude HEM (2nd channel) from flat-spot checking.')
 5017	FORMAT('   Exchange HEM (1st channel) & VEM (2nd) and'
     +	     /'   Exclude HEM from flat-spot checking.')
 5018	FORMAT(' EOGSEN parameter:'
     +	     /'   EOG sensitivity is REAL*4 value stored in ID',I3,' &',I3)
 5019	FORMAT(' EOGSEN parameter:'
     +	     /'   EOG sensitivity is reciprocal of REAL*4 value stored in',
     +	      ' IDs',I3,' &',I3)
4443 	FORMAT(' ADCRIT parameter:'
     +	     /'   Off-scale criterion obtained from curve''s ID',I3)
4445 	FORMAT(' OUTOPT parameter:'
     +	     /'   Selected single trials corrected & written to OUT:',8A1,'3')
4446 	FORMAT(' OUTOPT parameter:'
     +	     /'   No single trials written to OUT:',		      8A1,'3')
4447 	FORMAT(' OUTOPT parameter:'
     +	     /'   All trials corrected & written to OUT:',	      8A1,'3')
C
	NCHAN1=NCHAN1+1			!Add EOG channel to NCHAN1 temporarily
	fchan=2				!First channel in flat-spot checking
	IF(hem.GT.0)  fchan=3		!Exclude HEM channel
C   
C**************  FIRST PASS:  COMPUTE CORRECTIONS & AVERAGES  **************
C
C                                         Zero some arrays
	CALL  CLEAR(countr,4)
	CALL VCLEAR(XIDS,maxids*maxchn*maxbin)
	CALL  CLEAR(BASE,maxchn*maxbin*2)
	CALL  CLEAR(BS2,maxchn*2)
	CALL  CLEAR(BCX,maxchn*2)
	CALL VCLEAR(BN,maxpts*maxbin)
	CALL VCLEAR(BS,maxpts*maxchn*maxbin)
	CALL  CLEAR(SS2,maxchn*2)
	CALL  CLEAR(SCX,maxchn*2)
	CALL VCLEAR(SN,maxpts*maxbin)
	CALL VCLEAR(SS,maxpts*maxchn*maxbin)
C
	CALL date(daytim(1))		!Get current date & time
	CALL time(daytim(11))
	WRITE(lune4,5020)  daytim	!Report progress
	WRITE(lunto,5020)  daytim
	WRITE(lune4,5022)
 5020	FORMAT(/20X,'Begin first pass input at    ',18A1)
 5022	FORMAT(' READING TRIALS',64('-'))
C
	eof=0				!Reset end-of-file flag
	nextin=1			!Initialize input pointer
C
C------------------------------------------------------------------------
C
      DO 5100 nt=1,maxtrl		!Loop on trials
C
        CALL stin(nt,D,X)		!Read trial
C
        IF(eof.NE.0)     GOTO 5110	!Check for end-of-file
	WRITE(lunto,5715)  nt		!Report progress to user
C
ccc	IF(D(NIDS-1,1).EQ.-1)  nout(nt)=3   !Marked rejected prior to this run
	IF(nout(nt).EQ.3)  GOTO 5025	!Rejected by user?
        CALL badtrl(D,X)		!Off-scale, flat?
	nout(nt)=ibad			!Store decision
C
 5025   ibad=nout(nt)	!0=OK, 1=off-scale, 2=flat EEG, 3=dropped by user
        countr(ibad+1)=countr(ibad+1)+1
        IF(ibad.GT.0)  GOTO 5100	!Skip if trial rejected
C
        DO 5030 NI=1,NIDS		!Copy the (EOG) IDs in XID
 5030     XID(NI)=D(NI,1)
C
	CALL checkb(nbin,ncrit,idlist,idvalu,xid,icl) !Which bin?
C
	binmem(nt)=icl				      !Remember trial's bin #
C
        IF(ICL.EQ.0.AND.outopt.EQ.2)  ICL=maxbin      !Unselected in last bin
C
        IF(ICL.EQ.0.AND.outopt.NE.2)  GOTO 5100	!Branch if exclude trial
C
	blockn=xid(11)			!ID for block # of current trial
	CALL blklst(icl,maxbin,maxblk,blockn,blocks) !Store block # for bin
        CALL baseln(X,BSLN)		!Compute and subtract baseline
C
        DO 5040 nc=1,NCHAN		!Sum for bin-average baseline mean
 5040     BASE(nc,ICL)=BASE(nc,ICL)+BSLN(nc)
C
        IF(hem.EQ.-1)  GOTO 5045	!Branch if HEM correction
        CALL CLEAR(XX,maxpts)		!Clear blink marker buffer
	CALL blink(X,XX)		!Detect & mark blinks
	IF(iblink.NE.0)  nout(nt)=-1	!Store:  Blink detected on this trial
C
 5045   DO 5060 np=1,NPTS		!For each time point
          DO 5050 nc=1,NCHAN		!Copy current point's channels into V
 5050       V(nc)=X(np,nc)
	  IF(hem.EQ.-1)  GOTO 5060	!Branch if HEM correction
          IF(XX(np).EQ.1)  CALL XSUM(V,BS,BS2,BCX,BN,ICL,NCHAN,np)  !Blink?
 5060     IF(XX(np).EQ.0)  CALL XSUM(V,SS,SS2,SCX,SN,ICL,NCHAN,np)  !Saccade?
C
        DO 5080 nc=1,NCHAN		!Copy IDs into XIDS
          DO 5080 ni=1,NIDS
 5080       XIDS(ni,nc,ICL)=D(ni,nc)
C
 5100 CONTINUE				!End of loop on trials
C
C------------------------------------------------------------------------
C
 5110 itemp=countr(1)+countr(2)+countr(3)+countr(4)	!Jump here at EOF
      WRITE(lunto,5120)  itemp,countr,	!# of accepted and rejected trials
     +		IFIX(100.*(1.-FLOAT(countr(1))/FLOAT(itemp)))
      WRITE(lune4,5120)  itemp,countr,
     +		IFIX(100.*(1.-FLOAT(countr(1))/FLOAT(itemp)))
 5120 FORMAT(/' # trials read             : ',I6
     +	     /' # trials accepted         : ',I6
     +       /' # trials off-scale        : ',I6
     +       /' # trials with flat EEG    : ',I6
     +	     /' # trials dropped by user  : ',I6
     +	     /' Total % rejected          : ',I6)
C
	CALL outlst(nout)		!List rejected & blink trials
C
C**********************  FIRST PASS:  COMPUTATIONS  **********************
C
      BNTOT=0.				!Zero total counters
      SNTOT=0.
C
      CALL  CLEAR(BSTOT,maxchn*2)	!Zero total average buffers
      CALL  CLEAR(SSTOT,maxchn*2)
C                                         for each bin
      DO 5200 nb=1,maxbin
        DO 5200 np=1,NPTS
C
          IF(BN(np,nb).LE.0.) GOTO 5150	!For blinks
            BNTOT=BNTOT+BN(np,nb)	!Sum for total counter
            DO 5140 nc=1,NCHAN1		!Sum for total averages
 5140         BSTOT(nc)=BSTOT(nc)+BS(np,nc,nb)
C                                         for saccades
 5150     IF(SN(np,nb).LE.0.) GOTO 5200	!For blinks
            SNTOT=SNTOT+SN(np,nb)	!Sum for total counter
            DO 5160 nc=1,NCHAN1		!Sum for total averages
 5160         SSTOT(nc)=SSTOT(nc)+SS(np,nc,nb)
 5200   CONTINUE
C                                         compute total averages
      DO 5220 nc=1,NCHAN1
        IF(BNTOT.GT.1.)  BSTOT(nc)=BSTOT(nc)/BNTOT	!Blinks
 5220   IF(SNTOT.GT.1.)  SSTOT(nc)=SSTOT(nc)/SNTOT	!Saccades
C
      TOT=SNTOT+BNTOT			!Total # points
      IF(TOT.GE.1.)  RATIOB=BNTOT/TOT	!Blink proportion
      IF(TOT.GE.1.)  RATIOS=SNTOT/TOT	!Saccade proportion
C
      WRITE(lune4,122)  SNTOT,RATIOS,BNTOT,RATIOB
122   FORMAT(/' SAMPLE SIZES FOR REGRESSION COMPUTATIONS',38('-')/
     +       /' Regression           # of Points     Proportion'/
     +       /' Saccades       ',F15.0,F15.5
     +       /' Blinks         ',F15.0,F15.5/)
C
      DO 5280 nb=1,maxbin		!For each bin
C
        XN(nb)=BN(1,nb)+SN(1,nb)	!Compute # of trials
	IF(xn(nb).EQ.0)  GOTO 5280	!Do nothing if bin empty
C
        DO 5240 nc=1,NCHAN		!For each channel
          DO 5240 np=1,NPTS		!For each time point
            AVG(np,nc,nb)=BS(np,nc,nb)+SS(np,nc,nb)	!Sum into avg buffer
            IF(XN(nb).GT.1.) AVG(np,nc,nb)=AVG(np,nc,nb)/XN(nb)	!Raw average
 5240	    CONTINUE
 5280   CONTINUE
C
      WRITE(lune4,5290)  (nb,XN(nb),(blocks(j,nb),j=1,maxblk),nb=1,maxbin)
 5290 FORMAT(' # trials selected for bin ',I2,':',F4.0,' from blocks',5I4)
C
C				Write raw (uncorrected) average on lune2
      nexte2=1				!Initialize output record pointer
      CALL avout(XIDS,XN,AVG,lune2,nexte2)	!Write uncorrected averages
C
C  Compute correction for computational formulae of total var & covar
C
      DO 5300 nc=1,NCHAN1
C                                         for blinks
        BVAR(nc)=BSTOT(nc)*BSTOT(nc)
        BCXT(nc)=BSTOT(nc)*BSTOT(1)
C                                         for saccades
        SVAR(nc)=SSTOT(nc)*SSTOT(nc)
 5300   SCXT(nc)=SSTOT(nc)*SSTOT(1)
C
C  Compute total variance & covariance
C
      DO 5320 nc=1,NCHAN1
        IF(BNTOT.LE.0.)  GOTO 5310	!For blinks
          BS2(nc)=BS2(nc)/BNTOT-BVAR(nc)
          BCX(nc)=BCX(nc)/BNTOT-BCXT(nc)
 5310   IF(SNTOT.LE.0.)  GOTO 5320	!For saccades
          SS2(nc)=SS2(nc)/SNTOT-SVAR(nc)
          SCX(nc)=SCX(nc)/SNTOT-SCXT(nc)
 5320	CONTINUE
C
      CALL  CLEAR(BS2AVG,maxchn*2)	!Clear for blinks
      CALL  CLEAR(BCXAVG,maxchn*2)
      CALL  CLEAR(BXM,maxchn*2)
      CALL  CLEAR(SS2AVG,maxchn*2)	!Clear for saccades
      CALL  CLEAR(SCXAVG,maxchn*2)
      CALL  CLEAR(SXM,maxchn*2)
C                                         for each bin, for each point
      DO 5400 nb=1,maxbin
        DO 5400 np=1,NPTS
C
C  Compute adjustment of variance and covariance due to averages
C                                         for blinks
          IF(BN(np,nb).LE.0.)  GOTO 5350
C                                         for each channel
            DO 5340 nc=1,NCHAN1
C                                         compute temporary values
              BBS=AVG(np,nc,nb)*(2.*BS(np,nc,nb)-BN(np,nb)*AVG(np,nc,nb))
              BBX=AVG(np,nc,nb)*BS(np,1,nb)+
     +		AVG(np,1,nb)*BS(np,nc,nb)-BN(np,nb)*AVG(np,nc,nb)*AVG(np,1,nb)
C                                         sum in the adjustment buffers
              BXM(nc)=BXM(nc)+BN(np,nb)*AVG(np,nc,nb)
              BS2AVG(nc)=BS2AVG(nc)+BBS
 5340         BCXAVG(nc)=BCXAVG(nc)+BBX
C                                         for saccades
 5350     IF(SN(np,nb).LE.0.)  GOTO 5400
C                                         for each channel
            DO 5360 nc=1,NCHAN1
C                                         compute temporary values
              SSS=AVG(np,nc,nb)*(2.*SS(np,nc,nb)-SN(np,nb)*AVG(np,nc,nb))
              SSX=AVG(np,nc,nb)*SS(np,1,nb)+
     +		AVG(np,1,nb)*SS(np,nc,nb)-SN(np,nb)*AVG(np,nc,nb)*AVG(np,1,nb)
C                                         sum in the adjustment buffers
              SXM(nc)=SXM(nc)+SN(np,nb)*AVG(np,nc,nb)
              SS2AVG(nc)=SS2AVG(nc)+SSS
 5360         SCXAVG(nc)=SCXAVG(nc)+SSX
 5400     CONTINUE
C                                         compute covariance with total mean
      DO 5420 nc=1,NCHAN1
C                                         of the mean of blink points
        IF(BNTOT.GT.1.)  BXM(nc)=BXM(nc)/BNTOT
C                                         of the mean of saccade points
 5420   IF(SNTOT.GT.1.)  SXM(nc)=SXM(nc)/SNTOT
C                                         compute actual adjustment values of
C                                         the variance and covariance
C                                         due to the averages
      DO 5440 nc=1,NCHAN1
        IF(BNTOT.LE.0.)  GOTO 5430	!For blinks
          BS2AVG(nc)=BS2AVG(nc)/BNTOT-BXM(nc)*(2.*BSTOT(nc)-BXM(nc))
          BCXAVG(nc)=BCXAVG(nc)/BNTOT+
     +        BXM(nc)*BXM(1)-BXM(nc)*BSTOT(1)-BXM(1)*BSTOT(nc)
 5430   IF(SNTOT.LE.0.)  GOTO 5450	!For saccades
          SS2AVG(nc)=SS2AVG(nc)/SNTOT-SXM(nc)*(2.*SSTOT(nc)-SXM(nc))
          SCXAVG(nc)=SCXAVG(nc)/SNTOT+
     +        SXM(nc)*SXM(1)-SXM(nc)*SSTOT(1)-SXM(1)*SSTOT(nc)
 5440   CONTINUE
C
 5450 DO 5460 nc=1,NCHAN1	!Compute residual variance & covariance
        BS2RES(nc)=BS2(nc)-BS2AVG(nc)		!For blinks
        BCXRES(nc)=BCX(nc)-BCXAVG(nc)
        IF(BS2RES(nc).LT.0.)  BS2RES(nc)=0.	!Compute residual SDs
	BSD(nc)=SQRT(BS2RES(nc))
 5455   SS2RES(nc)=SS2(nc)-SS2AVG(nc)		!For saccades
        SCXRES(nc)=SCX(nc)-SCXAVG(nc)
        IF(SS2RES(nc).LT.0.)  SS2RES(nc)=0.	!Compute residuals SDs
 5460	SSD(nc)=SQRT(SS2RES(nc))
C                                         zero correlation buffers
      CALL  CLEAR(BRX,maxchn*2)
      CALL  CLEAR(SRX,maxchn*2)
C                                         compute correlations with EOG
      DO 5480 nc=1,NCHAN1
	IF(hem.EQ.-1)  GOTO 5480	!Branch if HEM correction
        IF(BSD(1).NE.0.AND.BSD(nc).NE.0)  BRX(nc)=BCXRES(nc)/(BSD(nc)*BSD(1))
 5480   IF(SSD(1).NE.0.AND.SSD(nc).NE.0)  SRX(nc)=SCXRES(nc)/(SSD(nc)*SSD(1))
C                                         write variance-covariance tables
cccc	WRITE(lune4,121)			!Total
cccc	CALL table(lune4,NCHAN1,BS2,BCX,SS2,SCX)
C
cccc	WRITE(lune4,132)			!Adjustment
cccc	CALL table(lune4,NCHAN1,BS2AVG,BCXAVG,SS2AVG,SCXAVG)
C
cccc	WRITE(lune4,123)			!Residual
cccc	CALL table(lune4,NCHAN1,BS2RES,BCXRES,SS2RES,SCXRES)
C
c121   FORMAT(/' TOTAL VARIANCE-COVARIANCE TABLE',46('-'))
c132   FORMAT(/' ADJUSTMENTS TO VAR-COVAR TABLE',
c     +    ' DUE TO SUBTRACTION OF AVERAGE',      18('-'))
c123   FORMAT(/' RESIDUAL VAR-COVAR TABLE',       52('-'))
C                                         compute correction factors
      IF(hem.EQ.-1)  GOTO 5520		!Branch if HEM correction
      WRITE(lune4,128)			!For blinks
128   FORMAT(/' CORRECTION FACTORS FOR BLINKS',  47('-')/)
      CALL corfac(lune4,NCHAN1,BRX,BSD,bcorr)
 5520 WRITE(lune4,129)			!For saccades
129   FORMAT(/' CORRECTION FACTORS FOR SACCADES',45('-')/)
      CALL corfac(lune4,NCHAN1,SRX,SSD,scorr)
C
      DO 5540 nb=1,maxbin		!Compute mean baseline
        DO 5540 nc=1,NCHAN
 5540     IF(XN(nb).GT.1.)  BASE(nc,nb)=BASE(nc,nb)/XN(nb)
C
C********************  FIRST PASS:  CORRECT AVERAGES  ********************
C
	CALL date(daytim(1))		!Get current date & time
	CALL time(daytim(11))
	WRITE(lune4,5600)  daytim	!Report progress
	WRITE(lunto,5600)  daytim
 5600	FORMAT(/20X,'Begin average correction at  ',18A1)
C                                         for each bin
      DO 5700 nb=1,maxbin
C                                         if no trial, skip
        IF(XN(nb).LE.0.)  GOTO 5700
C                                         for each time point
        DO 5680 np=1,NPTS
C                                         zero temporary variables
          BVEOG=0.
          SVEOG=0.
          BW=0.
          SW=0.
C                                         for blinks
          IF(BN(np,nb).LE.0.)  GOTO 5630
C                                         compute average
          DO 5620 nc=1,NCHAN
 5620       BS(np,nc,nb)=BS(np,nc,nb)/BN(np,nb)
C                                         compute deviation of EOG
          BVEOG=BS(np,1,nb)-BSTOT(1)
C                                         compute weight of blinks
          BW=BN(np,nb)/XN(nb)
C                                         for saccades
 5630	  IF(SN(np,nb).LE.0.)  GOTO 5650
C                                         compute average
          DO 5640 nc=1,NCHAN
 5640       SS(np,nc,nb)=SS(np,nc,nb)/SN(np,nb)
C                                         compute deviation of EOG
          SVEOG=SS(np,1,nb)-SSTOT(1)
C                                         compute weight of saccades
          SW=SN(np,nb)/XN(nb)
C                                         for each channel
 5650     DO 5660 nc=1,NCHAN1
C  avgadj=
C	  blink weight     (proportion of trials for bin called 'blink')
C	* blink correction factor   (blink beta predicting EEG from EOG)
C	* blink movement   (for this point & bin)
C	+
C	  saccade weight   (proportion of trials for bin called 'saccade')
C	* saccade correction factor (saccade beta predicting EEG from EOG)
C	* saccade movement (for this point & bin)
C                                         compute eye-movement effect
            avgadj=(BW*BCORR(nc)*BVEOG+SW*SCORR(nc)*SVEOG)
C                                         adjust the average
 5660       AVG(np,nc,nb)=AVG(np,nc,nb)-avgadj-BW*BSTOT(nc)-SW*SSTOT(nc)
C                                         sum the mean baseline
	  DO 5670 nc=2,NCHAN
 5670       AVG(np,nc,nb)=AVG(np,nc,nb)+BASE(nc,nb)
C
 5680	  CONTINUE			!End of loop on points
 5700	CONTINUE			!End of loop on bins
C                                         write corrected averages
	nexte1=1			!Initialize output record pointer
	CALL avout(XIDS,XN,AVG,lune1,nexte1)	!Write corrected averages
	CLOSE (UNIT=lune1)		!Close average output files
	CLOSE (UNIT=lune2)
C
C************* SECOND PASS:  CORRECT AND OUTPUT SINGLE TRIALS  *************
C
        IF(outopt.NE.0.AND.outopt.NE.2) GOTO 5850 !Branch if no single trials
C
	file(13)='3'  				!'o3' corrected single trials
	WRITE(lunto,5710)  (file(i),i=1,13)
 5710	FORMAT(/' Opening corrected single-trial output file:',T50,13A1/)
	OPEN  (UNIT=lune3,              NAME=file,          TYPE='NEW',
     +	      ACCESS='DIRECT',          FORM='UNFORMATTED', BUFFERCOUNT=2,
     +	      RECORDSIZE=ndwout,        MAXREC=maxtrl*(nchan-1),
     +	      ASSOCIATEVARIABLE=nexte3, ERR=5920)
ccc     +		BUFFERCOUNT=2,INITIALSIZE=12000,ERR=5920)
C   
	CALL date(daytim(1))		!Get current date & time
	CALL time(daytim(11))
	WRITE(lune4,5712)  daytim	!Report progress
	WRITE(lunto,5712)  daytim
 5712	FORMAT( 20X,'Begin second pass input at   ',18A1)
C
	eof=0				!Clear end-of-file flag
	nextin=1			!Reset input record pointer
	nexte3=1			!Initialize output record pointer
C
C------------------------------------------------------------------------
      DO 5800 nt=1,maxtrl		!Second pass:  loop on trial
C
        CALL stin(nt,D,X)		!Read trial
C
	icl=binmem(nt)			!Recall bin # for trial
	DO 5714 nc=2,NCHAN		!Store it in ID
 5714	  D(NIDS-3,nc)=ICL
C
        IF(eof.NE.0)       GOTO 5850	!Branch if done with single trials
	WRITE(lunto,5715)  nt		!Report progress to user
 5715	FORMAT('+    Trial',I6)
C
	DO 5718 nc=2,NCHAN
 	  D(NIDS-1,nc)=1		     !Label trial as accepted by EMCP
 5718	  IF(NOUT(nt).GT.0) D(NIDS-1,nc)=-1  !Label trial as rejected by EMCP
C
        IF(NOUT(nt).GT.0)  GOTO 5785	!Branch if reject trial
        CALL baseln(X,BSLN)		!Compute and subtract baseline
	IF(hem.EQ.-1)      GOTO 5720	!Branch if HEM correction
        CALL CLEAR(XX,maxpts)		!Zero blink marker buffer
        CALL blink(X,XX)		!Detect & mark blinks
C
 5720   DO 5780 np=1,NPTS		!Adujst trial
C
	  IF(hem.EQ.-1)    GOTO 5730	!Branch if HEM correction
          IF(XX(np).EQ.0)  GOTO 5730	!Branch unless blink
C
            BVEOG=X(np,1)-BSTOT(1)	!Deviation of EOG from mean:  blink
            DO 5725 nc=1,NCHAN1
              avgadj=BCORR(nc)*BVEOG		 !Effect of eye movement
 5725         X(np,nc)=X(np,nc)-avgadj-BSTOT(nc) !Correct for it
C
 5730       SVEOG=X(np,1)-SSTOT(1)	!Deviation of EOG from mean:  saccade
            DO 5740 nc=1,NCHAN1
              AVGADJ=SCORR(nc)*SVEOG		 !Effect of eye movement
 5740         X(np,nc)=X(np,nc)-AVGADJ-SSTOT(nc) !Correct for it
C
	  DO 5760 nc=2,NCHAN			!Restore baseline
 5760       X(np,nc)=X(np,nc)+BSLN(nc)
 5780	  CONTINUE
C
 5785	  DO 5790 nc=2,NCHAN			!Output the trial
ccc 5790	    WRITE(lune3,5825)
 5790	    WRITE(lune3'nexte3)
     +		(IFIX(D(ni,nc)),ni=1,NIDS),(IFIX(X(np,nc)),np=1,NPTS)
C
 5800	  CONTINUE				!End of loop on trials
ccc 5825	FORMAT(1X,10I6)
C------------------------------------------------------------------------
C
 5850	CALL date(daytim(1))			!Get end date & time
	CALL time(daytim(11))
	WRITE(lune4,4453)  daytim		!Report:  done
	WRITE(lunto,4453)  daytim
4453	FORMAT( 20X,'Normal termination at        ',18A1/)
C
	CALL exit
C
 5900	WRITE(lunto,5940)  (spec(i),i=1,14)	!Error messages
	CALL exit
 5920	WRITE(lunto,5960)  (file(i),i=1,13)
	CALL exit
 5940	FORMAT(/' ** Error opening spec file:  ',14A1//)
 5960	FORMAT(/' ** Error opening single-trial output file:  ',13A1//)
C
	END
C
C****************************************************************************
C****************************************************************************
C
C			***  Subroutines  ***
C
C******************************************************************
C
C             SUBROUTINE stin
C
C	Read one trial's ids & data from LUN 'lunin', optionally swap
C	channels 1 & 2 to put VEM first, and move the record from
C	INTEGER*2 to REAL*4 arrays.
C
C******************************************************************
C
	SUBROUTINE stin(nt,D,X)
C
	INTEGER*2	iid(20,6),iix(125,6)	!Local buffers
	REAL*4		D(20,6)			!From caller		
	VIRTUAL		X(125,6)
C
	INTEGER*2	hem,outopt,eof,fchan
C
	COMMON  /FILES/	lunti, lunto, lunin, lune1, lune2, lune3, lune4,
     +				     nextin,nexte1,nexte2,nexte3
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /RPARAM/	adcrit,eogsen
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C
	INTEGER*2	cal1,cal2		!For eogsen calculation
	REAL*4		caleog			!For eogsen calculation
	COMMON		/CALIB/	cal1,cal2	!Force adjacent addressing
	EQUIVALENCE	(caleog,cal1)		!Dual access to address
C
	eof=0					!Zero the end-of-file flag
C
	DO 5200 nc=1,NCHAN			!Read IDs, data per channel
 5200	  READ(lunin'nextin,END=999)
     +			(iid(ni,nc),ni=1,NIDS),(iix(np,nc),np=1,NPTS)
c 5200	  READ(lunin'nextin,ERR=998,END=999)
c     +			(iid(ni,nc),ni=1,NIDS),(iix(np,nc),np=1,NPTS)
C
	DO 5300 nc=1,nchan			!Code aud or vis trial type
	k=2					!1 = aud, 2 = vis
	IF(iid(13,nc).EQ.'OO'.OR.iid(13,nc).EQ.'QQ') k=1   !1 = aud, 2 = vis
 5300	  iid(18,nc)=k
C
	IF(hem.NE.2)  GOTO 6030		!Branch if HEM not first channel
C
	DO 6000 ni=1,nids		!Swap ids for first two channels
	  itemp   =iid(ni,1)
	  iid(ni,1)=iid(ni,2)
 6000	  iid(ni,2)=itemp
C
	DO 6020 np=1,npts		!Swap A/D data for first two channels
	  itemp   =iix(np,1)
	  iix(np,1)=iix(np,2)
 6020	  iix(np,2)=itemp
C
 6030	DO 6100 nc=1,nchan		!Move INTEGER*2 into REAL*4
C
	  DO 6040 ni=1,nids		!IDs
 6040	    d(ni,nc)=iid(ni,nc)
C
	  DO 6060 np=1,npts		!Data
 6060	    x(np,nc)=iix(np,nc)
 6100	  CONTINUE
C
	IF(hem.EQ.-1)      RETURN		!HEM correction
	IF(eogsen.GT.0.0)  RETURN		!Use EOGSEN value as is
	  cal1=iid(nids-1,1)			!Get EOG sensitivity
	  cal2=iid(nids,  1)			! (REAL*4 value now in 'cal')
	  IF(eogsen.EQ.0.0)  eogsen=caleog	!Store EOG sensitivity
	  IF(eogsen.LT.0.0)  eogsen=1.0/caleog	!Reciprocal is sensitivity
C
	RETURN
C
999	eof=1				!Signal if end-of-file encountered
	RETURN
C
998	WRITE(lunto,997)   nt,nc	!Handle 'ERR='
	WRITE(lune4,997)   nt,nc
	CALL exit
C
10	FORMAT(1X,10F7.1)
997	FORMAT(/' Input data read error at trial',I4,', channel',I4/)
C
	END
C
C*********************************************************************
C
C              SUBROUTINE XSUM
C
C	Sum data for the computational formulae
C	(Note -- The arrays locally called '?local' represent
C	different arrays in caller at different times.)
C
C*********************************************************************
C
	SUBROUTINE XSUM(V,alocal,blocal,clocal,dlocal,ICL,NCHAN,np)
C
	REAL*4	v(6),blocal(6),clocal(6)
	VIRTUAL	alocal(125,6,23),dlocal(125,23)
C
	DO 5000 nc=1,NCHAN				!For each channel
	  alocal(np,nc,ICL)=V(nc)+alocal(np,nc,ICL)	!Sum for average
	  blocal(nc)=blocal(nc)+V(nc)*V(nc)		!Sum for variance
 5000	  clocal(nc)=clocal(nc)+V(nc)*V(1)		!Sum for covariance
C					^ Note:  Using V(1) because that's EOG
	dlocal(np,ICL)=dlocal(np,ICL)+1.		!Sum of # of points
C
	RETURN
C
	END
C
C*********************************************************************
C
C              SUBROUTINE blink
C
C	In EOG channel, find and mark time points where blinks occur
C
C*********************************************************************
C
      SUBROUTINE blink(X,XX)
C
	INTEGER*2	hem,outopt,eof,fchan,CENTER,XX(125)
	REAL*4		NDIFF
	VIRTUAL		X(125,6)
C
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /RPARAM/	adcrit,eogsen
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C
	iblink=0		!Default:  no blink in trial
      ICRIT=70./eogsen		!Blink 'slope' criterion
      NDIFF=10./msec		!# points for 10 msec (= lag)
      LENGTH=NDIFF*7.+.5	!# points in 1/3 of template
	lengt2=length*2		!# points in 2/3 of template
      XN=LENGTH*3		!Template length
      TVAR=2.			!Template standard deviation
      IF((LENGTH/2.).EQ.(LENGTH/2))  LENGTH=LENGTH+1	!Force odd
      CENTER=(LENGTH+1)/2	!Point # of template center
      npMIN=LENGTH+CENTER		!First point # for c-c series
      npBACK=npMIN-1
      npMAX=NPTS-(LENGTH+npBACK)	!Last  point # for c-c series
C
      DO 5400 np=npMIN,npMAX	!Loop for c-c series
C
        npLOW=np-npBACK		!Blink scan start
        npHIGH=np+npBACK	!Blink scan end
        XCOV=0.			!Clear covariance buffer
C
        DO 5100 npp=npLOW,npHIGH	!For current 'np' point
	  n=npp-(npLOW-1)
          IF(n.LE.LENGTH)  GOTO 5050	!First third?
          IF(n.GT.LENGT2)  GOTO 5050	!Last  third?
	  XCOV=XCOV+X(npp,1)+X(npp,1)	!Middle third
	  GOTO 5100
 5050     XCOV=XCOV-X(npp,1)		!First or last third
 5100	  CONTINUE
C
        XCOV=XCOV/XN		!Compute covariance for current 'np' point
        SLOPE=XCOV/(TVAR*TVAR)
        IF(ABS(SLOPE).LE.ICRIT)  GOTO 5400	!Branch if covar too small
	  iblink=-1		!Store flag:  Blink detected on this trial
          IBLBEG=np-CENTER+1	!From beginning to end of middle third
          IBLEND=np+CENTER-1
          DO 5200 npp=IBLBEG,IBLEND		!Mark points as blinks
 5200       XX(npp)=1
C
 5400   CONTINUE		!End of c-c point loop
C
      RETURN
C
      END
C
C*********************************************************************
C
C               SUBROUTINE corfac
C
C	Write correlations and SDs; compute & write correction factors
C
C*********************************************************************
C
      SUBROUTINE corfac(lune4,NCHAN1,alocal,blocal,clocal)
C
C  ALOCAL = correlations, BLOCAL = SDs, CLOCAL = correction factors
	REAL*4		alocal(6),blocal(6),clocal(6)
C                                        for each channel
C  Use blocal(1) because that's EOG, & compute the correction factor
      DO 5000 nc=1,NCHAN1
        clocal(nc)=0.			!Zero the correction factor
        IF(blocal(1).NE.0.)		!beta = correlation * SDeeg / SDeog
     +		clocal(nc)=alocal(nc)*blocal(nc)/blocal(1)
 5000   CONTINUE
C
      WRITE(lune4,109)  (nc,        nc=1,NCHAN1)    !Column labels (channel #)
      WRITE(lune4,112)  (blocal(nc),nc=1,NCHAN1)    !Standard deviations
      WRITE(lune4,111)  (alocal(nc),nc=1,NCHAN1)    !Correlations
      WRITE(lune4,113)  (clocal(nc),nc=2,NCHAN1)    !Correction factors
C
109   FORMAT(20X,7I10)
112   FORMAT( ' Standard Deviation   ',7F10.3)
111   FORMAT( ' Correlation          ',7F10.3)
113   FORMAT( ' Correction factor    ',10X,6F10.3)
C
      RETURN
C
      END
C
C***********************************************************************
C
C                 SUBROUTINE avout
C
C	Write averages.  Called separately to write uncorrected and
C	corrected averages (to different LUNs).
C
C***********************************************************************
C
      SUBROUTINE avout(XIDS,XN,AVG,lun,next)
C
	INTEGER*2	hem,outopt,eof,fchan
	REAL*4		XN(23)
	VIRTUAL		xids(20,6,23)
	VIRTUAL		AVG(125,6,23)
C
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C                                        zero the bin number
      NBIN=0
      M1=MAXBIN-1			!Determine highest bin # used
      DO 5100 nb=M1,1,-1
        IF(XN(nb).LE.0)  GOTO 5100
          NBIN=nb
          GOTO 5200
 5100 CONTINUE
C
 5200 DO 5600 nb=1,maxbin-1		!For non-zero and non-garbage bins
	IF(xn(nb).LE.0.0)  GOTO 5500	!Skip if zero trials in bin
	DO 5400 nc=2,NCHAN		!For each channel except EOG
C
          IF(IDALL.EQ.0)  GOTO 100	!Branch to keep all IDs
C
            WRITE(lun'next)		!Just 3 IDs supplied by EMCP
     +		nb,nc,IFIX(XN(nb)),(IFIX(AVG(np,nc,nb)),np=1,NPTS)
            GOTO 5300
C
100         xids(NIDS-3,nc,nb)=nb	!Store bin # of this average
            xids(NIDS-2,nc,nb)=XN(nb)	!Store # trials in this bin's average
            WRITE(lun'next)
     +		(IFIX(xids(ni,nc,nb)),ni=1,NIDS),
     +		(IFIX(AVG(np,nc,nb)), np=1,NPTS)
C
 5300       CONTINUE
 5400       CONTINUE
 5500     CONTINUE
 5600   CONTINUE
C
      RETURN
C
      END
C
C***********************************************************************
C
C                  SUBROUTINE baseln
C
C	Compute and subtract the baseline
C
C***********************************************************************
C
      SUBROUTINE baseln(X,bsln)
C
	INTEGER*2	hem,outopt
	REAL*4		bsln(6)
	VIRTUAL		X(125,6)
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
C                                        for each channel
      DO 5400 nc=1,nchan
C
        bsln(nc)=0.			!Zero baseline array
C
        DO 5100 np=1,NPTS		!Compute baseline
 5100     bsln(nc)=bsln(nc)+X(np,nc)
        bsln(nc)=bsln(nc)/npts
C
        DO 5200 np=1,NPTS		!Remove baseline
 5200     X(np,nc)=X(np,nc)-bsln(nc)
C
 5400   CONTINUE
C
      RETURN
C
      END
C
C**************************************************************************
C
C                  SUBROUTINE badtrl
C
C	Check whether trial has off-scale EOG, off-scale EEG, or flat EEG
C
C**************************************************************************
C
      SUBROUTINE badtrl(D,X)
C
	INTEGER*2	hem,outopt,eof,fchan
	REAL*4		D(20,6)
	VIRTUAL		X(125,6)
C
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /RPARAM/	adcrit,eogsen
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C                                        zero the marker variable
      ibad=0
C                                        for each channel and time point
      DO 5200 nc=1,NCHAN1
        ADCX=ADCRIT				!Default = ADCRIT parameter
        IF(ADCRIT.EQ.0.0)  ADCX=D(nids-3,nc)	!Obtain from IDs?
        DO 5200 np=1,NPTS
          IF(ABS(X(np,nc)).LT.ADCX)  GOTO 5200	!Branch unless off-scale
            ibad=1				!Mark trial as off-scale
            RETURN
 5200     CONTINUE
C
      DO 5400 nc=fchan,NCHAN1		!For EEG channels
        DO 5400 np=5,NPTS
          DO 5300 npp=1,4		!4 previous points equal?
 5300       IF(X(np,nc).NE.X((np-npp),nc))  GOTO 5400	!Branch if not
          ibad=2			!Mark trial as flat if reach here
          RETURN
 5400	CONTINUE			!End of loops on points, channels
C
      RETURN
C
      END
C
C****************************************************************************
C
C                   SUBROUTINE table
C
C	Write the variance-covariance table to log file
C
C*****************************************************************************
C
      SUBROUTINE table(lune4,NCHAN1,BS2,BCX,SS2,SCX)
C
      DIMENSION BS2(6),BCX(6),SS2(6),SCX(6)
C
      WRITE(lune4,1) (nc,       nc=1,NCHAN1)	!Column label (channel #)
      WRITE(lune4,2) (BS2(nc),  nc=1,NCHAN1)	!Blink variance
      WRITE(lune4,3) (BCX(nc),  nc=1,NCHAN1)	!Blink covariance
      WRITE(lune4,5) (nc,       nc=1,NCHAN1)	!Column label (channel #)
      WRITE(lune4,2) (SS2(nc),  nc=1,NCHAN1)	!Saccade variance
      WRITE(lune4,3) (SCX(nc),  nc=1,NCHAN1)	!Saccade covariance
C
1     FORMAT(/' Blinks:'  /20X,7I10)
5     FORMAT(/' Saccades:'/20X,7I10)
2     FORMAT( ' Variance             ',7F10.2)
3     FORMAT( ' Covar (Channel, EOG) ',7F10.2)
C
      RETURN
C
      END
C
C****************************************************************************
C****************************************************************************
C
C		Local subroutines new to RT-11 version
C
C****************************************************************************
C
C	The CLEAR and VCLEAR subroutines are now contained in the
C	present source file instead of being obtained from the Harris
C	subroutine library.  In CLEAR, zeroing of integer rather than
C	real arrays is done, for speed.  In VCLEAR, zeroing of real
C	arrays is done, because some real arrays get so large that
C	twice the number of logical locations exceeds 32767.
C
C****************************************************************************
C
C                   SUBROUTINE clear
C
C	Zero a INTEGER*2 non-virtual array.
C
C****************************************************************************
C
	SUBROUTINE clear(array,length)
C
	INTEGER*2	ARRAY(1)
C
	DO 5000 I=1,LENGTH
 5000	  ARRAY(I)=0
C
	RETURN
	END
C
C****************************************************************************
C
C                   SUBROUTINE vclear
C
C	Zero a REAL*4 virtual array.
C
C****************************************************************************
C
	SUBROUTINE vclear(varray,length)
C
	VIRTUAL		VARRAY(1)
C
	DO 5000 I=1,LENGTH
 5000	  VARRAY(I)=0.0
C
	RETURN
	END
C
C****************************************************************************
C
C			SUBROUTINE opnfil
C
C	Subroutine for caller EMF11D.  Called once, at beginning
C	of caller.  Opens data input file and all output files.
C
C****************************************************************************
C
	SUBROUTINE opnfil(file)
C
C After the input file and three of the four output files are opened here,
C the 'file' array is set up for opening the .E3 single-trial output file.
C But the .E3 output file is not opened here.  It is opened by the caller,
C only if needed (i.e., only if single-trial correction is done), after the
C two average output files (.E1 & .E2) are closed.  This saves having to have
C an extra logical unit open, thus saving space.  Note the danger that, if
C device OUT: does not contain enough space for the .E3 file, the program will
C run all the way through the average computation and correction before
C crashing due to lack of disk space to open the .E3 file.
C
C-----------------------------------------------------------------------------
C
	INTEGER*2	hem,outopt,eof,fchan
	BYTE		file(1)
C
	COMMON  /FILES/	lunti, lunto, lunin, lune1, lune2, lune3, lune4,
     +				     nextin,nexte1,nexte2,nexte3
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C
	file(1) ='I'				!Input device is INP:
	file(2) ='N'
	file(3) ='P'
	file(4) =':'
ccc	file(10)='A'				!'A' for 'all trials'
	file(11)='.'
	file(14)=0				!Terminate with null byte
	WRITE(lunto,1100)  (file(i),i=1,13)	!Log input filename
	OPEN (UNIT=lunin,NAME=file,TYPE='OLD',READONLY,
     +		ACCESS='DIRECT',FORM='UNFORMATTED',RECORDSIZE=ndwin,
     +		BUFFERCOUNT=2,ASSOCIATEVARIABLE=nextin,ERR=940)
C
	file(1) ='O'				!Output device is OUT:
	file(2) ='U'
	file(3) ='T'
	file(12)=file(16)		!Output extension 'o' was stored there
C
	file(13)='1'				!'o1' corrected averages
	WRITE(lunto,1120)  (file(i),i=1,13)	!Log input filename
	OPEN (UNIT=lune1,NAME=file,TYPE='NEW',
     +		ACCESS='DIRECT',FORM='UNFORMATTED',RECORDSIZE=ndwout,
     +		MAXREC=(nchan-1)*(maxbin-1),ASSOCIATEVARIABLE=nexte1,ERR=960)
C
	file(13)='2'				!'o2' uncorrected averages
	WRITE(lunto,1140)  (file(i),i=1,13)	!Log input filename
	OPEN (UNIT=lune2,NAME=file,TYPE='NEW',
     +		ACCESS='DIRECT',FORM='UNFORMATTED',RECORDSIZE=ndwout,
     +		MAXREC=(nchan-1)*(maxbin-1),ASSOCIATEVARIABLE=nexte2,ERR=960)
C
	file(13)='4'				!'o4' log file
	WRITE(lunto,1160)  (file(i),i=1,13)	!Log input filename
	OPEN (UNIT=lune4,NAME=file,TYPE='NEW',INITIALSIZE=100,ERR=960)
C
	RETURN
C
 940	WRITE(lunto,1040)  (file(i),i=1,13)	!Error messages
	CALL exit
 960	WRITE(lunto,1060)  (file(i),i=1,13)
	CALL exit
C
 1040	FORMAT(/' ** Error opening data input  file:  ',           13A1//)
 1060	FORMAT(/' ** Error opening output file:  ',                13A1//)
 1100	FORMAT( ' Opening input file:',                        T50,13A1)
 1120	FORMAT( ' Opening corrected-avg output file:',         T50,13A1)
 1140	FORMAT( ' Opening uncorrected-avg output file:',       T50,13A1)
 1160	FORMAT( ' Opening log file:',                          T50,13A1)
C
	END
C
C****************************************************************************
C
C			SUBROUTINE outlst
C
C	Subroutine for caller EMF11D.  Called to dump lists of
C	rejected trials, according to reason for rejection.
C
C****************************************************************************
C
	SUBROUTINE outlst(nout)
C
	INTEGER*2	hem,outopt,eof,fchan
	BYTE		nout
	VIRTUAL		nout(1)
C
	COMMON  /FILES/	lunti, lunto, lunin, lune1, lune2, lune3, lune4,
     +				     nextin,nexte1,nexte2,nexte3
	COMMON /IPARAM/	hem,idall,msec,nchan,nchan1,nids,npts,outopt
	COMMON /IOTHER/	fchan,ibad,iblink,maxbin,maxtrl,ndwin,ndwout,eof
C
	DO 400 j=1,3			!For each rejection reason
C
	  DO 100 nt=1,maxtrl
 100	    IF(nout(nt).EQ.j)  GOTO 200	!Any trials rejected for this reason?
	  GOTO 400			!No -- try the next one
C
 200	  IF(j.EQ.1)  WRITE(lune4,1040)	!Label the list
	  IF(j.EQ.2)  WRITE(lune4,1060)
	  IF(j.EQ.3)  WRITE(lune4,1080)
	  n=0				!Clear # listed on current line
	  WRITE(lune4,1020)		!Move to new line
	  DO 300 nt=1,maxtrl		!List trials rejected for this reason
	    IF(nout(nt).NE.j)  GOTO 300	!Branch if not this reason
	    IF(n.EQ.15)        WRITE(lune4,1020)	!Move to new line
	    IF(n.EQ.15)        n=0			!Reset counter
	    WRITE(lune4,1000)  nt
	    n=n+1			!Count # listed on current line
 300	    CONTINUE
C
 400	  CONTINUE
C
	IF(hem.EQ.-1)         GOTO 900	!Branch if HEM correction
	DO 500 nt=1,maxtrl		!Any trial with a blink?
 500	  IF(nout(nt).EQ.-1)  GOTO 600
	WRITE(lune4,1120)		!None found -- report & exit
	GOTO 900
C
 600	WRITE(lune4,1140)		!Label output
	WRITE(lune4,1020)		!Move to new line
	n=0				!Clear # listed on current line
	DO 700 nt=1,maxtrl		!List trials with blinks
	  IF(nout(nt).NE.-1)  GOTO 700	!Branch if no blink
	  IF(n.EQ.15)         WRITE(lune4,1020)	!Move to new line
	  IF(n.EQ.15)         n=0		!Reset counter
	  WRITE(lune4,1000)   nt
	  n=n+1				!Count # listed on current line
 700	  CONTINUE
C
 900	WRITE(lune4,1100)		!Restore to left margin
C
	RETURN
C
 1000	FORMAT('+',I5,$)
 1020	FORMAT(' ')
 1040	FORMAT(' '/' Dropped for data off-scale (EOG or EEG):')
 1060	FORMAT(' '/' Dropped for flat EEG:')
 1080	FORMAT(' '/' Dropped by user:')
 1100	FORMAT('+')
 1120	FORMAT(' '/' No blinks detected.')
 1140	FORMAT(' '/' Accepted trials with at least one blink:')
C
	END
C
C****************************************************************************
C
C			SUBROUTINE checkb
C
C	Subroutine for caller EMF11D.  Called to check each record.
C	Applies 'selection' criteria to decide to include or exclude
C	a record, and, if include, in which 'bin'.
C	Functionally similar to CHECK subroutine used in Harris EMCP
C	program, but algorithm is specific to RT-11 adaptation of EMCP
C	program.
C
C****************************************************************************
C
	SUBROUTINE checkb(nbin,ncrit,idlist,idvalu,xid,icl)
C
C Decision method is to scan the selection specification tables built by
C subroutine SELECT, contained in two parallel arrays, 'idlist' and 'idvalu'.
C If idlist(i) .GT.0, include the record if its ID value matches idvalu(i).
C If idlist(i) .LT.0, exclude the record if its ID value matches idvalu(i).
C Thus, e.g., idlist(3) contains the number of an ID, and idvalu(3) contains
C the value of that ID on which to base a selection decision; the sign of
C idlist(3) determines whether a match means include or exclude.
C
C A second dimension is added to these table arrays, 'bin #'.  Thus, the
C selection criteria for each bin are applied until either one bin's criteria
C are met (icl = bin #) or all bins have been checked for (icl = 0).  Note
C that, while a given record may match several bins' selection criteria,
C the record is assigned to the first bin whose criteria it matches.
C
C Notes on logic of algorithm:
C   First, check for case where user wants all records (trials) to be
C processed in a single 'bin', because there are no selection criteria.
C Handle that case by retaining all records.
C   When there are selection criteria, method is to scan criteria for each
C bin until either a match is found or all bins have been checked for.
C In the latter case, the record is excluded (the caller will dump it into
C the 'garbage' bin, the highest-numbered; EMCP assumes that the main
C program's arrays are dimensioned for one more bin than is needed).
C   Jump out of checking criteria for current (DO 200 loop) bin as soon as
C there's a failure, i.e., as soon as 'icl' becomes zero, since no need to
C check other criteria for current bin.  Thus, goto 400 to move on to
C checking for next bin.
C   Reach label 200 when current ID value matches a single criterion for
C a single bin.  Fall through past label 200 and reach first 'RETURN' only
C if/when current set of ID values matches all criteria for a single bin.
C That's the bin the current record is then assigned to.
C   Fall through past label 400 to second RETURN only when set of ID values
C for current record has been checked against criteria for all bins and has
C failed to match criteria for any bin.
C
C Arguments:
C	nbin	# of bins specified
C	ncrit	count of IDs to select on for each bin
C	idlist	table of ID #s to select on for each bin
C	idvalu	table of ID values to select on for each bin
C	xid	IDs for current record
C	icl	'bin' # of current record returned to caller (0 if exclude)
C
C-----------------------------------------------------------------------------
C
	INTEGER*2	bin
	INTEGER*2	ncrit(23)
	REAL*4		idlist(8,23)
	REAL*4		idvalu(8,23)
	REAL*4		xid(1)
C
C-----------------------------------------------------------------------------
C
	icl=1				!Assume just one big bin
	IF(nbin.LT.0)  RETURN		!If so, all done
C
	DO 400 bin=1,nbin		!For each bin to check
	  icl=bin			!Default to 'include in current bin'
C
	  DO 200 nb=1,ncrit(bin)	!For each criterion for this bin
C
	    itemp=idlist(nb,bin)	!Working copy of ID #
	    temp=idvalu(nb,bin)		!Working copy of ID value
	    IF(itemp.GT.0)  includ=1	!'Include' criterion?
	    IF(itemp.LT.0)  includ=-1	!'Exclude' criterion?
	    itemp=IABS(itemp)		!Force ID # positive
	    IF(includ.GT.0 .AND. xid(itemp).NE.temp)  icl=0
	    IF(includ.LT.0 .AND. xid(itemp).EQ.temp)  icl=0
	    IF(icl.EQ.0)  GOTO 400	!Exclude, so go on to next bin
C
 200	    CONTINUE			!End of loop on criterion # within bin
	  RETURN			!Include in current bin # (icl=bin #)
C
 400	  CONTINUE			!End of loop on bin #
C
	RETURN				!Exclude (icl=0)
C
	END
C
C****************************************************************************
C
C			SUBROUTINE select
C
C	Subroutine for caller EMF11D.  Called once, early in caller,
C	to obtain 'selection' specifications from LUN 'lunsp'.
C	Functionally similar to, but much simpler and less flexible
C	than, SELECT subroutine used in Harris EMCP program.
C
C****************************************************************************
C
	SUBROUTINE select(lunto,lunsp,nbin,ncrit,idlist,idvalu)
C
C Selection method is to read in selection specifications from the general
C specification file, building two parallel arrays:
C	idlist		contains a list of IDs to select on
C	idvalu		contains the values of those IDs to select on
C Thus, e.g., idlist(3) contains the number of an ID, and idvalu(3) contains
C the value of that ID on which to base a selection decision.  Subroutine
C CHECK will later use this information to decide which bin to include a
C given record in, or to exclude a given record.
C
C Assumes that specification file is already open on LUN 'lunsp'.
C Each selection line contains two integers and one real number:
C	bin #, ID #, and ID value
C
C Arguments:
C	lunsp	LUN from which to read specifications
C	nbin	# of bins specified
C	ncrit	count of criteria per bin
C	idlist	table of ID #s to select on per bin
C	idvalu	table of ID values to select on per bin
C
C-----------------------------------------------------------------------------
C
	INTEGER*2	bin,idn		!Current bin # & ID #
	INTEGER*2	ncrit(23)	!Count of criteria per bin
	REAL*4		idlist(8,23)	!Table of ID #s to select on per bin
	REAL*4		idvalu(8,23)	!Table of ID values to select on / bin
	BYTE		bell
C
	DATA		maxbin	/23/	!Maximum # bins allowed (array sizes)
	DATA		maxcrt	/8/	!Maximum # criteria allowed (   "   )
	DATA		bell	/135/	!ASCII bell code
C
C-----------------------------------------------------------------------------
C
	nbin=0				!Clear memory of highest bin # used
	DO 100 n=1,maxbin		!Clear count of # of criteria for bin
 100	  ncrit(n)=0
C
 200	READ(lunsp,*,END=900)  bin,idn,temp	!Read next selection line
C
	  IF(bin.EQ.0 .AND. nbin.EQ.0)  nbin=-1	!Just one big bin
	  IF(bin.EQ.0)              RETURN		   !Bin # is zero?
	  IF(bin.GT.maxbin)         WRITE(lunto,1000) bell !Too many bins?
	  IF(bin.GT.maxbin)         CALL exit		   !Warn user & quit
	  IF(ncrit(bin).EQ.maxcrt)  WRITE(lunto,1020) bell !Too many criteria?
	  IF(ncrit(bin).EQ.maxcrt)  CALL exit		   !Warn user & quit
C
	  IF(bin.GT.nbin)  nbin=bin	!Update memory of highest bin # used
	  ncrit(bin)=ncrit(bin)+1	!Update count of # of criteria for bin
	  idlist(ncrit(bin),bin)=idn	!Store ID #
	  idvalu(ncrit(bin),bin)=temp	!Store ID value
	  GOTO 200
C
 900	RETURN				!No more 'selection' lines
C
 1000	FORMAT(/' ** SELECT subroutine:  Too many bins!  Aborting.',A1)
 1020	FORMAT(/' ** SELECT subroutine:  Too many criteria!  Aborting.',A1)
C
	END
C
C*******************************************************************
C
C			SUBROUTINE blklst
C
C	Subroutine for caller EMF11D.  Called to construct list
C	of which data collection trial blocks contributed to
C	each EMCP bin.
C
C*******************************************************************
C
	SUBROUTINE blklst(icl,maxbin,maxblk,blockn,blocks)
C
C  Args:
C	icl	bin # of current trial
C	maxbin	max # of bins  to store in 'blocks' (an array dimension)
C	maxblk	max # block #s to store in 'blocks' (an array dimension)
C	blockn	block # of current trial (from an ID stored in data)
C	blocks	array containing up to 5 block #s for each bin
C
C  Entries in 'blocks' are:
C	 0	value initialized by caller at program start
C	-2	overflow = more than 'maxblk' blocks in bin
C	>0	block #
C
	INTEGER*2	blockn,blocks(maxblk,maxbin),empty
C
	DO 100 j=1,maxblk  !For each possible entry in block list for this bin
C
 100	  IF(blockn.EQ.blocks(j,icl))  GOTO 900	!Already in list?
C
C  Not already in list
C
	DO 200 j=1,maxblk		!Find first empty slot for this bin
	  empty=j
 200	  IF(blocks(j,icl).EQ.0)  GOTO 300	!Found first empty slot?
C
C  No empty slots for this bin if reach here
C
	blocks(maxblk,icl)=-2			!Mark as overflowed
	GOTO 900
C
 300	blocks(empty,icl)=blockn		!Store new block #
C
 900	RETURN
C
	END
