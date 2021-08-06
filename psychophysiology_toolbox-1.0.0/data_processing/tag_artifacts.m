function [reject] = tag_artifacts(erp_inname,AT,verbose,minmaxCRIT,ms_defs,skipELECs), 

% [reject] = tag_artifacts(erp_inname,AT,verbose,minmaxCRIT,[rfsms,rfems,atsms,atems],skipELECs),
% 
% Types of Rejection: 
% 
%    Individual Channel - Each channel treated separately 
%    Criterion Channel  - Sweeps rejected based on artifacts in criterion channel(s)  
% 
% Rejection Operation - waveforms are tagged when the difference between the min or max within  
%   the artifact tagging window and the median of the reference window exceeds the criterion specified 
%   
% Returned 'reject' structured variable contains two fields: 
%   trials2reject - vector with ones for trials tagged for rejection, zeros otherwise  
%   N             - Number of trials rejected with each 'pass' 
%  
% Parameters 
%  erp_inname     - erp data structure, or input data file name with erp data structure  
%  AT             - core Artifact Tagging specification 
%    AT structure - LONG  - Fully specified AT structure, see tag_artifact_examples.m for examples 
%    'individual' - SHORT - command-line-style - Individual Channel Rejection 
%    'critchannel'- SHORT - command-line-style - Criterion Channel Rejection (VEOG/HEOG)  
%    'none'       - no rejection performed, reject vector returned with all zeros ('none' also ok)  
%  verbose        - 0-no, 1-yes 
%  minmaxCRIT     - [min max] criterion specified in units erp contains 
%  ms_defs        - [rfsms,rfems,atsms,atems] 
%        rfsms    - reference window start ms (0=no reference)  
%        rfems    - reference window end ms   (0=no reference)  
%        atsms    - artifact tagging window start ms 
%        atems    - artifact tagging window end ms 
%  skipELECs      - electrodes to skip cell array 
% 
% Two methods of operation: 
% 
%   FULL - AT structured array, and must be defined before calling tag_artifacts 
%          Each entry in AT defines a rejection 'pass'.  A simple definition contains 
%          one pass, no limit is specified for the number of passes allowed.  
%          (See tag_artifacts_basic_AT_defs.m for usable basic definitions)  
% 
%     AT variable definitions:  
%        AT(pass).label         -'individual' or 'critchannel' 
%        AT(pass).minmaxCRIT    - see minmaxCRIT above (e.g. [-100 100]) 
%        AT(pass).rfsms         - see ms_defs above  
%        AT(pass).rfems         - see ms_defs above  
%        AT(pass).rftype        - reference window type: mean, median, std, scalar value to compar 
%                                 (Optional - default median)  
%        AT(pass).atsms         - see ms_defs above  
%        AT(pass).atems         - see ms_defs above  
%        AT(pass).attype        - artifact tagging type: peak, mean, median, std 
%                                 (Optional - default peak)  
%        AT(pass).skipELECs     - cell array of elec names to skip, omit or use '' for none 
%        AT(pass).critELECs     - ONLY required for 'critchannel' label, cell array of criterion channels(s), 
%                                  or 'ALL' for any channel violation rejects whole trial, all channels)  
% 
%     AT Example (from tag_artifacts_basic_AT_defs.m): 
%        AT(1).label='individual';
%        AT(1).minmaxCRIT = [-100 100];
%        AT(1).rfsms =     1;  % reference start  
%        AT(1).rfems =  1000;  % reference stop 
%        AT(1).atsms =  -500;  % post-stim start 
%        AT(1).atems =    -1;  % post-stim end 
%        AT(1).skipELECs = '';
% 
%     Command Example: 
%       [reject] = tag_artifacts(erp,AT); 
%  
%   SHORT - command-line style operation 
% 
%     Command Examples:  
%       1 - [reject] = tag_artifacts(erp,'individual'); 
%       2 - [reject] = tag_artifacts(erp,'individual',1,[-100 100]); 
%       3 - [reject] = tag_artifacts(erp,'individual',1,[-100 100],[-500 1 1 1000]); 
%       4 - [reject] = tag_artifacts(erp,'individual',1,[-100 100],[-500 1 1 1000],skipELECs); 
% 
%     Example Descriptions:  
%       1 - default minmaxCRIT and ms_defs ( minmaxCRIT = [-100 100], ms_defs = [-500 1 1 1000] )  
%       2 - define minmaxCRIT, default ms_defs 
%       3 - define minmaxCRIT and ms_defs 
%       4 - defining minmaxCRIT, ms_defs, and skipELECs   
%  
%     NOTES:  
%       'critchannel' defaults to 'VEOG' and 'HEOG' channels, use AT structure for other  
%  
%       edited by JH 062912: fixes indexing problem when using critchannel AT (see changelog)
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
  else,
    erp = erp_inname; erp_inname = 'erp'; 
  end
  erp.data=double(erp.data);

  if isfield(erp,'domain') && isequal(erp.domain,'TFD') && ~(isequal(AT,'none') | isequal(AT,'NONE')),
    disp(['ERROR: ' mfilename ' NOT valid for TFD datatype ']);
    return
  end

