% Psychophysiology Toolbox, Components, University of Minnesota  

% create IDvars 

% general variables 

  IDvars.dataset_name = dataset_name     ;
  IDvars.rs           = rs               ;
  IDvars.runtype      = runtype          ;
  IDvars.verbose      = verbose          ;
  IDvars.domain       = domain           ; 

% runtype specific variables 
switch runtype
case {'pcatfd'}
  IDvars.timebinss    = timebinss 	 ;
  IDvars.startbin     = startbin 	 ;
  IDvars.endbin       = endbin  	 ;
  IDvars.fqbins       = fqbins  	 ;
  IDvars.fqstartbin   = fqstartbin 	 ;
  IDvars.fqendbin     = fqendbin 	 ;
  IDvars.fqamp01      = fqamp01          ;
  IDvars.dmx          = dmx 		 ;
  IDvars.rot          = rot 		 ;
  IDvars.fa           = fa               ;
case {'wintfd'}
  IDvars.timebinss    = timebinss 	 ;
  IDvars.startbin     = startbin         ;
  IDvars.endbin       = endbin           ;
  IDvars.fqbins       = fqbins  	 ;
  IDvars.fqstartbin   = fqstartbin       ;
  IDvars.fqendbin     = fqendbin         ;
  IDvars.fqamp01      = fqamp01 	 ;
  IDvars.comps_name   = comps_name       ;
  IDvars.comps_defs   = comps_defs       ;
case {'pca'}
  IDvars.startbin     = startbin 	 ;
  IDvars.endbin       = endbin  	 ;
  IDvars.dmx          = dmx              ;
  IDvars.rot          = rot 		 ;
  IDvars.fa           = fa               ;
case {'win'}
  IDvars.startbin     = startbin         ;
  IDvars.endbin       = endbin           ;
  IDvars.comps_name   = comps_name       ;
  IDvars.comps_defs   = comps_defs       ;
end

