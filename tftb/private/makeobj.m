function makeobj(s)
%MAKEOBJ Compiles a new object file.
%   MAKEOBJ FUNC_NAME compiles the c-file with name FUNC_NAME  
%   in C:\MATLAB.LOC\IN_PREP\EXTERN\SOURCE and copies the resul-
%   ting object file into C:\MATLAB.LOC\IN_PREP\EXTERN\OBJECT.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define pathnames
mfilepath='/x/addi/tfd/private';
cfilepath='/x/addi/tfd/private';

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
[cfn,cpn]=uigetfile(cs,'Compile into C-Object Function');

% get selected file name
funa=cfn(1:end-2);

% cancel if requested
if cfn==0; disp(['''',s,''' remains uncompiled.']); return; end

% obtain full pathnames
cpt=fullfile(cpn,cfn);

% diplay file name
disp(['File: ',cpt]);

% make sure current *.dll is not locked
clear(funa);
clear mex

% compile (optimized!)
disp('Compiling...'); pause(0);
eval(['cd ',cfilepath,'; mex -O -v -c ',cpt]);

% move executable
%eval(['!move ',cfilepath,'\*.obj ',mfilepath,' |']);
%eval(['!move ',cfilepath,'\*.bak ',cfilepath,'\Backup |']);

% switch into output directory
%cd C:\MATLAB.LOC\IN_PREP\EXTERN\object
