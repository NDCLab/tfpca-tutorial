% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% ---- NOT FINISHED ---- 

statvar = 'erp.stim.content'; 

eval(['uvar = unique(' statvar ');' ]);  
numofsubs = length(unique(erp.subnum)); 
numofelecs= length(unique(erp.elec)); 

for j = 1:length(uvar), 

  (length(erp.elec(erp.stim.content==uvar(j))) / numofelecs) /numofsubs  

end 
  
