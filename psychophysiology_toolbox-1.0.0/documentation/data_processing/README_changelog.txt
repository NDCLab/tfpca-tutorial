2004/0925 - 0.0.5-7 

  NEW FUNCTIONALITY: 
   - plot_erp - added lintype as new catcode variable - for defined linetypes 

2004/03/07 - 0.0.5-6

  NEW FUNCTIONALITY: 
   - baseline_dc - now replaced with slingle line of code to vectorize and be 
                   memory efficient. extract_average/trials, and plot_erp 
                   can now use larger files.   
   - resample_erp_savemem - for BIG datasets, takes longer, but uses less memory 
   - baseline_erp - baseline correct erp structure data with ms definitions 
   - export_ascii_multi - created for exporting to BESA - work in progress 
   - update_erp   - added - to update hand scored components with new alg
                    scored so they can be hand scored
   - combine_files_consolidate_subnums - when combining files that include the
     same subjects, dukplicate subnums/subnames are present.  This will remove them.    
   - trialtype_count - returns a ascending count separately for each value in 
     countvect, separately within splitvect (usually erp.subnum) 
   - score_HR - first attempt at a heart rate scoring program (IBI, bpms, etc.) 

  BUG FIXES: 
   - export_ascii - bug fix - variable cs now a matlab function, changes to cur_cs  
   - resample_erp - now takes filename for input (still doesn't write file
                    only passes erp variable back) 
   - get_components - now uses export_ascii by default 
   - export_ascii - bug fixed, default writes 0 byte files ('cols' default incorrect) 

