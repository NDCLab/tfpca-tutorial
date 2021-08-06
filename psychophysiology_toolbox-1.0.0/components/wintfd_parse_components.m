% Psychophysiology Toolbox, Components, University of Minnesota  

  % parse components for WINTFD  

  comps_defs_text = comps_defs; 
  clear comps_defs;  
 
  components = [];

   for j = 1:length(comps_defs_text(:,1)),
     [comps_defs(j).name, ...
      comps_defs(j).timesbin, ...
      comps_defs(j).timeebin, ...
      comps_defs(j).freqsbin, ...
      comps_defs(j).freqebin, ...
      comps_defs(j).minmax, ...
      comps_defs(j).measures ] = strread(char(comps_defs_text(j,:)),'%s%f%f%f%f%s%s');
%     if verbose > 0,   
%       disp(sprintf(['Component bin definition: %s\t time_start: %0.4g\t time_end: %0.4g\t freq_start: %0.4g\t freq_end: %0.4g\t'] ...
%                ,char(comps_defs(j).name),comps_defs(j).timesbin,comps_defs(j).timeebin,comps_defs(j).freqsbin,comps_defs(j).freqebin) );
%      end
   end

   clear comps_defs_text; 

