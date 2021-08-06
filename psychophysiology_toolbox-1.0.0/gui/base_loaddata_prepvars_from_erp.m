
% Psychophysiology Toolbox, Components, University of Minnesota  

  % message 
    if verbose > 0, disp(['          ' mfilename ': processing variables after loading data: start']); end 

  % define domain 
    if isfield(erp,'domain'),
      switch erp.domain
        case 'time', domain = 'time';
        case {'freq-power','freq-amplitude'}, domain = 'freq'; 
        case 'TFD', disp(['ERROR: input data cannot be TFD, must be time or freq']); break; end 
    else,          
      domain = 'time'; 
    end
    if     isfield(SETvars,'trl2avg') &&  isfield(SETvars.trl2avg,'domain'),  
      switch SETvars.trl2avg.domain,
        case 'time', domain = 'time';
        case {'freq-power','freq-amplitude'}, domain = 'freq'; 
        case 'TFD', disp(['ERROR: requested trl2avg data cannot be TFD, must be time or freq']); break; end 
    end  

  % define erp bins if undefined 
    switch IDvars.runtype,
    case {'pca'   ,'win'   },
      if startbin==0 & endbin==0,
      startbin   = 1; endbin   = length(erp.data(1,:))-erp.tbin;
      end
    end

  % parse electrode variables 

    % electrode_montage 
    create_electrode_montage = 0; 
    if     isfield(SETvars,'electrode_montage'), 
      if (isequal(SETvars.electrode_montage,'ALL') | isequal(SETvars.electrode_montage,'all')), 
        create_electrode_montage = 1; 
      end 
    elseif (isequal(SETvars.electrode_locations,'NONE') | isequal(SETvars.electrode_locations,'none')) % Added by BenningS
        create_electrode_montage = 0; % Added by BenningS    
    else, 
        create_electrode_montage = 1;
    end 

    if create_electrode_montage == 1,  
      SETvars.electrode_montage = erp.elecnames(unique(erp.elec),:);
      if ~isfield(SETvars,'electrode_locations'), % if both montage and location omitted, location='default' 
        SETvars.electrode_locations = 'default';
      end
    end
    clear create_electrode_montage; 

    % reformat electrode montage  
    for j = 1:length(SETvars.electrode_montage(:,1)),
      cur_electrode_montage_row = SETvars.electrode_montage(j,1:end);
      SETvars.electrode_montage_row(j).col = strread(char(cur_electrode_montage_row),'%s');
    end

    % electrode_locations 
    if isfield(SETvars,'electrode_locations'),
      if isequal(SETvars.electrode_locations,'default');
        evalc(['SETvars.electrode_locations = readlocs(''electrode_locations_default.ced''); ']);
      elseif (isequal(SETvars.electrode_locations,'NONE') | isequal(SETvars.electrode_locations,'none')) % Added by BenningS
        create_electrode_montage = 0; % Added by BenningS    
      else,
                eval(['SETvars.electrode_locations = readlocs(' SETvars.electrode_locations ');' ]); 
      end
    end

    % handle ISFspecs and trl2 avg 

        % ISFspecs 
          if exist('ISFspecs','var') && isfield(ISFspecs,'subnames'),
            if ~isfield(ISFspecs,'preprocessing'),    ISFspecs.preprocessing    =                0; end
            if ~isfield(ISFspecs,'ttypes2extract'),   ISFspecs.ttypes2extract   =            'ALL'; end
            if ~isfield(ISFspecs,'verbose'),          ISFspecs.verbose          =          verbose; end
            if ~isfield(ISFspecs,'baselinestartms')  
              if isfield(SETvars,'trl2avg') && isfield(SETvars.trl2avg,'baselinestartms'), 
                                                      ISFspecs.baselinestartms  = SETvars.trl2avg.baselinestartms;
              else,                                   ISFspecs.baselinestartms  =                 0; end, end
            if ~isfield(ISFspecs,'baselineendms')  
              if isfield(SETvars,'trl2avg') && isfield(SETvars.trl2avg,'baselineendms'), 
                                                      ISFspecs.baselineendms    = SETvars.trl2avg.baselineendms;
              else,                                   ISFspecs.baselineendms    =                 0; end, end
            if ~isfield(ISFspecs,'startms')
              if isfield(SETvars,'trl2avg') && isfield(SETvars.trl2avg,'startms'),
                                                      ISFspecs.startms          = SETvars.trl2avg.startms;
              else,                                   ISFspecs.startms          =                 0; end, end
            if ~isfield(ISFspecs,'endms')
              if isfield(SETvars,'trl2avg') && isfield(SETvars.trl2avg,'endms'),
                                                      ISFspecs.endms            = SETvars.trl2avg.endms;
              else,                                   ISFspecs.endms            =                 0; end, end
            if ~isfield(ISFspecs,'AT'),
              if isfield(SETvars,'trl2avg') && isfield(SETvars.trl2avg,'AT'),
                                                      ISFspecs.AT               = SETvars.trl2avg.AT;
              else,                                   ISFspecs.AT               =             'none';
              end
            end
            if ~isfield(ISFspecs,'domain'),
              if isfield(erp,'domain'),               ISFspecs.domain           =         erp.domain;
              else,                                   ISFspecs.domain           =             'time';
              end
            end
          end

        % SETvars.trl2avg 
          if isfield(SETvars,'trl2avg'),
            if ~isfield(SETvars.trl2avg,'preprocessing'),       SETvars.trl2avg.preprocessing       =          0; end
            if ~isfield(SETvars.trl2avg,'catcodes'),            SETvars.trl2avg.catcodes            =      'ALL'; end
            if ~isfield(SETvars.trl2avg,'verbose'),             SETvars.trl2avg.verbose             =    verbose; end
            if ~isfield(SETvars.trl2avg,'baselinestartms')  
              if isfield(ISFspecs,'baselinestartms'), 
                                                                SETvars.trl2avg.baselinestartms     = ISFspecs.baselinestartms;
              else,                                             SETvars.trl2avg.baselinestartms     =          0; end, end 
            if ~isfield(SETvars.trl2avg,'baselineendms')  
              if isfield(ISFspecs,'baselineendms'), 
                                                                SETvars.trl2avg.baselineendms       = ISFspecs.baselineendms;
              else,                                             SETvars.trl2avg.baselineendms       =          0; end, end
            if ~isfield(SETvars.trl2avg,'startms')
              if isfield(ISFspecs,'startms'),
                                                                SETvars.trl2avg.startms             = ISFspecs.startms;
              else,                                             SETvars.trl2avg.startms             =          0; end, end
            if ~isfield(SETvars.trl2avg,'endms')
              if isfield(ISFspecs,'endms'),
                                                                SETvars.trl2avg.endms               = ISFspecs.endms;
              else,                                             SETvars.trl2avg.endms               =          0; end, end
            if ~isfield(SETvars.trl2avg,'min_trials_averaged'), SETvars.trl2avg.min_trials_averaged =          1; end
            if ~isfield(SETvars.trl2avg,'AT'),
              if exist('ISFspecs','var') && isfield(ISFspecs,'AT'),
                                                                SETvars.trl2avg.AT                  =ISFspecs.AT;
              else,                                             SETvars.trl2avg.AT                  =     'none';
              end
            end
            if ~isfield(SETvars.trl2avg,'domain'),
              if isfield(erp,'domain'),                         SETvars.trl2avg.domain              = erp.domain;
              else,                                             SETvars.trl2avg.domain              =     'time';
              end
            end
          end

    % build elecs2extract.keepELECs to reduce to requested electrodes during extract trials/averages  
    m_rows=length(SETvars.electrode_montage_row);
    m_cols=length(SETvars.electrode_montage_row(1).col);
    extractvars.elecs2extract.keepELECs = '';
     for r=1:m_rows,
       for c=1:m_cols,
        cur_ename = char(SETvars.electrode_montage_row(r).col(c));
        if isequal(deblank(cur_ename),'NA'),
          % skip 
        else,
          if isempty(strmatch(deblank(cur_ename),erp.elecnames,'exact')),
            disp(['electrode name ' cur_ename ' from electrode_montage is invalid']);
           %retval = 0; erp = 0; return;
          else,
            extractvars.elecs2extract.keepELECs = strvcat(extractvars.elecs2extract.keepELECs,cur_ename);
          end
        end
       end
     end
     extractvars.elecs2extract.keepELECs = cellstr(extractvars.elecs2extract.keepELECs);

    % resample definition  
    if rs~=erp.samplerate,
      if isequal(domain,'time'),
        extractvars.resamplerate = rs;
      else,
        disp(['    ERROR: resampling not allowed for freq domain files -- NOT resampled -- you''re not getting what you requested']);
        return 
      end
    else,
      extractvars.resamplerate = erp.samplerate;
    end

  % message 
    if verbose > 0, disp(['          ' mfilename ': processing variables after loading data: end ']); end

