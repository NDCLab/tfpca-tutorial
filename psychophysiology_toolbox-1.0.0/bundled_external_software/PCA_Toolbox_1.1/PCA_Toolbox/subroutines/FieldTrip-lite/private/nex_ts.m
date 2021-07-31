function [n, ts] = nex_ts(filename, varname)
% nex_ts(filename, varname): Read timestamps from a .nex file
%
% [n, ts] = nex_ts(filename, varname)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   varname - variable name
% OUTPUT:
%   n - number of timestamps
%   ts - array of timestamps (in seconds)

% original from Plexon, download from http://www.plexoninc.com (8/4/02)
% modifications by Robert Oostenveld
%
% $Log: nex_ts.m,v $
% Revision 1.1  2005/02/11 07:46:34  roboos
% downloaded from Plexon website, added support for reading nex files on Solaris and Mac OS X (fopen ieee-le), added log-section to the comments after the help
%

n = 0;
ts = 0;

if(nargin ~= 2)
   disp('2 input arguments are required')
   return
end

if(ischar(filename) == 0)
   disp('input arguments should be character arrays')
   return
end

if(ischar(varname) == 0)
   disp('input arguments should be character arrays')
   return
end

if(length(filename) == 0)
   [fname, pathname] = uigetfile('*.nex', 'Select a Nex file');
	filename = strcat(pathname, fname);
end

fid = fopen(filename, 'r', 'ieee-le');
if(fid == -1)
	disp('cannot open file');
   return
end

disp(strcat('file = ', filename));
magic = fread(fid, 1, 'int32');
version = fread(fid, 1, 'int32');
comment = fread(fid, 256, 'char');
freq = fread(fid, 1, 'double');
tbeg = fread(fid, 1, 'int32');
tend = fread(fid, 1, 'int32');
nvar = fread(fid, 1, 'int32');
fseek(fid, 260, 'cof');
name = zeros(1, 64);
found = 0;
for i=1:nvar
	type = fread(fid, 1, 'int32');
	var_version = fread(fid, 1, 'int32');
	name = fread(fid, [1 64], 'char');
	offset = fread(fid, 1, 'int32');
	n = fread(fid, 1, 'int32');
	name = setstr(name);
	name = deblank(name);
	k = strcmp(name, deblank(varname));
	if(k == 1)
		found = 1;
		fseek(fid, offset, 'bof');
		ts = fread(fid, [1 n], 'int32');
		break
	end
	dummy = fread(fid, 128, 'char');
end

fclose(fid);

if found == 0
	disp('did not find variable in the file');
else
	ts = ts/freq;
	disp(strcat('number of timestamps = ', num2str(n)));
end
