% headdef - header definitions for eeg2mat program 
% 
% Sources - some source code modified and then incorporated from:  
%    JVIR, Jussi.Virkkala@occuphealth.fi
%    JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%
% HEADER

  headdef_text = [ 
    '  12 char          rev                  Revision string                                '
    '   1 int32         NextFile             offset to next file                            '
    '   1 int32         PrevFile             offset to prev file                            '
    '   1 char          type                 File type AVG=0, EEG=1, etc.                   '
    '  20 char          id                   Patient ID                                     '
    '  20 char          oper                 Operator ID                                    '
    '  20 char          doctor               Doctor ID                                      '
    '  20 char          referral             Referral ID                                    '
    '  20 char          hospital             Hospital ID                                    '
    '  20 char          patient              Patient name                                   '
    '   1 int16         age                  Patient Age                                    '
    '   1 char          sex                  Patient Sex Male= M , Female= F                '
    '   1 char          hand                 Handedness Mixed= M ,Rt= R , lft= L            '
    '  20 char          med                  Medications                                    '
    '  20 char          category             Classification                                 '
    '  20 char          state                Patient wakefulness                            '
    '  20 char          label                Session label                                  '
    '  10 char          date                 Session date string                            '
    '  12 char          time                 Session time strin                             '
    '   1 float32       mean_age             Mean age (Group files only)                    '
    '   1 float32       stdev                Std dev of age (Group files only)              '
    '   1 int16         n                    Number in group file                           '
    '  38 char          compfile             Path and name of comparison file               '
    '   1 float32       SpectWinComp         Spectral window compensation factor            '
    '   1 float32       MeanAccuracy         Average respose accuracy                       '
    '   1 float32       MeanLatency          Average response latency                       '
    '  46 char          sortfile             Path and name of sort file                     '
    '   1 int32         NumEvents            Number of events in eventable                  '
    '   1 char          compoper             Operation used in comparison                   '
    '   1 char          avgmode              Set during online averaging                    '
    '   1 char          review               Set during review of EEG data                  '
    '   1 uint16        nsweeps              Number of expected sweeps                      '
    '   1 uint16        compsweeps           Number of actual sweeps                        '
    '   1 uint16        acceptcnt            Number of accepted sweeps                      '
    '   1 uint16        rejectcnt            Number of rejected sweeps                      '
    '   1 uint16        pnts                 Number of points per waveform                  '
    '   1 uint16        nchannels            Number of active channels                      '
    '   1 uint16        avgupdate            Frequency of average update                    '
    '   1 char          domain               Acquisition domain TIME=0, FREQ=1              '
    '   1 char          variance             Variance data included flag                    '
    '   1 uint16        rate                 D-to-A rate                                    '
    '   1 float64       scale                scale factor for calibration                   '
    '   1 char          veogcorrect          VEOG corrected flag                            '
    '   1 char          heogcorrect          HEOG corrected flag                            '
    '   1 char          aux1correct          AUX1 corrected flag                            '
    '   1 char          aux2correct          AUX2 corrected flag                            '
    '   1 float32       veogtrig             VEOG trigger percentage                        '
    '   1 float32       heogtrig             HEOG trigger percentage                        '
    '   1 float32       aux1trig             AUX1 trigger percentage                        '
    '   1 float32       aux2trig             AUX2 trigger percentage                        '
    '   1 int16         heogchnl             HEOG channel number                            '
    '   1 int16         veogchnl             VEOG channel number                            '
    '   1 int16         aux1chnl             AUX1 channel number                            '
    '   1 int16         aux2chnl             AUX2 channel number                            '
    '   1 char          veogdir              VEOG trigger direction flag                    '
    '   1 char          heogdir              HEOG trigger direction flag                    '
    '   1 char          aux1dir              AUX1 trigger direction flag                    '
    '   1 char          aux2dir              AUX2 trigger direction flag                    '
    '   1 int16         veog_n               Number of points per VEOG waveform             '
    '   1 int16         heog_n               Number of points per HEOG waveform             '
    '   1 int16         aux1_n               Number of points per AUX1 waveform             '
    '   1 int16         aux2_n               Number of points per AUX2 waveform             '
    '   1 int16         veogmaxcnt           Number of observations per point - VEOG        '
    '   1 int16         heogmaxcnt           Number of observations per point - HEOG        '
    '   1 int16         aux1maxcnt           Number of observations per point - AUX1        '
    '   1 int16         aux2maxcnt           Number of observations per point - AUX2        '
    '   1 char          veogmethod           Method used to correct VEOG                    '
    '   1 char          heogmethod           Method used to correct HEOG                    '
    '   1 char          aux1method           Method used to correct AUX1                    '
    '   1 char          aux2method           Method used to correct AUX2                    '
    '   1 float32       AmpSensitivity       External Amplifier gain                        '
    '   1 char          LowPass              Toggle for Amp Low pass filter                 '
    '   1 char          HighPass             Toggle for Amp High pass filter                '
    '   1 char          Notch                Toggle for Amp Notch state                     '
    '   1 char          AutoClipAdd          AutoAdd on clip                                '
    '   1 char          baseline             Baseline correct flag                          '
    '   1 float32       offstart             Start point for baseline correction            '
    '   1 float32       offstop              Stop point for baseline correction             '
    '   1 char          reject               Auto reject flag                               '
    '   1 float32       rejstart             Auto reject start point                        '
    '   1 float32       rejstop              Auto reject stop point                         '
    '   1 float32       rejmin               Auto reject minimum value                      '
    '   1 float32       rejmax               Auto reject maximum value                      '
    '   1 char          trigtype             Trigger type                                   '
    '   1 float32       trigval              Trigger value                                  '
    '   1 char          trigchnl             Trigger channel                                '
    '   1 int16         trigmask             Wait value for LPT port                        '
    '   1 float32       trigisi              Interstimulus interval (INT trigger)           '
    '   1 float32       trigmin              Min trigger out voltage (start of pulse)       '
    '   1 float32       trigmax              Max trigger out voltage (during pulse)         '
    '   1 char          trigdir              Duration of trigger out pulse                  '
    '   1 char          Autoscale            Autoscale on average                           '
    '   1 int16         n2                   Number in group 2 (MANOVA)                     '
    '   1 char          dir                  Negative display up or down                    '
    '   1 float32       dispmin              Display minimum (Yaxis)                        '
    '   1 float32       dispmax              Display maximum (Yaxis)                        '
    '   1 float32       xmin                 X axis minimum (epoch start in sec)            '
    '   1 float32       xmax                 X axis maximum (epoch stop in sec)             '
    '   1 float32       AutoMin              Autoscale minimum                              '
    '   1 float32       AutoMax              Autoscale maximum                              '
    '   1 float32       zmin                 Z axis minimum - Not currently used            '
    '   1 float32       zmax                 Z axis maximum - Not currently used            '
    '   1 float32       lowcut               Archival value - low cut on external amp       '
    '   1 float32       highcut              Archival value - Hi cut on external amp        '
    '   1 char          common               Common mode rejection flag                     '
    '   1 char          savemode             Save mode EEG AVG or BOTH                      '
    '   1 char          manmode              Manual rejection of incomming data             '
    '  10 char          ref                  Label for reference electode                   '
    '   1 char          Rectify              Rectification on external channel              '
    '   1 float32       DisplayXmin          Minimun for X-axis display                     '
    '   1 float32       DisplayXmax          Maximum for X-axis display                     '
    '   1 char          phase                flag for phase computation                     '
    '  16 char          screen               Screen overlay path name                       '
    '   1 int16         CalMode              Calibration mode                               '
    '   1 int16         CalMethod            Calibration method                             '
    '   1 int16         CalUpdate            Calibration update rate                        '
    '   1 int16         CalBaseline          Baseline correction during cal                 '
    '   1 int16         CalSweeps            Number of calibration sweeps                   '
    '   1 float32       CalAttenuator        Attenuator value for calibration               '
    '   1 float32       CalPulseVolt         Voltage for calibration pulse                  '
    '   1 float32       CalPulseStart        Start time for pulse                           '
    '   1 float32       CalPulseStop         Stop time for pulse                            '
    '   1 float32       CalFreq              Sweep frequency                                '
    '  34 char          taskfile             Task file name                                 '
    '  34 char          seqfile              Sequence file path name                        '
    '   1 char          SpectMethod          Spectral method                                '
    '   1 char          SpectScaling         Scaling employed                               '
    '   1 char          SpectWindow          Window employed                                '
    '   1 float32       SpectWinLength       Length of window %                             '
    '   1 char          SpectOrder           Order of Filter for Max Entropy method         '
    '   1 char          NotchFilter          Notch Filter in or out                         '
    '   1 int16         HeadGain             Current head gain for SYNAMP                   '
    '   1 int           AdditionalFiles      No of additional files                         '
    '   5 char          unused               Free space                                     '
    '   1 int16         FspStopMethod        FSP - Stoping mode                             '
    '   1 int16         FspStopMode          FSP - Stoping mode                             '
    '   1 float32       FspFValue            FSP - F value to stop terminate                '
    '   1 int16         FspPoint             FSP - Single point location                    '
    '   1 int16         FspBlockSize         FSP - block size for averaging                 '
    '   1 uint16        FspP1                FSP - Start of window                          '
    '   1 uint16        FspP2                FSP - Stop  of window                          '
    '   1 float32       FspAlpha             FSP - Alpha value                              '
    '   1 float32       FspNoise             FSP - Signal to ratio value                    '
    '   1 int16         FspV1                FSP - degrees of freedom                       '
    '  40 char          montage              Montage file path name                         '
    '  40 char          EventFile            Event file path name                           '
    '   1 float32       fratio               Correction factor for spectral array           '
    '   1 char          minor_rev            Current minor revision                         '
    '   1 int16         eegupdate            How often incomming eeg is refreshed           '
    '   1 char          compressed           Data compression flag                          '
    '   1 float32       xscale               X position for scale box - Not used            '
    '   1 float32       yscale               Y position for scale box - Not used            '
    '   1 float32       xsize                Waveform size X direction                      '
    '   1 float32       ysize                Waveform size Y direction                      '
    '   1 char          ACmode               Set SYNAP into AC mode                         '
    '   1 uchar         CommonChnl           Channel for common waveform                    '
    '   1 char          Xtics                Scale tool-  tic  flag in X direction          '
    '   1 char          Xrange               Scale tool- range (ms,sec,Hz) flag X dir       '
    '   1 char          Ytics                Scale tool-  tic  flag in Y direction          '
    '   1 char          Yrange               Scale tool- range (uV, V) flag Y dir           '
    '   1 float32       XScaleValue          Scale tool- value for X dir                    '
    '   1 float32       XScaleInterval       Scale tool- interval between tics X dir        '
    '   1 float32       YScaleValue          Scale tool- value for Y dir                    '
    '   1 float32       YScaleInterval       Scale tool- interval between tics Y dir        '
    '   1 float32       ScaleToolX1          Scale tool- upper left hand screen pos         '
    '   1 float32       ScaleToolY1          Scale tool- upper left hand screen pos         '
    '   1 float32       ScaleToolX2          Scale tool- lower right hand screen pos        '
    '   1 float32       ScaleToolY2          Scale tool- lower right hand screen pos        '
    '   1 int16         port                 Port address for external triggering           '
    '   1 int32         NumSamples           Number of samples in continous file            '
    '   1 char          FilterFlag           Indicates that file has been filtered          '
    '   1 float32       LowCutoff            Low frequency cutoff                           '
    '   1 int16         LowPoles             Number of poles                                '
    '   1 float32       HighCutoff           High frequency cutoff                          '
    '   1 int16         HighPoles            High cutoff number of poles                    '
    '   1 char          FilterType           Bandpass=0 Notch=1 Highpass=2 Lowpass=3        '
    '   1 char          FilterDomain         Frequency=0 Time=1                             '
    '   1 char          SnrFlag              SNR computation flag                           '
    '   1 char          CoherenceFlag        Coherence has been  computed                   '
    '   1 char          ContinousType        Method used to capture events in  .cnt         '
    '   1 int32         EventTablePos        Position of event table                        '
    '   1 float32       ContinousSeconds     Number of seconds to displayed per page        '
    '   1 int32         ChannelOffset        Block size of one channel in SYNAMPS           '
    '   1 char          AutoCorrectFlag      Autocorrect of DC values                       '
    '   1 uchar         DCThreshold          Auto correct of DC level                       '
    ]; 

  headdef = struct('name',[],'size',[],'precision',[],'description',[]);
  headdef.size        = str2num(headdef_text(:,1:4));  
  headdef.precision   = headdef_text(:,6:19);    
  headdef.name        = headdef_text(:,20:40);
  headdef.description = headdef_text(:,41:87);

  clear headdef_text; 
 
