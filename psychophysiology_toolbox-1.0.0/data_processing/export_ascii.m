function [retval] = export_ascii(dataset_inname,dataset_outname,output_format), 

% [retval] = export_ascii(dataset_inname,dataset_outname,output_format),
% 
% Generally called from other toolbox fucntions, but can be called alone 
%    writes ascii dataset with any components in .components 
%    and any waveforms in .data input variable/filename   
% 
% Parameters: 
% 
%   dataset_inname    - components or erp data structure, passed as a variable or path to matlab file 
%   dataset_outname   - filename for output 
%   output_format     -'rows'     - data in rows of matrix, variable names in first column 
%                      'columns'  - data in columns of matrix, variable names in first row (default) 
%                      'BESA-asc' - produces .asc and .ela files for import to BESA 
%                      'BESA-mul' - produces .mul file for import to BESA (includes elec info) 
%                      'BESA-avr' - produces .avr file for import to BESA (includes elec info) 
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

  % vars 

  if ~exist('dataset_outname'), 
    if isstr('dataset_inname'), 
      if isequal(dataset_inname(end-3),'.'), 
        dataset_outname = dataset_inname(1:end-4); 
      else, 
         dataset_outname = dataset_inname; 
      end 
    else, 
      disp(['ERROR: dataset_inname not a string, and dataset_outname not defined']); 
      return  
    end 
  end 

  if ~exist('output_format'), 
    output_format = 'cols'; 
  end 
 
  data_out = cell(0);
  cur_cs = 0;

  % load data 
  if isstr(dataset_inname),
    load(dataset_inname);
    if exist('erp','var'), components = erp; clear erp; end
  else,
    components = dataset_inname; dataset_inname = 'components';  
  end

  % make elecname 
  elecname = cell(length(components.elec),1);
  for j = 1:length(elecname),
    elecname(j,:) = cellstr(components.elecnames(components.elec(j),:));
  end
  elecname = char(elecname);

  % compile header varnames 
  if isfield(components,'subnum')&~isfield(components.subs,'name'), 

    data_out(1).var = {'components.elec'    } ; data_out(1).name = {'elecnum' } ;
    data_out(2).var = {'elecname'           } ; data_out(2).name = {'elecname'} ;
    data_out(3).var = {'components.sweep'   } ; data_out(3).name = {'sweep'   } ;
    data_out(4).var = {'components.subnum'  } ; data_out(4).name = {'subnum'  } ;
    data_out(5).var = {'components.ttype'   } ; data_out(5).name = {'ttype'   } ;
    data_out(6).var = {'components.correct' } ; data_out(6).name = {'correct' } ;
    data_out(7).var = {'components.accept'  } ; data_out(7).name = {'accept'  } ;
    data_out(8).var = {'components.rt'      } ; data_out(8).name = {'rt'      } ;
    data_out(9).var = {'components.response'} ; data_out(9).name = {'response'} ;

  elseif isfield(components,'subnum')&isfield(components.subs,'name'), 

    % make subname 
    subname = cell(length(components.subnum),1);
    for j = 1:length(subname),
      subname(j,:) = cellstr(components.subs.name(components.subnum(j),:));
    end
    subname = char(subname);

    data_out(1).var = {'components.elec'    } ; data_out(1).name = {'elecnum' } ;
    data_out(2).var = {'elecname'           } ; data_out(2).name = {'elecname'} ;
    data_out(3).var = {'components.sweep'   } ; data_out(3).name = {'sweep'   } ;
    data_out(4).var = {'components.subnum'  } ; data_out(4).name = {'subnum'  } ;
    data_out(5).var = {'subname'            } ; data_out(5).name = {'subname' } ;
    data_out(6).var = {'components.ttype'   } ; data_out(6).name = {'ttype'   } ;
    data_out(7).var = {'components.correct' } ; data_out(7).name = {'correct' } ;
    data_out(8).var = {'components.accept'  } ; data_out(8).name = {'accept'  } ;
    data_out(9).var = {'components.rt'      } ; data_out(9).name = {'rt'      } ;
    data_out(10).var= {'components.response'} ; data_out(10).name= {'response'} ;

  else, 

    data_out(1).var = {'components.elec'    } ; data_out(1).name = {'elecnum' } ;
    data_out(2).var = {'elecname'           } ; data_out(2).name = {'elecname'} ;
    data_out(3).var = {'components.sweep'   } ; data_out(3).name = {'sweep'   } ;
    data_out(4).var = {'components.ttype'   } ; data_out(4).name = {'ttype'   } ;
    data_out(5).var = {'components.correct' } ; data_out(5).name = {'correct' } ;
    data_out(6).var = {'components.accept'  } ; data_out(6).name = {'accept'  } ;
    data_out(7).var = {'components.rt'      } ; data_out(7).name = {'rt'      } ;
    data_out(8).var = {'components.response'} ; data_out(8).name = {'response'} ;

  end 

  % build stim data for export 
  startnum = length(data_out);
  if isfield(components,'stim'),
    if isstruct(components.stim),
      stimnames = fieldnames(components.stim);
      for cur_cs = 1:length(stimnames),
        data_out(startnum+cur_cs).var  = eval(['{''components.stim.' char(stimnames(cur_cs)) '''};' ]);
        data_out(startnum+cur_cs).name = {char(stimnames(cur_cs))};
      end
    else,
      data_out(startnum+1).var  = {'components.stim'};
      data_out(startnum+1).name = {'stim'};
    end
  end

  % build component data for export 
  if isfield(components,'components'), 

    % tick counters indicating where header info ends and data begins 
    startnum = length(data_out);
    comps_startnum = startnum+1; 

    % component names 
    compnames = fieldnames(components.components);

    % add components 
    for cur_cs = 1:length(compnames),
      data_out(startnum+cur_cs).var  = eval(['{''components.components.' char(compnames(cur_cs)) '''};' ]);
      data_out(startnum+cur_cs).name = {char(compnames(cur_cs))};
    end

    % build data matrix 
    comps_mat = zeros(length(components.elec),length(compnames)); 
    for cur_cs = 1:length(compnames),
      comps_mat(:,cur_cs) =  eval([' components.components.' char(compnames(cur_cs)) ';' ]); 
    end

  end 

  % build waveform data for export 
  if isfield(components,'data'),

    % add tbin 
    startnum = length(data_out);
    data_out(startnum+1).var  = {'ones(size(components.elec))*components.tbin'};
    data_out(startnum+1).name = 'tbin';

    % tick counters indicating where header info ends and data begins 
    startnum = length(data_out);
    comps_startnum = startnum+1;

    % add data points 
    for cur_cs = 1:length(components.data(1,:)),
      data_out(startnum+cur_cs).var  = eval(['{''components.data(:,' num2str(cur_cs) ')''};' ]);   
      data_out(startnum+cur_cs).name = ['T' num2str(cur_cs)];  
    end

    % build data matrix 
    comps_mat = zeros(size(components.data));
    for cur_cs = 1:length(components.data(1,:)),
      comps_mat(:,cur_cs) = components.data(:,cur_cs);  
    end

  end 

  % determine type of data in each variable (e.g. char vs numeric) 
  for j=1:length(data_out),
    eval(['cur_var = ' char(data_out(j).var) ';']);
    if      ischar(cur_var),
      data_out(j).type = {'string'};
    elseif  isnumeric(cur_var),
%     if mean(mod(cur_var,1))==0,
%       data_out(j).type = {'integer'};
%     else,
        data_out(j).type = {'number'};
%     end
    end
  end

  % write out data 
  switch output_format, 
  case 'BESA-asc',

    % open file for writing 
    fid=fopen([dataset_outname '.asc'],'w');

    % vars 
    elecnames = elecname(1:length(unique(components.elec)),:);

    % write elecnames as .ela file 
    fid_ela=fopen([dataset_outname '.ela'],'w');
    for j=1:length(elecnames(:,1)),
      fprintf(fid_ela,'%s\n',elecnames(j,:));
    end
    fclose(fid_ela);

    % write comps matrix
    for j=1:length(comps_mat(:,1)),
      fprintf(fid,'%0.8g\t',comps_mat(j,1:end-1));
      fprintf(fid,'%0.8g\n',comps_mat(j,end));
    end

  case 'BESA-mul', 

    fid=fopen([dataset_outname '.mul'],'w');

    % vars 
    elecnames = unique(cellstr(elecname));

    % write header line 1 
    fprintf(fid,'TimePoints=%d  '             ,length(comps_mat(1,:))); 
    fprintf(fid,'Channels=%d  '               ,length(elecnames));
    fprintf(fid,'BeginSweep[ms]=%0.2f  '      ,(components.tbin*(1000/components.samplerate)));
    fprintf(fid,'SamplingInterval[ms]=%0.3f  ',1000/components.samplerate);
    fprintf(fid,'Bins/uV=%0.3f  '             ,1);
    fprintf(fid,'SegmentName=%s  '            ,'condition-name');
    fprintf(fid,'\n'); 

    % write elecnames as line 2 
    for j=1:length(elecnames)-1,
      fprintf(fid,' %s',char(elecnames(j)));
    end
    fprintf(fid,' %s\n'  ,char(elecnames(j+1)));

    % write comps matrix
    for j=1:length(comps_mat(1,:)),
      fprintf(fid,' %0.4g' ,comps_mat(1:end,j));
      fprintf(fid,'\n');
    end

  case 'BESA-avr', 

    % open file for writing 
    fid=fopen([dataset_outname '.avr'],'w');

    % vars 
    elecnames = unique(cellstr(elecname));

    % write header line 1 
    fprintf(fid,'Npts=%d  '   ,length(comps_mat(1,:)));
    fprintf(fid,'TSB=%0.2f  ' ,0); % (components.tbin*(1000/components.samplerate)));
    fprintf(fid,'DI=%0.3f  '  ,1000/components.samplerate);
    fprintf(fid,'SB=%0.3f  '  ,1);
    fprintf(fid,'SC=%d  '     ,1);
    fprintf(fid,'Nchan=%d  '  ,length(elecnames));
    fprintf(fid,'\n');

    % write elecnames as line 2 
    for j=1:length(elecnames)-1,
      fprintf(fid,' %s',char(elecnames(j)));
    end
    fprintf(fid,' %s\n'  ,char(elecnames(j+1)));

    % write comps matrix
    for j=1:length(comps_mat(:,1)), 
      fprintf(fid,' %0.4g',comps_mat(j,1:end)); 
      fprintf(fid,'\n');
    end

