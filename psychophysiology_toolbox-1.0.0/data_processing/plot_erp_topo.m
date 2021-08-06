function [retval] = plot_erpdata(erp_inname,outname,outformat,plottype,electrode_montage,catcodes,blsms,blems,startms,endms,louV,hiuV,filterspec,AT,verbose),

% ---- NOT FINISHED -- Doesn't work yet --- 

%  plot_erpdata(erp_inname,outname,outformat,plottype,electrode_montage,catcodes,blsms,blems,startms,endms,louV,hiuV,filterspec,AT,verbose),
% 
% Operation - Plots means each specified category (catcodes parameter) for each electrode as 
%             specified in electrode_montage matrix. 
% 
% Parameters: 
%   erp_inname             - erp data structure, or input data file name with erp data structure  
%   outname                - output file name, empty to suppress writing file  
%   outformat              - output file format, empty to suppress writeing file [as passed to matlab print command -- e.g. 'epsc2', see for options] 
%   plottype               - 'mean', 'median', or 'trials'  
%   electrode_montage      - electrodes(s) and layout for plot  
%   catcodes               - categories to plot  
%   blsms                  - baseline adjust in ms, zero or [] for none.   
%   blems                  - baseline adjust in ms, zero or [] for none.    
%   startms                - X-axis, start of plot window (ms for time, Hz for freq)  
%   endms                  - X-axis, end of plot window (ms for time, Hz for freq)  
%   louV                   - Y-axis highest value (uV for time, power for freq)   
%   hiuV                   - Y-axis lowest value (uV for time, power for freq)  
%   filterspec             - [lowpass] or [highpass lowpass]  
%   AT                     - AT - see tag_artifacts for definition (zero or 'NONE' for none)  
%   verbose                - 0=no, 1 or greater = yes  
% 
% electrode_montage Example: 
% 
%     electrode_montage = ([
%         'F3     FZ     F4     '
%         'C3     CZ     C4     '
%         'P3     PZ     P4     '
%                         ]);
% 
% catcodes Example: 
% 
%     catcodes(1).name = 'Correct';   catcodes(1).text = 'erp.correct==1'; 
%     catcodes(2).name = 'Incorrect'; catcodes(2).text = 'erp.correct==0'; 
% 
% Command Example Freq: 
% 
%  plot_erpdata('datafile_Freq','plot_Correct_Freq','epsc2','mean',electrode_montage,catcodes,[],[],0,32,0,0,0,AT,1); 
% 
% Command Example Time: 
% 
%  plot_erpdata('datafile_Time','plot_Correct_Time','epsc2','mean',electrode_montage,catcodes,-500,-1,-100,1000,0,0,15,AT,1); 
%
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
  else,
    erp = erp_inname; erp_inname = 'erp';
  end
  erp.data=double(erp.data);