% ELECTRODES

  elecdef_text = [
    '  10 char          lab                  Electrode label - last bye contains NULL       '
    '   1 char          reference            Reference electrode number                     '
    '   1 char          skip                 Skip electrode flag ON=1 OFF=0                 '
    '   1 char          reject               Artifact reject flag                           '
    '   1 char          display              Display flag for  STACK  display               '
    '   1 char          bad                  Bad electrode flag                             '
    '   1 uint16        n                    Number of observations                         '
    '   1 char          avg_reference        Average reference status                       '
    '   1 char          ClipAdd              Automatically add to clipboard                 '
    '   1 float32       x_coord              X screen coord. for  TOP  display              '
    '   1 float32       y_coord              Y screen coord. for  TOP  display              '
    '   1 float32       veog_wt              VEOG correction weight                         '
    '   1 float32       veog_std             VEOG std dev. for weight                       '
    '   1 float32       snr                  signal-to-noise statistic                      '
    '   1 float32       heog_wt              HEOG Correction weight                         '
    '   1 float32       heog_std             HEOG Std dev. for weight                       '
    '   1 int16         baseline             Baseline correction value in raw ad units      '
    '   1 char          Filtered             Toggel indicating file has be filtered         '
    '   1 char          Fsp                  Extra data                                     '
    '   1 float32       aux1_wt              AUX1 Correction weight                         '
    '   1 float32       aux1_std             AUX1 Std dev. for weight                       '
    '   1 float32       sensitivity          electrode sensitivity                          '
    '   1 char          Gain                 Amplifier gain                                 '
    '   1 char          HiPass               Hi Pass value                                  '
    '   1 char          LoPass               Lo Pass value                                  '
    '   1 uchar         Page                 Display page                                   '
    '   1 uchar         Size                 Electrode window display size                  '
    '   1 uchar         Impedance            Impedance test                                 '
    '   1 uchar         PhysicalChnl         Physical channel used                          '
    '   1 char          Rectify              Free space                                     '
    '   1 float32       calib                Calibration factor                             '
                  ];

  elecdef = struct('name',[],'size',[],'precision',[],'description',[],'value',[]);
  elecdef.size        = str2num(elecdef_text(:,1:4));
  elecdef.precision   = elecdef_text(:,6:19);
  elecdef.name        = elecdef_text(:,20:40);
  elecdef.description = elecdef_text(:,41:87);

  clear elecdef_text; 

