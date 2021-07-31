function [trial_count] = trial_count(erp,countvect,splitvect), 

% [trial_count] = trial_count(erp,countvect[,splitvect]),
% 
%    returns a ascending count separately for each value in
%    countvect, separately within splitvect.  
% 
%    countvect - vector, or string with name of variable  
%    splitvect - vector, or string with name of variable 
%                (usually erp.subnum; defaults to all ones -- no split)
% 
% Psychophysiology Toolbox - Data Processing 0.0.5-6, Edward Bernat, University of Minnesota  

  % vars 
  try,   
    eval(['vcount = ' countvect ';']);
  catch, 
    vcount = countvect; 
  end 
 
  if exist('splitvect','var'), 
    try,  
      eval(['vsplit = ' splitvect ';']); 
    catch, 
      vsplit = splitvect; 
    end  
  else, 
           vsplit = ones(size(erp.elec)); 
  end 

  % count 
  us = unique(vsplit); 
  uc = unique(vcount);
  elecs = unique(erp.elec);
  trial_count = zeros(size(erp.elec));
  for s = 1:length(us), 
    for e=1:length(elecs),
      for c = 1:length(uc),
        tc = find(vcount==uc(c)&vsplit==us(s)&erp.elec==elecs(e));
        for j = 1:length(tc),
          trial_count(tc(j)) = j;
        end
      end
    end
  end 
 