% vars 

  if exist('verbose'       ,'var')==0, verbose        =       0;      end

  % electrode_montage vars  

  if isstruct(electrode_montage), 
    electrode_locations = electrode_montage.locations; 
    electrode_montage   = electrode_montage.montage; 
  end 
  
  create_electrode_montage = 0;
  if isstruct(electrode_montage), 
    if     isfield(electrode_montage,'electrode_montage'),
      if (isequal(electrode_montage.electrode_montage,'ALL') | isequal(electrode_montage.electrode_montage,'all')),
        create_electrode_montage = 1;
      end
    else,
        create_electrode_montage = 1;
    end

    if create_electrode_montage == 1,
      electrode_montage.electrode_montage = erp.elecnames(unique(erp.elec),:);
      if ~isfield(electrode_montage,'electrode_locations'), % if both montage and location omitted, location='default' 
        electrode_montage.electrode_locations = 'default';
      end
    end
    clear create_electrode_montage;

    % reformat electrode montage  
    for j = 1:length(electrode_montage.electrode_montage(:,1)),
      cur_electrode_montage_row = electrode_montage.electrode_montage(j,1:end);
      electrode_montage.electrode_montage_row(j).col = strread(char(cur_electrode_montage_row),'%s');
    end

    % electrode_locations 
    if isfield(electrode_montage,'electrode_locations'),
      if isequal(electrode_montage.electrode_locations,'default');
        evalc(['electrode_montage.electrode_locations = readlocs(''electrode_locations_default.asc''); ']);
      else,
                electrode_montage.electrode_locations = readlocs(electrode_montage.electrode_locations);
      end
    end
  else, 
    evalc(['electrode_montage.electrode_locations = readlocs(''electrode_locations_default.asc''); ']);
    electrode_montage.electrode_montage = erp.elecnames(unique(erp.elec),:);     
  end 
  electrode_locations = electrode_montage.electrode_locations; 
  electrode_montage   = electrode_montage.electrode_montage; 

  % electrode_montage final processing  
  for j = 1:length(electrode_montage(:,1)),
    cur_electrode_montage_row = electrode_montage(j,1:end);
    electrode_montage_row(j).col = strread(char(cur_electrode_montage_row),'%s');
  end

  m_rows=length(electrode_montage_row);
  m_cols=length(electrode_montage_row(1).col);

        % gather together values for interpolated surface 
        cur_enames = [];
        for r=1:m_rows,
          for c=1:m_cols,
            cur_ename = char(electrode_montage_row(r).col(c));
            if ~isequal(deblank(cur_ename),'NA'),
              cur_enames = strvcat(cur_enames,cur_ename);

            end
          end
        end
        clear x y r c cur_ename

        % make electrode_locations and electrodes in dataset have the same electrodes 
        cur_elocs= []; cur_evals = []; cur_eval = 0;
        big_eloc = char(electrode_locations.labels);
        for j = 1:length(cur_enames(:,1)),
          cur_e =  strmatch(deblank(cur_enames(j,:)),big_eloc,'exact');
          if cur_e,   % add elec to cur_elocs  
            cur_elocs= [cur_elocs; cur_e; ];
%           cur_eval  = cur_eval  + 1;
%           cur_evals = [cur_evals; cur_evals;]; 
          else,                                             % delete elec from z 
            if verbose > 0,  
              disp(['    WARNING:' mfilename ': topomap plotting: ' deblank(cur_enames(j,:)) ' electrode location undefined -- omitted from topomap ']);
                  % for ' ...  cur_measure_name ' ' cur_measure_type ]); 
            end
          end
        end
        clear j 
        cur_eloc = electrode_locations(cur_elocs);

  % colordefs 
    plotcolors = {'r' 'b' 'g' 'k' 'm' 'c' 'y' 'r--' 'b--' 'g--' 'k--' 'm--' 'c--' 'y--' };

% prep vars 
  % define domain 
    if isfield(erp,'domain'),
      switch erp.domain
        case 'time', domain = 'time';
        case {'freq-power','freq-amplitude'}, domain = 'freq'; end
    else,          domain = 'time'; end

  % scaling  
    extract_base_convert_factors; 
    tms  = erp.tbin * bin2unitfactor; 
 
    switch domain 
      case 'time', pscale=[1:length(erp.data(1,:))]*bin2unitfactor - tms;
      case 'freq', pscale=[1:length(erp.data(1,:))]*bin2unitfactor;  end 

  % define baseline adjust or not  
    if isempty(blems)==1 | isempty(blems)==1 | (blsms==0&blems==0),   
       baseline_DC_adjust = 0;  
    else,   
       baseline_DC_adjust = 1; 
    end

  % define bins 
    switch domain
      case 'time', extract_base_ms;
      case 'freq', extract_base_Hz; end

% baseline correct
  if baseline_DC_adjust == 1, 
    for j=1:length(erp.data(:,1)),
      erp.data(j,:)=erp.data(j,:)-median(erp.data(j,blsbin:blebin));
    end
   %erp.data=baseline_dc(erp.data,blsbin:blebin);
  end 

% Artifact Tagging (AT) 
  reject = tag_artifacts(erp,AT,verbose);
  erp.stim.reject = reject.trials2reject;

% parse filterspec 
  if isequal(domain,'time'),
    % define hpf and lpf 
    if     length(filterspec)==1, hpf = 0;             lpf = filterspec(1);
    elseif length(filterspec)==2, hpf = filterspec(1); lpf = filterspec(2);
    else                        , hpf = 0;             lpf = 0; end
  end 

% reset figure 
  subplot(1,1,1); 

