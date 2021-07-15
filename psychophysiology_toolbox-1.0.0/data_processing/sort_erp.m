function erp = sort_erp(erp,sortindex), 

% sort_erp(erp,sortindex) 
% 
%  Sorts all relevant internal vectors from the given sort index vector 
% 
%  sortindex - can be either a vector of length erp.elec to sort by, 
%              or the name of an internal vector (e.g. erp.elec) 
% 
%  NOTE: tested with time, freq, and TFD data types  

if isstr(sortindex), 
  [sorttoss,sortindex] = sort(eval(sortindex)); 
end 

% main vector sort 
erp.data     =     erp.data(sortindex,:,:);
erp.elec     =     erp.elec(sortindex);
erp.sweep    =    erp.sweep(sortindex); 
erp.correct  =  erp.correct(sortindex);
erp.accept   =   erp.accept(sortindex);
erp.ttype    =    erp.ttype(sortindex);
erp.rt       =       erp.rt(sortindex);
erp.response = erp.response(sortindex);


% .stim variables sort  
  if isfield(erp,'stim'),
    stimnames = fieldnames(erp.stim);
    for sn = 1:length(stimnames),
      cur_stimname = char(stimnames(sn,:));
      eval(['erp.stim.' cur_stimname '=erp.stim.' cur_stimname '(sortindex,:);' ]);
    end
  end
 
