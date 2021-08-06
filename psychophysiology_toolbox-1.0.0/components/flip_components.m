function [components] = flip_components(RunID,components2flip), 

% flip_components(RunID,components2flip)  
% 
%  RunID           - ID from _startup script, see, e.g. pcatfd_startup  
%  components2flip - numeric value of commponent  
% 
 
% paths 
    psychophysiology_toolbox_paths_defaults;
    psychophysiology_toolbox_parameters_defaults;

% check existence of file 
  if ~exist([output_data_path '/' RunID '-PCs.mat']), 
    error([' RunID does not exist']); 
  end 

% load data 
  load([output_data_path '/' RunID '-PCs.mat']);
 
% flip components 
  for cc = 1:length(components2flip),  
    P(components2flip(cc),:) = P(components2flip(cc),:) * -1;
    if exist('Pmat'), 
      Pmat(:,:,components2flip(cc)) = Pmat(:,:,components2flip(cc)) * -1; 
    end 
  end 

% save PCs 
  if exist('Pmat'),
    save([output_data_path '/' RunID '-PCs'],'LATENT','EXPLAINED','P','Pmat'); 
  else, 
    save([output_data_path '/' RunID '-PCs'],'LATENT','EXPLAINED','P');
  end 

% remove any generated components files, so they will be regenerated with flipped PCs 
  delete([output_data_path '/' RunID '.*']);

 