% main loop 
legendplotted = 0; 
cBIG = zeros(length(cur_eloc),length(erp.data(1,:)),length(catcodes));  
for r=1:m_rows,
 for c=1:m_cols,

  cur_ename = char(electrode_montage_row(r).col(c));
  curplot = ((r-1)*m_cols)+c;
  if ~isequal(cur_ename,'NA')&~isequal(cur_ename,'BLANK'),

    e=strmatch(cur_ename,erp.elecnames,'exact'); 

%   cBIG=[];
    for t=1:length(catcodes), 

      eval(['cur_cat = ' catcodes(t).text ';' ]); 
      if isfield(catcodes(t),'trials') == 1, 
        if isempty(catcodes(t).trials) == 0,
          if catcodes(t).trials == 0, cur_trials = 0; end   
          if catcodes(t).trials == 1, cur_trials = 1; end  
        else, 
         cur_trials = 0; 
        end  
      else,     
        cur_trials = 0; 
      end

      if isempty(e)==0, 
        if isfield(erp.stim,'catcodes')==1,  
          ca=erp.data(erp.elec==e&cur_cat==1&reject.trials2reject==0&erp.stim.catcodes~=-9,:); 
        else, 
          ca=erp.data(erp.elec==e&cur_cat==1&reject.trials2reject==0,:);  
        end  
      else, 
        ca=zeros(size(pscale)); 
      end 

      % extract trials or averages  
      if length(ca(:,1)) ==0, ca = zeros(size(pscale)); end
      if length(ca(:,1)) > 1, 
        if cur_trials == 0, 

          switch plottype, 
          case 'mean' 
            ca = mean(ca);  
          case 'median' 
            ca = median(ca); 
          case 'trials'
%           ca = ca; 
            disp(['ERROR:' mfilename ': trials option nor supported for topo']); return 
          otherwise 
            ca = mean(ca); 
          end  

        else, 

            ca = ca; 

        end  
      end 

      % filter 
      if isequal(domain,'time'),
%       if verbose>0, disp(['Filtering ' catcodes(t).name ' ... ']); end
        % perform filtering 
        if     lpf==0&hpf~=0,  ca=filts_highpass_butter(ca,hpf/(erp.samplerate/2));%disp('hpf'); 
        elseif lpf~=0&hpf==0,   ca=filts_lowpass_butter(ca,lpf/(erp.samplerate/2));%disp('lpf'); 
        elseif lpf~=0&hpf~=0,  ca=filts_bandpass_butter(ca,[hpf/(erp.samplerate/2) lpf/(erp.samplerate/2)]); end 
      end

      % build matrix 
      cBIG(curplot,:,t) = ca; 
 
    end 

    orient landscape;

  end 

 end
end

% legend 
    legendtxt = []; 
    for t = 1:length(catcodes),
      legendtxt = strvcat(legendtxt,char(catcodes(t).name)); 
    end 
    legendtxt = cellstr(legendtxt); 
    legendtxt(length(legendtxt)+1) = {-1}; 

% plot topo 
  subplot(1,1,1);  
  plottopo(cBIG,'chanlocs',cur_eloc,'showleg','on','legend',legendtxt,'colors',plotcolors,'axsize',[.5 .5]);  

% output and title name definition 
  t_inname = strrep(erp_inname,'_','-');
  if isequal(domain,'time'),
    if hpf~=0, hpfstr = [' Highpass ' num2str(hpf) ' Hz']; else, hpfstr=''; end
    if lpf~=0, lpfstr = [' Lowpass ' num2str(lpf) ' Hz']; else, lpfstr=''; end
    if isempty([hpfstr lpfstr]),
      filtstr = 'none';
    else,
      filtstr = [hpfstr lpfstr ];
    end
  end

  titletxt(1).text = ['Data File [ ' t_inname ' ] '];
  switch domain
    case 'time',titletxt(2).text = [' Axes [ X = ms, Y = amp. ] Filter [ ' filtstr ' ]' ];
    case 'freq',titletxt(2).text = [' Axes [ X = Hz, Y = Power ]']; end
 %titletxt(3).text = ['Plot Type [' plottype ']' ]; 
  suptitle_multi(titletxt);

% print 
if exist('outname','var'), 
if ~isempty(outname),
  if ~isempty(outformat), 
    eval(['print ' outname ' -d' outformat]); 
    if isempty(findstr(outformat,'ps'))==0, 
      eval(['!ps2pdf ' outname '.*ps']); 
    end 
  end  
end 
end 

