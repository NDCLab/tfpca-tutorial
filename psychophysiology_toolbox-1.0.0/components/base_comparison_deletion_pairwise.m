function [vals] = pairwise_delete(vals,subnum_big); 

% Psychophysiology Toolbox, Components, University of Minnesota  

    % delete pairwise missing values 
    usn = []; 
    for j = 1:length(vals), 
      usn = [usn; unique(vals(j).subnums);]; 
    end 
    usn = unique(usn); 

    badsubnums = [];
    for j = 1:length(usn),
      for k = 1:length(vals),
        if  isempty(find(vals(k).subnums==usn(j))), 
            badsubnums = [badsubnums usn(j)];     end
      end
    end 

    badsubnums = unique(badsubnums);

    if ~isempty(badsubnums),
      for j=1:length(vals),
        reject_subs = zeros(size(vals(j).subnums)); 
        t = []; 
        for k=1:length(badsubnums),
          t = [t; find(vals(j).subnums==badsubnums(k));]; 
        end
        reject_subs(t)=1;
        vals(j).subnums = vals(j).subnums(reject_subs==0);
        vals(j).vals    =    vals(j).vals(reject_subs==0,:);
      end
    end


