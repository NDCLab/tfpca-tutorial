
% epsmerge_cmd = ['perl -w -I' psychophys_components_path filesep 'epsmerge' filesep 'lib ' psychophys_components_path filesep 'epsmerge' filesep 'epsmerge'];
  epsmerge_cmd = ['perl -w -I' epsmerge_path filesep 'lib ' epsmerge_path filesep 'epsmerge'];

  epsmerge_full = [epsmerge_cmd ' -x ' num2str(numofcols) ' -y ' num2str(numofrows) ' -O L -tmar 80 -bmar 80 -rmar 70 --header ts16 --script ''"' mergename_title '"'' -o ' output_plots_path filesep mergename '.eps ' files2merge  ];

  if ispc,
    fid = fopen([output_plots_path filesep mergename '.bat'],'w');
    fwrite(fid,epsmerge_full);
    fclose(fid);
    evalc(['!' output_plots_path filesep mergename '.bat']);
    if exist([output_plots_path filesep mergename '.eps'])~=0,
      delete([output_plots_path filesep mergename '.bat']);
    end
%   evalc(['!' epsmerge_full ]);
  elseif isunix,
%   fid = fopen([output_plots_path filesep mergename '.bat'],'w');
%   fwrite(fid,epsmerge_full);
%   fclose(fid);
%   evalc(['!' output_plots_path filesep mergename '.bat']);
%   if exist([output_plots_path filesep mergename '.eps'])~=0,
%     delete([output_plots_path filesep mergename '.bat']);
%   end
    evalc(['!' epsmerge_full ]);
  end

  evalc(['!ps2pdf ' output_plots_path filesep mergename '.eps ' output_plots_path filesep mergename '.pdf' ]); % - removed by JH 03.20.17

  % Segment below added by JH on 08.08.19 for compatibility with Matlab 2018b. ghostscript is no longer shipped with Matlab, and so three ghostscript arguments need to be passed to ps2pdf  
% addpath([psychophys_path 'bundled_external_software' filesep]);
% ghost_lib_search = dir([ghost_path '/share/ghostscript/**/lib*']);
% ghost_path_lib = [ghost_lib_search(1).folder '/lib/'];
% ghost_path_gs  = [ghost_path '/bin/gs'];
% clear ghost_lib_search

% evalc(['ps2pdf(''psfile'', '''  output_plots_path filesep mergename '.eps'', ''pdffile'', ''' output_plots_path filesep mergename '.pdf'', ''gslibpath'', ghost_path_lib, ''gscommand'', ghost_path_gs,''gsfontpath'', ghost_path_lib)' ]); 

%  evalc(['ps2pdf(''psfile'', '''  output_plots_path filesep mergename '.eps'', ''pdffile'', ''' output_plots_path filesep mergename '.pdf'')' ]); % added by JH 03.20.17
% rmpath([psychophys_path 'bundled_external_software' filesep]);


% old style - before windows .bat files 
% epsmerge_cmd = ['perl -w -I' psychophys_components_path filesep 'epsmerge' filesep 'lib ' psychophys_components_path filesep 'epsmerge' filesep 'epsmerge'];
% evalc(['!' epsmerge_cmd ' -x ' num2str(numofcols) ' -y ' num2str(numofrows) ' -O L -tmar 80 -bmar 80 -rmar 70 --header ts16 --script ''"' mergename_title '"'' -o ' output_plots_path filesep mergename '.eps ' files2merge  ]);
% evalc(['!ps2pdf ' output_plots_path filesep mergename '.eps ' output_plots_path filesep mergename '.pdf' ]);

% cleanup
% if exist([output_plots_path filesep mergename '.eps'])~=0,
%   delete([output_plots_path filesep ID '-plot_*.eps']);
% end

 
