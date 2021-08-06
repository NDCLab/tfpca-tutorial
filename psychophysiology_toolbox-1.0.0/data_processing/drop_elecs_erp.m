function [erp] = reduce_erp(erp_inname,reduce_text,verbose),
% [erp] = reduce_erp(erp_inname_erp,reduce_text,verbose), 
% 
% reduce_erp - reduce number of wavefoms based on reduce_text criteria 
% 
%   reduce_text example: 
%     reduce_text = 'erp.accept==1'; 
%     reduce_text = 'erp.correct==0|erp.correct==1'; 
% 
%   NOTE: also works for component score files -- 'components' variable (as of) 
%         Use 'erp' in reduce text -- i.e. refer to the input variable as 'erp' in criteria   
% 
% modified for TFDs 2/21/05 Edward Bernat 
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

  if exist('verbose'         ,'var')==0, verbose         =       0;      end

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
    if exist('components','var'), erp = components; clear components; end 
  else,
    erp = erp_inname; erp_inname = 'erp'; 
  end

% vars 
  if     ischar(reduce_text) | isstruct(reduce_text) | iscell(reduce_text), 
     try   eval(['reduce_vect = ' char(reduce_text) ';']); 
     catch disp(['WARNING: ' mfilename ': reduce_text ''' char(reduce_text) ''' failed, reduction not conducted']);
           disp(['WARNING text: ']);
           disp(lasterr); 
           return 
     end  
  elseif islogical(reduce_text) & length(reduce_text(:,1))==length(erp.elec), 
     reduce_vect = reduce_text;  
  end 

% main processing 

      if isequal(unique(reduce_vect),0),
        disp(['WARNING: ' mfilename ': specified criterion yields NO records, reduction not conducted']);
        return;
      end

    if isfield(erp,'components'),
      compnames = fieldnames(erp.components);
      for sn = 1:length(compnames),
        cur_compname = char(compnames(sn,:));
        eval(['erp.components.' cur_compname '=[erp.components.' cur_compname '(reduce_vect,:);];' ]);
      end
    end
    if isfield(erp,'data'),
    erp.data     = [     erp.data(reduce_vect,:,:) ;];
    end 
    if isfield(erp,'elec'),
    erp.elec     = [     erp.elec(reduce_vect,:) ;];
    end
    if isfield(erp,'sweep'),
    erp.sweep    = [    erp.sweep(reduce_vect,:) ;];
    end 
    if isfield(erp,'subnum'),
    erp.subnum   = [   erp.subnum(reduce_vect,:) ;];
    end
    if isfield(erp,'ttype'),
    erp.ttype    = [    erp.ttype(reduce_vect,:) ;];
    end 
    if isfield(erp,'correct'),
    erp.correct  = [  erp.correct(reduce_vect,:) ;];
    end
    if isfield(erp,'accept'),
    erp.accept   = [   erp.accept(reduce_vect,:) ;];
    end
    if isfield(erp,'rt'),
    erp.rt       = [       erp.rt(reduce_vect,:) ;];
    end
    if isfield(erp,'response'),
    erp.response = [ erp.response(reduce_vect,:) ;];
    end
    if isfield(erp,'set'),
    erp.set      = [      erp.set(reduce_vect,:) ;];
    end

    if isfield(erp,'stim'),     
      stimnames = fieldnames(erp.stim);
      for sn = 1:length(stimnames),
        cur_stimname = char(stimnames(sn,:));
        eval(['erp.stim.' cur_stimname '=[erp.stim.' cur_stimname '(reduce_vect,:);];' ]);
      end
    end


