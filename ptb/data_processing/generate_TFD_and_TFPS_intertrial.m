function [erp_TFD,erp_TFD_ITPC,erp_avg] = generate_TFPS_interelec(erp,domainparms,TFPSparms,verbose),  

% generate_TFPS_interelec(erp,domainparms,TFPSparms,verbose),

% general vars 
  if ~exist('verbose','var'), verbose = 1; end

% create TFDs 

  % vars 
  if exist('domainparms')
    if ~isfield(domainparms,'domain'),       domainparms.domain = 'TFD';                 end
    if ~isfield(domainparms,'method'),       domainparms.method = 'rid_rihaczek';        end
    if ~isfield(domainparms,'samplerateTF'), domainparms.samplerateTF = erp.samplerate;  end
    if ~isfield(domainparms,'freqbins'),     domainparms.freqbins  = size(erp.data,2)/2; end
    if ~isfield(domainparms,'options'),      domainparms.options = [''];                 end  
  else,
    domainparms.domain = 'TFD';
    domainparms.method = 'rid_rihaczek';
    domainparms.samplerateTF = erp.samplerate;
    domainparms.freqbins  = size(erp.data,2)/2;
    domainparms.options = ['']; 
  end
  if ~isequal(domainparms.domain,'TFD'),
    disp(['ERROR:' mfilename ': requested TFD domain is not ''TFD''']);
    return
  end

  % generate trial TFD 
  erp_TFD = generate_TFDs(erp,domainparms,10); 

% create average TFPS 
  erp_TFD_ITPC = generate_TFPS_interelec(erp_TFD,TFPSparms,ones(size(erp.sweep)));

% create averaged TFD energy and time-domain voltage to go along with TFPS_IT 
  catcodes(1).name = 1; catcodes(1).text = 'erp.ttype~=-999'; erp.domain='time';
  erp_avg = aggregate_erp(erp,catcodes);
  erp_TFD_avg = aggregate_erp(erp_TFD,catcodes);

