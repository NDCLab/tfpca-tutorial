% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% This script can be executed and the AT variables used by passing to tag_artifacts 

% Individual Channel Rejection Examples 

  % 2 pass - 1000 ms total  
  clear AT
  AT(1).label='individual';
  AT(1).minmaxCRIT = [-100 100];
  AT(1).rfsms =     1;  % reference start  
  AT(1).rfems =  1000;  % reference stop 
  AT(1).atsms =  -500;  % post-stim start 
  AT(1).atems =    -1;  % post-stim end 
  AT(1).skipELECs = {''};
  AT(2).label='individual';
  AT(2).minmaxCRIT = [-100 100];
  AT(2).rfsms =  -500;  % reference start  
  AT(2).rfems =    -1;  % reference stop 
  AT(2).atsms =     1;  % post-stim start 
  AT(2).atems =  1000;  % post-stim end 
  AT(2).skipELECs = {''};
  AT1000_individual = AT;

  % 2 pass - 2000 ms total  
  clear AT
  AT(1).label='individual';
  AT(1).minmaxCRIT = [-100 100];
  AT(1).rfsms =     1;  % reference start  
  AT(1).rfems =  2000;  % reference stop 
  AT(1).atsms =  -500;  % post-stim start 
  AT(1).atems =    -1;  % post-stim end 
  AT(1).skipELECs = {''};
  AT(2).label='individual';
  AT(2).minmaxCRIT = [-100 100];
  AT(2).rfsms =  -500;  % reference start  
  AT(2).rfems =    -1;  % reference stop 
  AT(2).atsms =     1;  % post-stim start 
  AT(2).atems =  2000;  % post-stim end 
  AT(2).skipELECs = {''};
  AT2000_individual = AT;

  % 3 pass - 8000 ms total  
  clear AT
  AT(1).label='individual';
  AT(1).minmaxCRIT = [-100 100];
  AT(1).rfsms =     1;  % reference start  
  AT(1).rfems =  3000;  % reference stop 
  AT(1).atsms =  -500;  % post-stim start 
  AT(1).atems =    -1;  % post-stim end 
  AT(1).skipELECs = {''};
  AT(2).label='individual';
  AT(2).minmaxCRIT = [-100 100];
  AT(2).rfsms =  -500;  % reference start  
  AT(2).rfems =    -1;  % reference stop 
  AT(2).atsms =     1;  % post-stim start 
  AT(2).atems =  3000;  % post-stim end 
  AT(2).skipELECs = {''};
  AT(3).label='individual';
  AT(3).minmaxCRIT = [-200 200];
  AT(3).rfsms =  -500;  % reference start  
  AT(3).rfems =    -1;  % reference stop 
  AT(3).atsms =     1;  % post-stim start 
  AT(3).atems =  8000;  % post-stim end 
  AT(3).skipELECs = {''};
  AT8000_individual = AT;

% Criterion channel rejection (VEOG/HEOG)  

  % 2 pass - 1000 ms total  
  clear AT
  AT(1).label='CRITchannel';
  AT(1).minmaxCRIT = [-100 100];
  AT(1).rfsms =     1;  % reference start  
  AT(1).rfems =  1000;  % reference stop 
  AT(1).atsms =  -500;  % post-stim start 
  AT(1).atems =    -1;  % post-stim end 
  AT(1).skipELECs = {''}; 
  AT(1).critELECs = {'VEOG'; ...
                         'HEOG'; ...
                         };
  AT(2).label='CRITchannel';
  AT(2).minmaxCRIT = [-100 100];
  AT(2).rfsms =  -500;  % reference start  
  AT(2).rfems =    -1;  % reference stop 
  AT(2).atsms =     1;  % post-stim start 
  AT(2).atems =  1000;  % post-stim end 
  AT(2).skipELECs = {''};
  AT(2).critELECs = {'VEOG'; ...
                         'HEOG'; ...
                         };
  AT1000_CRITchannel = AT;


% COMBINED - Individual Channel Baseline and Criterion Channel Epoch rejectsion (VEOG/HEOG)  

  % 2 pass - 1000 ms total  
  clear AT
  AT(1).label='individual';
  AT(1).minmaxCRIT = [-100 100];
  AT(1).rfsms =     1;  % reference start  
  AT(1).rfems =  1000;  % reference stop 
  AT(1).atsms =  -500;  % post-stim start 
  AT(1).atems =    -1;  % post-stim end 
  AT(1).skipELECs = {''};
  AT(2).label='CRITchannel';
  AT(2).minmaxCRIT = [-100 100];
  AT(2).rfsms =  -500;  % reference start  
  AT(2).rfems =    -1;  % reference stop 
  AT(2).atsms =     1;  % post-stim start 
  AT(2).atems =  1000;  % post-stim end 
  AT(2).skipELECs = {''};
  AT(2).critELECs = {'VEOG'; ...
                         'HEOG'; ...
                         };
  AT1000_Combined = AT;

