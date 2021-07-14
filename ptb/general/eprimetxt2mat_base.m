function [stim] = readdata(infile,fieldtext)

%readdata(infile)

% vars
  x=1;
  count=0;

% read data into variables
  fid = fopen(infile,'r');
  for fnum = 1:length(fieldtext(:,1)),

    fieldname = strrep(fieldtext(fnum,5:end),' ',''); 
    fieldtype = fieldtext(fnum,1:3);

    frewind(fid);

    while x==1,

          t = fgetl(fid);
          if t == -1, x=0; break; end

          tfind = findstr(t,[fieldname ':']);
          if isempty(tfind), tfind=0; end

          if tfind~=0,
             count = count + 1;
             q=findstr(t,':');
             val = t(q+1:length(t));
             if fieldtype == 'num',
                val = str2num(val);
             elseif fieldtype =='txt',
               val = [char(val) blanks(16-length(val)) ];
             end
             eval([fieldname '(count,:) = val;']);
          end

    end

    x=1;
    count=0;

  end
  fclose(fid);

% roll variables into stim variable structure

  for fnum = 1:length(fieldtext(:,1)),

    fieldname = strrep(fieldtext(fnum,5:end),' ',''); 
  
    if isempty(findstr(fieldname,'.')) == 0, 
     
      periodspot = findstr(fieldname,'.');
      varname   = fieldname(1:periodspot(1)-1); 
      varfname  = strrep(fieldname(periodspot(1)+1:end),' ',''); 

      if exist(varname,'var') == 1, 
        if isempty(varfname)==1 | eval(['isfield(' varname ',varfname)']) ==1, 
%         message = 'yes' 
          eval(['stim.' fieldname ' = ' fieldname ';']); 
        end 
      end 
    
    else,  
     
       if exist(fieldname) == 1,
         eval(['stim.' fieldname ' = ' fieldname ';']);
       end

    end
  end 