% SWEEP for epoched data (.eeg files)  

  sweepdef_text = [ 
    '   1 char          accept               accept byte                                    '
    '   1 int16         ttype                trial type                                     '
    '   1 int16         correct              accuracy                                       '
    '   1 float32       rt                   reaction time                                  '
    '   1 int16         response             response type                                  '
    '   1 int16         reserved             not used                                       '
        ]; 

  sweepdef = struct('name',[],'size',[],'precision',[],'description',[],'value',[]);
  sweepdef.size        = str2num(sweepdef_text(:,1:4));
  sweepdef.precision   = sweepdef_text(:,6:19);
  sweepdef.name        = sweepdef_text(:,20:40);
  sweepdef.description = sweepdef_text(:,41:87);

  clear sweepdef_text; 

% EVENTS for continuous data (.cnt files)  

  eventdef1_text = [ 
    '   1 uint16        StimType             Stimulus Type                                  ' 
    '   1 uchar         KeyBoard             Key Board                                      ' 
    '   1 char          KeyPad_Accept        Key Pad Accept                                 ' 
    '   1 int32         Offset               File Offset of Event                           ' 
                  ]; 

  eventdef2_text = [
    '   1 uint16        StimType             Stimulus Type                                  '
    '   1 uchar         KeyBoard             Key Board                                      '
    '   1 char          KeyPad_Accept        Key Pad                                        '
    '   1 int32         Offset               File Offset of Event                           '
    '   1 int16         Type                 Type                                           ' 
    '   1 int16         Code                 Code                                           ' 
    '   1 float32       Latency              Latency                                        ' 
    '   1 char          EpochEvent           EpochEvent                                     ' 
    '   1 char          Accept2              Accept                                         ' 
    '   1 char          Accuracy             Accutracy                                      ' 
                 ];

  eventdef1 = struct('name',[],'size',[],'precision',[],'description',[],'value',[]);
  eventdef1.size        = str2num(eventdef1_text(:,1:4));
  eventdef1.precision   = eventdef1_text(:,6:19);
  eventdef1.name        = eventdef1_text(:,20:40);
  eventdef1.description = eventdef1_text(:,41:87);

  clear eventdef1_text; 

  eventdef2 = struct('name',[],'size',[],'precision',[],'description',[],'value',[]);
  eventdef2.size        = str2num(eventdef2_text(:,1:4));
  eventdef2.precision   = eventdef2_text(:,6:19);
  eventdef2.name        = eventdef2_text(:,20:40);
  eventdef2.description = eventdef2_text(:,41:87);

  clear eventdef2_text; 
 
