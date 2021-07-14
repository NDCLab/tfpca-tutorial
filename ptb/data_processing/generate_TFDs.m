function [erptfd] = TFDs(erp_inname,domainparms,verbose),

% [erptfd] = TFDs(erp_inname,domainparms,verbose), 
% 
%   erp_inname     - erp data structure, or input data file name with erp data structure   
%   domainparms    - TF transform parameters 
%   verbose        - 0=off, >=1=on 
% 
%   domainparms is a structured variable with the following options: 
% 
%     domain       = 'TFD';
%     samplerateTF =  requested interpolation in time after TFD computation 
%     freqbins     =  IDvars.fqbins;
%     method       = 'bintfd';   
% 
% 
%    NOTE:   see individual generate_TFDs wrapper functions for required  
%            and optional parameters for any specific transform  
% 
%    Default - if domain parms not specified, or some parameters left out 
% 
%            domainparms.domain = 'TFD'; 
%            domainparms.method = 'bintfd'; 
%            domainparms.samplerateTF = erp.samplerate; 
%            domainparms.freqbins  = 128; 
% 
% 
% Edward Bernat, University of Minnesota  

  % load and prep data 
    if isstr(erp_inname),
      load(erp_inname);
    else,
      erp = erp_inname; erp_inname = 'erp';
    end
    erp.data=double(erp.data);

  % vars 
    trials = length(erp.elec);

    if ~exist('verbose','var'), verbose = 1; end 
    if exist('domainparms') 
      if ~isfield(domainparms,'domain'),       domainparms.domain = 'TFD'; end
      if ~isfield(domainparms,'method'),       domainparms.method = 'bintfd'; end  
      if ~isfield(domainparms,'samplerateTF'), domainparms.samplerateTF = erp.samplerate; end  
      if ~isfield(domainparms,'freqbins'),     domainparms.freqbins  = 128; end  
    else, 
      domainparms.domain = 'TFD'; 
      domainparms.method = 'bintfd'; 
      domainparms.samplerateTF = erp.samplerate; 
      domainparms.freqbins  = 128; 
    end 
    if ~isequal(domainparms.domain,'TFD'), 
      disp(['ERROR:' mfilename ': requested domain is not ''TFD''']); 
      return  
    end 

  % Generate the tfds
    if verbose > 0,
    disp(['Generating TFDs - TFD surface resamplerate:'  num2str(domainparms.samplerateTF) ... 
                                           ' freqbins:'  num2str(domainparms.freqbins)     ... 
                                     ' ERP samplerate:'  num2str(erp.samplerate)           ... 
                                             ' Trials:'  num2str(trials)                  ... 
                                       ' Distribution:'  domainparms.method  ]);
    end

  % Generate TFDs - call external script to handle details for specified TFD toolbox  
  switch domainparms.method, 
  case {'bintfd','borjor'},           eval(['generate_TFDs_tftb_quantum_signal;' ]); 
  case {'binomial2','born_jordan2'},  eval(['generate_TFDs_dtfd_jeff_oneil;' ]);
  case {'cwt','dwt'},                 eval(['generate_TFDs_matlab_wavelet_toolbox;']); % NOTE: dwt not tested, and may not work 
  case {'rid_rihaczek'},              eval(['generate_TFDs_rid_rihaczek;']); 
  otherwise, 
    if exist(['generate_TFDs_' domainparms.method])==2,  
      eval(['generate_TFDs_' domainparms.method ';']);  
    else, 
      disp(['ERROR:' mfilename ': TFD method undefined, no TFDs were produced']); 
      erptfd = 0;  
      return 
    end  
  end 

  % closing vars 
  if ~isequal(erptfd,0), 
    erptfd.samplerate   = erp.samplerate;
    erptfd.samplerateTF = domainparms.samplerateTF;
    erptfd.tbin        = round((erp.tbin)*(domainparms.samplerateTF/erp.samplerate));
    erptfd.domain       = 'TFD'; 
  end 

