Modified Dec, 2004 to add more options than just simple ascii name.  


dataset_name parameter can be: 
  - simple ascii dataset name (will look for required [dataset_name '_loaddata'] and optionally [dataset_name '_loadvars'] to run) 
  - erp-structure with data ('untitled' is the dataset_name used) 
  - path to datafile (filename used as dataset_name) - will look for [dataset_name '_loadvars'] to run loadvars 
  - path to script to load data (script name is dataset_name) - will look for [dataset_name '_loadvars'] to run loadvars   
  - structure (detailed below) 

structure to be passed to startup function via dataset_name can contain: 

  - erpcomp.dataset_name - required - ascii text of the datasetname  
  - erpcomp.loaddata - optional - if omitted, loaddata assumed to be [dataset_name '_loaddata']; 
      - erp-structure 
      - path to datafile 
      - path to script
      - the commands themselves as a string  
      - structure defining individual subject files to be combined -- see below  
  - erpcomp.loadvars - optional (loadvars not run if omitted or empty -- default values used)  
      - omitted 
      - empty 
      - path to script 
      - the commands themselves as a string  
      - a structured SETvars subvariable, containing options 
      NOTE: as many sources as possible from these will ALL be run 

Using individual subject files that are combined into dataset during run, defined in loaddata: 
      - strtucture defining individual subject files to load and combine (using extract_averages/trials). 
        This can be passed via the erpcomp.loaddata as a structure, or in a loaddata script, etc. 
        - innamebeg/subnames/innameend - identical with extract_averages/trials - required 
        - AT - optional - defaults to 'none' - see tag_artifacts for definition 
        - preprocessing - optional - path to preprocessing script or commands to be executed inline
        - ttypes2extract - optional - limit trials extracted - see extract_trials for definition 
        - verbose 
        - domain 

EXAMPLES: 

  Example 1 (old method, looks for [dataset_name '_loaddata'] and [dataset_name '_loadvars'] ): 
 
    win_startup('mydatasetname',256,comps_name,comps_defs,PlotAvgs,PlotCatDiffs,PlotsMerge,ExportAscii,Verbose);

  Example 2 (new path to datafile or script... filename becomes dataset_name ): 

    win_startup('/pathname/to/data/filename.mat',256,comps_name,comps_defs,PlotAvgs,PlotCatDiffs,PlotsMerge,ExportAscii,Verbose);

  Example 3 (new structure, with files): 
 
    clear erpcomp
    erpcomp.dataset_name = 'mydatasetname'; 
    erpcomp.loaddata     = '/pathname/to/data/filename.mat'; 
    erpcomp.loadvars     = 'some_loadvars_script';
    win_startup(erpcomp,256,comps_name,comps_defs,PlotAvgs,PlotCatDiffs,PlotsMerge,ExportAscii,Verbose);

  Example 4 (new structure, with commands passed): 
 
    clear erpcomp
    erpcomp.dataset_name = 'mydatasetname';
    erpcomp.loaddata     = ['load(''/pathname/to/data/filename.mat''), ' ...
                            'erp = reduce_erp(erp,erp.ttype~=255); '          ];  
    erpcomp.loadvars     = ['SETvars.topomap_colormap_scale_factor           =  .8;'         ... 
                            'SETvars.topomap_colormap_name                   = ''default'';' ...
                            'SETvars.ptype                                   = ''epsc2'';'   ];
    win_startup(erpcomp,256,comps_name,comps_defs,PlotAvgs,PlotCatDiffs,PlotsMerge,ExportAscii,Verbose);

  Example 5 (new structure, with loaddata passing individual subject file parameters):

    clear erpcomp
    erpcomp.dataset_name           = 'mydatasetname';
    erpcomp.loaddata.innamebeg     = '/pathname/to/data/';
    erpcomp.loaddata.innameend     = '_file_ending';
    erpcomp.loaddata.subnames      = subnames;
    erpcomp.loaddata.AT            = 'individual';  
    erpcomp.loaddata.preprocessing = ['erp.data = filts_lowpass_butter(erp.data,50/(erp.samplerate/2),12);' ];
    erpcomp.loaddata.ttypes2extract= 'ALL'; 
    erpcomp.loadvars               = ['SETvars.topomap_colormap_scale_factor           =  .8;'         ...
                                      'SETvars.topomap_colormap_name                   = ''default'';' ...
                                      'SETvars.ptype                                   = ''epsc2'';'   ];
    win_startup(erpcomp,256,comps_name,comps_defs,PlotAvgs,PlotCatDiffs,PlotsMerge,ExportAscii,Verbose);