% vars 

   reject.trials2reject        = zeros(size(erp.elec));
   reject.trials2reject_subset = zeros(length(erp.elec),length(AT));
   reject.trials2rejectN = [];
   reject.trials2reject_subsetN = [];

   if exist('verbose','var') ==0, verbose = 0; end
   if verbose >= 2, disp('Artifact Tagging (AT) ... '); end

   % handle AT 
    create_AT = 0; 
    if     exist('AT','var')==0, 
      create_AT = 0;
    elseif isempty(AT), 
      create_AT = 0;
    elseif isstruct(AT) == 0, 
      switch lower(AT)  
        case 'individual' 
          create_AT =  1; 
        case 'critchannels' 
          create_AT =  2;
        case {'NONE','none'}, 
          create_AT = 10;
        otherwise 
          create_AT =  0;
       end  
    elseif isstruct(AT) ==1, 
      create_AT = -1; 
    end  

    switch create_AT 
      case  0, 
          disp(['WARNING:' mfilename ':' mfilename ': AT not correctly defined -- no rejection performed']); 
        return; 
      case 10,  
        if verbose >= 2,
          disp(['MESSAGE:' mfilename ': no artifact rejection requested -- no rejection performed']); 
        end 
        return; 
    end 

    if create_AT>0&create_AT<10, 
      switch lower(AT)  
      case 'individual', 
	label='individual'; 
        if exist('minmaxCRIT','var')==0, minmaxCRIT=[-100 100]; end
        if exist('ms_defs','var')==0,  
	  ms_defs(1) = -500;  % reference start  
          ms_defs(2) =    0;  % reference stop 
          ms_defs(3) =    1;  % post-stim start 
	  ms_defs(4) = 1000;  % post-stim end 
        end 
        if exist('skipELECs','var')==0,   
	  skipELECs = {''}; 
        end 
          critELECs = {''};  
      case 'critchannels', 
        label='critchannels'; 
        if exist('minmaxCRIT','var')==0, minmaxCRIT=[-100 100]; end
        if exist('ms_defs','var')==0,
         ms_defs(1) = -500;  % reference start  
         ms_defs(2) =    0;  % reference stop 
         ms_defs(3) =    1;  % post-stim start 
         ms_defs(4) = 1000;  % post-stim end 
        end
        if exist('skipELECs','var')==0,
          skipELECs = {''};
        end
          critELECs = {'VEOG'; ...
                       'HEOG'; ...
                                 }; 
      end 

      clear AT 
      AT(1).label = label; 
      AT(1).rfsms = ms_defs(1);  % reference start  
      AT(1).rfems = ms_defs(2);  % reference stop 
      AT(1).atsms = ms_defs(3);  % tag start 
      AT(1).atems = ms_defs(4);  % tag end 
      AT(1).minmaxCRIT = minmaxCRIT; 
      AT(1).skipELECs = skipELECs; 
      AT(1).critELECs = critELECs; 
      create_AT = -1;  
    end