2004/03/07 - 0.0.5-5 

   - export_ascii - renamed from components_export_ascii - now exports waveforms if present,  
                    and can be in either column or row orientation. 
                    components_export_ascii symlinked for compatibility 
                      - old behavior preserved by default  
   - extract average/trials - modified to accept erp with subnum all one value
                              for grand averaging - other minor mods  
   - ffts       - extract_averages/extract_trials - modified to taper before fft, 
                  also accepts structured domain variable to use different or no window.  
   - reduce_erp - added option for structured variable, and resampling 
                - modified to handle cnt files (doesn't look for eeg only vectors) 
   - extract averages/trials - modified to accept input erp variable in 
                         addition to filename(s).  Also, modified so that 
                         input erp or file can be either single or multiple 
                         files of single subjects, or one file/variable with 
                         multiple subjects in it.   
   - review components - mod - zero and reject trials now use 'r' and 'z' keys 
                         instead of areas of the graph. 
   - reorganize_elecs  - added - modify/reduce/renumber electrodes 
   - components_export_ascii - added subname along with subnum in ascii file. 
                         built from subs.name (only added if subnum present)  
   - reduce_erp/combine_files - added support for component files. 
   - combine_filespec  - added function - frontend to combine_files for filespecs 
   - combine_files     - added set variable -- identifies input filenumber  

   - bug fixes - extract averages/trials now checks domain def correctly 
               - combine_files - correctly omits stim variable if not present
               - combine_files - correctly handles cellarray (only did chararray) 
               - plot_erpdata  - added 'exact' to strmatch, when choosing
                                 elecs to plot -- avoids multiple matches.  
                               - baseline adjust AGAIN after filtering.  
               - extract averages/trials - modified to handle subnames correctly 
                         when using variable-multi mode (e.g. psychophys_components trl2avg)  
                         extract_base_loadprep_data - reduce_erp line gets subnum from subs.name 
                         extract_base_evaluate_singlemulti - define subnames from subs.name 
                                                             instead of unique(erp.subnum) 
               - get_components - if single bin given for component, now
                                  accurately returns that value.  
                                  Before couldn't do single value  
 
2003/02/27 - 0.0.5-4 
   - extract_trials/averages - added WARNING to verbose output when subject
                         has no waveforms that meet criterion. 
   - combine_files     - fixed subnum manipulation to sync with
                         erp.subs.names.  Old way they were not correctly synched. 
   - review_components - added subname to plot title for aggregate files  
   - review_components - bug fix - when signal is all zeros, uses +1/-1 for axis 
   - plot_erpdata      - bug fix - when signal is all zeros, uses +1/-1 for axis
   - combine_files     - now makes a unique subnum value for each added subject. 
                         correctly handles single and multiple subject files. 

2003/02/02 - 0.0.5-3
   - bug fix - reduce_erp wasn't reducing the stim vectors 
   - blsms/blems - ALL functionw now define zero for baseline as 'none'  
      -get/review components - use zero as baseline reference for components 
      -extract/plot - do not perform baseline correction.  
      NOTE: old extract averages/trials would give default baseline of half
      the baseline epoch when blsms and blems defined as zero, this changes that
      default behavior to not do any baseline correction.  
   - extract_base_convert_factors - gathered all bin2unit (ms/Hz) conversion
     in one script, parallel to psychophys_components toolbox 
   - tag_artifacts - bug introduced 0.0.5-1  AT(x).rftype and AT(x).attype,
     for critELECs format.  Minor miscode, but errored/crashed, fixed. 
   - combine_files - bug fix when combining subject level files, omitting subs var.  
   - erp.elecnames - can now be cell-array (worked through dataproc)  
   - bug fix - in base_ ms/Hz, correcting for when calulated startbin is zero (now 1) 
 
2003/01/22 - 0.0.5-2
   - bug fix - extract_base_load_data.m - remove extraneous 'return'  
   - bug fix - extract_trials.m - ttypes2extract 'ALL' not handled correctly 
 
2003/01/16 - 0.0.5-1 
   - tag_artifacts - add AT(x).rftype and AT(x).attype parameters (not fully
     vallidated in terms of operation)  
   - tag_artifacts - minor code cleanup for ms -> bin translation 
   - tag_artifacts - changed skipELECnames to skipELECs 
   - review_components - bug fix in parameter order calling get_components, 
                       - modified to handle when no subnum variable present.  
   - combine_files - bug fix - remove code modifying subnums for set 

2003/01/10 - 0.0.5 - change parameter order of component and plot functions 
   - bug fix - change components functions to read cell array as well as
     string arays, like psychophys_components does. 
   - change electrode_montage parsing in plot_erpdata to be like components
     toolbox, using cell array, and allowing variably spaced entries.  Also, 
     added NA to BLANK as option for empty plot to match components toolbox 
   - change to check for datafile name before loading.  If it doesn't exist,
     that file is not processed, just skipped. 
   - plot_erpdata - added plottype parameter -- ! changed parameter order !  
   - minor tweaks to trials and averages verbose text output, now displays electrode names 
   - modified tag_artifacts so that if ref start and end ms are zero, reference is zero. 
 
2003/01/02 - 0.0.4-3 
   - added reduce_erp 
   - change combine_files to use reduce_erp, and reduce_text can now have multiple lines 
   - change component_write_ascii script so elecnames matrix ca be width other than 10.  

2002/12/30 - 0.0.4-2
   - cleaned up plot_erp substantially,
     - now handles 'freq' domain correctly 
     - title in English 
   - get_components and review_components now handle freq domain correctly 
   - added extract_base_Hz.m for central translation to Hz, for consistency.   
   - freq domain must now specify either freq-power or freq-amplitude in
     extract_averages and extract_trials.  Rest of scripts respect this.  
   - filtspec now used instead of lpf for plot_erp and *components, old behavior 
     still supported.  Now can use filtspec of [hpf lpf] for bandpass or just lpf.     
   - plot_erp and component scripts now force data to double, so unscaled data will process.  
   - bug fixes to extract_average and extract_trials, introduced in 0.0.4-1 in
     removing option for stim to be a vector.  Also, now stim vectorized in extract_average.   
   - removed sub_functions directory, now contained in separate psychophys_general toobox, 
     required for use of psychophys_dataproc toolbox. 
 
2002/12/30 - 0.0.4-1 
   - tag_artifacts 
     - documentation 
     - made AT skip and keep ELECs consistent cell arrays 
     - removed default skipELECnames, now none 
     - added tag_artifacts_basic_AT_defs.m  
   - extract_averages and extract_trials - now skip and keep ELECs need exact match 
   - removed option for stim to be a vector, stim MUST be structured variable containing vectors 
     This was also done to pca/pcatfd to make them all predictable and consistent  
   - modified extract_averages and extract_trials - subnames can now be a cell array  
   
2002/12/15 - 0.0.4
   - extensive rewrite of ascii export routine for components (now in components_export_ascii.m) 
   - hand_components renamed to review_components 
   - added combine_files 
   - many little bug fixes

2002/11/17 - 0.0.3
    - changed the way scaling is handled, to only scale neuroscan files
    - speed changes - extract_trials and extract_averages are now more vectorized

2002/11/09 - 0.0.2 release

  many changes, and bug fixes
    - extract_trials
    - extract_averages
    - plot_erpdata
    - get_components - now handles multiple component definitions and selected measures
    - tag_artifacts - now can be used more easily from command line 'on-the-fly'

  new programs
    - hand_components - for reviewing/scoring components by hand

2002/07/26 - 0.0.1 release

