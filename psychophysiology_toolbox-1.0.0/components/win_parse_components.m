% Psychophysiology Toolbox, Components, University of Minnesota  

  % parse components for WIN script  

  comps_defs_text = comps_defs; 
  clear comps_defs;  
 
  components = [];

   for j = 1:length(comps_defs_text(:,1)),
     [comps_defs(j).name, ...
      comps_defs(j).blsbin, ...
      comps_defs(j).blebin, ...
      comps_defs(j).startbin, ...
      comps_defs(j).endbin, ...
      comps_defs(j).minmax, ...
      comps_defs(j).measures ] = strread(char(comps_defs_text(j,:)),'%s%f%f%f%f%s%s');
%     if verbose > 0,   
%       disp(sprintf(['Component bin definition: %s\t startbin: %0.4g\t endbin: %0.4g\t '] ...
%                ,char(comps_defs(j).name),comps_defs(j).startbin,comps_defs(j).endbin) );
%      end
   end

   clear comps_defs_text; 

