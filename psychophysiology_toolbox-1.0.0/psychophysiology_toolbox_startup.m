% COMPONENTS-0.0.7-3, Edward Bernat, University of Minnesota  

  % define paths 
  psychophysiology_toolbox_paths_defaults; 

  % core toolbox scripts 
  disp(sprintf(['\nPsychophysiology Toolbox veryfying and adding paths ... ']));
  disp(sprintf(['\n  Verifying core toolbox paths ... \n'])); 

  if ~exist(psychophys_components_path,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid psychophys_components_path: '                 psychophys_components_path ]);  
  else,                                        disp(['  FOUND: psychophys_components_path:      '                                                            psychophys_components_path ]); end

  if ~exist(psychophys_dataproc_path  ,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid psychophys_dataproc_path:   '                 psychophys_dataproc_path   ]); 
  else,                                        disp(['  FOUND: psychophys_dataproc_path:        '                                                            psychophys_dataproc_path   ]); end

  if ~exist(psychophys_dataimport_path,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid psychophys_dataimport_path:   '               psychophys_dataimport_path ]);
  else,                                        disp(['  FOUND: psychophys_dataimport_path:      '                                                            psychophys_dataimport_path ]); end

  if ~exist(psychophys_general_path   ,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid psychophys_general_path:    '                 psychophys_general_path    ]); 
  else,                                        disp(['  FOUND: psychophys_general_path:         '                                                            psychophys_general_path    ]); end

  if ~exist(psychophys_gui_path       ,'dir'), disp(['  WARNING: gui toolbox will not operate       -- invalid psychophys_gui_path:        '                 psychophys_gui_path        ]); 
  else,                                        disp(['  FOUND: psychophys_gui_path:             '                                                            psychophys_gui_path        ]); end

  % internal toolbox scripts  
  addpath(psychophys_path, ... 
          psychophys_components_path,  ...
          psychophys_dataproc_path, ...
          psychophys_dataimport_path, ...
          psychophys_general_path, ... 
          '-BEGIN'); 

  % required directory structure 
  disp(sprintf(['\n  Verifying directories for scripts, cache, and output ... \n']));
 
  if ~exist(data_cache_path           ,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid data_cache_path:            '                 data_cache_path            ]); 
  else,                                        disp(['  FOUND: dir_data_cache:                  '                                                            data_cache_path            ]); end

  if ~exist(output_plots_path         ,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid output_plots_path:          '                 output_plots_path          ]); 
  else,                                        disp(['  FOUND: dir_output_plots:                '                                                            output_plots_path          ]); end

  if ~exist(output_data_path          ,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid output_data_path:           '                 output_data_path           ]); 
  else,                                        disp(['  FOUND: dir_output_data:                 '                                                            output_data_path           ]); end

  if ~exist(scripts_path              ,'dir'), disp(['  WARNING: components toolbox may not operate -- invalid scripts_path:               '                 scripts_path               ]); 
  else,                                        disp(['  FOUND: dir_scripts:                     '                                                            scripts_path               ]); end

  % user direcotries 
  if exist(data_cache_path),         addpath(data_cache_path);      end
  if exist(output_plots_path),       addpath(output_plots_path);    end
  if exist(output_data_path),        addpath(output_data_path);     end
  if exist(scripts_path),            addpath(scripts_path);         end

  % external toolboxes 

  % EEGLAB  
  disp(sprintf(['\n  Verifying paths for external bundled scripts ... \n']));
  if ~exist(eeglab_path               ,'dir'), disp(['  WARNING: components toolbox will fail topographic plotting -- invalid eeglab_path:               '   eeglab_path                ]); 
  else,                                        disp(['  FOUND: eeglab_path:                     '                                                            eeglab_path                ]); end
  % EPS merge 
  if ~exist(epsmerge_path             ,'dir'), disp(['  WARNING: components toolbox will not integrate plots -- invalid epsmerge_path:                   '   epsmerge_path              ]); 
  else,                                        disp(['  FOUND: epsmerge_path:                   '                                                            epsmerge_path              ]); end
  % PCA_Toolbxo (Joe Dien) 
  if ~exist(PCA_Toolbox_path          ,'dir'), disp(['  WARNING: components toolbox will not run doPCA from the PCA_Toolbox -- invalid PCA_Toolbox_path: '   PCA_Toolbox_path           ]);
  else,                                        disp(['  FOUND: PCA_Toolbox_path:                '                                                            PCA_Toolbox_path           ]); end

  addpath(epsmerge_path,eeglab_path,PCA_Toolbox_path); 

  % DiscreteTFD Toolbox 
  disp(sprintf(['\n  Looking for supported time-frequency toolboxes ... \n']));

  if ~exist(dtfd_toolbox_path         ,'dir'), disp(['  WARNING: DiscreteTFD Toolbox (GPL) not installed - TFDs using the DTFD not available -- dtfd_toolbox_path: '    dtfd_toolbox_path ]); 
  else,                                        disp(['  FOUND: DiscreteTFD Toolbox (GPL) - dtfd_toolbox_path:            '                                              dtfd_toolbox_path ]); 
                                               addpath(dtfd_toolbox_path);  
  end 

  % Rihaczek RID with phase coherence 
  if ~exist(rid_rihaczek_toolbox_path ,'dir'), disp(['  WARNING: Rihaczek RID (GPL) not installed - TFDs and TFPCs using rid_rihaczek not available -- rid_rihaczek_toolbox_path: '    rid_rihaczek_toolbox_path ]);
  else,                                        disp(['  FOUND: Rihaczek RID (GPL) - rid_rihaczek_toolbox_path:           '                                                             rid_rihaczek_toolbox_path ]);
                                               addpath(rid_rihaczek_toolbox_path);
  end

  % Time-Frequency Toolbox (Quantum Signal) 
  if ~exist(tftb_toolbox_path         ,'dir'), disp(['  WARNING: Time-Frequency Toolbox (Q.S) not installed - TFDs using the TFTB not available -- tftb_toolbox_path: ' tftb_toolbox_path ]); 
  else,                                        disp(['  FOUND: Time-Frequency Toolbox (Q.S.) - tftb_toolbox_path:        '                                              tftb_toolbox_path ]); 
                                               addpath(tftb_toolbox_path);   
  end

  % Matlab Wavelet Toolbox  
  wavelet_toolbox_ver = ver; wavelet_toolbox_ver = {wavelet_toolbox_ver.Name}; wavelet_toolbox_ver = strmatch('Wavelet Toolbox',wavelet_toolbox_ver);
  if  isempty(wavelet_toolbox_ver),          , disp(['  WARNING: components toolbox will not generate Wavelets using the Matlab Wavelet Toolbox -- not installed '                      ]); 
  else,                                        disp(['  FOUND: Matlab Wavelet Toolbox (Mathworks Inc.)'                                                                                 ]); 
  end

  disp(sprintf(['\nPsychophysiology Toolbox completed verifying and adding paths. \n']));

  disp(sprintf(['\nPsychophysiology Toolbox starting figure windows ... \n']));
 %figures_startup; 

