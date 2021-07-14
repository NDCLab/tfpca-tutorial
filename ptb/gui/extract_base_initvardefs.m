
  % default values 
  if exist('rsrate'          ,'var')==0, rsrate          =       0;      end
  if exist('P1'              ,'var')==0, P1              =       0;      end
  if exist('P2'              ,'var')==0, P2              =       0;      end
  if exist('XX'              ,'var')==0, XX              =       0;      end
  if exist('AT'              ,'var')==0, AT              =       'NONE'; end
  if exist('catcodes2extract','var')==0, catcodes2extract=       'ALL';  end
  if exist('elecs2extract'   ,'var')==0, elecs2extract   =       'ALL';  end
  if exist('verbose'         ,'var')==0, verbose         =       0;      end

  % domain variable 
  if isstruct(domain),
    domainparms = domain;
    domain      = domain.domain;
  end

  switch domain
  case 'time'
  case 'freq-power'
  case 'freq-amplitude'
  case 'TFD'
  otherwise
    disp('ERROR: domain definition'); return
  end

  if findstr(domain,'freq'),
    if exist('domainparms'),
      if ~isfield(domainparms,'windowname'),
        disp('ERROR: domain.windowname definition'); return
      end
      if ~isfield(domainparms,'windowparms'),
        domainparms.windowparms = [''];
      end
    else, % default fft windowing  
      domainparms.windowname = '@tukeywin';
      domainparms.windowparms = '.25';
    end
  end
  if findstr(domain,'TFD'),
    if exist('domainparms'),
      if ~isfield(domainparms,'method'),      domainparms.method = 'bintfd'; end
      if ~isfield(domainparms,'options'),   domainparms.options = ['''PosOnly'',''Analytic'',0,''Hanning''']; end
    else,
      domainparms.method = 'bintfd';
      domainparms.options = ['''PosOnly'',''Analytic'',0,''Hanning'''];
    end
  end

  if verbose >=1, 
    disp(['     Domain: ' domain ]); 
    if exist('domainparms'), 
    disp(['       Domain parameters are: ']);  
    disp(domainparms); 
    end 
  end 

  % create stim variable to be index for new averaged data  
  berp.data                 = [];
  berp.elec                 = [];
  berp.erpN                 = [];
  berp.sweep                = [];
  berp.subnum               = [];
  berp.ttype                = [];
  berp.correct              = [];
  berp.accept               = [];
  berp.rt                   = [];
  berp.response             = [];
  berp.subs.name            = [];

