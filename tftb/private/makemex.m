function makemex(s)
%MAKEMEX Builds a C-MEX DLL file.
%   MAKEMEX FUNC_NAME compiles the c-file with name FUNC_NAME  
%   in C:\MATLAB.LOC\IN_PREP\EXTERN\SOURCE and links it to a
%   C-MEX DLL file into C:\MATLAB.LOC\IN_PREP\EXTERN\MEXFILES.
%   All auxiliary files are stored in ~\EXTERN\AUXFILES.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define pathnames
mfilepath='/x/addi/tfd/private';
cfilepath='/x/addi/tfd/private';
afilepath='/x/addi/tfd/private';
ofilepath='/x/addi/tfd/private';


% check for filename specification
if nargin<1; s='*'; end

% reduce name to maximum of eight characters
s=deblank(s); if length(s)>8; s=s(1:8); end
if isempty(s); s='*'; end

% check for illegal character
if ~isempty(findstr(s,'.'));
   error(['Function name ''',s,''' is illegal.']);
end

% make all characters lower case
funa=lower(s); s=funa; % s(1)=upper(s(1));

% get path and filename
cs=[cfilepath,'/',s,'.c'];
[cfn,cpn]=uigetfile(cs,'Build C-MEX DLL Function');

% get selected file name
funa=cfn(1:end-2);

% cancel if requested
if cfn==0; disp(['''',s,''' remains uncompiled.']); return; end

% obtain full pathnames
cpt=fullfile(cpn,cfn);

% diplay file name
disp(['File   : ',upper(cpt)]);

% make sure current *.dll is not locked
clear(funa);
clear mex

% obtain list of object files from pragma statements
obj='';
% open file
fid=fopen(cpt,'r');
% read file line by line
culi=fgetl(fid);
% set comment flag to zero
cmnt=0;
while isstr(culi);
   red=culi;
   % read line token by token
   while ~isempty(red);
      culi=red; [tok,red]=strtok(culi);
      if strcmp(tok,'/*'); cmnt=1; end
      if strcmp(tok,'*/'); cmnt=0; end
      % treat #pragma line only outside of comment
      if cmnt==0;
         if strcmp(lower(tok),'#pragma');
            [tok2,red2]=strtok(red);
            if strcmp(lower(tok2),'use_object');
               tok3=strtok(red2);
               if isempty(tok3);
                  error('Missing #pragma use_object file.'); end
               disp(['Object : ',ofilepath,'/',upper(tok3),'.o']);
               obj=[obj,' ',ofilepath,'/',tok3,'.o'];
            end
         end
      end
   end
   culi=fgetl(fid);
end
fclose(fid);

% compile and link (optimized!)
disp('Compiling and Linking...'); pause(0);
eval(['cd ',cfilepath,'; mex -O -v ',cpt,obj]);

% move executable
%eval(['!move ',cfilepath,'\*.dll ',mfilepath,' |']);
%eval(['!move ',cfilepath,'\*.bak ',cfilepath,'\Backup |']);
%eval(['!move ',cfilepath,'\*.def ',afilepath,' |']);
%eval(['!move ',cfilepath,'\*.map ',afilepath,' |']);

% switch to output directory
%cd C:\MATLAB.LOC\IN_PREP\EXTERN\MEXFILES