% reject 

   % main loop for reject each AT 
   if create_AT == -1, 

   for ATnum = 1:length(AT), 

   curAT = []; curAT = AT(ATnum);  
   if verbose >= 2, disp('AT criterion'); disp(curAT), end  
   keepELECs= ones(size(erp.elec));
   skipELECs=zeros(size(erp.elec));
   critELECs=zeros(size(erp.elec));

     % create skipELECs vector for artifact rejection 
       if isfield(curAT,'skipELECs'),
         if isempty(curAT.skipELECs)==0,
           for e=1:length(curAT.skipELECs),
             cn = strmatch(curAT.skipELECs(e),erp.elecnames,'exact');
             if isempty(cn)~=1,
             for x = 1:length(cn),
               skipELECs=[skipELECs + [erp.elec==cn(x)] ];
             end
             end
           end
         end
       end
       skipELECs =  (skipELECs~=0);

     % create keepELECs vector for artifact rejection 
       if isfield(curAT,'keepELECs'), 
         if isempty(curAT.keepELECs)==0,  keepELECs=zeros(size(erp.elec)); 
           for e=1:length(curAT.keepELECs), 
             cn = strmatch(curAT.keepELECs(e),erp.elecnames,'exact');
             if isempty(cn)~=1,
             for x = 1:length(cn),
               keepELECs=[keepELECs + [erp.elec==cn(x)] ];
             end
             end
           end 
         end 
       end
       keepELECs =  (keepELECs~=0);

       elec2tag = keepELECs;
       elec2tag = elec2tag .* abs(skipELECs-1); 
       elec2tag = elec2tag >= 1;

    % create critELECs 
       if isfield(curAT,'critELECs'),
         if isempty(curAT.critELECs)==0,
           if length(curAT.critELECs) == 1 & isequal(upper(curAT.critELECs),{'ALL'}), 
             critELECs=ones(size(erp.elec));
           else, 
             for e=1:length(curAT.critELECs),
               cn = strmatch(curAT.critELECs(e),erp.elecnames,'exact');
               if isempty(cn)~=1,
                 for x = 1:length(cn),
                   critELECs=[critELECs + [erp.elec==cn(x)] ];
                 end
               end 
             end 
           end
         end
       end
       critELECs =  (critELECs~=0);

    % define windows values  
      if ~isfield(curAT,'rftype') ||  isempty(curAT.rftype),  curAT.rftype = 'median'; end 
      if ~isfield(curAT,'attype') ||  isempty(curAT.attype),  curAT.attype = 'peak'  ; end
      if ~isfield(curAT,'rfsms')  && ~isfield(curAT,'rfems'), curAT.rfsms = 0;  
                                                              curAT.rfems = 0; end  
      if curAT.rfsms==0 & curAT.rfems==0, curAT.rftype = 0; end  
      
    % define window lengths and positions  
       rfs = erp.tbin  +round(curAT.rfsms*(erp.samplerate/1000)); % reference start  
       rfe = erp.tbin  +round(curAT.rfems*(erp.samplerate/1000)); % reference end 
       ats = erp.tbin  +round(curAT.atsms*(erp.samplerate/1000)); % post-stim 1 sec start 
       ate = erp.tbin  +round(curAT.atems*(erp.samplerate/1000)); % post-stim 1 sec end 
      %if abs(rfs) <= (erp.samplerate/1000)*1.5, rfs = erp.tbin; end
      %if abs(rfe) <= (erp.samplerate/1000)*1.5, rfe = erp.tbin; end
      %if abs(ats) <= (erp.samplerate/1000)*1.5, ats = erp.tbin; end
      %if abs(ate) <= (erp.samplerate/1000)*1.5, ate = erp.tbin; end

      % definition checks 
        % reference window 
        if rfs < 1, rfs = 1;
          if verbose >= 2, disp(['WARNING:' mfilename ': reference window starting bin exceeds available data -- clipped to start of data']); end  
        end
        if rfe > length(erp.data(1,:)), rfe = length(erp.data(1,:));
          if verbose >= 2, disp(['WARNING:' mfilename ': reference window ending bin exceeds available data -- clipped to end of data']); end  
        end
        if rfs > length(erp.data(1,:)) | ats  > length(erp.data(1,:)),
          disp(['ERROR:' mfilename ': reference window starting bin exceeds available data -- result not correct']);
        end
        % artifact window 
        if ats < 1, ats = 1;
          if verbose >= 2, disp(['WARNING:' mfilename ': artifact tagging window starting bin exceeds available data -- clipped to start of data']); end  
        end
        if ate > length(erp.data(1,:)), ate = length(erp.data(1,:));
          if verbose >= 2, disp(['WARNING:' mfilename ': artifact tagging window ending bin exceeds available data -- clipped to end of data']); end  
        end
        if ats > length(erp.data(1,:)),  
          disp(['ERROR:' mfilename ': artifact tagging window starting bin exceeds available data -- result not correct']);
        end
        
    % choose AT method 
     switch lower(curAT.label) 

     case 'individual' 

       % ref 
       if isnumeric(curAT.rftype), 
            ref_vals = ones(size(erp.data(:,1)))*curAT.rftype; 
       else, 
         switch curAT.rftype 
           case 'mean'
             ref_vals =       mean(erp.data(:,rfs:rfe)')';
           case 'median' 
             ref_vals =     median(erp.data(:,rfs:rfe)')';
           case 'std'
             ref_vals =        std(erp.data(:,rfs:rfe)')';
           case 'var'
             ref_vals =        var(erp.data(:,rfs:rfe)')';
           end
       end 

       % at 
       switch curAT.attype 
         case 'peak' 
           pos_at_vals =    max(erp.data(:,ats:ate)')';
           neg_at_vals =    min(erp.data(:,ats:ate)')';
         case 'mean'
           pos_at_vals =   mean(erp.data(:,ats:ate)')';
           neg_at_vals =   mean(erp.data(:,ats:ate)')';
         case 'median'
           pos_at_vals = median(erp.data(:,ats:ate)')';
           neg_at_vals = median(erp.data(:,ats:ate)')';
         case 'std'
           pos_at_vals =    std(erp.data(:,ats:ate)')';
           neg_at_vals =    std(erp.data(:,ats:ate)')';
         case 'var'
           pos_at_vals =    var(erp.data(:,ats:ate)')';
           neg_at_vals =    var(erp.data(:,ats:ate)')';
       end 

       % evalutation vectors 
       pos_at_vals = pos_at_vals - ref_vals; 
       neg_at_vals = neg_at_vals - ref_vals;
 
       % create rejection vector 
       cur_trials2reject = neg_at_vals < curAT.minmaxCRIT(1) | pos_at_vals >curAT.minmaxCRIT(2); 

       cur_trials2reject = cur_trials2reject .* elec2tag;
       cur_trials2reject = cur_trials2reject >= 1;
       reject.trials2reject = (reject.trials2reject + cur_trials2reject);  

       if verbose >= 2, disp(['     individual channels rejected by trial:		' num2str([size(cur_trials2reject(cur_trials2reject==1),1) size(reject.trials2reject(elec2tag~=0),1) ]) ]); end 
       reject.trials2reject_subsetN = [reject.trials2reject_subsetN; [size(cur_trials2reject(cur_trials2reject==1),1) size(elec2tag(elec2tag~=0),1) ]; ];  

     case 'critchannel' 

       cur_trials2reject = zeros(size(erp.elec));  
       sweeps = unique(erp.sweep);  
       for s = 1:length(sweeps), 
         cur_sweep = sweeps(s);  
         cur_crit_vect = critELECs==1&erp.sweep==cur_sweep;  

         % ref 
         if isnumeric(curAT.rftype), 
              ref_vals = ones(size(erp.data(cur_crit_vect,1)))*curAT.rftype;
         else, 
           switch curAT.rftype
             case 'mean'
               ref_vals =       mean(erp.data(cur_crit_vect,rfs:rfe)')';
             case 'median'
               ref_vals =     median(erp.data(cur_crit_vect,rfs:rfe)')';
             case 'std'
               ref_vals =        std(erp.data(cur_crit_vect,rfs:rfe)')';
           end
         end

         % at 
         switch curAT.attype 
           case 'peak'
             pos_at_vals =    max(erp.data(cur_crit_vect,ats:ate)')';
             neg_at_vals =    min(erp.data(cur_crit_vect,ats:ate)')';
           case 'mean'
             pos_at_vals =   mean(erp.data(cur_crit_vect,ats:ate)')';
             neg_at_vals =   mean(erp.data(cur_crit_vect,ats:ate)')';
           case 'median'
             pos_at_vals = median(erp.data(cur_crit_vect,ats:ate)')';
             neg_at_vals = median(erp.data(cur_crit_vect,ats:ate)')';
           case 'std'
             pos_at_vals =    std(erp.data(cur_crit_vect,ats:ate)')';
             neg_at_vals =    std(erp.data(cur_crit_vect,ats:ate)')';
         end
         pos_at_vals = max(pos_at_vals); 
         neg_at_vals = min(neg_at_vals); 

         % evalutation vectors 
         pos_at_vals = pos_at_vals - ref_vals;
         neg_at_vals = neg_at_vals - ref_vals;

         % create rejection values 
         if any(neg_at_vals < curAT.minmaxCRIT(1)) | any(pos_at_vals > curAT.minmaxCRIT(2)), 
           cur_trials2reject(erp.sweep==(sweeps(s))) = 1; 
         end 
         
        %if neg_at_vals < curAT.minmaxCRIT(1) | pos_at_vals > curAT.minmaxCRIT(2), 
        %   cur_trials2reject(erp.sweep==s) = 1; 
        % end 

%        if  npeaks < curAT.minmaxCRIT(1) | ppeaks>curAT.minmaxCRIT(2), 
%          cur_trials2reject(erp.sweep==s) = 1; 
%        end 

       end

       cur_trials2reject = cur_trials2reject .* elec2tag; 
       cur_trials2reject = cur_trials2reject >= 1;
       reject.trials2reject = (reject.trials2reject + cur_trials2reject); 

       if verbose >= 2, disp(['     CRIT channel rejects trials:			' num2str([size(cur_trials2reject(cur_trials2reject==1),1) size(reject.trials2reject(elec2tag~=0),1) ]) ]); disp(' '); end
       reject.trials2reject_subsetN = [reject.trials2reject_subsetN; [size(cur_trials2reject(cur_trials2reject==1),1) size(elec2tag(elec2tag~=0),1) ]; ];

   end 

     reject.trials2reject_subset(:,ATnum) = cur_trials2reject;  

   end 
   end 

   % total up ALL rejected trials
    if verbose >= 1, disp([   '     tag_artifacts - total tagged trials:		'  num2str([size(reject.trials2reject(reject.trials2reject~=0),1) size(reject.trials2reject,1) ]) ]); disp(' '); end 
    reject.trials2rejectN=[length(reject.trials2reject(reject.trials2reject~=0)) length(reject.trials2reject) ];

