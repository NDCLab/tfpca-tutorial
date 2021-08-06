function [retval] = ff(erp_inname),

% [retval] = check_erp(erp_inname), 
% 
%  erp_inname - can be erp structure, or filename containing erp structure 
% 
%  retval     - zero if no errors 
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 

% load and prep data
  if isstr(erp_inname),
    load(erp_inname,'-MAT');
    if ~exist('erp'),
      disp(['erp structure doesn''t exist']);
    end
  else,
    erp = erp_inname; erp_inname = 'erp';
  end

% vars 
  checkerror = 0; 

% check that needed fields are present 
  if ~isfield(erp,           'elec'), disp(['Needed field missing: elec           ']); checkerror = checkerror+1;  end
  if ~isfield(erp,          'sweep'), disp(['Needed field missing: sweep          ']); checkerror = checkerror+1;  end
  if ~isfield(erp,        'correct'), disp(['Needed field missing: correct        ']); checkerror = checkerror+1;  end
  if ~isfield(erp,         'accept'), disp(['Needed field missing: accept         ']); checkerror = checkerror+1;  end
  if ~isfield(erp,          'ttype'), disp(['Needed field missing: ttype          ']); checkerror = checkerror+1;  end
  if ~isfield(erp,             'rt'), disp(['Needed field missing: rt             ']); checkerror = checkerror+1;  end
  if ~isfield(erp,       'response'), disp(['Needed field missing: response       ']); checkerror = checkerror+1;  end
  if ~isfield(erp,           'data'), disp(['Needed field missing: data           ']); checkerror = checkerror+1;  end
  if ~isfield(erp,      'elecnames'), disp(['Needed field missing: elecnames      ']); checkerror = checkerror+1;  end
  if ~isfield(erp,           'tbin'), disp(['Needed field missing: tbin           ']); checkerror = checkerror+1;  end
  if ~isfield(erp,     'samplerate'), disp(['Needed field missing: samplerate     ']); checkerror = checkerror+1;  end
  if ~isfield(erp,'original_format'), disp(['Needed field missing: original_format']); checkerror = checkerror+1;  end
  if ~isfield(erp,      'scaled2uV'), disp(['Needed field missing: scaled2uV      ']); checkerror = checkerror+1;  end

% check that index vectors are the correct length 
  datalength = length(erp.data(:,1));
  if ~isequal(datalength,length(erp.elec           )), disp(['Index vector length different from rows of data: elec    ']); checkerror = checkerror+1;end
  if ~isequal(datalength,length(erp.sweep          )), disp(['Index vector length different from rows of data: sweep   ']); checkerror = checkerror+1;end
  if ~isequal(datalength,length(erp.correct        )), disp(['Index vector length different from rows of data: correct ']); checkerror = checkerror+1;end
  if ~isequal(datalength,length(erp.accept         )), disp(['Index vector length different from rows of data: accept  ']); checkerror = checkerror+1;end
  if ~isequal(datalength,length(erp.ttype          )), disp(['Index vector length different from rows of data: ttype   ']); checkerror = checkerror+1;end
  if ~isequal(datalength,length(erp.rt             )), disp(['Index vector length different from rows of data: rt      ']); checkerror = checkerror+1;end
  if ~isequal(datalength,length(erp.response       )), disp(['Index vector length different from rows of data: response']); checkerror = checkerror+1;end
                                                                                                                            
  if isfield(erp,'stim'),                                                                                                   
    stimnames = fieldnames(erp.stim);                                                                                       
    for sn = 1:length(stimnames),                                                                                           
      cur_stimname = char(stimnames(sn,:));                                                                                 
      if ~isequal(datalength,length(eval(['erp.stim.' cur_stimname ]))), disp(['Index vector length different from rows of data: stim.' cur_stimname]); checkerror = checkerro+1;end 
    end
  end

% return value 
  retval = checkerror; 
