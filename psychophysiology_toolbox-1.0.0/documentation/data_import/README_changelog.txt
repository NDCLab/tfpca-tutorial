12/11/2004 0.0.6-5
      - avg2mat/eeg2mat/cnt2mat modified to be compatible with matlab 7.0.1 
        [this only involved using cellstr when defining head, elec, and sweep] 
      - check_erp - checks/verifies erp structure  

03/10/2004 0.0.6-4 
      - modified eeg2mat/cnt2mat to handle new Neuroscan 4.3 32 bit files. 
      - modified avg2mat to have same variables as eeg2mat, so it behaves 
                 like and epoched file -- making it possible to use all 
                 relevevant toolbox scripts on the avg imported files. 
      - cnt2mat - can't find a way to determine file type without user definition, 
                  cnt2mat now requires external def, or  defaults to 16-bit.  
                  eeg2mat users filesize to auto-determine.  
         
06/30/2003 0.0.6-3 

      - rereference_avg - added function to conduct simple average reference.  
      - rereference_elec- added function to reference on average of listed elecs.
      - edf2mat/bdf2mat - minor updates from web 
      - triggers2events - fixed help documentation mistakes 
      - bug fixes 
          epoch - fixed bug where printf didn't convert cnt.event to double
                - if last epoch over end of data, last trial invalid -- now
                  warns the last trial is invalid.  

01/28/2003 0.0.6-2
      - epoch/rereference - now handle stim variable fully when present  
        (simply not supported before -- would error out)  
      - rereference - bug fix - now handles epoched file rereferencing
        correctly, as well as cnt files.  epoched code incorrectly assigned
        electrode numbers, producing incorrect output files  

01/20/2003 0.0.6-1   
      - epoch - bugs fixed - tbin was misdefined, prestim epoch was misdefined 
      - rereference - now uses variable length entries in .ldr file for flexibility  
        (converted from rigid charater matrix to cell arrays when reading in .ldr file)  

12/15/2002 
0.0.6 - added Biosemi BDF wrapper for openbdf/readbdf functions from www.biosemi.com 
      - consolidated eeg/cnt _scale2mat() into ns2mat_scale2uV()  
      - moved cnt2mat_epoch and _ldr to epoch() and rereference(), and modifiied   
        - epoch is now generalized to handle more than just neuroscan continuous files 
        - rereference is oriented to epoched and continuous 
        - dropped ldr parameter from eeg2mat and cnt2mat, only in rereference now 
      - changed quiet parameter to 'verbose' and default behavior is verbose = 0 
      - added triggers2events() to transform trigger rising or falling edges
        into sigular events in the event channel (for BDF files primarily)  

11/16/2002 
0.0.5 - moved ns2mat_create_extra_vars into main 2mat scripts 
      - for speed - defined arrays before loops, not within  
      - scale2uV now uses a flag when done (erp.scale2uV) 
      - added origianl_format variable 

7/28/2002 
0.0.4-3 - added ns2mat_create_extra_vars funcitons to alow more vars
            to be standardly created after creating basic file.  Mayy 
            be best to call in cnt2mat, eeg2mat, and avg2mat, to autoload 
            these vars during creation.  

6/17/2002 
0.0.4-2 - scale2uV forces erp.data to double before attempting scaling  

5/24/2002 
0.0.4-1 - minor message handling changes, processing behavior untouched ...

3/10/2002
0.0.4 - tweak messages from eeg2mat 
      - use int16 ONLY if scale2uV not selected to save space/memory

3/6/2002 
0.0.3 - fix avg2mat for SD values 

2/27/2002 
0.0.2 - added avg2mat 
      - modified eeg2mat to have quiet option. This also required general header and elec header  
        read to be totally consistent with cnt2mat 

12/7/2001 
0.0.1 - first release 