%   % EVT file 
%     % create events 
%     category_vector = components.stim.catcodes;  
%     cur_evt = category_vector(1); 
%     evt = cur_evt;  
%     for j = 1:length(components.elec), 
%       if cur_evt~=category_vector(j),  
%         evt = [evt; category_vector(j);]; 
%         cur_evt=category_vector(j); 
%       end 
%     end  

%   if exist('evt'), 
%     fid_evt=fopen([dataset_outname '.evt'],'w');
%     fprintf(fid_evt,'Tms\tCode\tTriNo\n',comps_mat(j,1:end-1)); 
%     for j=1:length(evt), 
%       event_time = ((j-1) * (1000/components.samplerate) * length(components.data(1,:))); + components.tbin * (1000/components.samplerate);  
%       fprintf(fid_evt,'%0.2f\t%d\t%0.4g\n',[event_time j evt(j)]);  
%     end 
%     fclose(fid_evt);  
%    end 

  case 'cols',

    % open file for writing 
    fid=fopen([dataset_outname '.dat'],'w');
 
    % write variable names as first line
    for j=1:length(data_out)-1,
      fprintf(fid,'%s\t',char(data_out(j).name));
    end
    fprintf(fid,'%s'  ,char(data_out(j+1).name));
    fprintf(fid,'\n');

    % write data loop - row by row
    for q=1:length(components.elec)

      % write header vars
      for j=1:comps_startnum-1, % length(data_out)-1,
        eval(['cur_var = ' char(data_out(j).var) ';']);

        switch char(data_out(j).type),
          case 'string',  fprintf(fid,'%s\t',   cur_var(q,:));
