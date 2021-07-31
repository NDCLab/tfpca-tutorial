function [Cvals] = base_comparison_var(X,erp,Cset,elecval), 

% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 

  if isempty(elecval), 
        elecvec = []; 
  else, elecvec = erp.elec; 
  end 
  for j=1:length(Cset.var), 
      if ~isfield(Cset.var(j),'DV'), 
        Cset.var(j).DV='component'; 
      elseif isempty(Cset.var(j).DV), 
        Cset.var(j).DV='component'; 
      end 
  end 
 
% main 

  if     length(Cset.var)==1, 

    % create data 
    eval(['CATcrit = ' Cset.var.crit ';']); 
    if isequal(Cset.var.DV,'component'), 
      [Cvals.vals,Cvals.subnums] = base_uni2multi(X,CATcrit,erp.subnum,elecvec,elecval);
    else, 
      eval(['x = ' Cset.var.DV ';']);  
      [Cvals.vals,Cvals.subnums] = base_uni2multi(x,CATcrit,erp.subnum,elecvec,elecval);
    end 

  elseif length(Cset.var)>=2, 

    % create data for each value of set 
    for j = 1:length(Cset.var), 
      if isequal(Cset.var(j).DV,'component'),
        eval(['CATcrit = ' Cset.var(j).crit ';' ]); 
        [Cvals(j).vals,Cvals(j).subnums]  = base_uni2multi(X,CATcrit,erp.subnum,elecvec,elecval);
      else,
        eval(['x = ' Cset.var(j).DV ';']);
        [Cvals.vals,Cvals.subnums]        = base_uni2multi(x,CATcrit,erp.subnum,elecvec,elecval);
      end
    end 

    % delete pairwise missing values 
    Cvals = base_comparison_deletion_pairwise(Cvals,erp.subnum); 

    % get difference value 
    Cvals = base_comparison_difference_subject(Cvals); 

  end 

