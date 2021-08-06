function [erp] = merge_data2stim(erp,erp_key,mergedata,mergedata_key,missingvalue,fields2merge,OPTIONS,verbose), 

% [erp] = merge_data2stim(erp,erp_key,mergedata,mergedata_key,missingvalue,fields2merge,OPTIONS,verbose),
% 
%    erp            - erp structure to merge data into  
%    erp_key        - 1) cell array or vector to match in mergedata:   e.g.  erp.stim.KEYVAR  
%                     2) string of field in erp to match in mergedata: e.g. 'erp.stim.KEYVAR' 
%                     3) 'SUBNAME' keyword for matching by subname (erp.subs.name)  
%    mergedata      - data to merge, or filename of read_ascii_dataset compatible file. 
%    mergedata_key  - 1) cell array or vector to match in erp:         e.g. mergedata.KEYVAR  
%                     2) string of field to match in erp:              e.g. 'KEYVAR' 
%    missingvalue   - missing value 
%    fields2merge   - string or cell array of fields from datafile to merge into erp.stim  
%                     'ALL' will merge all fields in the file  
%    OPTIONS        - .case - 'upper' or 'lower' to force case of variable names 
%    verbose        - verbosity 1-? - not yet effective 
% 
%    NOTES:  
%          
%       1) mergedata must be cell arrays of strings containing numeric data.  
%          (read_ascii_dataset will provide the correct format). String data  
%          will appear in resulting erp structure as its ascii number. 
%          Missing value must be specified as a number in string format.   
%          
%       2) fields that already exist in erp.stim, will have new data merged in. 
% 

   % if stim field not present, create it 
   if ~isfield(erp,'stim'), erp.stim = []; end 

   % read in data if requested 
   if ~isstruct(mergedata), 
     mergedata=read_ascii_dataset(mergedata,missingvalue);
   end 
 
   % force case if requested 
   if exist('OPTIONS')==2 && isfield(OPTIONS,'case'), 
     fns = fieldnames(mergedata); 
     eval(['fnsnew=' OPTIONS.case '(fns);']);
     for jj=1:length(fns), 
       eval(['mergedata_new.' char(fnsnew(jj))  '= mergedata.' char(fns(jj)) ';' ]); 
     end 
     mergedata = mergedata_new; 
     clear mergedata_new 
   end 
 
   % handle string name of key variables vs. actual variables passed 
   if isstr(erp_key) && ~isequal(erp_key,'SUBNAME'),
     erp_key = eval([ erp_key ]);
   end
   if isstr(mergedata_key), 
     mergedata_key = eval(['mergedata.' mergedata_key ';']); 
   end 

   % build index of the fields to merge 
   if ~exist('fields2merge','var') || isempty('fields2merge') || isequal(upper(fields2merge),'ALL'), 
     fns = fieldnames(mergedata); 
   else, 
     fns = fields2merge; 
   end 
  %SUBNAME = strmatch('SUBNAME',fns); 

   % build empty vectors for new data as needed 
   for f = 1:length(fns), 
     if ~isfield(erp.stim,char(fns(f))),  
       eval(['erp.stim.' char(fns(f)) ' = ones(size(erp.elec))* ' missingvalue ';']); 
     end  
   end

   % merge in new data 
   for j=1:length(mergedata_key), 
     if isequal(erp_key,'SUBNAME') 
       cur_subnum = strmatch(mergedata_key(j),erp.subs.name,'exact');   
         if length(cur_subnum) > 1,
           disp(['ERROR: ' mfilename ' : current SUBNAME has duplicates in erp dataset -- SUBNAME = ' erp.subs.name(cur_subnum(1),:) ]); 
           erp = []; 
           return 
         end
       if ~isempty(cur_subnum) 
         cur_mergeval = find(erp.subnum==cur_subnum); 
       else 
         cur_mergeval = cur_subnum;  
       end  
     else, 
       if isnumeric(mergedata_key(j)), 
         cur_mergeval = find(erp_key==mergedata_key(j));
       else, 
         cur_mergeval = find(erp_key==str2num(char(mergedata_key(j))));
       end 
     end 

     if ~isempty(cur_mergeval),
        for f=1:length(fns), 
          if ~isequal(eval(['erp.stim.' char(fns(f)) ]),erp_key), 
            if isnumeric( eval(['mergedata.' char(fns(f)) '(j)']) ), 
              if ~isempty( eval(['mergedata.' char(fns(f)) '(j)']) ),  
                eval(['erp.stim.' char(fns(f)) '(cur_mergeval) = mergedata.' char(fns(f)) '(j);']); 
              else, 
                eval(['erp.stim.' char(fns(f)) '(cur_mergeval) = str2num(missingvalue);']);  
              end  
            else, 
              if ~isempty( eval(['str2num(char(mergedata.' char(fns(f)) '(j)))']) ),  
                eval(['erp.stim.' char(fns(f)) '(cur_mergeval) = str2num(char(mergedata.' char(fns(f)) '(j)));']); 
              else, 
                eval(['erp.stim.' char(fns(f)) '(cur_mergeval) = str2num(missingvalue);']);  
              end  
            end 
          end  
        end 
     end

   end