%         case 'integer', fprintf(fid,'%d\t',   cur_var(q,:));
          case 'number',  fprintf(fid,'%0.8g\t',cur_var(q,:)); end

      end

      % write comps matrix
      if (length(data_out)-(comps_startnum-1)) > 1,
        fprintf(fid,'%0.8g\t',comps_mat(q,1:end-1));
      end
        fprintf(fid,'%0.8g\n',comps_mat(q,end));

    end

  case 'rows', 

    % open file for writing 
    fid=fopen([dataset_outname '.dat'],'w');

    % write data loop - row by row  
    for j=1:length(data_out), 
      fprintf(fid,'%s\t',char(data_out(j).name));
      eval(['cur_var = ' char(data_out(j).var) ';']);

      switch char(data_out(j).type),
      case 'string',  
        for q=1:length(cur_var(:,1)), 
          fprintf(fid,'%s\t',   cur_var(q,:)); 
        end 
      case 'number',  fprintf(fid,'%0.8g\t',cur_var'); end

      fprintf(fid,'\n');

    end 

  end 

  fclose(fid);

  retval = 1; 


%%% OLD Alternative Methods NOT Employed %%% 

% % write out data - column by column, even through comps matrix  
% fid=fopen([dataset_outname '.dat'],'w');
% 
%   % write headers 
%   for j=1:length(data_out)-1,
%     fprintf(fid,'%s\t',char(data_out(j).name));
%   end
%   fprintf(fid,'%s'  ,char(data_out(j+1).name));
%   fprintf(fid,'\n');
%
%   % write data 
%   for q=1:length(components.elec)
%   for j=1:length(data_out)-1,
%     eval(['cur_var = ' char(data_out(j).var) ';']);
% 
%     switch char(data_out(j).type),
%     case 'string',
%       fprintf(fid,'%s\t',cur_var(q,:));
%%    case 'integer',
%%      fprintf(fid,'%0.8g\t',cur_var(q,:));
%     case 'number'
%       fprintf(fid,'%0.8g\t',cur_var(q,:));
%     end
% 
%   end
%     eval(['cur_var = ' char(data_out(j+1).var) ';']);
% 
%     switch char(data_out(j+1).type),
%     case 'string',
%       fprintf(fid,'%s',cur_var(q,:));
%     case 'integer',
%       fprintf(fid,'%0.8g',cur_var(q,:));
%     case 'number'
%       fprintf(fid,'%0.8g',cur_var(q,:));
%     end
%     fprintf(fid,'\n');
%   end
% 
% fclose(fid);
% 
% retval = 1; 

%   % write data - attempt to compile big text matrix to use fwrite - slow and not working 
%   data_out_text = []; 
%   for j=1:2, %length(data_out),
% 
%     eval(['cur_var = ' char(data_out(j).var) ';']);
% 
%     switch char(data_out(j).type),
%     case 'string',
%     eval(['cur_var = ' char(data_out(j).var) ';']);
%     case 'integer',
%     eval(['cur_var = num2str(' char(data_out(j).var) ');']);
%    %eval(['cur_var = sprintf(''%0.8g'',' char(data_out(j).var) ');']);
%     case 'number'
%     eval(['cur_var = num2str(' char(data_out(j).var) ');']);
%    %eval(['cur_var = sprintf(''%0.8g'',' char(data_out(j).var) ');']);
%     end
% 
%     data_out_text = [data_out_text, cur_var,]; 
% 
%   end

