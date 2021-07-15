function [epochs] = count_epochs(erp), 

% [epochs] = count_epochs(erp) 
% 
% counts epochs, based on counting elecs from low to high.  Drop from high to low indicates new epoch. 
% 

epochs = zeros(size(erp.elec)); 
epoch_count = 1; 
cur_elec  = erp.elec(1); 
for jj=1:length(erp.elec), 

  new_elec  = erp.elec(jj); 
  if new_elec < cur_elec, 
    epoch_count = epoch_count + 1;
  end 
  epochs(jj) = epoch_count;
  cur_elec  = erp.elec(jj);
  
end

