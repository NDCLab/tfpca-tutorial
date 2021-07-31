COMPONENTS Toolbox changelog 

09/01/2004 - 0.0.8 

   -Changed Behavior:
     -base_pcasvd - now outputs explained variance, and included in all output files. 
   -Bug Fixes:

05/31/2004 - 0.0.7-4 
   -Changed Behavior: 
     -SETvars.electrode_topomapparms - to modify topomap parameters
     -mask in wintfd now displays only activity associated with a given
         component instead of letter some 'show through' -- more accurate 
     -cache_clear - now accepts limitations on clearing with the parameters: 
           'data_cache', 'output_data', and 'output_plots' 
         This was done to correspond more obviously with the directories.  
         Old parameter names were: 
           'tfds', 'data', and 'plots'  
     -output_data - new file with ONLY PCs written 
         - Done in order to substitude PCs from other RunIDs. 
         - scripts check if -PCs files exists and builds component score set using
           that -- i.e. PC surfaces must be identical size/shape.  
          
   -Bug Fixes:
     -base_comparison_statistics - correlation didn't pairwise delete before
             checking that there were enough unique values to run the corr.
             Rare possibility that this would crash happened -- now fixed.
     -base_plot_topo_comparison_statistics - changed display of N to use
             the actual N used in stats (Cval now passed back by
             base_comparison_statistics with pairwise deletion if
             within-subjects or correlation is used)
     -base_comparison_set - made ALL pairwise deletion happen here or under 
             here in base_comparison_var. removed from stats scripts 
     -minor fixes in the help for several functions 

01/15/2004 - 0.0.7-3

  -Changed Behavior 
    -base_components_export - now uses export_ascii with reversed inname/outname
    -fqA parameter - now accepts
          L-log - log all energy values - problems if there are neg #s - 0=.01
          F-1/f - amplify energy by frequency (multiply) -- or use 1
          S-standardize by whole epoch
          K-Standardize by baseline epoch
          B-Baseline adjust (ERSP)
 
  -Bug Fixes:
     -median topomap plotting not working for differences and stats, now all
             rely on base_plot_topo_vars_cur_measures_order

10/15/2003 - 0.0.7-2 
  -Changed Behavior: 
   -N's now included on topo diff/stats plots 

  -Bug Fixes: 
   -correlation difference waves/maps - were using incorrect splits (grouphi==1&grouplo==0) 
                                      - also for pctile and std cases hi/lo reversed  
                                      - not doing pairwise deletion to make sure
                                        N's are equal -- now it does.  

