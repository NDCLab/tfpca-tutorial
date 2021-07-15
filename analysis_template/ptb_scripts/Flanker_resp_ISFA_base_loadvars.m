% -----------------------------------------------------------------------------
% This loadvars script has several parameters that can be set. Examples of such parameters are:
  % The setup of catcodes (category codes) from triggers.
  % Setting parameters for subsampling.
  % Links to electrode location files (.ced).
  % Output plot parameters.
% -----------------------------------------------------------------------------
% The following section  sets up catcodes.
  clear catcodes %Clears any leftover information that may be in the "catcodes" variable. Prevents interference with the new catcodes that follow.

  %Note: The '(#)' following catcodes is the numerical designation. This is different from it's catcodes name, and the name and number do not have to be identical. 
  %Note: Catcodes names will be used to reference this catcode later on. Catcode names can be numerical or characters with a length of 2
  %Note: Triggers must be defined as characters, within a pair of single-quotations. The '&', '|', '>=', and '<=' signs can be useful at these steps.
  %Note: It is reccomended to leave a note following each catcode to define it's category..

  catcodes(1).name   = 1; catcodes(1).text  = 'erp.stim.bin==4'; % congruent & corr
  catcodes(2).name   = 2; catcodes(2).text  = 'erp.stim.bin==5'; % incongruent & error
  catcodes(3).name   = 3; catcodes(3).text  = 'erp.stim.bin==6'; % incongruent & corr
  
% Prepares catcodes variables to be run.
  trl2avg.catcodes = catcodes;
  trl2avg.verbose = 1;
  SETvars.trl2avg = trl2avg; clear trl2avg

% Specifies to save data in data_cache (Options: 0 No, 1 Yes).
  SETvars.cache_erp = 1; 
  
  SETvars.electrode_locations = '''erp_core_35_locs.ced''';
  SETvars.electrode_to_plot   = 'FCz';

% Subsampling Parameters:
% Note: These parameters are temporarily modified in "base_averages".
  SETvars.trl2avg.OPTIONS.subsampling                   = [];
  SETvars.trl2avg.OPTIONS.subsampling.method            = 'user_defined';                                  % Points scripts that use this file towards the named subsampled file below.
  SETvars.trl2avg.OPTIONS.subsampling.subsample_length  = [  8];                                           % Number of trials to go into each average. Each subject must have enough trials available for each catcode.
  SETvars.trl2avg.OPTIONS.subsampling.num_of_subsamples = [ 25];                                           % Total number of subsamples.
  SETvars.trl2avg.OPTIONS.subsampling.boot_samples      = [ 0];                                            % Total number of boot samples.
  SETvars.trl2avg.OPTIONS.subsampling.static_sets       = 'Flanker_resp_ISFA_base_averages_subsampling';   % Name for finished subsampled file.
  