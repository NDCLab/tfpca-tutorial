% Psychophysiology Toolbox, Components, University of Minnesota  

% unpack IDvars into individual variables 

% general variables 
  dataset_name = IDvars.dataset_name  ;  
  rs           = IDvars.rs            ;
  runtype      = IDvars.runtype       ;
  verbose      = IDvars.verbose       ;
  domain       = IDvars.domain        ; 

% runtype specific variables 
switch IDvars.runtype 
case {'pcatfd'}   
  timebinss    = IDvars.timebinss     ;
  startbin     = IDvars.startbin      ;
  endbin       = IDvars.endbin        ;
  fqbins       = IDvars.fqbins	      ;
  fqstartbin   = IDvars.fqstartbin    ;
  fqendbin     = IDvars.fqendbin      ;
  fqamp01      = IDvars.fqamp01       ;
  dmx          = IDvars.dmx           ;
  rot	       = IDvars.rot	      ;
  fa           = IDvars.fa            ;
case {'wintfd'}				      
  timebinss    = IDvars.timebinss     ;
  startbin     = IDvars.startbin      ;
  endbin       = IDvars.endbin        ;
  fqbins       = IDvars.fqbins        ;
  fqstartbin   = IDvars.fqstartbin    ;
  fqendbin     = IDvars.fqendbin      ;
  fqamp01      = IDvars.fqamp01       ;
  comps_name   = IDvars.comps_name    ;
  comps_defs   = IDvars.comps_defs    ;
case {'pca'}				      
  startbin     = IDvars.startbin      ;
  endbin       = IDvars.endbin        ;
  dmx          = IDvars.dmx           ;
  rot	       = IDvars.rot	      ;
  fa           = IDvars.fa            ;
case {'win'}				      
  startbin     = IDvars.startbin      ;
  endbin       = IDvars.endbin        ;
  comps_name   = IDvars.comps_name    ;
  comps_defs   = IDvars.comps_defs    ;
end 

% use IDvars to create other variables 
eval(['erpfname = ''' dataset_name '_' num2str(rs) ''';' ]);

switch runtype
case 'pcatfd'

  eval(['ID=''' dataset_name '-'    runtype              ...
                             '-rs'  num2str(rs)          ...
                             '-t'   num2str(timebinss)   ...
                             's'    num2str(startbin)    ...
                             'e'    num2str(endbin)      ...
                             '-f'   num2str(fqbins)      ...
                             's'    num2str(fqstartbin)  ...
                             'e'    num2str(fqendbin)    ...
                             '-fqA'  num2str(fqamp01)    ...
                             '-DMX'  num2str(dmx)        ...
                             '-ROT'  rot                 ...
                             '-fac'  num2str(fa)         ...
                             ''';']);

  eval(['tfdfname = ''' dataset_name '_' num2str(rs) '_t' num2str(timebinss) 'f' num2str(fqbins) ''';' ]);

case 'wintfd'

  eval(['ID=''' dataset_name '-'    runtype              ...
                             '-rs'  num2str(rs)          ...
                             '-t'   num2str(timebinss)   ...
                             '-f'   num2str(fqbins)      ...
                             '-fqA'  num2str(fqamp01)    ...
                             '-'    comps_name           ...
                             ''';']);

  eval(['tfdfname = ''' dataset_name '_' num2str(rs) '_t' num2str(timebinss) 'f' num2str(fqbins) ''';' ]);

case 'pca'

 eval(['ID=''' dataset_name  '-'    runtype              ...
                             '-rs'  num2str(rs)          ...
                             '-s'   num2str(startbin)    ...
                             '-e'   num2str(endbin)      ...
                             '-DMX' num2str(dmx)         ...
                             '-ROT' num2str(rot)         ...
                             '-fac' num2str(fa)          ...
                             ''';']);

case 'win'

 eval(['ID=''' dataset_name  '-'    runtype              ...
                             '-rs'  num2str(rs)          ...
                             '-'    comps_name           ...
                             ''';']);

end

 