08/04/2003 - 0.0.7-1 
  -electrode_locations_default.asc - updated to 75 standard 10-20 positions 
  -logs - now adds to log if exists, instead of overwriting (done to keep initial SVD) 
  -SETvars.comparisons - can now be passed through *_startup.m programs,
   either as structured variable with .comparisons and .comparison_label, or 
   as a string pointing to a file.  Still can be 0 (don't run) or 1 (run the 
   SETvars.comparisons in the datasetname_loadvars.m script.  New
   .comparison_label labels all output files uniquely - ommitting doesn't add
   unique identifier -- old style.  
  -TFD negative time index values now valid - baseline of TFD now saved, and
   can be used for decomposition, etc..  Negative numbers index prestimulus.  

  -Bug Fixes: 
    -strmatch function for electrodes in functions evaluating the electrode_to_plot option 
     lacked 'exact' parameter -- potential bug if specified electrode double-matched 
     electrode in erp.elecnames   
    -base_plot_topo_subplot.m modified to make elocs and data have the exact
     same electrodes.  This involved deleting from dataset, and 'exact' parameter
     in electrode matching.  
    -help for startup files had some parameters listed in the wrong order
     (pca_startup, win_startup, wintfd_startup)

07/20/2003 - 0.0.7 
  -SETvars.TFDbaseline - .start and .end - option to adjust TFD for baseline activity 
     during preptfd.  Baseline epoch still not stored with data for space. 
  -loaddata/loadvars - changed to allow omitting electrode_montage and
   electrode_locations -- will default to all electrodes and 'default' locations. 
   Also, electrode_montage can be specified as 'all' or 'ALL'. 
  -topomap - from EEGLAB 4.091 integrated for interpolated topographic head maps 
   -_loadvars - variable electrode_locations, contains, locations readable by 
     readloc.m (reads many formats, see docs), an EEGLAB structured variable
     of formats (as returned by readloc.m), or 'default' to use internal. 
   -added eeglab_path to psychophys_components_paths_defaults.m 
  -cache_erp/cache_tfd loadvars variable.  If ommitted: cache_erp=0, cache_tfd=1
  -trl2avg - added loadvars variable option to take TFDs at the trial-level 
   and then average the ERP and TFD before decomposition 
  -Added timing counters to print elapsed time per function for run. 
  -startup files changed to all use base_startup_inner for most of 
   their operations, more simple. 
  -EXTENSIVE rewrite of differences subsystem - SYNTAX CHANGE  
   -_loadvars - syntax variable changed to 'comparisons' structured variable  
   -optimize getting difference values, over twice as fast as 0.0.6-2.  
  -Added option to custom define colormaps and caxis  
   for differences and statistics with new loadvars vars: 
   -differences_colormap, differences_caxis 
   -statistics_colormaps, statistics_caxis 
   -minor bug fixes 
     -scree was not printing if decomposition was already computed 
     -20030720 - base_comparison_deletion_pairwise - wasn't deleting pairwise correctly 
               - base_comparison_set - only deleted pairwise for dataset, not plots.  
                                       Now does for both.   
     -20030720 - added SETvars.trl2avg.min_trials_averaged keyword 
 
  TODO: 
    -text output for correlations doesn't have correct label, although correct N 
 
03/01/2003 - 0.0.6-2
  -Optimized base_uni2multi - substantial speed increase 
  -figures_startup function added to place all figures (optional use) 
  -TopoMaps - Now delete paiwise within electrodes, for Wilcoxon and
   difference plots 
  -changed diff_cats to handle logical vectors (used to rely on isnumeric, 
   added islogical - added to base_cur_diffcat.m  

02/02/2003 - 0.0.6-1 
  -changed algorithm for 'pointing PCs positive' to work better.  Now based on
   average activity above and below the median, instead of neg/pos peak in
   relation to the mean 
  -change to create subnum variable (all ones) if single subject file loaded
   without one (base_loaddata)
  -memory - pcatfd_start and wintfd_start now clear erptfd it was loaded twice  
  -Difference plots/stats now support between-subject effects.  
   -new keyword 'comparison_type' added to difference_categories 
    Options are 'paired' or 'independent'  

01/07/2003 - 0.0.6 - Integrating PCA and PCATFD toolboxes into one (COMPONENTS)  
  -EXTENSIVE rewrite of front-end and data handling, integrating PCA and PCATFD into one. 
  -Four main frontend _startup scripts now to run things: PCA, WIN, WINTFD, and PCATFD.  
  -WIN and WINTFD added for manually defined window-based component selection. 
     -WIN for time and freq signals (1-D, range of X-axis values defines window) 
     -WINTFD for TFD signals (2-d, block of X-Y axis values defined window). 
     -component_definitions variable - like get_components from psychophys_dataproc. 
  -renamed several scripts to be more obvious/English. 
  -Topographic scripts now are in English with components names listed as y-label
  -Component plots are now labled in English with component names listed as y-label  
  -Modified Merge scripts to delete merged .eps files if merge is sucessful.  
   This make 1 or 2 output files per run (_short.eps and _long.eps if diffs requested) 
  -Modification/testing to make sure toolbox runs on Win98 and Win2000.  Tested paths 
   and perl calls to epsmerge. 

PCA/PCATFD Toolbox changelog 
  
01/02/2003 - 0.0.5 - Move to psychophys_toolbox data format   
  - electrode_text variable is now only name of elecs in rows that
    correspond to elecnum.  No longer use first 3 characters for elecnum.
    Also, now length of rows doesn't matter, not rigid at 4 characters.
  - electrode_montage spacing now doesn't matter, just that every row has the
    same number of elements
  - changed to psychophys_toolbox data format.  Internale format not changes.
    Instead import script is now embedded in toolbox (loaddata.m), maybe 
    convert internal later.

12/30/2002 - 0.0.4-3
  - changed default filtering to 3rd order from 5th order 
  - removed pcatfd_misc, now in psychophys_general, required on path for operation 
  - minor bug fixes

12/30/2002 - 0.0.4-2 
  - removed '_base' from all script names, and otherwise renamed many scripts.
  - minor bug fixes, particularly mptf_export (old pcatfd_main_dataexport.m)

12/23/2002 - 0.0.4-1 
  - changed _vars input parameter names:  
        difference_categories
        electrode_montage 
        electrode_text  
        topomap_colormap_name 
        topomap_colormap_scale_factor 
   - changed difference_categories processing substantively - allows text values for categories  

12/15/2002 - 0.0.4 

  - made directories for plots, data, and tfds into variables defined in pcatfd_parameters.m -- toolbox style 
  - extensive rewrite of ascii export routine for components (pcatfd_main_dataexport.m)
    (incompatible column structure - added elecnames, and changed 'elec' to 'elecnum', 
     also S1/S2 vars are now dropped because subnum, elec, and stim vars are already included, 
     and no other vars are allowed for S1/S2 criteria) 

11/25/2002 - 0.0.3 

  - fixed timing problem, TFD subsampling MUST be an integer  
  - changed rotation to use text - 'none' or 'vmx' - headed towards adding promax and oblimin (also deleted PLS varimax, licensing) 
  - added IDvars to pass variables between functions in startup scripts - headed towards passing data 
  - added some return values (retval) preparing for move to fully error detection in startup.m  
  - added rawtfd_plotGavg, rawtfd_plottopo, and rawtfd_get_components - for accessing raw TFDs, without decomposition 
  - added edpdataimport for direct import of toolbox data 
  - added reduceset2criterion to assist subsetting data arbitrarily for run 
  - changed the way data is loaded at the top of functions, stopped loading unecessary data for topo functions for speed 

8/15/2002 - 0.0.2    
  - The text output is now more condensed and interpretable, and the plots are labeled in English. 
  - PDF output almost runs on Windows (for PDFs of all relevant plots for a run integrated onto one page) 
     maybe next release -- epsmerge not behaving the same on Windows. 
  - Figure windows now auto-placed when program launches.  (can be changed in pcatfd_base_startup -- eventually will make an external config file).  
  - The category plotting and statistical mapping had some minor bugs and now seem pretty much ready as well.
 
7/15/2002 - 0.0.1 - First release 
  - Core pcatfd scripts developed and used for a couple of years, bundeled into a toolbox format. 

