% Path defaults 
% 
% Paths here can be overridden using a psychophysiology_toolbox_paths.m script file on the path.  
% 
% Psychophysiology Toolbox, Components, Edward Bernat, University of Minnesota  

% paths to toolboxes 

% vars 
  tpath=which('psychophysiology_toolbox_startup'); 
  fileseps = find(tpath==filesep); 
  if ~isempty(fileseps), tpath=tpath(1:fileseps(length(fileseps))); end

% internal toolbox paths  
  psychophys_path            = [tpath                   ];  
  psychophys_components_path = [tpath 'components'      ]; 
  psychophys_dataproc_path   = [tpath 'data_processing' ]; 
  psychophys_dataimport_path = [tpath 'data_import'     ];
  psychophys_general_path    = [tpath 'general'         ];
  psychophys_gui_path        = [tpath 'gui'             ];

% paths to user directories: scripts, data and output directories 
  output_plots_path          = ['.' filesep 'output_plots'    ];
  output_data_path           = ['.' filesep 'output_data'     ];
  data_cache_path            = ['.' filesep 'data_cache'      ];
  scripts_path               = ['.' filesep 'scripts'         ];

% External toolboxes/scripts  

  % paths to external GPL toolboxes bundled with Psychophysiology Toolbox 
    % epsmerge - for coalating .eps files into one large plot 
    epsmerge_path              = [tpath 'bundled_external_software' filesep 'epsmerge'];
    % eeglab - for topographic plotting routines 
    eeglab_path                = [tpath 'bundled_external_software' filesep 'eeglab'];
    % PCA_Toolbox (Joe Dien) 
    PCA_Toolbox_path           = [tpath 'bundled_external_software' filesep 'PCA_Toolbox']; 

  % time-frequency toolboxes 
 
    % Time-Frequency ToolBox - Quantum Signal 
    tftb_toolbox_path          = [tpath '..' filesep 'tftb'];
    % DiscreteTFD - for GPL Cohen's class RID implementation 
    dtfd_toolbox_path          = [tpath 'bundled_external_software' filesep 'dtfd'];
    % Rihaczek RID - for GPL Cohen's class complex RID implementation for phase-coherence  
    rid_rihaczek_toolbox_path  = [tpath 'bundled_external_software' filesep 'rid_rihaczek_PC'];

% load externally defined values if present 
  if exist('psychophysiology_toolbox_paths')==2,
    psychophysiology_toolbox_paths;
  end

% cleanup 
  clear tpath fileseps
