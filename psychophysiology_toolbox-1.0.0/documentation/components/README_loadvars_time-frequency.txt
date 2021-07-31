
% ---------------------------------------
  %   Time-Frequency Distributions
  % -------------------------------------

  %  -------------------------------------
  %  Basics - energy/phase-sync
  %  -------------------------------------

  % absolute value - of TF distribution after calculation, use when needed (default = 0)  
  %                  (e.g. 1 for amplitude from RID Rihaczek or wavelets, 
  %                   most RIDs are already energy/amplitude, and abs would violate 
  %                   the meaning of RID negative values, negative energy).  

    SETvars.TFDparams.abs           = 1;

  % Phase-Synchrony - Intertrial - for each sensor separately, mean across trial-tro-trial phase diffs 
    SETvars.TFDparams.TFPS.method   = 'intertrial';

  % Phase-Synchrony - Interelec - mean of phase diffs between refelec and sensor across trials 
    SETvars.TFDparams.TFPS.method   = 'interelec';
    SETvars.TFDparams.TFPS.refelec  = 'FCZ';

  %  -------------------------------------
  %  TF Baseline - for 'B'aseline corrected TFDs, see above
  %  -------------------------------------

  % Baseline definition for Time-Freq surFactorsToExtractces (defaults to
  % entire prestimulus time)
    SETvars.TFDbaseline.start = -150;
    SETvars.TFDbaseline.end   =  -50;

  %  -------------------------------------
  %  Time-Frequency Energy distribitions
  %  -------------------------------------

  % bintfd - binomial TFTB
    SETvars.TFDparams.method        = 'bintfd';
  % SETvars.TFDparams.options      = ['''PosOnly'',''Analytic'',0,''Hanning''']; % options 

  % binomial TFD - Jeff Oneil's DTFT
    SETvars.TFDparams.method      = 'binomial2';

  % continuous wavelets - Matlab wavelet toolbox
    SETvars.TFDparams.method       =  'cwt';
    SETvars.TFDparams.scale_factor =    .25;
    SETvars.TFDparams.scale_number =     32;
    SETvars.TFDparams.wavelet      = 'morl';
    SETvars.TFDparams.abs          =      1;

  % RID Rihaczek - energy
    SETvars.TFDparams.method        = 'rid_rihaczek';
    SETvars.TFDparams.abs           = 1;

  %  -------------------------------------
  %  Time-Frequency Phase-Synchrony Distributions
  %  -------------------------------------

  % RID Rihaczek - Intertrial
    SETvars.TFDparams.method        = 'rid_rihaczek';
    SETvars.TFDparams.TFPS.method   = 'intertrial';

  % RID Rihaczek - Interelec
    SETvars.TFDparams.method        = 'rid_rihaczek';
    SETvars.TFDparams.TFPS.method   = 'interelec';
    SETvars.TFDparams.TFPS.refelec  = 'FCZ';

  % Wavelet (Matlab Toolbox) - Intertrial
    SETvars.TFDparams.method       = 'cwt';
    SETvars.TFDparams.scale_number = rsrate;
    SETvars.TFDparams.scale_factor =      1;
    SETvars.TFDparams.wavelet      =  'cmor1-1';
    SETvars.TFDparams.abs          =      0;
    SETvars.TFDparams.TFPS.method  = 'intertrial';

  % Wavelet (Matlab Toolbox) - Interelec
    SETvars.TFDparams.method       = 'cwt';
    SETvars.TFDparams.scale_number = rsrate;
    SETvars.TFDparams.scale_factor =      1;
    SETvars.TFDparams.wavelet      =  'cmor1-1';
    SETvars.TFDparams.abs          =      0;
    SETvars.TFDparams.TFPS.method  = 'interelec';
    SETvars.TFDparams.TFPS.refelec = 'FCZ';


