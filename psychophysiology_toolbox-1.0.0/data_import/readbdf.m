function bdf = readbdf(file_name, scale);
%READBDF  Reads and returns contents of Biosemi data file
%
%Usage:   bdf = readbdf(file_name[, scale]);
%         bdf = readbdf(file_name);
%         bdf = readbdf(file_name, 0);
%
%Input:   Name of Biosemi-formatted (bdf) file
%           (returns error in error field if
%           not .bdf file extension) 
%         scale: OPTIONAL boolean (0/1) parameter indicating whether 
%           to scale to uV (1, default)
%
%Output:  structured variable containing the 
%           following fields:
%             data (as channels by samples matrix), 
%             elecnames (channel labels), 
%             samplerate, 
%             event (Status channel), 
%             elec (numeric vector),
%             scaled2uV (boolean), and 
%             original_format
%             error (if one occurs)
%            
% NB: If an error occurs reading the file header, the data field
%     will be an empty matrix 

%smm, fall 2006
%This function is built around functions from the BIOSIG toolbox,
%written by Alois Schloegl

if exist('scale', 'var')==0, scale = 1; end

if exist(file_name, 'file')
    [path, name, ext, version] = fileparts(file_name);
    msg = ['Opening ' file_name];
    if strcmpi(ext, '.bdf')
        if scale==0
            HDR = sopen(file_name, 'rb', 0, 'UCAL');
            disp([msg '. Data are in RAW AD UNITS']);
            scaled2uV = 0;
        else 
            HDR = sopen(file_name);
            disp([msg '. Data will be converted to microvolts.']);
            scaled2uV = 1;
        end
        disp(['Reading ' file_name]);
        if HDR.NS == 1
            msg = (['***According to file header, the only channel is ' ...
                     deblank(HDR.Label) '. Data matrix will be empty.']);
            disp(msg);
            bdf.error       = msg;
            bdf.data        = [];
            bdf.event       = [];
        else
            [S, HDR]        = sread(HDR);
            HDR             = sclose(HDR);
            bdf.data        = S';
            bdf.event       = bdf.data(end,:);
        end
        bdf.elec            = (1:HDR.NS)';
        bdf.elecnames       = HDR.Label;
%       bdf.event           = bdf.data(end,:);
        bdf.samplerate      = HDR.SampleRate;
        bdf.original_format = 'bdf-cnt';
        bdf.scaled2uV       = scaled2uV;
    else
        msg = ['File ' file_name ' is not a bdf-formatted (Biosemi) file'];
        disp(msg);
        bdf.error = msg;
    end
else
    msg = ['File ' file_name ' not found'];
    disp(msg);
    bdf.error = msg;
end

%---------------------------------------------------------------%

function [HDR,H1,h2] = sopen(arg1,PERMISSION,CHAN,MODE,arg5,arg6)
% SOPEN opens signal files for reading and writing and returns 
%       the header information. Many different data formats are supported.
%
% HDR = sopen(Filename, PERMISSION, [, CHAN [, MODE]]);
% [S,HDR] = sread(HDR, NoR, StartPos);
% HDR = sclose(HDR);
%
% PERMISSION is one of the following strings 
%	'r'	read header
%	'w'	write header
%
% CHAN defines a list of selected Channels
%   Alternative CHAN can be also a Re-Referencing Matrix ReRefMx
%       (i.e. a spatial filter). 
%   E.g. the following command returns the difference and 
%       the mean of the first two channels. 
%   HDR = sopen(Filename, 'r', [[1;-1],[.5,5]]);
%   [S,HDR] = sread(HDR, Duration, Start);
%   HDR = sclose(HDR);
%
% Several files can be loaded at once with SLOAD
%
% HDR contains the Headerinformation and internal data
% S 	returns the signal data 
%
% see also: SLOAD, SREAD, SSEEK, STELL, SCLOSE, SWRITE, SEOF


% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

%	$Revision: 1.84 $
%	$Id: sopen.m,v 1.84 2004/12/30 21:47:38 schloegl Exp $
%	(C) 1997-2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/


if isnan(str2double('1, 3'));
        fprintf(2,'Warning BIOSIG: incorrect version of STR2DOUBLE.\n');
        fprintf(2,'- Its recommended to update STR2DOUBLE. Contact Alois!\n');
end;

global FLAG_NUMBER_OF_OPEN_FIF_FILES;

if ischar(arg1),
        HDR.FileName = arg1;
%elseif length(arg1)~=1,
%	HDR = [];
elseif isfield(arg1,'name')
        HDR.FileName = arg1.name;
	HDR.FILE = arg1; 
else %if isfield(arg1,'FileName')
        HDR = arg1;
%else
%	HDR = [];
end;


if nargin<2, 
        PERMISSION='r'; 
elseif isempty(PERMISSION),
        PERMISSION='r'; 
elseif isnumeric(PERMISSION),
        fprintf(HDR.FILE.stderr,'Warning SOPEN: second argument should be PERMISSION, assume its the channel selection\n');
        CHAN = PERMISSION; 
        PERMISSION = 'r'; 
elseif ~any(PERMISSION(1)=='RWrw'),
        fprintf(HDR.FILE.stderr,'Warning SOPEN: PERMISSION must be ''r'' or ''w''. Assume PERMISSION is ''r''\n');
        PERMISSION = 'r'; 
end;
if ~any(PERMISSION=='b');
        PERMISSION = [PERMISSION,'b']; % force binary open. Needed for Octave
end;

if nargin<3, CHAN = 0; end; 
if all(size(CHAN)>1) | any(floor(CHAN)~=CHAN) | (any(CHAN<0) & prod(size(CHAN))>1),
        ReRefMx = CHAN; 
        CHAN = find(any(CHAN,2));
end

if nargin<4, MODE = ''; end;
if isempty(MODE), MODE=' '; end;	% Make sure MODE is not empty -> FINDSTR

% test for type of file 
if any(PERMISSION=='r'),
        HDR = getfiletype(HDR);
	if HDR.ERROR.status, 
		fprintf(HDR.FILE.stderr,'%s\n',HDR.ERROR.message);
		return;
	end;
else
	[pfad,file,FileExt] = fileparts(HDR.FileName);
	HDR.FILE.Name = file;
	HDR.FILE.Path = pfad;
	HDR.FILE.Ext  = FileExt(2:length(FileExt));
	if ~isfield(HDR.FILE,'stderr'),
	        HDR.FILE.stderr = 2;
	end;
	if ~isfield(HDR.FILE,'stdout'),
	        HDR.FILE.stdout = 1;
	end;	
	HDR.FILE.OPEN = 0;
        HDR.FILE.FID  = -1;
	HDR.ERROR.status  = 0; 
	HDR.ERROR.message = ''; 
end;

%% Initialization
if ~isfield(HDR,'NS');
        HDR.NS = NaN; 
end;
if ~isfield(HDR,'SampleRate');
        HDR.SampleRate = NaN; 
end;
if ~isfield(HDR,'Label');
        HDR.Label = []; 
end;
if ~isfield(HDR,'PhysDim');
        HDR.PhysDim = ''; 
end;
if ~isfield(HDR,'T0');
        HDR.T0 = repmat(nan,1,6);
end;
if ~isfield(HDR,'Filter');
        HDR.Filter.LowPass  = NaN; 
        HDR.Filter.HighPass = NaN; 
end;
if ~isfield(HDR,'FLAG');
        HDR.FLAG.UCAL = ~isempty(strfind(MODE,'UCAL'));   % FLAG for UN-CALIBRATING
        HDR.FLAG.FILT = 0; 	% FLAG if any filter is applied; 
        HDR.FLAG.TRIGGERED = 0; % the data is untriggered by default
end;
if ~isfield(HDR,'EVENT');
        HDR.EVENT.TYP = []; 
        HDR.EVENT.POS = []; 
end;
%following 3 lines added by SMM 8/31/2006
if ~isfield(HDR,'TYPE')
	HDR.TYPE = upper(HDR.FILE.Ext);
end
if strcmp(HDR.TYPE,'EDF') | strcmp(HDR.TYPE,'GDF') | strcmp(HDR.TYPE,'BDF'),
        if any(PERMISSION=='w');
                HDR = eegchkhdr(HDR);
        end;
        if nargin<4,
                HDR = sdfopen(HDR,PERMISSION,CHAN);
        else
                HDR = sdfopen(HDR,PERMISSION,CHAN,MODE);
        end;

	%%% Event file stored in GDF-format
	if ~any([HDR.NS,HDR.NRec,~length(HDR.EVENT.POS)]);
		HDR.TYPE = 'EVENT';
	end;	
%elseif  code for lots of other file formats deleted
        
elseif strcmp(HDR.TYPE,'BrainVision'),
        % get the header information from the VHDR ascii file
        fid = fopen(HDR.FileName,'rt');
        if fid<0,
                fprintf('Error SOPEN: could not open file %s\n',HDR.FileName);
                return;
        end; 
        tline = fgetl(fid);
        HDR.BV = [];
        UCAL = 0; 
        flag = 1; 
        while ~feof(fid), 
                tline = fgetl(fid);
                if isempty(tline),
                elseif tline(1)==';',
                elseif tline(1)==10, 
                elseif tline(1)==13,    % needed for Octave 
                elseif strncmp(tline,'[Common Infos]',14)
                        flag = 2;     
                elseif strncmp(tline,'[Binary Infos]',14)
                        flag = 3;     
                elseif strncmp(tline,'[Channel Infos]',14)
                        flag = 4;     
                elseif strncmp(tline,'[Coordinates]',12)
                        flag = 5;     
                elseif strncmp(tline,'[Marker Infos]',12)
                        flag = 6;     
                elseif strncmp(tline,'[Comment]',9)
                        flag = 7;     
                elseif strncmp(tline,'[',1)     % any other segment
                        flag = 8;     
                        
                elseif any(flag==[2,3]),
                        [t1,r] = strtok(tline,'=');
                        [t2,r] = strtok(r,['=,',char([10,13])]);
                        if ~isempty(t2),
                                HDR.BV = setfield(HDR.BV,t1,t2);
                        end;
                elseif flag==4,        
                        [t1,r] = strtok(tline,'=');
                        [t2,r] = strtok(r, ['=',char([10,13])]);
                        ix = [find(t2==','),length(t2)];
                        [chan, stat1] = str2double(t1(3:end));
                        HDR.Label{chan,1} = t2(1:ix(1)-1);        
                        HDR.BV.reference{chan,1} = t2(ix(1)+1:ix(2)-1);
                        [v, stat] = str2double(t2(ix(2)+1:end));          % in microvolt
                        if (prod(size(v))==1) & ~any(stat)
                                HDR.Cal(chan) = v;                                
                        else
                                UCAL = 1; 
                                HDR.Cal(chan) = 1;
                        end;
                elseif flag==5,   
                        [t1,r] = strtok(tline,'=');
                        chan = str2double(t1(3:end));
                        [v, stat] = str2double(r(2:end));
                        HDR.ElPos(chan,:) = v;
                end
        end
        fclose(fid);

        % convert the header information to BIOSIG standards
        HDR.NS = str2double(HDR.BV.NumberOfChannels);
        HDR.SampleRate = 1e6/str2double(HDR.BV.SamplingInterval);      % sampling rate in Hz
        if UCAL & ~strncmp(HDR.BV.BinaryFormat,'IEEE_FLOAT',10),
                fprintf(2,'Warning SOPEN (BV): missing calibration values\n');
                HDR.FLAG.UCAL = 1; 
        end;
        HDR.NRec = 1;                   % it is a continuous datafile, therefore one record
        HDR.Calib = [zeros(1,HDR.NS) ; diag(HDR.Cal)];  % is this correct?
        HDR.PhysDim = 'uV';
        HDR.FLAG.TRIGGERED = 0; 
        HDR.Filter.LowPass = repmat(NaN,HDR.NS,1);
        HDR.Filter.HighPass = repmat(NaN,HDR.NS,1);
        HDR.Filter.Notch = repmat(NaN,HDR.NS,1);
        
        if strncmpi(HDR.BV.BinaryFormat, 'int_16',6)
                HDR.GDFTYP = 'int16'; 
                HDR.AS.bpb = HDR.NS * 2; 
        elseif strncmpi(HDR.BV.BinaryFormat, 'ieee_float_32',13)
                HDR.GDFTYP = 'float32'; 
                HDR.AS.bpb = HDR.NS * 4; 
        elseif strncmpi(HDR.BV.BinaryFormat, 'ieee_float_64',13)
                HDR.GDFTYP = 'float64'; 
                HDR.AS.bpb = HDR.NS * 8; 
        end
        
        %read event file 
        fid = fopen(fullfile(HDR.FILE.Path, HDR.BV.MarkerFile),'rt');
        if fid>0,
                while ~feof(fid),
                        s = fgetl(fid);
                        if strncmp(s,'Mk',2),
                                [N,s] = strtok(s(3:end),'=');
                                ix = find(s==',');
                                ix(length(ix)+1)=length(s)+1;
                                N = str2double(N);
                                HDR.EVENT.POS(N,1) = str2double(s(ix(2)+1:ix(3)-1));
                                HDR.EVENT.TYP(N,1) = 0;
                                HDR.EVENT.DUR(N,1) = str2double(s(ix(3)+1:ix(4)-1));
                                HDR.EVENT.CHN(N,1) = str2double(s(ix(4)+1:ix(5)-1));
                                HDR.EVENT.TeegType{N,1} = s(2:ix(1)-1);
                                HDR.EVENT.TeegDesc{N,1} = s(ix(1)+1:ix(2)-1);
                        end;
                end
                fclose(fid);
        end

        %open data file 
        if strncmpi(HDR.BV.DataFormat, 'binary',5)
                PERMISSION='rb';
        elseif strncmpi(HDR.BV.DataFormat, 'ascii',5)                 
                PERMISSION='rt';
        end;

        HDR.FILE.FID = fopen(fullfile(HDR.FILE.Path,HDR.BV.DataFile),PERMISSION,'ieee-le');
        if HDR.FILE.FID < 0,
                fprintf(HDR.FILE.stderr,'ERROR SOPEN BV: could not open file %s\n',fullfile(HDR.FILE.Path,HDR.BV.DataFile));
                return;
        end;
        
        HDR.FILE.OPEN= 1; 
        HDR.FILE.POS = 0; 
        HDR.HeadLen  = 0; 
        if strncmpi(HDR.BV.DataFormat, 'binary',5)
                fseek(HDR.FILE.FID,0,'eof');
                HDR.AS.endpos = ftell(HDR.FILE.FID);
                fseek(HDR.FILE.FID,0,'bof');
                HDR.AS.endpos = HDR.AS.endpos/HDR.AS.bpb;
                
        elseif strncmpi(HDR.BV.DataFormat, 'ascii',5)  
                s = char(sread(HDR.FILE.FID,inf,'char')');
                s(s==',')='.';
                [tmp,status] = str2double(s);
                if strncmpi(HDR.BV.DataOrientation, 'multiplexed',6),
                        HDR.BV.data = tmp;
                elseif strncmpi(HDR.BV.DataOrientation, 'vectorized',6),
                        HDR.BV.data = tmp';
                end
                HDR.AS.endpos = size(HDR.BV.data,1);
                if ~any(HDR.NS ~= size(tmp));
                        fprintf(HDR.FILE.stderr,'ERROR SOPEN BV-ascii: number of channels inconsistency\n');
                end;
        end
        HDR.SPR = HDR.AS.endpos;
        
elseif strcmp(HDR.TYPE,'unknown'),
        HDR.ERROR.status = -1;
	%HDR.ERROR.message = sprintf('ERROR SOPEN: File %s could not be opened - unknown type.\n',HDR.FileName);
	%fprintf(HDR.FILE.stderr,'ERROR SOPEN: File %s could not be opened - unknown type.\n',HDR.FileName);
        HDR.FILE.FID = -1;
        return;
        
else
        %fprintf(HDR.FILE.stderr,'SOPEN does not support your data format yet. Contact <a.schloegl@ieee.org> if you are interested in this feature.\n');
        HDR.FILE.FID = -1;	% this indicates that file could not be opened. 
        return;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	General Postprecessing for all formats of Header information 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add trigger information for triggered data
if HDR.FLAG.TRIGGERED & isempty(HDR.EVENT.POS)
	HDR.EVENT.POS = [0:HDR.NRec-1]'*HDR.SPR;
	HDR.EVENT.TYP = repmat(hex2dec('0300'),HDR.NRec,1);
	HDR.EVENT.CHN = repmat(0,HDR.NRec,1);
	HDR.EVENT.DUR = repmat(0,HDR.NRec,1);
end;

% apply channel selections to EVENT table
if any(CHAN) & ~isempty(HDR.EVENT.POS) & isfield(HDR.EVENT,'CHN'),	% only if channels are selected. 
	sel = (HDR.EVENT.CHN(:)==0);	% memory allocation, select all general events
	for k = find(~sel'),		% select channel specific elements
		sel(k) = any(HDR.EVENT.CHN(k)==CHAN);
	end;
	HDR.EVENT.POS = HDR.EVENT.POS(sel);
	HDR.EVENT.TYP = HDR.EVENT.TYP(sel);
	HDR.EVENT.DUR = HDR.EVENT.DUR(sel);	% if EVENT.CHN available, also EVENT.DUR is defined. 
	HDR.EVENT.CHN = HDR.EVENT.CHN(sel);
	% assigning new channel number 
	a = zeros(1,HDR.NS);
	for k = 1:length(CHAN),		% select channel specific elements
		a(CHAN(k)) = k;		% assigning to new channel number. 
	end;
	ix = HDR.EVENT.CHN>0;
	HDR.EVENT.CHN(ix) = a(HDR.EVENT.CHN(ix));	% assigning new channel number
end;	

if any(PERMISSION=='r') & ~isnan(HDR.NS);
        if exist('ReRefMx','var'),
                % fix size if ReRefMx
                sz = size(ReRefMx); 	                 
                if sz(1) > HDR.NS, 	 
                        fprintf(HDR.FILE.stderr,'ERROR: size of ReRefMx [%i,%i] exceeds Number of Channels (%i)\n',size(ReRefMx),HDR.NS); 	 
                        fclose(HDR.FILE.FID); 	 
                        HDR.FILE.FID = -1; 	 
                        return; 	 
                else        
                        ReRefMx = [ReRefMx; zeros(HDR.NS-sz(1),sz(2))];
                end; 	 
                
                HDR.Calib = HDR.Calib*ReRefMx;
		Calib     = HDR.Calib;
                HDR.InChanSelect = find(any(Calib(2:end,:),2));
        else
                if CHAN==0,
                        CHAN=1:HDR.NS;
                elseif any(CHAN > HDR.NS),
                        fprintf(HDR.FILE.stderr,'ERROR: selected channels exceed Number of Channels %i\n',HDR.NS);
                        fclose(HDR.FILE.FID); 
                        HDR.FILE.FID = -1;	
                        return;
                end;
                
		Calib     = HDR.Calib;
		Calib     = Calib(:,CHAN(:));
		HDR.Calib = Calib;
                HDR.InChanSelect = find(any(Calib(2:end,:),2));
        end;
        HDR.Calib = sparse(HDR.Calib); 
end;

%-----------------------------------------------------------------------%

function [S,HDR] = sread(HDR,NoS,StartPos)
% SREAD loads selected seconds of a signal file
%
% [S,HDR] = sread(HDR [,NoS [,StartPos]] )
% NoS       Number of seconds, default = 1 (second)
% StartPos  Starting position, if not provided the following data is read continously from the EDF file. 
%                    no reposition of file pointer is performed
%
% HDR=sopen(Filename,'r',CHAN);
% [S,HDR] = sread(HDR, NoS, StartPos)
%      	reads NoS seconds beginning at StartPos
% 
% [S,HDR] = sread(HDR, inf) 
%      	reads til the end starting at the current position 
% 
% [S,HDR] = sread(HDR, N*HDR.Dur) 
%	reads N trials of an BKR file 
% 
%
% See also: fread, SREAD, SWRITE, SCLOSE, SSEEK, SREWIND, STELL, SEOF

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


%	$Revision: 1.36 $
%	$Id: sread.m,v 1.36 2004/12/30 21:47:38 schloegl Exp $
%	(C) 1997-2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/

S = [];

if nargin<2, 
        NoS = inf; 
end;

if NoS<0,
        fprintf(HDR.FILE.stderr,'Error SREAD: NoS must be non-negative\n');
        return;
end;
if (nargin==3) 
        if (StartPos<0),
                fprintf(HDR.FILE.stderr,'Error SREAD: StartPos must be non-negative\n');
                return;
        end;
        tmp = HDR.SampleRate*StartPos;
        if tmp ~= round(tmp),
        %        fprintf(HDR.FILE.stderr,'Warning SREAD: StartPos yields non-integer position\n');
                StartPos = round(tmp)/HDR.SampleRate;
        end;
end;

tmp = HDR.SampleRate*NoS;
if tmp ~= round(tmp),
        %fprintf(HDR.FILE.stderr,'Warning SREAD: NoS yields non-integer position [%f, %f]\n',NoS,HDR.SampleRate);
        NoS = round(tmp)/HDR.SampleRate;
end;
STATUS = 0; 

if strcmp(HDR.TYPE,'EDF') | strcmp(HDR.TYPE,'BDF') | strcmp(HDR.TYPE,'GDF') ,
        if nargin<3,
                [S,HDR] = sdfread(HDR, NoS );
        else
                [S,HDR] = sdfread(HDR, NoS ,StartPos);
        end;

        if strcmp(HDR.TYPE,'GDF'),      % overflow detection
                for k = 1:length(HDR.InChanSelect),
                        ix = (S(:,k)>=HDR.DigMax(HDR.InChanSelect(k))) | (S(:,k)<=HDR.DigMin(HDR.InChanSelect(k)));
                        S(ix,k) = NaN;
                end;
        end;
%elseif code for many different formats deleted
        
else
        fprintf(2,'Error SREAD: %s-format not supported yet.\n', HDR.TYPE);        
	return;
end;


%%% TOGGLE CHECK - checks whether HDR is kept consist %%% 
global SREAD_TOGGLE_CHECK
if isfield(HDR.FLAG,'TOGGLE');
        if HDR.FLAG.TOGGLE~=SREAD_TOGGLE_CHECK,
                fprintf(HDR.FILE.stderr,'Warning SREAD: [s,HDR]=sread(HDR, ...) \nYou forgot to pass HDR in %i call(s) of SREAD\n',SREAD_TOGGLE_CHECK-HDR.FLAG.TOGGLE);
        end;
else
        HDR.FLAG.TOGGLE=0;
        SREAD_TOGGLE_CHECK=0;
end;
SREAD_TOGGLE_CHECK = SREAD_TOGGLE_CHECK+1;
HDR.FLAG.TOGGLE = HDR.FLAG.TOGGLE+1;

if STATUS,
        fprintf(HDR.FILE.stderr,'WARNING SREAD: something went wrong. Please send these files %s and BIOSIGCORE to <a.schloegl@ieee.org>',HDR.FileName);
        save biosigcore.mat 
end;

if ~HDR.FLAG.UCAL,
        % S = [ones(size(S,1),1),S]*HDR.Calib([1;1+HDR.InChanSelect],:); 
        % perform the previous function more efficiently and
        % taking into account some specialities related to Octave sparse
        % data. 

        if 1; %exist('OCTAVE_VERSION')
                % force octave to do a sparse multiplication
                % the difference is NaN*sparse(0) = 0 instead of NaN
                % this is important for the automatic overflow detection

		Calib = HDR.Calib;  
                tmp   = zeros(size(S,1),size(Calib,2));   % memory allocation
                for k = 1:size(Calib,2),
                        chan = find(Calib(1+HDR.InChanSelect,k));
                        tmp(:,k) = double(S(:,chan)) * Calib(1+HDR.InChanSelect(chan),k) + Calib(1,k);
                end
                S = tmp; 
        else
                % S = [ones(size(S,1),1),S]*HDR.Calib([1;1+HDR.InChanSelect],:); 
                % the following is the same as above but needs less memory. 
                S = double(S) * HDR.Calib(1+HDR.InChanSelect,:);
                for k = 1:size(HDR.Calib,2),
                        S(:,k) = S(:,k) + HDR.Calib(1,k);
                end;
        end;
end;

%---------------------------------------------------------------------------%

function [EDF,H1,h2]=sdfopen(arg1,arg2,arg3,arg4,arg5,arg6)
% Opens EDF/GDF/SDF files for reading and writing. 
% The EDF format is specified in [1], GDF in [2].
% SDF is the SIESTA convention about polygraphic recordings (see [3], pp.8-9). 
% SDF used the EDF format.
%
% EDF=sdfopen(Filename,'r' [,CHAN [,Mode [,TSR]]]);
% [S,EDF]=sdfread(EDF, NoR, StartPos)
%
% CHAN defines the selected Channels or a re-referencing matrix
%
% Mode=='SIESTA' indicates that #1 - #6 is rereferenced to (M1+M2)/2           
% Mode=='AFIR' indicates that Adaptive FIR filtering is used for ECG removing
%			Implements Adaptive FIR filtering for ECG removal in EDF/GDF-tb.
% 			based on the Algorithm of Mikko Koivuluoma <k7320@cs.tut.fi>
%                 A delay of EDF.AFIR.delay number of samples has to be considered. 
% Mode=='SIESTA+AFIR' for both
% Mode=='UCAL' [default]
%                 indicates that no calibration (re-scaling) to Physical Dim. is used. 
%                 The output are 16bit interger numbers. 'UCAL' overrides 'SIESTA'
% Mode=='RAW' One column represents one EDF-block
% Mode=='Notch50Hz' Implements a simple FIR-notch filter for 50Hz
% Mode=='RECG' Implements ECG minimization with regression analysis
% Mode=='TECG' Implements ECG minimization with template removal (Test status)
% Mode=='HPF0.0Hz'  Implements a high-pass filter (with the zero at z=+1, i.e. a differentiator 
%                     In this case a Notch-filter and/or sub-sampling is recommended. 
% Mode=='TAUx.yS' compensates time-constant of x.y seconds
% Mode=='EOG[hvr]' produces HEOG, VEOG and/or REOG output (CHAN not considered)
% 
% Mode=='OVERFLOW' overflow detection
% Mode=='FailingElectrodeDetector' using optimized threshold based AUC for FED & OFC
% Mode=='Units_Blocks' requests the arguments in SDFREAD in Blocks [default is seconds]
%
% TSR [optional] is the target sampling rate
%         Currently only downsampling from 256 and 200 to 100Hz is supported.  
%         The details are described in the appendix of [4].
%
% EDF.ErrNo~=0  indicates that an error occured.
% For compatibility to former versions, 
%    EDF.FILE.FID = -1 indicates that file has not been opened.
%
% Opening of an EDF/SDF File for writing
% [EDF]=sdfopen(EDF,'w') is equal to  
% [EDF]=sdfopen(EDF.FileName,'w',EDF.Dur,EDF.SampleRate);
% At least EDF.FileName, EDF.NS, EDF.Dur and EDF.EDF.SampleRate must be defined
% 
% 
% See also: fopen, SDFREAD, SWRITE, SCLOSE, SSEEK, SREWIND, STELL, SEOF


% References: 
% [1] Bob Kemp, Alpo Värri, Agostinho C. Rosa, Kim D. Nielsen and John Gade
%     A simple format for exchange of digitized polygraphic recordings.
%     Electroencephalography and Clinical Neurophysiology, 82 (1992) 391-393.
% see also: http://www.medfac.leidenuniv.nl/neurology/knf/kemp/edf/edf_spec.htm
%
% [2] Alois Schlögl, Oliver Filz, Herbert Ramoser, Gert Pfurtscheller
%     GDF - A GENERAL DATAFORMAT FOR BIOSIGNALS
%     Technical Report, Department for Medical Informatics, Universtity of Technology, Graz (2004)
% see also: http://www.dpmi.tu-graz.ac.at/~schloegl/matlab/eeg/gdf4/TR_GDF.PDF
%
% [3] The SIESTA recording protocol. 
% see http://www.ai.univie.ac.at/siesta/protocol.html
% and http://www.ai.univie.ac.at/siesta/protocol.rtf 
%
% [4] Alois Schlögl
%     The electroencephalogram and the adaptive autoregressive model: theory and applications. 
%     (ISBN 3-8265-7640-3) Shaker Verlag, Aachen, Germany.
% see also: "http://www.shaker.de/Online-Gesamtkatalog/Details.idc?ISBN=3-8265-7640-3"


% Testing state
%
% (1) reads header information and writes the header; can be used to check SDFOPEN or for correcting headerinformation
% EDF=sdfopen(EDF,'r+b'); EDF=sdfclose(EDF); 
% 
% (2a) Minimal requirements for opening an EDF-File
% EDF.FileName='file.edf'; % define filename
% EDF.NS = 5; % fix number of channels
% EDF=sdfopen(EDF,'wb');
%     write file
%     define header somewhen before 
% EDF=sdfclose(EDF); % writes the corrected header information
% 
% (2b) Minimal requirements for opening an EDF-File
% EDF=sdfopen('file.edf','wb',N); % N number of channels
%      .. do anything, e.g define header
% EDF=sdfopen(EDF,'w+b'); % writes Header information
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

% EDF.WarnNo   1: ascii(0) in 1st header
%              2: ascii(0) in 2nd header
%              4: invalid SPR
%              4: invalid samples_per_record-values
%              8: date not in EDF-format (tries to guess correct date, see also E2)
%             16: invalid number_of-channels-value
%             32: invalid value of the EDF header length
%             64: invalid value of block_duration
%            128: Polarity of #7 probably inverted  
%
% EDF.ErrNo    1: first 8 bytes different to '0       ', this violates the EDF spec.
%              2: Invalid date (unable to guess correct date)
%              4: Incorrect date information (later than actual date) 
%             16: incorrect filesize, Header information does not match actual size

%	$Revision: 1.34 $
%	$Id: sdfopen.m,v 1.34 2004/12/09 16:51:31 schloegl Exp $
%	(C) 1997-2002, 2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/

if nargin<2, 
        arg2='rb'; 
elseif ~any(arg2=='b');
        arg2= [arg2,'b']; % force binary open. 
end;

if isstruct(arg1) 
        EDF=arg1; 
        FILENAME=EDF.FileName;
else
        FILENAME=arg1;
        fprintf(2,'Warning SDFOPEN: the use of SDFOPEN is discouraged (SDFOPEN might disappear); please use SOPEN instead.\n');
end;

H1idx = [8 80 80 8 8 8 44 8 8 4];
H2idx = [16 80 8 8 8 8 8 80 8 32];

%%%%% Define Valid Data types %%%%%%
%GDFTYPES=[0 1 2 3 4 5 6 7 16 17 255+(1:64) 511+(1:64)];
GDFTYPES=[0 1 2 3 4 5 6 7 16 17 255+[1 12 22 24] 511+[1 12 22 24]];

%%%%% Define Size for each data type %%%%%
GDFTYP_BYTE=zeros(1,512+64);
GDFTYP_BYTE(256+(1:64))=(1:64)/8;
GDFTYP_BYTE(512+(1:64))=(1:64)/8;
GDFTYP_BYTE(1:18)=[1 1 1 2 2 4 4 8 8 4 8 0 0 0 0 0 4 8]';

%EDF.GDFTYP.TEXT={'char','int8','uint8','int16','uint16','int32','uint32','int64','uint64','float32','float64'};
%GDFTYP_BYTE=[1 1 1 2 2 4 4 8 8 4 8 0 0 0 0 0 4 8]';
%GDFTYPES=[0 1 2 3 4 5 6 7 16 17];

EDF.ErrNo = 0;

if strcmp(EDF.TYPE,'EDF')
        EDF.VERSION='0       ';
elseif strcmp(EDF.TYPE,'GDF') 
        EDF.VERSION='GDF     ';
elseif strcmp(EDF.TYPE,'BDF'),
        EDF.VERSION=[char(255),'BIOSEMI'];
end;

%%%%%%% ============= READ ===========%%%%%%%%%%%%
if any(arg2=='r'), 
        
[EDF.FILE.FID,MESSAGE]=fopen(FILENAME,arg2,'ieee-le');          
%EDF.FILE.FID=fid;

if EDF.FILE.FID<0 
        %fprintf(EDF.FILE.stderr,'Error SDFOPEN: %s %s\n',MESSAGE,FILENAME);  
        H1=MESSAGE; H2=FILENAME;
        EDF.ErrNo = [32,EDF.ErrNo];
	return;
end;
EDF.FILE.OPEN = 1 + any(arg2=='+'); 
EDF.FileName = FILENAME;

PPos=min([max(find(FILENAME=='.')) length(FILENAME)+1]);
SPos=max([0 find(FILENAME==filesep)]);
EDF.FILE.Ext = FILENAME(PPos+1:length(FILENAME));
EDF.FILE.Name = FILENAME(SPos+1:PPos-1);
if SPos==0
	EDF.FILE.Path = pwd;
else
	EDF.FILE.Path = FILENAME(1:SPos-1);
end;
EDF.FileName = [EDF.FILE.Path filesep EDF.FILE.Name '.' EDF.FILE.Ext];
%EDF.datatype = 'EDF';

%%% Read Fixed Header %%%
[tmp,count]=fread(EDF.FILE.FID,184,'uchar');     %
if count<184,
        EDF.ErrNo = [64,EDF.ErrNo];
        return;
end;
H1=setstr(tmp');     %


EDF.VERSION=H1(1:8);                     % 8 Byte  Versionsnummer 
if ~(strcmp(EDF.VERSION,'0       ') | all(abs(EDF.VERSION)==[255,abs('BIOSEMI')]) | strcmp(EDF.VERSION(1:3),'GDF'))
        EDF.ErrNo = [1,EDF.ErrNo];
	if ~strcmp(EDF.VERSION(1:3),'   '); % if not a scoring file, 
%	    return; 
	end;
end;
EDF.PID = deblank(H1(9:88));                  % 80 Byte local patient identification
EDF.RID = deblank(H1(89:168));                % 80 Byte local recording identification

IsGDF=strcmp(EDF.VERSION(1:3),'GDF');

if strcmp(EDF.VERSION(1:3),'GDF'),
        if 1, % if strcmp(EDF.VERSION(4:8),' 0.12'); % in future versions the date format might change. 
      		EDF.T0(1,1) = str2double( H1(168 + [ 1:4]));
		EDF.T0(1,2) = str2double( H1(168 + [ 5 6]));
        	EDF.T0(1,3) = str2double( H1(168 + [ 7 8]));
        	EDF.T0(1,4) = str2double( H1(168 + [ 9 10]));
        	EDF.T0(1,5) = str2double( H1(168 + [11 12]));
        	EDF.T0(1,6) = str2double( H1(168 + [13:16]))/100;
     	end; 
     
	if str2double(EDF.VERSION(4:8))<0.12
                tmp = setstr(fread(EDF.FILE.FID,8,'uchar')');    % 8 Byte  Length of Header
                EDF.HeadLen = str2double(tmp);    % 8 Byte  Length of Header
        else
		%EDF.HeadLen = fread(EDF.FILE.FID,1,'int64');    % 8 Byte  Length of Header
		EDF.HeadLen = fread(EDF.FILE.FID,1,'int32');    % 8 Byte  Length of Header
		tmp         = fread(EDF.FILE.FID,1,'int32');    % 8 Byte  Length of Header
        end;
        EDF.reserved1 = fread(EDF.FILE.FID,8+8+8+20,'uchar');     % 44 Byte reserved
        
        %EDF.NRec = fread(EDF.FILE.FID,1,'int64');     % 8 Byte  # of data records
        EDF.NRec = fread(EDF.FILE.FID,1,'int32');     % 8 Byte  # of data records
                   fread(EDF.FILE.FID,1,'int32');     % 8 Byte  # of data records
        if strcmp(EDF.VERSION(4:8),' 0.10')
                EDF.Dur =  fread(EDF.FILE.FID,1,'float64');    % 8 Byte  # duration of data record in sec
        else
                tmp =  fread(EDF.FILE.FID,2,'uint32');    % 8 Byte  # duration of data record in sec
                EDF.Dur =  tmp(1)./tmp(2);
        end;
        EDF.NS =   fread(EDF.FILE.FID,1,'uint32');     % 4 Byte  # of signals
else 
        tmp=(find((H1<32) | (H1>126))); 		%%% syntax for Matlab
        if ~isempty(tmp) %%%%% not EDF because filled out with ASCII(0) - should be spaces
                %H1(tmp)=32; 
                EDF.ErrNo=[1025,EDF.ErrNo];
        end;
        
        EDF.T0 = zeros(1,6);
        ErrT0=0;
        tmp = str2double( H1(168 + [ 7  8]));
        if ~isnan(tmp), EDF.T0(1) = tmp; else ErrT0 = 1; end;
        tmp = str2double( H1(168 + [ 4  5]));
        if ~isnan(tmp), EDF.T0(2) = tmp; else ErrT0 = 1; end;
        tmp = str2double( H1(168 + [ 1  2]));
        if ~isnan(tmp), EDF.T0(3) = tmp; else ErrT0 = 1; end;
        tmp = str2double( H1(168 + [ 9 10]));
        if ~isnan(tmp), EDF.T0(4) = tmp; else ErrT0 = 1; end;
        tmp = str2double( H1(168 + [12 13]));
        if ~isnan(tmp), EDF.T0(5) = tmp; else ErrT0 = 1; end;
        tmp = str2double( H1(168 + [15 16]));
        if ~isnan(tmp), EDF.T0(6) = tmp; else ErrT0 = 1; end;
        
	if any(EDF.T0~=fix(EDF.T0)); ErrT0=1; end;

        if ErrT0,
                ErrT0=0;
                EDF.ErrNo = [1032,EDF.ErrNo];
                
                tmp = H1(168 + [1:8]);
                for k = [3 2 1],
                        %fprintf(1,'\n zz%szz \n',tmp);
                        [tmp1,tmp] = strtok(tmp,' :./-');
			tmp1 = str2double([tmp1,' ']);
			
                        if isempty(tmp1)
                                ErrT0 = ErrT0 | 1;
                        else
                                EDF.T0(k)  = tmp1;
                        end;
                end;
                tmp = H1(168 + [9:16]);
                for k = [4 5 6],
                        [tmp1,tmp] = strtok(tmp,' :./-');
                        tmp1=str2double([tmp1,' ']);
                        if isempty(tmp1)
                                ErrT0 = ErrT0 | 1;
                        else
                                EDF.T0(k)  = tmp1;
                        end;
                end;
                if ErrT0
                        EDF.ErrNo = [2,EDF.ErrNo];
                end;
        else
                % Y2K compatibility until year 2084
                if EDF.T0(1) < 85    % for biomedical data recorded in the 1950's and converted to EDF
                        EDF.T0(1) = 2000+EDF.T0(1);
                elseif EDF.T0(1) < 100
                        EDF.T0(1) = 1900+EDF.T0(1);
                %else % already corrected, do not change
                end;
        end;     
        H1(185:256)=setstr(fread(EDF.FILE.FID,256-184,'uchar')');     %
        EDF.HeadLen = str2double(H1(185:192));           % 8 Bytes  Length of Header
        EDF.reserved1=H1(193:236);              % 44 Bytes reserved   
        EDF.NRec    = str2double(H1(237:244));     % 8 Bytes  # of data records
        EDF.Dur     = str2double(H1(245:252));     % 8 Bytes  # duration of data record in sec
        EDF.NS      = str2double(H1(253:256));     % 4 Bytes  # of signals
	EDF.AS.H1   = H1;	                     % for debugging the EDF Header
end;

if strcmp(EDF.reserved1(1:4),'EDF+'),	% EDF+ specific header information 
	[EDF.Patient.Id,   tmp] = strtok(EDF.PID,' ');
	[EDF.Patient.Sex,  tmp] = strtok(tmp,' ');
	[EDF.Patient.Birthday, tmp] = strtok(tmp,' ');
	[EDF.Patient.Name, tmp] = strtok(tmp,' ');

	[chk, tmp] = strtok(EDF.RID,' ');
	if ~strcmp(chk,'Startdate')
		fprintf(EDF.FILE.stderr,'Warning SDFOPEN: EDF+ header is corrupted.\n');
	end;
	[EDF.Date2, tmp] = strtok(tmp,' ');
	[EDF.ID.Investigation, tmp] = strtok(tmp,' ');
	[EDF.ID.Investigator,  tmp] = strtok(tmp,' ');
	[EDF.ID.Equiment, tmp] = strtok(tmp,' ');
end;

if any(size(EDF.NS)~=1) %%%%% not EDF because filled out with ASCII(0) - should be spaces
        fprintf(EDF.FILE.stderr, 'Warning SDFOPEN: invalid NS-value in header of %s\n',EDF.FileName);
        EDF.ErrNo=[1040,EDF.ErrNo];
        EDF.NS=1;
end;
% Octave assumes EDF.NS is a matrix instead of a scalare. Therefore, we need
% Otherwise, eye(EDF.NS) will be executed as eye(size(EDF.NS)).
EDF.NS = EDF.NS(1);     

if isempty(EDF.HeadLen) %%%%% not EDF because filled out with ASCII(0) - should be spaces
        EDF.ErrNo=[1056,EDF.ErrNo];
        EDF.HeadLen=256*(1+EDF.NS);
end;

if isempty(EDF.NRec) %%%%% not EDF because filled out with ASCII(0) - should be spaces
        EDF.ErrNo=[1027,EDF.ErrNo];
        EDF.NRec = -1;
end;

if isempty(EDF.Dur) %%%%% not EDF because filled out with ASCII(0) - should be spaces
        EDF.ErrNo=[1088,EDF.ErrNo];
        EDF.Dur=30;
end;

if  any(EDF.T0>[2084 12 31 24 59 59]) | any(EDF.T0<[1985 1 1 0 0 0])
        EDF.ErrNo = [4, EDF.ErrNo];
end;

%%% Read variable Header %%%
if ~strcmp(EDF.VERSION(1:3),'GDF'),
        idx1=cumsum([0 H2idx]);
        idx2=EDF.NS*idx1;

        h2=zeros(EDF.NS,256);
        [H2,count]=fread(EDF.FILE.FID,EDF.NS*256,'uchar');
        if count < EDF.NS*256 
	        EDF.ErrNo=[8,EDF.ErrNo];
                return; 
        end;
                
        %tmp=find((H2<32) | (H2>126)); % would confirm 
        tmp = find((H2<32) | ((H2>126) & (H2~=255) & (H2~=181)& (H2~=230))); 
        if ~isempty(tmp) %%%%% not EDF because filled out with ASCII(0) - should be spaces
                H2(tmp) = 32; 
	        EDF.ErrNo = [1026,EDF.ErrNo];
        end;
        
        for k=1:length(H2idx);
                %disp([k size(H2) idx2(k) idx2(k+1) H2idx(k)]);
                h2(:,idx1(k)+1:idx1(k+1))=reshape(H2(idx2(k)+1:idx2(k+1)),H2idx(k),EDF.NS)';
        end;
        %size(h2),
        h2=setstr(h2);
        %(h2(:,idx1(9)+1:idx1(10))),
        %abs(h2(:,idx1(9)+1:idx1(10))),
        
        EDF.Label      =            h2(:,idx1(1)+1:idx1(2));
        EDF.Transducer =            h2(:,idx1(2)+1:idx1(3));
        EDF.PhysDim    =            h2(:,idx1(3)+1:idx1(4));
        EDF.PhysMin    = str2double(h2(:,idx1(4)+1:idx1(5)));
        EDF.PhysMax    = str2double(h2(:,idx1(5)+1:idx1(6)));
        EDF.DigMin     = str2double(h2(:,idx1(6)+1:idx1(7)));
        EDF.DigMax     = str2double(h2(:,idx1(7)+1:idx1(8)));
        EDF.PreFilt    =            h2(:,idx1(8)+1:idx1(9));
        EDF.SPR        = str2double(h2(:,idx1(9)+1:idx1(10)));
        %EDF.reserved  =       h2(:,idx1(10)+1:idx1(11));
	if ~all(abs(EDF.VERSION)==[255,abs('BIOSEMI')]),
		EDF.GDFTYP     = 3*ones(1,EDF.NS);	%	datatype
	else
		EDF.GDFTYP     = (255+24)*ones(1,EDF.NS);	%	datatype
	end;
	
        if isempty(EDF.SPR), 
                fprintf(EDF.FILE.stderr, 'Warning SDFOPEN: invalid SPR-value in header of %s\n',EDF.FileName);
                EDF.SPR=ones(EDF.NS,1);
	        EDF.ErrNo=[1028,EDF.ErrNo];
        end;
else
        if (ftell(EDF.FILE.FID)~=256),
		error('position error');
	end;	 
%%%        status = fseek(EDF.FILE.FID,256,'bof');
        EDF.Label      =  setstr(fread(EDF.FILE.FID,[16,EDF.NS],'uchar')');		
        EDF.Transducer =  setstr(fread(EDF.FILE.FID,[80,EDF.NS],'uchar')');	
        EDF.PhysDim    =  setstr(fread(EDF.FILE.FID,[ 8,EDF.NS],'uchar')');
%       EDF.AS.GDF.TEXT = EDF.GDFTYP.TEXT;
        EDF.PhysMin    =         fread(EDF.FILE.FID,[EDF.NS,1],'float64');	
        EDF.PhysMax    =         fread(EDF.FILE.FID,[EDF.NS,1],'float64');	

        %EDF.DigMin     =         fread(EDF.FILE.FID,[EDF.NS,1],'int64');	
        %EDF.DigMax     =         fread(EDF.FILE.FID,[EDF.NS,1],'int64');	
	tmp            =         fread(EDF.FILE.FID,[2*EDF.NS,1],'int32');	
        EDF.DigMin     = tmp((1:EDF.NS)*2-1);
        tmp            =         fread(EDF.FILE.FID,[2*EDF.NS,1],'int32');	
        EDF.DigMax     = tmp((1:EDF.NS)*2-1);
        
        EDF.PreFilt    =  setstr(fread(EDF.FILE.FID,[80,EDF.NS],'uchar')');	%	
        EDF.SPR        =         fread(EDF.FILE.FID,[ 1,EDF.NS],'uint32')';	%	samples per data record
%       changed by SMM 9/2006
        EDF.GDFTYP     =         fread(EDF.FILE.FID,[32,EDF.NS],'uchar');	%	datatype
%        EDF.GDFTYP     =         fread(EDF.FILE.FID,[ 1,EDF.NS],'uint32');	%	datatype
        %                        fread(EDF.FILE.FID,[32,EDF.NS],'uchar')';	%	datatype
end;

EDF.Filter.LowPass = repmat(nan,1,EDF.NS);
EDF.Filter.HighPass = repmat(nan,1,EDF.NS);
for k=1:EDF.NS,
	tmp = EDF.PreFilt(k,:);

	ixh=strfind(tmp,'HP');
	ixl=strfind(tmp,'LP');
	ixn=strfind(tmp,'Notch');
	ix =strfind(lower(tmp),'hz');
	%tmp(tmp==':')=' ';
try;
	if any(tmp==';')
		[tok1,tmp] = strtok(tmp,';');
		[tok2,tmp] = strtok(tmp,';');
		[tok3,tmp] = strtok(tmp,';');
	else
		[tok1,tmp] = strtok(tmp,' ');
		[tok2,tmp] = strtok(tmp,' ');
		[tok3,tmp] = strtok(tmp,' ');
	end;
	[T1, F1 ] = strtok(tok1,': ');
	[T2, F2 ] = strtok(tok2,': ');
	[T3, F3 ] = strtok(tok3,': ');

	[F1 ] = strtok(F1,': ');
	[F2 ] = strtok(F2,': ');
	[F3 ] = strtok(F3,': ');
	
	if strcmp(F1,'DC'), F1='0'; end;
	if strcmp(F2,'DC'), F2='0'; end;
	if strcmp(F3,'DC'), F3='0'; end;
	
	tmp = strfind(lower(F1),'hz');
	if ~isempty(tmp), F1=F1(1:tmp-1); end;
	tmp = strfind(lower(F2),'hz');
	if ~isempty(tmp), F2=F2(1:tmp-1); end;
	tmp = strfind(lower(F3),'hz');
	if ~isempty(tmp), F3=F3(1:tmp-1); end;

	if strcmp(T1,'LP'), 
		EDF.Filter.LowPass(k) =str2double(F1);
	elseif strcmp(T1,'HP'), 
		EDF.Filter.HighPass(k)=str2double(F1);
	elseif strcmp(T1,'Notch'), 
		EDF.Filter.Notch(k)   =str2double(F1);
	end;
	if strcmp(T2,'LP'), 
		EDF.Filter.LowPass(k) =str2double(F2);
	elseif strcmp(T2,'HP'), 
		EDF.Filter.HighPass(k)=str2double(F2);
	elseif strcmp(T2,'Notch'), 
		EDF.Filter.Notch(k)   =str2double(F2);
	end;
	if strcmp(T3,'LP'), 
		EDF.Filter.LowPass(k) =str2double(F3);
	elseif strcmp(T3,'HP'), 
		EDF.Filter.HighPass(k)=str2double(F3);
	elseif strcmp(T3,'Notch'), 
		EDF.Filter.Notch(k)   =str2double(F3);
	end;
catch
	fprintf(1,'Cannot interpret: %s\n',EDF.PreFilt(k,:));
end;
end;

%		EDF=gdfcheck(EDF,1);
if any(EDF.PhysMax==EDF.PhysMin), EDF.ErrNo=[1029,EDF.ErrNo]; end;	
if any(EDF.DigMax ==EDF.DigMin ), EDF.ErrNo=[1030,EDF.ErrNo]; end;	
EDF.Cal = (EDF.PhysMax-EDF.PhysMin)./(EDF.DigMax-EDF.DigMin);
EDF.Off = EDF.PhysMin - EDF.Cal .* EDF.DigMin;
EDF.EDF.SampleRate = EDF.SPR / EDF.Dur;
EDF.AS.MAXSPR=1;
for k=1:EDF.NS,
        EDF.AS.MAXSPR = lcm(EDF.AS.MAXSPR,EDF.SPR(k));
end;
EDF.SampleRate = EDF.AS.MAXSPR/EDF.Dur;

EDF.AS.spb = sum(EDF.SPR);	% Samples per Block
EDF.AS.bi = [0;cumsum(EDF.SPR)]; 
EDF.AS.BPR  = ceil(EDF.SPR.*GDFTYP_BYTE(EDF.GDFTYP+1)'); 
EDF.AS.SAMECHANTYP = all(EDF.AS.BPR == (EDF.SPR.*GDFTYP_BYTE(EDF.GDFTYP+1)')) & ~any(diff(EDF.GDFTYP)); 
EDF.AS.GDFbi = [0;cumsum(ceil(EDF.SPR.*GDFTYP_BYTE(EDF.GDFTYP+1)'))]; 
EDF.AS.bpb = sum(ceil(EDF.SPR.*GDFTYP_BYTE(EDF.GDFTYP+1)'));	% Bytes per Block
EDF.AS.startrec = 0;
EDF.AS.numrec = 0;
EDF.AS.EVENTTABLEPOS = -1;

EDF.Calib = [EDF.Off'; diag(EDF.Cal)];
EDF.AS.endpos = EDF.FILE.size;

%[status, EDF.AS.endpos, EDF.HeadLen, EDF.AS.bpb EDF.NRec, EDF.HeadLen+EDF.AS.bpb*EDF.NRec]
if EDF.NRec == -1   % unknown record size, determine correct NRec
        EDF.NRec = floor((EDF.AS.endpos - EDF.HeadLen) / EDF.AS.bpb);
elseif  EDF.NRec ~= ((EDF.AS.endpos - EDF.HeadLen) / EDF.AS.bpb);
        if ~strcmp(EDF.VERSION(1:3),'GDF'),
                EDF.ErrNo=[16,EDF.ErrNo];
                fprintf(2,'\nWarning SDFOPEN: size (%i) of file %s does not fit headerinformation\n',EDF.AS.endpos,EDF.FileName);
                EDF.NRec = floor((EDF.AS.endpos - EDF.HeadLen) / EDF.AS.bpb);
        else
                EDF.AS.EVENTTABLEPOS = EDF.HeadLen + EDF.AS.bpb*EDF.NRec;
        end;
end; 


if 0, 
        
elseif strcmp(EDF.TYPE,'GDF') & (EDF.AS.EVENTTABLEPOS > 0),  
        status = fseek(EDF.FILE.FID, EDF.AS.EVENTTABLEPOS, 'bof');
        [EVENT.Version,c] = fread(EDF.FILE.FID,1,'char');
        EDF.EVENT.SampleRate = [1,256,65536]*fread(EDF.FILE.FID,3,'uint8');
	if ~EDF.EVENT.SampleRate, % ... is not defined in GDF 1.24 or earlier
		EDF.EVENT.SampleRate = EDF.SampleRate; 
	end;
        EVENT.N = fread(EDF.FILE.FID,1,'uint32');
        if EVENT.Version==1,
                [EDF.EVENT.POS,c1] = fread(EDF.FILE.FID,[EVENT.N,1],'uint32');
                [EDF.EVENT.TYP,c2] = fread(EDF.FILE.FID,[EVENT.N,1],'uint16');
                if any([c1,c2]~=EVENT.N) | (EDF.AS.endpos~=EDF.AS.EVENTTABLEPOS+8+EVENT.N*6),
                        fprintf(2,'\nERROR SDFOPEN: Eventtable corrupted in file %s\n',EDF.FileName);
                end
                
                % convert EVENT.Version 1 to 3
                EDF.EVENT.CHN = zeros(EVENT.N,1);    
                EDF.EVENT.DUR = zeros(EVENT.N,1);    
                flag_remove = zeros(size(EDF.EVENT.TYP));        
                types  = unique(EDF.EVENT.TYP);
                for k1 = find(bitand(types(:)',hex2dec('8000')));
                        TYP0 = bitand(types(k1),hex2dec('7fff'));
                        TYP1 = types(k1);
                        ix0 = (EDF.EVENT.TYP==TYP0);
                        ix1 = (EDF.EVENT.TYP==TYP1);
                        if sum(ix0)==sum(ix1), 
                                EDF.EVENT.DUR(ix0) = EDF.EVENT.POS(ix1) - EDF.EVENT.POS(ix0);
                                flag_remove = flag_remove | (EDF.EVENT.TYP==TYP1);
                        else 
                                fprintf(2,'Warning ELOAD: number of event onset (TYP=%s) and event offset (TYP=%s) differ\n',dec2hex(TYP0),dec2hex(TYP1));
                        end;
                end
                if any(EDF.EVENT.DUR<0)
                        fprintf(2,'Warning ELOAD: EVENT ONSET later than EVENT OFFSET\n',dec2hex(TYP0),dec2hex(TYP1));
                        EDF.EVENT.DUR(:) = 0
                end;
                EDF.EVENT.TYP = EDF.EVENT.TYP(~flag_remove);
                EDF.EVENT.POS = EDF.EVENT.POS(~flag_remove);
                EDF.EVENT.CHN = EDF.EVENT.CHN(~flag_remove);
                EDF.EVENT.DUR = EDF.EVENT.DUR(~flag_remove);
                EVENT.Version = 3; 
                
        elseif EVENT.Version==3,
                [EDF.EVENT.POS,c1] = fread(EDF.FILE.FID,[EVENT.N,1],'uint32');
                [EDF.EVENT.TYP,c2] = fread(EDF.FILE.FID,[EVENT.N,1],'uint16');
                [EDF.EVENT.CHN,c3] = fread(EDF.FILE.FID,[EVENT.N,1],'uint16');
                [EDF.EVENT.DUR,c4] = fread(EDF.FILE.FID,[EVENT.N,1],'uint32');
                if any([c1,c2,c3,c4]~=EVENT.N) | (EDF.AS.endpos~=EDF.AS.EVENTTABLEPOS+8+EVENT.N*12),
                        fprintf(2,'\nERROR SDFOPEN: Eventtable corrupted in file %s\n',EDF.FileName);
                end
                
        else
                fprintf(2,'\nWarning SDFOPEN: Eventtable version %i not supported\n',EVENT.Version);
        end;
        EDF.AS.endpos = EDF.AS.EVENTTABLEPOS;   % set end of data block, might be important for SSEEK

        % Classlabels according to 
        % http://cvs.sourceforge.net/viewcvs.py/*checkout*/biosig/biosig/t200/eventcodes.txt
        if (length(EDF.EVENT.TYP)>0)
                ix = (EDF.EVENT.TYP>hex2dec('0300')) & (EDF.EVENT.TYP<hex2dec('030d'));
                ix = ix | (EDF.EVENT.TYP==hex2dec('030f')); % unknown/undefined cue
                EDF.Classlabel = mod(EDF.EVENT.TYP(ix),256);
                EDF.Classlabel(EDF.Classlabel==15) = NaN; % unknown/undefined cue
        end;

        % Trigger information and Artifact Selection 
        ix = find(EDF.EVENT.TYP==hex2dec('0300')); 
        EDF.TRIG = EDF.EVENT.POS(ix);
        EDF.ArtifactSelection = repmat(logical(0),length(ix),1);
        for k = 1:length(ix),
                ix2 = find(EDF.EVENT.POS(ix(k))==EDF.EVENT.POS);
                if any(EDF.EVENT.TYP(ix2)==hex2dec('03ff'))
                        EDF.ArtifactSelection(k) = logical(1);                
                end;
        end;
        
elseif strcmp(EDF.TYPE,'EDF') & (length(strmatch('EDF Annotations',EDF.Label))==1),
        % EDF+: 
        tmp = strmatch('EDF Annotations',EDF.Label);
        EDF.EDF.Annotations = tmp;
        EDF.Cal(EDF.EDF.Annotations) = 1;
        EDF.Off(EDF.EDF.Annotations) = 0;
        
        status = fseek(EDF.FILE.FID,EDF.HeadLen+EDF.AS.bi(EDF.EDF.Annotations)*2,'bof');
        t = fread(EDF.FILE.FID,EDF.SPR(EDF.EDF.Annotations),'uchar',EDF.AS.bpb-EDF.SPR(EDF.EDF.Annotations)*2);
        t = char(t)';
        lt = length(t);
        EDF.EDF.ANNONS = t;
        N = 0; 
        ix = 1; 
	t = [t,' '];
        while ix < length(t),
                while (ix<=lt) & (t(ix)==0), ix = ix+1; end;
                ix1 = ix; 
                while (ix<=lt) & (t(ix)~=0), ix = ix+1; end;
                ix2 = ix; 
                if (ix < lt),
                        v = t(ix1:ix2-1);
                        [s1,v]=strtok(v,20);
                        s1(s1==21) = 0;
                        tmp=str2double(char(s1));
                        
                        [s2,v]=strtok(v,20);
                        [s3,v]=strtok(v,20);
                        
                        N = N+1;
                        EDF.EVENT.POS(N,1) = tmp(1);
                        if length(tmp)>1,
                                EDF.EVENT.DUR(N,1) = tmp(2);
                        end;
                        EDF.EVENT.TeegType{N,1} = char(s2);
                        EDF.EVENT.TeegDesc{N,1} = char(s3);
                end;
        end;
        EDF.EVENT.TYP(1:N,1) = 0;

elseif strcmp(EDF.TYPE,'EDF') & (length(EDF.FILE.Name)==8) & any(lower(EDF.FILE.Name(1))=='bchmnpsu') 
        if strcmp(lower(EDF.FILE.Name([3,6:8])),'001a'),
                % load scoring of ADB database if available 

                fid2 = fopen(fullfile(EDF.FILE.Path, [EDF.FILE.Name(1:7),'.txt']),'r');
                if fid2<0,
                        fid2 = fopen(fullfile(EDF.FILE.Path,[lower(EDF.FILE.Name(1:7)),'.txt']),'r');
                end
                if fid2<0,
                        fid2 = fopen(fullfile(EDF.FILE.Path,[EDF.FILE.Name(1:7),'.TXT']),'r');
                end
                if fid2>0,
                        tmp = fread(fid2,inf,'char');
                        fclose(fid2);
                        [ma,status] = str2double(char(tmp'));
                        if ~any(isnan(status(:))),
                                %%% TODO: include ADB2EVENT here

				% code from MAK2BIN.M (C) 1998-2004 A. Schlögl 
				ERG = zeros(size(ma));

				%%%% one artifact %%%%
				for k=0:9,
				        if exist('OCTAVE_VERSION')==5
				                ERG = ERG+(ma==k)*2^k;
				        else
				                ERG(ma==k) = 2^k;
				        end;
				end;

				%%%% more than one artifact %%%%
				[i,j] = find(ma>9);
				L='123456789';
				for k=1:length(i),
				        b=int2str(ma(i(k),j(k)));
				        erg=0;
				        for l=1:9,
				                if any(b==L(l)), erg=erg+2^l; end;
				        end;        
				        ERG(i(k),j(k)) = erg;
				end;
				
				N   = 0;
				POS = [];
				TYP = [];
				DUR = [];
				CHN = [];
				cc  = zeros(1,10);
				for k = 1:9,
				        for c = 1:7;%size(ERG,2),
				                tmp = [0;~~(bitand(ERG(:,c),2^k));0];
				 
				                cc(k+1) = cc(k+1) + sum(tmp);
				                pos = find(diff(tmp)>0);
				                pos2 = find(diff(tmp)<0);
				                n   = length(pos);
				                
				                POS = [POS; pos(:)];
				                TYP = [TYP; repmat(k,n,1)];
				                CHN = [CHN; repmat(c,n,1)];
				                DUR = [DUR; pos2(:)-pos(:)];
				                N   = N + n;
				        end;
				end;
				
				EDF.EVENT.Fs = 1;
				if nargin>1,
				        EVENT.Fs = EDF.SampleRate;
				end;
				
				[tmp,ix] = sort(POS);
				EDF.EVENT.POS = (POS(ix)-1)*EVENT.Fs+1;
				EDF.EVENT.TYP = TYP(ix) + hex2dec('0100');
				EDF.EVENT.CHN = CHN(ix);
				EDF.EVENT.DUR = DUR(ix)*EVENT.Fs;
				
				%EDF.EVENT.ERG = ERG;
			end;
                end
        end;
else
	% search for WSCORE scoring file in path and in file directory. 
	tmp = [upper(EDF.FILE.Name),'.006'];
        fid2 = fopen(fullfile(EDF.FILE.Path,tmp),'r');
        if fid2 > 0,
                tmp = fread(fid2,inf,'char');
                fclose(fid2);
                [x,status] = str2double(char(tmp'));
                if ~any(isnan(status(:))),
                        EDF.EVENT.POS = x(:,1);
                        EDF.EVENT.TYP = x(:,2);
                end;
        end;
end;

status = fseek(EDF.FILE.FID, EDF.HeadLen, 'bof');
EDF.FILE.POS = 0;

% if Channelselect, ReReferenzing and Resampling
% Overflowcheck, Adaptive FIR
% Layer 4 

%if nargin<3 %%%%%          Channel Selection 
if nargin <3 %else
        arg3=0;
end;

EDF.SIE.ChanSelect = 1:EDF.NS;
EDF.InChanSelect = 1:EDF.NS;

%EDF.SIE.RR=1; %is replaced by ~EDF.FLAG.UCAL
if ~isfield(EDF,'FLAG')
        EDF.FLAG.UCAL=0;
end;
if ~isfield(EDF.FLAG,'UCAL');
        EDF.FLAG.UCAL=0;
end;
EDF.SIE.RS=0; %exist('arg5')==1; if EDF.SIE.RS, EDF.SIE.RS==(arg5>0); end;
EDF.SIE.TH=0; %(exist('arg6')==1);
EDF.SIE.RAW=0;
EDF.SIE.REGC=0;
EDF.SIE.TECG=0;
EDF.SIE.AFIR=0;
EDF.SIE.FILT=0;
EDF.SIE.TimeUnits_Seconds=1;
%EDF.SIE.ReRefMx=eye(EDF.NS);
EDF.SIE.REG=eye(EDF.NS);
%EDF.SIE.ReRefMx = EDF.SIE.ReRefMx(:,EDF.SIE.ChanSelect);
%EDF.Calib=EDF.Calib*EDF.SIE.REG*EDF.SIE.ReRefMx; 

%if nargin>2 %%%%%          Channel Selection 
        EDF.SIE.REG=eye(EDF.NS);
        if arg3==0
                EDF.SIE.ChanSelect = 1:EDF.NS;
                EDF.InChanSelect = 1:EDF.NS;
                EDF.SIE.ReRefMx = eye(EDF.NS);
        else
                [nr,nc]=size(arg3);
                if all([nr,nc]>1), % Re-referencing
                        EDF.SIE.ReRefMx = [[arg3 zeros(size(arg3,1),EDF.NS-size(arg3,2))]; zeros(EDF.NS-size(arg3,1),EDF.NS)];
                        EDF.InChanSelect = find(any(EDF.SIE.ReRefMx'));
                        EDF.SIE.ChanSelect = find(any(EDF.SIE.ReRefMx));
                        if nargin>3
                        %        fprintf(EDF.FILE.stderr,'Error SDFOPEN: Rereferenzing does not work correctly with %s (more than 3 input arguments)\n',arg4);
                        end;
                else
                        EDF.SIE.ChanSelect = arg3; %full(sparse(1,arg3(:),1,1,EDF.NS));
                        EDF.InChanSelect = arg3;
                        EDF.SIE.ReRefMx = eye(EDF.NS);
                end;
        end;
        
        if (exist('sedfchk')==2),  
                EDF=sedfchk(EDF); % corrects incorrect Header information. 
        end;

	%EDF.SIE.CS=1;
        EDF.SIE.RS=exist('arg5')==1; if EDF.SIE.RS, EDF.SIE.RS==(arg5>0); end;
        EDF.SIE.TH=0; %(exist('arg6')==1);
        EDF.SIE.RAW=0;
        EDF.SIE.REGC=0;
        EDF.SIE.TECG=0;
        EDF.SIE.AFIR=0;
        EDF.SIE.FILT=0;
        %EDF.AS.MAXSPR=max(EDF.SPR(EDF.SIE.ChanSelect)); % Layer 3 defines EDF.AS.MAXSPR in GDFREAD
        if 0,
		EDF.AS.MAXSPR=EDF.SPR(EDF.SIE.ChanSelect(1));
	        for k=2:length(EDF.SIE.ChanSelect),
    		        EDF.AS.MAXSPR = lcm(EDF.AS.MAXSPR,EDF.SPR(EDF.SIE.ChanSelect(k)));
	        end;
	end;
	EDF.SampleRate = EDF.AS.MAXSPR/EDF.Dur;
        
        EDF.SIE.REG=eye(EDF.NS);

        %elseif nargin>3   %%%%% RE-REFERENCING
        if nargin>3   
                if ~isempty(strfind(upper(arg4),'SIESTA'))
                        EDF.SIE.ReRefMx = eye(EDF.NS);% speye(EDF.NS);
                        EDF.SIE.ReRefMx(7,1:6)=[1 1 1 -1 -1 -1]/2;
                        EDF.SIE.TH=1;
	                % calculate (In)ChanSelect based on ReRefMatrix
    		        EDF.InChanSelect = find(any(EDF.SIE.ReRefMx'));
            		EDF.SIE.ChanSelect = find(any(EDF.SIE.ReRefMx));
                end;
                if ~isempty(strfind(upper(arg4),'EOG'))
                        tmp=strfind(upper(arg4),'EOG');
                        tmp=lower(strtok(arg4(tmp:length(arg4)),' +'));
                        EDF.SIE.ReRefMx = sparse(EDF.NS,EDF.NS);% speye(EDF.NS);
                        if any(tmp=='h'); EDF.SIE.ReRefMx(8:9,1)=[ 1 -1 ]';  end;
                        if any(tmp=='v'); EDF.SIE.ReRefMx(1:9,2)=[ 1 0 0 1 0 0 1 -1 -1]';end;
                        if any(tmp=='r'); EDF.SIE.ReRefMx(3:9,3)=[ 1 0 0 1 2 -2 -2]'/2;  end;
                        %EDF.SIE.TH = 1;
	                % calculate (In)ChanSelect based on ReRefMatrix
    		        EDF.InChanSelect = find(any(EDF.SIE.ReRefMx'));
            		EDF.SIE.ChanSelect = find(any(EDF.SIE.ReRefMx));
                end;
                
                if ~isempty(strfind(upper(arg4),'UCAL'))
                        %EDF.SIE.ReRefMx = speye(EDF.NS); % OVERRIDES 'SIESTA' and 'REGRESS_ECG'
                        %EDF.SIE.RR  = 0;
                        EDF.FLAG.UCAL = 1;
                end;
                if ~isempty(strfind(upper(arg4),'RAW'))
                        EDF.SIE.RAW = 1;
                end;
                if ~isempty(strfind(upper(arg4),'OVERFLOW'))
                        EDF.SIE.TH  = 1;
                end;
                if ~isempty(strfind(arg4,'FailingElectrodeDetector'))
                        EDF.SIE.FED = 1;
			EDF.SIE.TH  = 2;
                end;
		
                if ~isempty(strfind(upper(arg4),'ECG')), % identify ECG channel for some ECG artifact processing method   
                        if ~isempty(strfind(upper(arg4),'SIESTA'))
                                channel1=12;
                                %channel2=1:9;
                                M=zeros(EDF.NS,1);M(channel1)=1;
                        end
                        if isfield(EDF,'ChanTyp')
                                M=upper(char(EDF.ChanTyp(channel1)))=='C';
                                channel1=find(M);
                                M=(upper(char(EDF.ChanTyp))=='E' | upper(char(EDF.ChanTyp))=='O' );
                                %channel2=find(M);
                        else
                                channel1 = 12;
                                %channel2=1:9;
                                M=zeros(EDF.NS,1);M(channel1)=1;
                        end;
                        
                end;
                if ~isempty(strfind(upper(arg4),'RECG'))
                        EDF.SIE.REGC = 1;
                        if all(EDF.InChanSelect~=channel1)
                                EDF.InChanSelect=[EDF.InChanSelect channel1];        
                        end;
                end;
                
                if ~isempty(strfind(upper(arg4),'TECG'))
                        fprintf(EDF.FILE.stderr,'SDFOPEN: status of TECG Mode: alpha test passed\n');    
                        %%%% TECG - ToDo
                        % - optimize window
                        if exist([lower(EDF.FILE.Name) 'ECG.mat']);
                                if exist('OCTAVE_VERSION')==5
                                        load(file_in_loadpath([lower(EDF.FILE.Name) 'ECG.mat']));
                                else
                                        load([lower(EDF.FILE.Name) 'ECG.mat']);
                                end;
                                if isstruct(QRS)
                                        EDF.SIE.TECG = 1;
					%%%  EDF.AS.MAXSPR=size(QRS.Templates,1)/3;
                                        EDF.AS.MAXSPR=lcm(EDF.AS.MAXSPR,EDF.SPR(channel1));
				else
                                        fprintf(EDF.FILE.stderr,'WARNING SDFOPEN: %s invalid for TECG\n',[ lower(EDF.FILE.Name) 'ECG.mat']);
                                end;
                        else
                                fprintf(EDF.FILE.stderr,'WARNING SDFOPEN: %s not found\t (needed for Mode=TECG)\n',[lower(EDF.FILE.Name) 'ECG.mat']);
                        end;
                end;
                
                if ~isempty(strfind(upper(arg4),'AFIR')) 
                        % Implements Adaptive FIR filtering for ECG removal in EDF/GDF-tb.
                        % based on the Algorithm of Mikko Koivuluoma <k7320@cs.tut.fi>
                                
                        % channel2 determines which channels should be corrected with AFIR 
                        
                        %EDF = sdf_afir(EDF,12,channel2);
                        channel2=EDF.SIE.ChanSelect;	
                        fprintf(EDF.FILE.stderr,'Warning SDFOPEN: option AFIR still buggy\n');    
                        if isempty(find(channel2))
                                EDF.SIE.AFIR=0;
                        else
                                EDF.SIE.AFIR=1;
                                EDF.AFIR.channel2=channel2;
                                
                                EDF.AFIR.alfa=0.01;
                                EDF.AFIR.gamma=1e-32;
                                
                                EDF.AFIR.delay  = ceil(0.05*EDF.AS.MAXSPR/EDF.Dur); 
                                EDF.AFIR.nord = EDF.AFIR.delay+EDF.AS.MAXSPR/EDF.Dur; 
                                
                                EDF.AFIR.nC = length(EDF.AFIR.channel2);
                                EDF.AFIR.w = zeros(EDF.AFIR.nC, max(EDF.AFIR.nord));
                                EDF.AFIR.x = zeros(1, EDF.AFIR.nord);
                                EDF.AFIR.d = zeros(EDF.AFIR.delay, EDF.AFIR.nC);
                                
                                channel1=12;
                                
                                if isfield(EDF,'ChanTyp')
                                        if upper(char(EDF.ChanTyp(channel1)))=='C';
                                                EDF.AFIR.channel1 = channel1;
                                        else
                                                EDF.AFIR.channel1 = find(EDF.ChanTyp=='C');
                                                fprintf(EDF.FILE.stderr,'Warning %s: #%i is not an ECG channel, %i used instead\n' ,filename,channel1,EDF.AFIR.channel1);
                                        end;
                                else
                                        EDF.AFIR.channel1 = channel1;
                                end;
                                
                                if all(EDF.InChanSelect~=channel1)
                                        EDF.InChanSelect=[EDF.InChanSelect channel1];        
                                end;
                        end;
                end;


                if isempty(strfind(upper(arg4),'NOTCH50')) 
                        EDF.Filter.A = 1;
                        EDF.Filter.B = 1;
                else
                        EDF.SIE.FILT = 1;
                        EDF.Filter.A = 1;
                        EDF.Filter.B = 1;
                        %if all(EDF.SampleRate(EDF.SIE.ChanSelect)==100)
                        if EDF.AS.MAXSPR/EDF.Dur==100
                                EDF.Filter.B=[1 1]/2;
                                %elseif all(EDF.SampleRate(EDF.SIE.ChanSelect)==200)
                        elseif EDF.AS.MAXSPR/EDF.Dur==200
                                EDF.Filter.B=[1 1 1 1]/4;
                                %elseif all(EDF.SampleRate(EDF.SIE.ChanSelect)==256)
                        elseif EDF.AS.MAXSPR/EDF.Dur==400
                                EDF.Filter.B=ones(1,8)/8;
                                %elseif all(EDF.SampleRate(EDF.SIE.ChanSelect)==256)
                        elseif EDF.AS.MAXSPR/EDF.Dur==256
                                EDF.Filter.B=poly([exp([-1 1 -2 2]*2*pi*i*50/256)]); %max(EDF.SampleRate(EDF.SIE.ChanSelect)))]);
                                EDF.Filter.B=EDF.Filter.B/sum(EDF.Filter.B);
                        else
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: 50Hz Notch does not fit\n');
                        end;
                end;



                if ~isempty(strfind(upper(arg4),'NOTCH60')) 
                        fprintf(EDF.FILE.stderr,'Warning SDFOPEN: option NOTCH60 not implemented yet.\n');    
                end;


                if ~isempty(strfind(upper(arg4),'HPF')),  % high pass filtering
                        if EDF.SIE.FILT==0; EDF.Filter.B=1; end;
                        EDF.SIE.FILT=1;
                        EDF.Filter.A=1;
		end;
                if ~isempty(strfind(upper(arg4),'HPF0.0Hz')),  % high pass filtering
                        EDF.Filter.B=conv([1 -1], EDF.Filter.B);
                elseif ~isempty(strfind(upper(arg4),'TAU')),  % high pass filtering / compensate time constant
                        tmp=strfind(upper(arg4),'TAU');
                        TAU=strtok(upper(arg4(tmp:length(arg4))),'S');
                        tau=str2double(TAU);
                        if isempty(tau)
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: invalid tau-value.\n');
                        else
                                EDF.Filter.B=conv([1 (EDF.Dur/EDF.AS.MAXSPR/tau-1)], EDF.Filter.B);
                        end;
			
                %%%% example 'HPF_1.0Hz_Hamming',  % high pass filtering
                elseif ~isempty(strfind(upper(arg4),'HPF')),  % high pass filtering
			    tmp=strfind(upper(arg4),'HPF');
			    FilterArg0=arg4(tmp+4:length(arg4));
			    %[tmp,FilterArg0]=strtok(arg4,'_');
			    [FilterArg1,FilterArg2]=strtok(FilterArg0,'_');
			    [FilterArg2,FilterArg3]=strtok(FilterArg2,'_');
			    tmp=strfind(FilterArg1,'Hz');
			    F0=str2double(FilterArg1(1:tmp-1));				    
			    B=feval(FilterArg2,F0*EDF.AS.MAXSPR/EDF.Dur);
			    B=B/sum(B);
			    B(ceil(length(B)/2))=(B(ceil(length(B)/2)))-1;
			    
                        EDF.Filter.B=conv(-B, EDF.Filter.B);
                end;


                if ~isempty(strfind(upper(arg4),'UNITS_BLOCK'))
			EDF.SIE.TimeUnits_Seconds=0; 
                end;

        end; % end nargin >3
        
        if EDF.SIE.FILT==1;
		EDF.Filter.Z=[];
                for k=1:length(EDF.SIE.ChanSelect),
                        [tmp,EDF.Filter.Z(:,k)]=filter(EDF.Filter.B,EDF.Filter.A,zeros(length(EDF.Filter.B+1),1));
                end;
    		EDF.FilterOVG.Z=EDF.Filter.Z;
        end;
        
        if EDF.SIE.REGC
                FN=[lower(EDF.FILE.Name) 'cov.mat'];
                if exist(FN)~=2
                        fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Covariance-file %s not found.\n',FN);
                        EDF.SIE.REGC=0;   
                else
                        if exist('OCTAVE_VERSION')==5
                                load(file_in_loadpath(FN));
                        else
                                load(FN);
                        end;
                        if exist('XC') == 1
                                %EDF.SIE.COV = tmp.XC;
                                %[N,MU,COV,Corr]=decovm(XC);
                                N=size(XC,2);
                                COV=(XC(2:N,2:N)/XC(1,1)-XC(2:N,1)*XC(1,2:N)/XC(1,1)^2);
                                
                                %clear tmp;
                                %cov = diag(EDF.Cal)*COV*diag(EDF.Cal);
                                mcov = M'*diag(EDF.Cal)*COV*diag(EDF.Cal);
                                %mcov(~())=0;
                                EDF.SIE.REG = eye(EDF.NS) - M*((mcov*M)\(mcov));
                                EDF.SIE.REG(channel1,channel1) = 1; % do not remove the regressed channels
                                %mcov, EDF.SIE.REG, 
                        else
                                fprintf(EDF.FILE.stderr,'Error SDFOPEN: Regression Coefficients for ECG minimization not available.\n');
                        end;
                end;
                
        end;
        
        if EDF.SIE.TECG == 1; 
                % define channels that should be corrected
                if isfield(QRS,'Version')
                        OutChanSelect=[1:11 13:EDF.NS];
                        if EDF.SIE.REGC % correct templates
                                QRS.Templates=QRS.Templates*EDF.SIE.REG;
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Mode TECG+RECG not tested\n');
                        end;
                        if QRS.Version~=2
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN Mode TECG: undefined QRS-version\n');
                        end;
                else
                        %OutChanSelect=find(EDF.ChanTyp=='E' | EDF.ChanTyp=='O');
                        OutChanSelect=[1:9 ];
			if any(EDF.SIE.ChanSelect>10)
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Mode TECG: Only #1-#9 are corrected\n');
                        end;
                        if EDF.SIE.REGC, % correct the templates
                                QRS.Templates=QRS.Templates*EDF.SIE.REG([1:9 12],[1:9 12]);
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Mode TECG+RECG not tested\n');
                        end;
                        
                end;
                fs = EDF.SPR(12)/EDF.Dur; 
                QRS.Templates=detrend(QRS.Templates,0); %remove mean
                EDF.TECG.idx = [(QRS.Index-fs/2-1) (EDF.NRec+1)*EDF.SPR(12)]; %include terminating element
                EDF.TECG.idxidx = 1; %pointer to next index

                % initialize if any spike is detected before first window    
	        pulse = zeros(length(QRS.Templates),1);
    		Index=[];
	        while EDF.TECG.idx(EDF.TECG.idxidx) < 1,
    		        Index=[Index EDF.TECG.idx(EDF.TECG.idxidx)-EDF.AS.startrec*EDF.SPR(12)];
            		EDF.TECG.idxidx=EDF.TECG.idxidx+1;
	        end;
	        if ~isempty(Index)
    		        pulse(Index+length(QRS.Templates)) = 1;  
	        end;
        
                for k=1:length(EDF.InChanSelect),
                        k=find(OutChanSelect==EDF.InChanSelect(k));
                        if isempty(k)
                                EDF.TECG.QRStemp(:,k) = zeros(fs,1);
                        else
                                EDF.TECG.QRStemp(:,k) = QRS.Templates(0.5*fs:1.5*fs-1,k).*hanning(fs);
                        end;
                        [tmp,EDF.TECG.Z(:,k)] = filter(EDF.TECG.QRStemp(:,k),1,pulse);
                end;
        end; % if EDF.SIE.TECG==1
        
        %syms Fp1 Fp2 M1 M2 O2 O1 A1 A2 C3 C4
        if 0, % ??? not sure, whether it has any advantage
        for k=EDF.SIE.ChanSelect,
                %fprintf(1,'#%i: ',k);
                tmp=find(EDF.SIE.ReRefMx(:,k))';
                
                if EDF.SIE.ReRefMx(tmp(1),k)==1,
                        x=EDF.Label(tmp(1),:);
                else
                        x=sprintf('%3.1f*%s',EDF.SIE.ReRefMx(tmp(1),k),deblank(EDF.Label(tmp(1),:)));
                end;
                for l=2:length(tmp), L=tmp(l);
                        if (EDF.SPR(tmp(l-1),:)~=EDF.SPR(tmp(l),:))  
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: SampleRate Mismatch in "%s", channel #%i and #%i\n',EDF.FILE.Name,tmp(l-1),tmp(l));
                        end;
                        if ~strcmp(EDF.PhysDim(tmp(l-1),:),EDF.PhysDim(tmp(l),:))  
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Dimension Mismatch in "%s", channel #%i and #%i\n',EDF.FILE.Name,tmp(l-1),tmp(l));
                        end;
                        if ~strcmp(EDF.Transducer(tmp(l-1),:),EDF.Transducer(tmp(l),:))  
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Transducer Mismatch in "%s", channel #%i and #%i\n',EDF.FILE.Name,tmp(l-1),tmp(l));
                        end;
                        if ~strcmp(EDF.PreFilt(tmp(l-1),:),EDF.PreFilt(tmp(l),:))  
                                fprintf(EDF.FILE.stderr,'Warning SDFOPEN: PreFiltering Mismatch in "%s", channel #%i and #%i\n',EDF.FILE.Name,tmp(l-1),tmp(l));
                        end;
                        x=[x sprintf('+(%3.1f)*(%s)',EDF.SIE.ReRefMx(tmp(l),k),deblank(EDF.Label(tmp(l),:)))];
                end;
                EDF.Label(k,1:length(x))=x; %char(sym(x))
        end;
        %Label,
        EDF.SIE.ReRefMx = EDF.SIE.ReRefMx(:,EDF.SIE.ChanSelect);
	        
        EDF.PhysDim = EDF.PhysDim(EDF.SIE.ChanSelect,:);
        EDF.PreFilt = EDF.PreFilt(EDF.SIE.ChanSelect,:);
        EDF.Transducer = EDF.Transducer(EDF.SIE.ChanSelect,:);
        end;
        
        if EDF.SIE.RS,
		tmp = EDF.AS.MAXSPR/EDF.Dur;
                if arg5==0
                        %arg5 = max(EDF.SPR(EDF.SIE.ChanSelect))/EDF.Dur;
                        
                elseif ~rem(tmp,arg5); % The target sampling rate must divide the source sampling rate   
			EDF.SIE.RS = 1;
			tmp=tmp/arg5;
			EDF.SIE.T = ones(tmp,1)/tmp;
                elseif arg5==100; % Currently, only the target sampling rate of 100Hz are supported. 
                        EDF.SIE.RS=1;
                        tmp=EDF.AS.MAXSPR/EDF.Dur;
                        if exist('OCTAVE_VERSION')
                                load resample_matrix4octave.mat T256100 T200100;
                        else
                                load('resample_matrix');
                        end;
                        if 1,
                                if tmp==400,
                                        EDF.SIE.T=ones(4,1)/4;
                                elseif tmp==256,
                                        EDF.SIE.T=T256100;
                                elseif tmp==200,
                                        EDF.SIE.T=T200100; 
                                elseif tmp==100,
                                        EDF.SIE.T=1;
                                else
                                        fprintf('Warning SDFOPEN-READ: sampling rates should be equal\n');     
                                end;	
                        else
                                tmp=EDF.SPR(EDF.SIE.ChanSelect)/EDF.Dur;
                                if all((tmp==256) | (tmp<100)) 
                                        EDF.SIE.RS = 1;
                                        %tmp=load(RSMN,'T256100');	
                                        EDF.SIE.T = T256100;	
                                elseif all((tmp==400) | (tmp<100)) 
                                        EDF.SIE.RS = 1;
                                        EDF.SIE.T = ones(4,1)/4;
                                elseif all((tmp==200) | (tmp<100)) 
                                        EDF.SIE.RS = 1;
                                        %tmp=load(RSMN,'T200100');	
                                        EDF.SIE.T = T200100;	
                                elseif all(tmp==100) 
                                        %EDF.SIE.T=load('resample_matrix','T100100');	
                                        EDF.SIE.RS=0;
                                else
                                        EDF.SIE.RS=0;
                                        fprintf('Warning SDFOPEN-READ: sampling rates should be equal\n');     
                                end;
                        end;
                else
                        fprintf(EDF.FILE.stderr,'Error SDFOPEN-READ: invalid target sampling rate of %i Hz\n',arg5);
                        EDF.SIE.RS=0;
			EDF.ErrNo=[EDF.ErrNo,];
			%EDF=sdfclose(EDF);
			%return;
                end;
        end;
        
        FN=[lower(EDF.FILE.Name), 'th.mat'];
        if exist(FN)~=2,
	        if EDF.SIE.TH, % && ~exist('OCTAVE_VERSION'),
                        fprintf(EDF.FILE.stderr,'Warning SDFOPEN: THRESHOLD-file %s not found.\n',FN);
                        EDF.SIE.TH=0;   
                end;
        else
                if exist('OCTAVE_VERSION')==5
                        tmp=load(file_in_loadpath(FN));
                else
                        tmp=load(FN);
                end;
                if isfield(tmp,'TRESHOLD'), 
                        EDF.SIE.THRESHOLD = tmp.TRESHOLD;
            	        %fprintf(EDF.FILE.stderr,'Error SDFOPEN: TRESHOLD''s not found.\n');
                end;
                

        end;
    	if EDF.SIE.TH>1, % Failing electrode detector 
	        fprintf(2,'Warning SDFOPEN (%s): FED not implemented yet\n',EDF.FileName);
                for k=1:length(EDF.InChanSelect),K=EDF.InChanSelect(k);
	        %for k=1:EDF.NS,
    		        [y1,EDF.Block.z1{k}] = filter([1 -1], 1, zeros(EDF.SPR(K)/EDF.Dur,1));
            		[y2,EDF.Block.z2{k}] = filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,zeros(EDF.SPR(K)/EDF.Dur,1));
                
           		[y3,EDF.Block.z3{k}] = filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,zeros(EDF.SPR(K)/EDF.Dur,1));
    		end;
        end;

% Initialization of Bufferblock for random access (without EDF-blocklimits) of data 
	if ~EDF.SIE.RAW & EDF.SIE.TimeUnits_Seconds
                EDF.Block.number=[0 0 0 0]; %Actual Blocknumber, start and end time of loaded block, diff(EDF.Block.number(1:2))==0 denotes no block is loaded;
                                            % EDF.Blcok.number(3:4) indicate start and end of the returned data, [units]=samples.
		EDF.Block.data=[];
		EDF.Block.dataOFCHK=[];
	end;
        
%end; % end of SDFOPEN-READ

%%%%%%% ============= WRITE ===========%%%%%%%%%%%%        

elseif any(arg2=='w') %  | (arg2=='w+')
%        fprintf(EDF.FILE.stderr,'error EDFOPEN: write mode not possible.\n'); 
        H1=[]; H2=[];
%        return;
        
EDF.SIE.RAW = 0;
if ~isstruct(arg1)  % if arg1 is the filename 
        EDF.FileName=arg1;
        if nargin<3
                tmp=input('SDFOPEN: list of samplerates for each channel? '); 
                EDF.EDF.SampleRate = tmp(:);
        else
                EDF.EDF.SampleRate = arg3;
        end;
        EDF.NS=length(EDF.EDF.SampleRate);
        if nargin<4
                tmp=input('SDFOPEN: Duration of one block in seconds: '); 
                EDF.Dur = tmp;
                EDF.SPR=EDF.Dur*EDF.SampleRate;
        else
                if ~isempty(strfind(upper(arg4),'RAW'))
                        EDF.SIE.RAW = 1;
                else
                        EDF.Dur = arg4;
                        EDF.SPR=EDF.Dur*EDF.SampleRate;
                end;
        end;
        EDF.SampleRate = EDF.AS.MAXSPR/EDF.Dur;
end;

FILENAME=EDF.FileName;
PPos=min([max(find(FILENAME=='.')) length(FILENAME)+1]);
SPos=max([0 find(FILENAME==filesep)]);
EDF.FILE.Ext = FILENAME(PPos+1:length(FILENAME));
EDF.FILE.Name = FILENAME(SPos+1:PPos-1);
if SPos==0
	EDF.FILE.Path = pwd;
else
	EDF.FILE.Path = FILENAME(1:SPos-1);
end;
EDF.FileName = [EDF.FILE.Path filesep EDF.FILE.Name '.' EDF.FILE.Ext];

% Check all fields of Header1
if ~isfield(EDF,'VERSION')
        fprintf('Warning SDFOPEN-W: EDF.VERSION not defined; default=EDF assumed\n');
        EDF.VERSION='0       '; % default EDF-format
end;

if ~strcmp(EDF.VERSION(1:3),'GDF');
        %EDF.VERSION = '0       ';
        fprintf(EDF.FILE.stderr,'\nData are stored with integer16.\nMeasures for minimizing round-off errors have been taken.\nDespite, overflow and round off errors may occur.\n');  
        
        if sum(EDF.SPR)>61440/2;
                fprintf(EDF.FILE.stderr,'\nWarning SDFOPEN: One block exceeds 61440 bytes.\n')
        end;
else
        EDF.VERSION = 'GDF 1.25';       % April 15th, 2004, support of eventtable position included
end;

if ~isfield(EDF,'PID')
        fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.PID not defined\n');
        EDF.PID=setstr(32+zeros(1,80));
end;
if ~isfield(EDF,'RID')
        fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.RID not defined\n');
        EDF.RID=setstr(32+zeros(1,80));
end;
if ~isfield(EDF,'T0')
        EDF.T0=zeros(1,6);
        fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.T0 not defined\n');
end;
if ~isfield(EDF,'reserved1')
        EDF.reserved1=char(ones(1,44)*32);
else
        tmp=min(8,size(EDF.reserved1,2));
        EDF.reserved1=[EDF.reserved1(1,1:tmp), char(32+zeros(1,44-tmp))];
end;
if ~isfield(EDF,'NRec')
        EDF.NRec=-1;
end;
if ~isfield(EDF,'Dur')
        if EDF.NS>0,
                fprintf('Warning SDFOPEN-W: EDF.Dur not defined\n');
        end;
        EDF.Dur=NaN;
end;
if ~isfield(EDF,'NS')
        EDF.ERROR = sprintf('Error SDFOPEN-W: EDF.NS not defined\n');
        EDF.ErrNo = EDF.ErrNo + 128;
	return;
end;
if ~isfield(EDF,'SampleRate')
        EDF.SampleRate = NaN;
end;
if ~isfield(EDF,'SPR')
        EDF.SPR = NaN;
end;
if ~isfield(EDF,'EDF')
        EDF.EDF.SampleRate = repmat(EDF.SampleRate,EDF.NS,1);
elseif ~isfield(EDF.EDF,'SampleRate')
        EDF.EDF.SampleRate = repmat(EDF.SampleRate,EDF.NS,1);
end;

if ~EDF.NS,
elseif ~isnan(EDF.Dur) & any(isnan(EDF.SPR)) & ~any(isnan(EDF.EDF.SampleRate))
	EDF.SPR = EDF.EDF.SampleRate * EDF.Dur;
elseif ~isnan(EDF.Dur) & ~any(isnan(EDF.SPR)) & any(isnan(EDF.EDF.SampleRate))
	EDF.SampleRate = EDF.Dur * EDF.SPR;
elseif isnan(EDF.Dur) & ~any(isnan(EDF.SPR)) & ~any(isnan(EDF.EDF.SampleRate))
	EDF.Dur = EDF.SPR ./ EDF.SampleRate;
	if all(EDF.Dur(1)==EDF.Dur)
		EDF.Dur = EDF.Dur(1);
	else
		fprintf(EDF.FILE.stderr,'Warning SDFOPEN: SPR and SampleRate do not fit\n');
		[EDF.SPR,EDF.SampleRate,EDF.Dur]
	end;
elseif ~isnan(EDF.Dur) & ~any(isnan(EDF.SPR)) & ~any(isnan(EDF.EDF.SampleRate))
        %% thats ok, 
else
        EDF.ErrNo = EDF.ErrNo + 128;
	fprintf(EDF.FILE.stderr,'ERROR SDFOPEN: more than 1 of EDF.Dur, EDF.SampleRate, EDF.SPR undefined.\n');
	return; 
end;


% Check all fields of Header2
if ~isfield(EDF,'Label')
        EDF.Label=setstr(32+zeros(EDF.NS,16));
        if EDF.NS>0,
                fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.Label not defined\n');
        end;
else
        tmp=min(16,size(EDF.Label,2));
        EDF.Label = [EDF.Label(1:EDF.NS,1:tmp), char(32+zeros(EDF.NS,16-tmp))];
end;
if ~isfield(EDF,'Transducer')
        EDF.Transducer=setstr(32+zeros(EDF.NS,80));
else
        tmp=min(80,size(EDF.Transducer,2));
        EDF.Transducer=[EDF.Transducer(1:EDF.NS,1:tmp), setstr(32+zeros(EDF.NS,80-tmp))];
end;
if ~isfield(EDF,'PreFilt')
        EDF.PreFilt = setstr(32+zeros(EDF.NS,80));
        if isfield(EDF,'Filter'),
        if isfield(EDF.Filter,'LowPass') & isfield(EDF.Filter,'HighPass') & isfield(EDF.Filter,'Notch'),
                if any(length(EDF.Filter.LowPass) == [1,EDF.NS]) & any(length(EDF.Filter.HighPass) == [1,EDF.NS]) & any(length(EDF.Filter.Notch) == [1,EDF.NS])
                        for k = 1:EDF.NS,
                                k1 = min(k,length(EDF.Filter.LowPass));
                                k2 = min(k,length(EDF.Filter.HighPass));
                                k3 = min(k,length(EDF.Filter.Notch));
                                PreFilt{k,1} = sprintf('LP: %5.f Hz; HP: %5.2f Hz; Notch: %i',EDF.Filter.LowPass(k1),EDF.Filter.HighPass(k2),EDF.Filter.Notch(k3));
                        end;
                        EDF.PreFilt = strvcat(PreFilt);
                end;
        end
        end
end;
tmp = min(80,size(EDF.PreFilt,2));
EDF.PreFilt = [EDF.PreFilt(1:EDF.NS,1:tmp), setstr(32+zeros(EDF.NS,80-tmp))];

if ~isfield(EDF,'PhysDim')
        EDF.PhysDim=setstr(32+zeros(EDF.NS,8));
        if EDF.NS>0,
                fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.PhysDim not defined\n');
        end;
else
        tmp=min(8,size(EDF.PhysDim,2));
        EDF.PhysDim=[EDF.PhysDim(1:EDF.NS,1:tmp), setstr(32+zeros(EDF.NS,8-tmp))];
end;

if ~isfield(EDF,'PhysMin')
        if EDF.NS>0,
                fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.PhysMin not defined\n');
        end
        EDF.PhysMin=repmat(nan,EDF.NS,1);
else
        EDF.PhysMin=EDF.PhysMin(1:EDF.NS);
end;
if ~isfield(EDF,'PhysMax')
        if EDF.NS>0,
                fprintf('Warning SDFOPEN-W: EDF.PhysMax not defined\n');
        end;
        EDF.PhysMax=repmat(nan,EDF.NS,1);
else
        EDF.PhysMax=EDF.PhysMax(1:EDF.NS);
end;
if ~isfield(EDF,'DigMin')
        if EDF.NS>0,
                fprintf(EDF.FILE.stderr,'Warning SDFOPEN-W: EDF.DigMin not defined\n');
        end
        EDF.DigMin=repmat(nan,EDF.NS,1);
else
        EDF.DigMin=EDF.DigMin(1:EDF.NS);
end;
if ~isfield(EDF,'DigMax')
        if EDF.NS>0,
                fprintf('Warning SDFOPEN-W: EDF.DigMax not defined\n');
        end;
        EDF.DigMax=repmat(nan,EDF.NS,1);
else
        EDF.DigMax=EDF.DigMax(1:EDF.NS);
end;
if ~isfield(EDF,'SPR')
        if EDF.NS>0,
                fprintf('Warning SDFOPEN-W: EDF.SPR not defined\n');
        end;
        EDF.SPR = repmat(nan,EDF.NS,1);
        EDF.ERROR = sprintf('Error SDFOPEN-W: EDF.SPR not defined\n');
        EDF.ErrNo = EDF.ErrNo + 128;
        %fclose(EDF.FILE.FID); return;
else
        EDF.SPR=reshape(EDF.SPR(1:EDF.NS),EDF.NS,1);
end;
EDF.AS.MAXSPR = 1;
for k=1:EDF.NS,
        EDF.AS.MAXSPR = lcm(EDF.AS.MAXSPR,EDF.SPR(k));
end;

if (abs(EDF.VERSION(1))==255)  & strcmp(EDF.VERSION(2:8),'BIOSEMI'),
        EDF.GDFTYP=255+24+zeros(1,EDF.NS);

elseif strcmp(EDF.VERSION,'0       '),
        EDF.GDFTYP=3+zeros(1,EDF.NS);

elseif strcmp(EDF.VERSION(1:3),'GDF'),
	if EDF.NS == 0;
		EDF.GDFTYP = [];
	elseif ~isfield(EDF,'GDFTYP'),
	        EDF.ERROR = sprintf('Warning SDFOPEN-W: EDF.GDFTYP not defined\n');
                EDF.ErrNo = EDF.ErrNo + 128;
                % fclose(EDF.FILE.FID); return;
        else
                EDF.GDFTYP= EDF.GDFTYP(1:EDF.NS);
        end;
else
	fprintf(EDF.FILE.stderr,'Error SDFOPEN: invalid VERSION %s\n ',EDF.VERSION);
	return;
end;

%%%%%% generate Header 1, first 256 bytes 
EDF.HeadLen=(EDF.NS+1)*256;
H1=setstr(32*ones(1,256));
H1(1:8)=EDF.VERSION; %sprintf('%08i',EDF.VERSION);     % 8 Byte  Versionsnummer 
H1( 8+(1:length(EDF.PID)))=EDF.PID;       
H1(88+(1:length(EDF.RID)))=EDF.RID;
%H1(185:192)=sprintf('%-8i',EDF.HeadLen);

%%%%% Open File 
if ~any(arg2=='+') 
        [fid,MESSAGE]=fopen(FILENAME,'w+b','ieee-le');          
else  % (arg2=='w+')  % may be called only by SDFCLOSE
        if EDF.FILE.OPEN==2 
                [fid,MESSAGE]=fopen(FILENAME,'r+b','ieee-le');          
        else
                fprintf(EDF.FILE.stderr,'Error SDFOPEN-W+: Cannot open %s for write access\n',FILENAME);
                return;
        end;
end;
if fid<0 
        %fprintf(EDF.FILE.stderr,'Error EDFOPEN: %s\n',MESSAGE);  
        H1=MESSAGE;H2=[];
        EDF.ErrNo = EDF.ErrNo + 32;
        fprintf(EDF.FILE.stderr,'Error SDFOPEN-W: Could not open %s \n',FILENAME);
        return;
end;
EDF.FILE.FID = fid;
EDF.FILE.OPEN = 2;

if strcmp(EDF.VERSION(1:3),'GDF'),
        H1(168+(1:16))=sprintf('%04i%02i%02i%02i%02i%02i%02i',floor(EDF.T0),floor(100*rem(EDF.T0(6),1)));
        c=fwrite(fid,abs(H1(1:184)),'uchar');
        %c=fwrite(fid,EDF.HeadLen,'int64');
        c=fwrite(fid,[EDF.HeadLen,0],'int32');
        c=fwrite(fid,ones(8,1)*32,'uint8'); % EP_ID=ones(8,1)*32;
        c=fwrite(fid,ones(8,1)*32,'uint8'); % Lab_ID=ones(8,1)*32;
        c=fwrite(fid,ones(8,1)*32,'uint8'); % T_ID=ones(8,1)*32;
        c=fwrite(fid,ones(20,1)*32,'uint8'); % 
        %c=fwrite(fid,EDF.NRec,'int64');
        c=fwrite(fid,[EDF.NRec,0],'int32');
        %fwrite(fid,EDF.Dur,'float64');
        [n,d]=rat(EDF.Dur); fwrite(fid,[n d], 'uint32');
	c=fwrite(fid,EDF.NS,'uint32');
else
        H1(168+(1:16))=sprintf('%02i.%02i.%02i%02i:%02i:%02i',floor(rem(EDF.T0([3 2 1 4 5 6]),100)));
        H1(185:192)=sprintf('%-8i',EDF.HeadLen);
        H1(193:236)=EDF.reserved1;
        H1(237:244)=sprintf('%-8i',EDF.NRec);
        H1(245:252)=sprintf('%-8i',EDF.Dur);
        H1(253:256)=sprintf('%-4i',EDF.NS);
        H1(abs(H1)==0)=char(32); 
        c=fwrite(fid,abs(H1),'uchar');
end;

%%%%%% generate Header 2,  NS*256 bytes 
if ~strcmp(EDF.VERSION(1:3),'GDF');
        sPhysMax=setstr(32+zeros(EDF.NS,8));
        for k=1:EDF.NS,
                tmp=sprintf('%-8g',EDF.PhysMin(k));
                lt=length(tmp);
                if lt<9
                        sPhysMin(k,1:lt)=tmp;
                else
                        if any(upper(tmp)=='E') | find(tmp=='.')>8,
                                fprintf(EDF.FILE.stderr,'Error SDFOPEN-W: PhysMin(%i) does not fit into header\n', k);
                        else
                                sPhysMin(k,:)=tmp(1:8);
                        end;
                end;
                tmp=sprintf('%-8g',EDF.PhysMax(k));
                lt=length(tmp);
                if lt<9
                        sPhysMax(k,1:lt)=tmp;
                else
                        if any(upper(tmp)=='E') | find(tmp=='.')>8,
                                fprintf(EDF.FILE.stderr,'Error SDFOPEN-W: PhysMin(%i) does not fit into header\n', k);
                        else
                                sPhysMax(k,:)=tmp(1:8);
                        end;
                end;
        end;
        sPhysMin=reshape(sprintf('%-8.1f',EDF.PhysMin)',8,EDF.NS)';
        sPhysMax=reshape(sprintf('%-8.1f',EDF.PhysMax)',8,EDF.NS)';
        
        idx1=cumsum([0 H2idx]);
        idx2=EDF.NS*idx1;
        h2=setstr(32*ones(EDF.NS,256));
        size(h2);
        h2(:,idx1(1)+1:idx1(2))=EDF.Label;
        h2(:,idx1(2)+1:idx1(3))=EDF.Transducer;
        h2(:,idx1(3)+1:idx1(4))=EDF.PhysDim;
        %h2(:,idx1(4)+1:idx1(5))=sPhysMin;
        %h2(:,idx1(5)+1:idx1(6))=sPhysMax;
        h2(:,idx1(4)+1:idx1(5))=sPhysMin;
        h2(:,idx1(5)+1:idx1(6))=sPhysMax;
        h2(:,idx1(6)+1:idx1(7))=reshape(sprintf('%-8i',EDF.DigMin)',8,EDF.NS)';
        h2(:,idx1(7)+1:idx1(8))=reshape(sprintf('%-8i',EDF.DigMax)',8,EDF.NS)';
        h2(:,idx1(8)+1:idx1(9))=EDF.PreFilt;
        h2(:,idx1(9)+1:idx1(10))=reshape(sprintf('%-8i',EDF.SPR)',8,EDF.NS)';
        h2(abs(h2)==0)=char(32);
        for k=1:length(H2idx);
                fwrite(fid,abs(h2(:,idx1(k)+1:idx1(k+1)))','uchar');
        end;
else
        fwrite(fid, abs(EDF.Label)','uchar');
        fwrite(fid, abs(EDF.Transducer)','uchar');
        fwrite(fid, abs(EDF.PhysDim)','uchar');
        fwrite(fid, EDF.PhysMin,'float64');
        fwrite(fid, EDF.PhysMax,'float64');
	if exist('OCTAVE_VERSION')>4,  % Octave does not support INT64 yet. 
        	fwrite(fid, [EDF.DigMin,-(EDF.DigMin<0)]','int32');
	        fwrite(fid, [EDF.DigMax,-(EDF.DigMax<0)]','int32');
        else
		fwrite(fid, EDF.DigMin, 'int64');
	        fwrite(fid, EDF.DigMax, 'int64');
	end;

        fwrite(fid, abs(EDF.PreFilt)','uchar');
        fwrite(fid, EDF.SPR,'uint32');
        fwrite(fid, EDF.GDFTYP,'uint32');
        fprintf(fid,'%c',32*ones(32,EDF.NS));
end;

tmp = ftell(EDF.FILE.FID);
if tmp ~= (256 * (EDF.NS+1)) 
        fprintf(1,'Warning SDFOPEN-WRITE: incorrect header length %i bytes\n',tmp);
%else   fprintf(1,'sdfopen in write mode: header info stored correctly\n');
end;        

EDF.AS.spb = sum(EDF.SPR);	% Samples per Block
EDF.AS.bi  = [0;cumsum(EDF.SPR)];
EDF.AS.BPR = ceil(EDF.SPR(:).*GDFTYP_BYTE(EDF.GDFTYP(:)+1)');
EDF.AS.SAMECHANTYP = all(EDF.AS.BPR == (EDF.SPR(:).*GDFTYP_BYTE(EDF.GDFTYP(:)+1)')) & ~any(diff(EDF.GDFTYP));
%EDF.AS.GDFbi= [0;cumsum(EDF.AS.BPR)];
EDF.AS.GDFbi = [0;cumsum(ceil(EDF.SPR(:).*GDFTYP_BYTE(EDF.GDFTYP(:)+1)'))];
EDF.AS.bpb   = sum(ceil(EDF.SPR(:).*GDFTYP_BYTE(EDF.GDFTYP(:)+1)'));	% Bytes per Block
EDF.AS.startrec = 0;
EDF.AS.numrec = 0;
EDF.FILE.POS  = 0;

else % if arg2 is not 'r' or 'w'
        fprintf(EDF.FILE.stderr,'Warning SDFOPEN: Incorrect 2nd argument. \n');
end;        

if EDF.ErrNo>0
        fprintf(EDF.FILE.stderr,'ERROR %i SDFOPEN\n',EDF.ErrNo);
end;

%---------------------------------------------------------------------------%

function [HDR] = sclose(HDR)
% SCLOSE closes the file with the handle HDR
% [HDR] = sclose(HDR)
%    HDR.FILE.status = -1 if file could not be closed.
%    HDR.FILE.status = 0 indicates the file has been closed.
%
% see also: SOPEN, SREAD, SSEEK, STELL, SCLOSE, SWRITE

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

%	$Revision: 1.14 $
%	$Id: sclose.m,v 1.14 2004/12/06 08:37:48 schloegl Exp $
%	(C) 1997-2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/


if (HDR.FILE.FID<0) | ~HDR.FILE.OPEN, 
        HDR.FILE.status = -1;
        %fprintf(HDR.FILE.stderr,'Warning SCLOSE (%s): invalid handle\n',HDR.FileName);
end;

if HDR.FILE.OPEN >= 2,          % write-open of files 
	% check file length - simple test for file integrity         
        EndPos = ftell(HDR.FILE.FID);          % get file length
        % force file pointer to the end, otherwise Matlab 6.5 R13 on PCWIN
        status = fseek(HDR.FILE.FID, 0, 'eof'); % go to end-of-file
        
	if strcmp(HDR.TYPE,'EDF') | strcmp(HDR.TYPE,'BDF') | strcmp(HDR.TYPE,'GDF'),
         	tmp = floor((EndPos - HDR.HeadLen) / HDR.AS.bpb);  % calculate number of records
        	if ~isnan(tmp)
                        % commented out by SMM 9/2006
        	        % HDR.NRec=tmp;   
			fseek(HDR.FILE.FID,236,'bof');
			if strcmp(HDR.TYPE,'GDF')
			        c=fwrite(HDR.FILE.FID,[HDR.NRec,0],'int32');
			else	
			        fprintf(HDR.FILE.FID,'%-8i',HDR.NRec);
			end;
		end;
                if strcmp(HDR.TYPE,'GDF')
                        if isfield(HDR,'EVENT'),
                                if length(HDR.EVENT.POS)~=length(HDR.EVENT.TYP),
                                        fprintf(HDR.FILE.stderr,'Warning SCLOSE-GDF: cannot write Event table, its broken\n');
                                else
                                        HDR.AS.EVENTTABLEPOS = HDR.HeadLen+HDR.AS.bpb*HDR.NRec;
                                        %fseek(HDR.FILE.FID,HDR.HeadLen+HDR.AS.bpb*HDR.NRec,'bof');
                                        status = fseek(HDR.FILE.FID,0,'eof');
                                        if ftell(HDR.FILE.FID)~=HDR.AS.EVENTTABLEPOS,
                                                fprintf(HDR.FILE.stderr,'Warning SCLOSE-GDF: inconsistent GDF file\n');
                                        end
                                        EVENT.Version = 1;
                                        if isfield(HDR.EVENT,'CHN') & isfield(HDR.EVENT,'DUR'), 
                                                if any(HDR.EVENT.CHN) | any(HDR.EVENT.DUR),
                                                        EVENT.Version = 3;
                                                end;
                                        end;
					if ~isfield(HDR.EVENT,'SampleRate'), HDR.EVENT.SampleRate = HDR.SampleRate; end;
					tmp = HDR.EVENT.SampleRate;
					tmp = [EVENT.Version,mod(tmp,256),floor(mod(tmp,65536))/256,floor(tmp/65536)];
                                        fwrite(HDR.FILE.FID,tmp,'uint8');  % Type of eventtable
                                        fwrite(HDR.FILE.FID,length(HDR.EVENT.POS),'uint32');
                                        if EVENT.Version==1;
                                                c1 = fwrite(HDR.FILE.FID,HDR.EVENT.POS,'uint32');
                                                c2 = fwrite(HDR.FILE.FID,HDR.EVENT.TYP,'uint16');
                                                c3 = length(HDR.EVENT.POS); c4 = c3; 
                                        elseif EVENT.Version==3;
                                                c1 = fwrite(HDR.FILE.FID,HDR.EVENT.POS,'uint32');
                                                c2 = fwrite(HDR.FILE.FID,HDR.EVENT.TYP,'uint16');
                                                c3 = fwrite(HDR.FILE.FID,HDR.EVENT.CHN,'uint16');
                                                c4 = fwrite(HDR.FILE.FID,HDR.EVENT.DUR,'uint32');
                                        end;
                                        if any([c1,c2,c3,c4]~=length(HDR.EVENT.POS))
                                                fprintf(2,'\nError SCLOSE: writing of EVENTTABLE failed. File %s not closed.\n', HDR.FileName);
                                                return;
                                        end
                                end
                        end;
                end;
        end;
end;

if strcmp(HDR.TYPE,'FIF') & HDR.FILE.OPEN;
        global FLAG_NUMBER_OF_OPEN_FIF_FILES
        rawdata('close');
        HDR.FILE.OPEN = 0;
        HDR.FILE.status = 0;
        FLAG_NUMBER_OF_OPEN_FIF_FILES = FLAG_NUMBER_OF_OPEN_FIF_FILES-1; 
        
elseif strmatch(HDR.TYPE,{'ADI','GTEC','LABVIEW','MAT','MAT4','MAT5','XML','XML-FDA','SierraECG'}),
        HDR.FILE.OPEN = 0;
        
elseif HDR.FILE.OPEN,
        HDR.FILE.OPEN = 0;
        HDR.FILE.status = fclose(HDR.FILE.FID);
end;
       
%--------------------------------------------------------------------------------------------%

function [num,status,strarray] = str2double(s,cdelim,rdelim,ddelim)
%% STR2DOUBLE converts strings into numeric values
%%  [NUM, STATUS,STRARRAY] = STR2DOUBLE(STR) 
%%  
%%  STR2DOUBLE can replace STR2NUM, but avoids the insecure use of EVAL 
%%  on unknown data [1]. 
%%
%%    STR can be the form '[+-]d[.]dd[[eE][+-]ddd]' 
%%	d can be any of digit from 0 to 9, [] indicate optional elements
%%    NUM is the corresponding numeric value. 
%%       if the conversion fails, status is -1 and NUM is NaN.  
%%    STATUS = 0: conversion was successful
%%    STATUS = -1: couldnot convert string into numeric value
%%    STRARRAY is a cell array of strings. 
%%
%%    Elements which are not defined or not valid return NaN and 
%%        the STATUS becomes -1 
%%    STR can be also a character array or a cell array of strings.   
%%        Then, NUM and STATUS return matrices of appropriate size. 
%%
%%    STR can also contain multiple elements.
%%    default row-delimiters are: 
%%        NEWLINE, CARRIAGE RETURN and SEMICOLON i.e. ASCII 10, 13 and 59. 
%%    default column-delimiters are: 
%%        TAB, SPACE and COMMA i.e. ASCII 9, 32, and 44.
%%    default decimal delimiter is '.' char(46), sometimes (e.g in 
%%	Tab-delimited text files generated by Excel export in Europe)  
%%	might used ',' as decimal delimiter.
%%
%%  [NUM, STATUS] = STR2DOUBLE(STR,CDELIM,RDELIM,DDELIM) 
%%       CDELIM .. [OPTIONAL] user-specified column delimiter
%%       RDELIM .. [OPTIONAL] user-specified row delimiter
%%       DDELIM .. [OPTIONAL] user-specified decimal delimiter
%%       CDELIM, RDELIM and DDELIM must contain only 
%%       NULL, NEWLINE, CARRIAGE RETURN, SEMICOLON, COLON, SLASH, TAB, SPACE, COMMA, or ()[]{}  
%%       i.e. ASCII 0,9,10,11,12,13,14,32,33,34,40,41,44,47,58,59,91,93,123,124,125 
%%
%%    Examples: 
%%	str2double('-.1e-5')
%%	   ans = -1.0000e-006
%%
%% 	str2double('.314e1, 44.44e-1, .7; -1e+1')
%%	ans =
%%	    3.1400    4.4440    0.7000
%%	  -10.0000       NaN       NaN
%%
%%	line ='200,300,400,NaN,-inf,cd,yes,no,999,maybe,NaN';
%%	[x,status]=str2double(line)
%%	x =
%%	   200   300   400   NaN  -Inf   NaN   NaN   NaN   999   NaN   NaN
%%	status =
%%	    0     0     0     0     0    -1    -1    -1     0    -1     0
%%
%% Reference(s): 
%% [1] David A. Wheeler, Secure Programming for Linux and Unix HOWTO.
%%    http://en.tldp.org/HOWTO/Secure-Programs-HOWTO/

%% This program is free software; you can redistribute it and/or
%% modify it under the terms of the GNU General Public License
%% as published by the Free Software Foundation; either version 2
%% of the License, or (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program; if not, write to the Free Software
%% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

%%	$Revision: 1.12 $
%%	$Id: str2double.m,v 1.12 2004/09/01 13:49:18 schloegl Exp $
%%	Copyright (C) 2004 by Alois Schloegl <a.schloegl@ieee.org>	
%%      This function is part of Octave-Forge http://octave.sourceforge.net/

FLAG_OCTAVE = exist('OCTAVE_VERSION','builtin');

% valid_char = '0123456789eE+-.nNaAiIfF';	% digits, sign, exponent,NaN,Inf
valid_delim = char(sort([0,9:14,32:34,abs('()[]{},;:"|/')]));	% valid delimiter
if nargin < 1,
        error('missing input argument.')
end;
if nargin < 2,
        cdelim = char([9,32,abs(',')]);		% column delimiter
else
        % make unique cdelim
        cdelim = char(sort(cdelim(:)));
        tmp = [1;1+find(diff(abs(cdelim))>0)];
        cdelim = cdelim(tmp)';
end;
if nargin < 3,
        rdelim = char([0,10,13,abs(';')]);	% row delimiter
else
        % make unique rdelim
        rdelim = char(sort(rdelim(:)));
        tmp = [1;1+find(diff(abs(rdelim))>0)];
        rdelim = rdelim(tmp)';
end;
if nargin<4,
        ddelim = '.';
elseif length(ddelim)~=1,
        error('decimal delimiter must be exactly one character.');
end;

% check if RDELIM and CDELIM are distinct
delim = sort(abs([cdelim,rdelim,ddelim]));
tmp   = [1, 1 + find(diff(delim)>0)];
delim = delim(tmp);
%[length(delim),length(cdelim),length(rdelim)]
if length(delim) < (length(cdelim)+length(rdelim))+1, % length(ddelim) must be one.
        error('row, column and decimal delimiter are not distinct.');
end;

% check if delimiters are valid
tmp  = sort(abs([cdelim,rdelim]));
flag = zeros(size(tmp));
k1 = 1;
k2 = 1;
while (k1 <= length(tmp)) & (k2 <= length(valid_delim)),
        if tmp(k1) == valid_delim(k2),            
                flag(k1) = 1; 
                k1 = k1 + 1;
        elseif tmp(k1) < valid_delim(k2),            
                k1 = k1 + 1;
        elseif tmp(k1) > valid_delim(k2),            
                k2 = k2 + 1;
        end;
end;
if ~all(flag),
        error('Invalid delimiters!');
end;

%%%%% various input parameters 
if isnumeric(s) 
	if all(s<256) & all(s>=0)
    	        s = char(s);
	else
		error('STR2DOUBLE: input variable must be a string')
	end;
end;

if isempty(s),
        num = [];
        status = 0;
        return;

elseif iscell(s),
        strarray = s;

elseif ischar(s) & all(size(s)>1),	%% char array transformed into a string. 
	for k = 1:size(s,1), 
                tmp = find(~isspace(s(k,:)));
                strarray{k,1} = s(k,min(tmp):max(tmp));
        end;

elseif ischar(s),
        num = [];
        status = 0;
        strarray = {};

        s(end+1) = rdelim(1);     % add stop sign; makes sure last digit is not skipped

	RD = zeros(size(s));
	for k = 1:length(rdelim),
		RD = RD | (s==rdelim(k));
	end;
	CD = RD;
	for k = 1:length(cdelim),
		CD = CD | (s==cdelim(k));
	end;
        
        k1 = 1; % current row
        k2 = 0; % current column
        k3 = 0; % current element
        
        sl = length(s);
        ix = 1;
        %while (ix < sl) & any(abs(s(ix))==[rdelim,cdelim]),
        while (ix < sl) & CD(ix), 
                ix = ix + 1;
        end;
        ta = ix; te = [];
        while ix <= sl;
                if (ix == sl),
                        te = sl;
                end;
                %if any(abs(s(ix))==[cdelim(1),rdelim(1)]),
                if CD(ix), 
                        te = ix - 1;
                end;
                if ~isempty(te),
                        k2 = k2 + 1;
                        k3 = k3 + 1;
                        strarray{k1,k2} = s(ta:te);
                        %strarray{k1,k2} = [ta,te];
                        
                        flag = 0;
                        %while any(abs(s(ix))==[cdelim(1),rdelim(1)]) & (ix < sl),
                        while CD(ix) & (ix < sl),
                                flag = flag | RD(ix);
                                ix = ix + 1;
                        end;
                        
                        if flag, 
                                k2 = 0;
                                k1 = k1 + 1;
                        end;
                        ta = ix;
                        te = [];
	        end;
                ix = ix + 1;
        end;
else
        error('STR2DOUBLE: invalid input argument');
end;

[nr,nc]= size(strarray);
status = zeros(nr,nc);
num    = repmat(NaN,nr,nc);

for k1 = 1:nr,
for k2 = 1:nc,
        t = strarray{k1,k2};
        if (length(t)==0),
		status(k1,k2) = -1;		%% return error code
                num(k1,k2) = NaN;
        else 
                %% get mantisse
                g = 0;
                v = 1;
                if t(1)=='-',
                        v = -1; 
                        l = min(2,length(t));
                elseif t(1)=='+',
                        l = min(2,length(t));
                else
                        l = 1;
                end;

                if strcmpi(t(l:end),'inf')
                        num(k1,k2) = v*inf;
                        
                elseif strcmpi(t(l:end),'NaN');
                        num(k1,k2) = NaN;
                        
                else
			if ddelim=='.',
				t(t==ddelim)='.';
			end;	
			if FLAG_OCTAVE,
	    			[v,tmp2,c] = sscanf(char(t),'%f %s','C');
	    		else
				[v,c,em,ni] = sscanf(char(t),'%f %s');
				c = c * (ni>length(t));
			end;
			if (c==1),
	            		num(k1,k2) = v;
			else
	            		num(k1,k2) = NaN;
	            		status(k1,k2) = -1;
			end			
		end
	end;
end;
end;        

%---------------------------------------------------------------------------------%

function [HDR] = getfiletype(arg1)
% GETFILETYPE get file type 
%
% HDR = getfiletype(Filename);
% HDR = getfiletype(HDR.FileName);
%
% HDR is the Header struct and contains stuff used by SOPEN. 
% HDR.TYPE identifies the type of the file [1,2]. 
%
% see also: SOPEN 
%
% Reference(s): 
%   [1] http://www.dpmi.tu-graz.ac.at/~schloegl/matlab/eeg/
%   [2] http://www.dpmi.tu-graz.ac.at/~schloegl/biosig/TESTED 


% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

%	$Revision: 1.22 $
%	$Id: getfiletype.m,v 1.22 2004/12/28 20:35:12 schloegl Exp $
%	(C) 2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/

if ischar(arg1),
        HDR.FileName = arg1;
elseif isfield(arg1,'name')
        HDR.FileName = arg1.name;
	HDR.FILE = arg1; 
elseif isfield(arg1,'FileName')
        HDR = arg1;
end;

HDR.TYPE = 'unknown';
HDR.FILE.OPEN = 0;
HDR.FILE.FID  = -1;
HDR.ERROR.status  = 0; 
HDR.ERROR.message = ''; 
if ~isfield(HDR.FILE,'stderr'),
        HDR.FILE.stderr = 2;
end;
if ~isfield(HDR.FILE,'stdout'),
        HDR.FILE.stdout = 1;
end;	

if exist(HDR.FileName,'dir') 
        [pfad,file,FileExt] = fileparts(HDR.FileName);
        HDR.FILE.Name = file; 
        HDR.FILE.Path = pfad; 
	HDR.FILE.Ext  = FileExt(2:end); 
	if strcmpi(FileExt,'.ds'), % .. & isdir(HDR.FileName)
	        f1 = fullfile(HDR.FileName,[file,'.meg4']);
	        f2 = fullfile(HDR.FileName,[file,'.res4']);
	        if (exist(f1,'file') & exist(f2,'file')), % & (exist(f3)==2)
            		HDR.FileName  = f1; 
			% HDR.TYPE = 'MEG4'; % will be checked below 
	        end;
	else
    		HDR.TYPE = 'DIR'; 
    		return; 
	end;
end;

fid = fopen(HDR.FileName,'rb','ieee-le');
if fid < 0,
	HDR.ERROR.status = -1; 
        HDR.ERROR.message = sprintf('Error GETFILETYPE: file %s not found.\n',HDR.FileName);
        return;
else
        [pfad,file,FileExt] = fileparts(HDR.FileName);
        if ~isempty(pfad),
                HDR.FILE.Path = pfad;
        else
                HDR.FILE.Path = pwd;
        end;
        HDR.FILE.Name = file;
        HDR.FILE.Ext  = char(FileExt(2:length(FileExt)));

	fseek(fid,0,'eof');
	HDR.FILE.size = ftell(fid);
	fseek(fid,0,'bof');

        [s,c] = fread(fid,132,'uchar');
        if (c == 0),
                s = repmat(0,1,132-c);
        elseif (c < 132),
                s = [s', repmat(0,1,132-c)];
        else
                s = s';
        end;

        if c,
                %%%% file type check based on magic numbers %%%
                type_mat4 = str2double(char(abs(sprintf('%04i',s(1:4)*[1;10;100;1000]))'));
                ss = char(s);
                if 0,
                elseif all(s(1:2)==[207,0]);
                        HDR.TYPE='BKR';
                elseif strncmp(ss,'Version 3.0',11); 
                        HDR.TYPE='CNT';
                elseif strncmp(ss,'Brain Vision Data Exchange Header File',38); 
                        HDR.TYPE = 'BrainVision';
                elseif strncmp(ss,'0       ',8); 
                        HDR.TYPE='EDF';
                elseif all(s(1:8)==[255,abs('BIOSEMI')]); 
                        HDR.TYPE='BDF';
                        
                elseif strncmp(ss,'GDF',3); 
                        HDR.TYPE='GDF';
                elseif strncmp(ss,'EBS',3); 
                        HDR.TYPE='EBS';
                elseif strncmp(ss,'CEN',3) & all(s(6:8)==hex2dec(['1A';'04';'84'])') & (all(s(4:5)==hex2dec(['13';'10'])') | all(s(4:5)==hex2dec(['0D';'0A'])')); 
                        HDR.TYPE='FEF';
                        HDR.VERSION   = str2double(ss(9:16))/100;
                        HDR.Encoding  = str2double(ss(17:24));
                        if any(str2double(ss(25:32))),
                                HDR.Endianity = 'ieee-be';
                        else
                                HDR.Endianity = 'ieee-le';
                        end;
                        if any(s(4:5)~=[13,10])
                                fprintf(2,'Warning GETFILETYPE (FEF): incorrect preamble in file %s\n',HDR.FileName);
                        end;
                        
                elseif strncmp(ss,'MEG41CP',7); 
                        HDR.TYPE='CTF';
                elseif strncmp(ss,'MEG41RS',7) | strncmp(ss,'MEG4RES',7); 
                        HDR.TYPE='CTF';
                elseif strncmp(ss,'MEG4',4); 
                        HDR.TYPE='CTF';
                elseif strncmp(ss,'CTF_MRI_FORMAT VER 2.2',22); 
                        HDR.TYPE='CTF';
                elseif 0, strncmp(ss,'PATH OF DATASET:',16); 
                        HDR.TYPE='CTF';
                        
                elseif strcmp(ss(1:8),'@  MFER '); 
                        HDR.TYPE='MFER';
                elseif strcmp(ss(1:6),'@ MFR '); 
                        HDR.TYPE='MFER';
                elseif all(s(17:22)==abs('SCPECG')); 
                        HDR.TYPE='SCP';
                elseif strncmp(ss,'ATES MEDICA SOFT. EEG for Windows',32);	% ATES MEDICA SOFTWARE, NeuroTravel 
                        HDR.TYPE='ATES';
                        HDR.Version = ss(35:42);
                elseif strncmp(ss,'POLY_SAM',8);	% Poly5/TMS32 sample file format.
                        HDR.TYPE='TMS32';
                elseif strncmp(ss,'"Snap-Master Data File"',23);	% Snap-Master Data File .
                        HDR.TYPE='SMA';
                elseif all(s([1:2,20])==[1,0,0]) & any(s(19)==[2,4]); 
                        HDR.TYPE='TEAM';	% Nicolet TEAM file format
                elseif strncmp(ss,HDR.FILE.Name,length(HDR.FILE.Name)); 
                        HDR.TYPE='MIT';
                elseif strncmp(ss,'DEMG',4);	% www.Delsys.com
                        HDR.TYPE='DEMG';
                        
                elseif strncmp(ss,'NEX1',4); 
                        HDR.TYPE='NEX';
                elseif strcmp(ss([1:4]),'fLaC'); 
                        HDR.TYPE='FLAC';
                elseif strcmp(ss([1:4]),'OggS'); 
                        HDR.TYPE='OGG';
                elseif strcmp(ss([1:4]),'.RMF'); 
                        HDR.TYPE='RMF';

                elseif strncmp(ss,'AON4',4); 
                        HDR.TYPE='AON4';
                elseif all(s(3:7)==abs('-lh5-')); 
                        HDR.TYPE='LHA';
                elseif strncmp(ss,'PSID',4); 
                        HDR.TYPE='SID';
			HDR.Title = ss(23:54);    
			HDR.Author = ss(55:86);    
			HDR.Copyright = ss(87:118);    

                elseif strncmp(ss,'.snd',4); 
                        HDR.TYPE='SND';
                        HDR.Endianity = 'ieee-be';
                elseif strncmp(ss,'dns.',4); 
                        HDR.TYPE='SND';
                        HDR.Endianity = 'ieee-le';
                elseif strcmp(ss([1:4,9:12]),'RIFFWAVE'); 
                        HDR.TYPE='WAV';
                        HDR.Endianity = 'ieee-le';
                elseif strcmp(ss([1:4,9:11]),'FORMAIF'); 
                        HDR.TYPE='AIF';
                        HDR.Endianity = 'ieee-be';
                elseif strcmp(ss([1:4,9:12]),'RIFFAVI '); 
                        HDR.TYPE='AVI';
                        HDR.Endianity = 'ieee-le';
                elseif all(s([1:4,9:21])==[abs('RIFFRMIDMThd'),0,0,0,6,0]); 
                        HDR.TYPE='RMID';
                        HDR.Endianity = 'ieee-be';
                elseif all(s(1:9)==[abs('MThd'),0,0,0,6,0]) & any(s(10)==[0:2]); 
                        HDR.TYPE='MIDI';
			HDR.Endianity = 'ieee-be';
                elseif ~isempty(findstr(ss(1:16),'8SVXVHDR')); 
                        HDR.TYPE='8SVX';
                elseif strcmp(ss([1:4,9:12]),'RIFFILBM'); 
                        HDR.TYPE='ILBM';
                elseif strcmp(ss([1:4]),'2BIT'); 
                        HDR.TYPE='AVR';
                elseif all(s([1:4])==[26,106,0,0]); 
                        HDR.TYPE='ESPS';
                        HDR.Endianity = 'ieee-le';
                elseif all(s([1:4])==[0,0,106,26]); 
                        HDR.TYPE='ESPS';
                        HDR.Endianity = 'ieee-le';
                elseif strcmp(ss([1:15]),'IMA_ADPCM_Sound'); 
                        HDR.TYPE='IMA ADPCM';
                elseif all(s([1:8])==[abs('NIST_1A'),0]); 
                        HDR.TYPE='NIST';
                elseif all(s([1:7])==[abs('SOUND'),0,13]); 
                        HDR.TYPE='SNDT';
                elseif strcmp(ss([1:18]),'SOUND SAMPLE DATA '); 
                        HDR.TYPE='SMP';
                elseif strcmp(ss([1:19]),'Creative Voice File'); 
                        HDR.TYPE='VOC';
                elseif strcmp(ss([5:8]),'moov'); 	% QuickTime movie 
                        HDR.TYPE='QTFF';
                elseif strncmp(ss,'FWS',3) | strncmp(ss,'CWS',3); 	% Macromedia 
                        HDR.TYPE='SWF';
			HDR.VERSION = s(4); 
			HDR.SWF.size = s(5:8)*256.^[0:3]';
                elseif all(s(1:16)==hex2dec(reshape('3026b2758e66cf11a6d900aa0062ce6c',2,16)')')
                        %'75B22630668e11cfa6d900aa0062ce6c'
                        HDR.TYPE='ASF';
                        
                elseif strncmp(ss,'MPv4',4); 
                        HDR.TYPE='MPv4';
                        HDR.Date = ss(65:87);
                elseif strncmp(ss,'RG64',4); 
                        HDR.TYPE='RG64';
                elseif strncmp(ss,'DTDF',4); 
                        HDR.TYPE='DDF';
                elseif strncmp(ss,'RSRC',4);
                        HDR.TYPE='LABVIEW';
                elseif strncmp(ss,'IAvSFo',6); 
                        HDR.TYPE='SIGIF';
                elseif any(s(4)==(2:7)) & all(s(1:3)==0); % [int32] 2...7
                        HDR.TYPE='EGI';
                        
                elseif all(s(1:4)==hex2dec(reshape('AFFEDADA',2,4)')');        % Walter Graphtek
                        HDR.TYPE='WG1';
                        HDR.Endianity = 'ieee-le';
                elseif all(s(1:4)==hex2dec(reshape('DADAFEAF',2,4)')'); 
                        HDR.TYPE='WG1';
                        HDR.Endianity = 'ieee-be';
                        
                elseif strncmp(ss,'HeaderLen=',10); 
			tmp = ss(1:min(find((s==10) | (s==13))));
			tmp(tmp=='=') = ' ';
                        [t,status,sa] = str2double(tmp,[9,32],[10,13]);
                        if strcmp(sa{3},'SourceCh') & strcmp(sa{5},'StatevectorLen') & ~any(status([2,4,6]))
                                HDR.TYPE='BCI2000';
                                HDR.HeadLen = t(2);
                                HDR.NS = t(4);
                                HDR.BCI2000.StateVectorLength = t(6);
                        end;
                        
                elseif strcmp(ss([1:4,9:12]),'RIFFCNT ')
                        HDR.TYPE='EEProbe-CNT';     % continuous EEG in EEProbe format, ANT Software (NL) and MPI Leipzig (DE)
                elseif all(s(1:4)==[38 0 16 0])
                        HDR.TYPE='EEProbe-AVR';     % averaged EEG in EEProbe format, ANT Software (NL) and MPI Leipzig (DE)
                        
                elseif strncmp(ss,'ISHNE1.0',8);        % ISHNE Holter standard output file.
                        HDR.TYPE='ISHNE';
                elseif strncmp(ss,'rhdE',4);	% Holter Excel 2 file, not supported yet. 
                        HDR.TYPE='rhdE';          
                        
                elseif strncmp(ss,'RRI',3);	% R-R interval format % Holter Excel 2 file, not supported yet. 
                        HDR.TYPE='RRI';          
                elseif strncmp(ss,'Repo',4);	% Repo Holter Excel 2 file, not supported yet. 
                        HDR.TYPE='REPO';          
                elseif strncmp(ss,'Beat',4);	% Beat file % Holter Excel 2 file, not supported yet. 
                        HDR.TYPE='Beat';          
                elseif strncmp(ss,'Evnt',4);	% Event file % Holter Excel 2 file, not supported yet. 
                        HDR.TYPE='EVNT';          
                        
                elseif strncmp(ss,'CFWB',4); 	% Chart For Windows Binary data, defined by ADInstruments. 
                        HDR.TYPE='CFWB';
                elseif all(s==[abs('PLEXe'),zeros(1,127)]); 	% http://WWW.PLEXONINC.COM
                        HDR.TYPE='PLX';
                        
                elseif any(s(3:6)*(2.^[0;8;16;24]) == (30:40))
                        HDR.VERSION = s(3:6)*(2.^[0;8;16;24]);
                        offset2 = s(7:10)*(2.^[0;8;16;24]);
                        
                        if     HDR.VERSION < 34, offset = 150;
                        elseif HDR.VERSION < 35, offset = 164; 
                        elseif HDR.VERSION < 36, offset = 326; 
                        elseif HDR.VERSION < 38, offset = 886; 
                        else   offset = 1894; 
                        end;
                        if (offset==offset2),  
                                HDR.TYPE = 'ACQ';
                        end;
                        
                elseif all(s(1:4) == hex2dec(['FD';'AE';'2D';'05'])');
                        HDR.TYPE='AKO';
                elseif all(s(1:2)==[hex2dec('55'),hex2dec('AA')]);
                        HDR.TYPE='RDF'; % UCSD ERPSS aquisition system 
                elseif strncmp(ss,'Stamp',5)
                        HDR.TYPE='XLTEK-EVENT';
                        
                elseif all(s(1:2)==[hex2dec('55'),hex2dec('3A')]);      % little endian 
                        HDR.TYPE='SEG2';
                        HDR.Endianity = 'ieee-le';
                elseif all(s(1:2)==[hex2dec('3A'),hex2dec('55')]);      % big endian 
                        HDR.TYPE='SEG2';
                        HDR.Endianity = 'ieee-be';
                        
                elseif strncmp(ss,'MATLAB Data Acquisition File.',29);  % Matlab Data Acquisition File 
                        HDR.TYPE='DAQ';
                elseif strncmp(ss,'MATLAB 5.0 MAT-file',19); 
                        HDR.TYPE='MAT5';
                        if (s(127:128)==abs('MI')),
                                HDR.Endianity = 'ieee-le';
                        elseif (s(127:128)==abs('IM')),
                                HDR.Endianity = 'ieee-be';
                        end;
                elseif strncmp(ss,'Model {',7); 
                        HDR.TYPE='MDL';
                elseif all(s(85:92)==abs('SAS FILE')); 	% FREESURVER TRIANGLE_FILE_MAGIC_NUMBER
                        HDR.TYPE='SAS';
                        
                elseif any(s(1)==[49:51]) & all(s([2:4,6])==[0,50,0,0]) & any(s(5)==[49:50]),
                        HDR.TYPE = 'WFT';	% nicolet
                        
                elseif all(s(1:3)==[255,255,254]); 	% FREESURVER TRIANGLE_FILE_MAGIC_NUMBER
                        HDR.TYPE='FS3';
                elseif all(s(1:3)==[255,255,255]); 	% FREESURVER QUAD_FILE_MAGIC_NUMBER or CURVATURE
                        HDR.TYPE='FS4';
                elseif all(s(1:3)==[0,1,134]) & any(s(4)==[162:164]); 	% SCAN *.TRI file 
                        HDR.TYPE='TRI';
                elseif all((s(1:4)*(2.^[24;16;8;1]))==1229801286); 	% GE 5.X format image 
                        HDR.TYPE='5.X';
                        
                elseif all(s(1:2)==[105,102]); 
                        HDR.TYPE='669';
                elseif all(s(1:2)==[234,96]); 
                        HDR.TYPE='ARJ';
                elseif s(1)==2; 
                        HDR.TYPE='DB2';
                elseif any(s(1)==[3,131]); 
                        HDR.TYPE='DB3';
                elseif strncmp(ss,'DDMF',4); 
                        HDR.TYPE='DMF';
                elseif strncmp(ss,'DMS',4); 
                        HDR.TYPE='DMS';
                elseif strncmp(ss,'FAR',3); 
                        HDR.TYPE='FAR';
                elseif all(ss(5:6)==[175,18]); 
                        HDR.TYPE='FLC';
                elseif strncmp(ss,'GF1PATCH110',12); 
                        HDR.TYPE='GF1';
                elseif strncmp(ss,'GIF8',4); 
                        HDR.TYPE='GIF';
                elseif strncmp(ss,'CPT9FILE',8);        % Corel PhotoPaint Format
                        HDR.TYPE='CPT9';
                        
                elseif all(s(21:28)==abs('ACR-NEMA')); 
                        HDR.TYPE='ACR-NEMA';
                elseif all(s(1:132)==[zeros(1,128),abs('DICM')]); 
                        HDR.TYPE='DICOM';
                elseif all(s([2,4,6:8])==0) & all(s([1,3,5]));            % DICOM candidate
                        HDR.TYPE='DICOM';
                elseif all(s(1:18)==[8,0,5,0,10,0,0,0,abs('ISO_IR 100')])             % DICOM candidate
                        HDR.TYPE='DICOM';
                elseif all(s(12+[1:18])==[8,0,5,0,10,0,0,0,abs('ISO_IR 100')])             % DICOM candidate
                        HDR.TYPE='DICOM';
                elseif all(s([1:8,13:20])==[8,0,0,0,4,0,0,0,8,0,5,0,10,0,0,0])            % DICOM candidate
                        HDR.TYPE='DICOM';
                        
                elseif strncmp(ss,'*3DSMAX_ASCIIEXPORT',19)
                        HDR.TYPE='ASE';
                elseif strncmp(s,'999',3)
                        HDR.TYPE='DXF-Ascii';
                elseif all(s([1:4])==[32,32,48,10])
                        HDR.TYPE='DXF?';
                elseif all(s([1:4])==[103,23,208,113])
                        HDR.TYPE='DXF13';
                elseif strncmp(ss,'AutoCAD Binary DXF',18)
                        HDR.TYPE='DXF-Binary';

                elseif strncmp(ss,'%!PS-Adobe',10)
                        HDR.TYPE='PS/EPS';
                elseif strncmp(ss,'HRCH: Softimage 4D Creative Environment',38)
                        HDR.TYPE='HRCH';
                elseif strncmp(ss,'#Inventor V2.0 ascii',11)
                        HDR.TYPE='IV2';
			HDR.Version = ss(12:14);
                elseif strncmp(ss,'HRCH: Softimage 4D Creative Environment',38)
                        HDR.TYPE='HRCH';
                elseif all(s([1:2])==[1,218])
                        HDR.TYPE='RGB';
                elseif strncmp(ss,'#$SMF',5)
                        HDR.TYPE='SMF';
			HDR.Version = str2double(ss(7:10));
                elseif strncmp(ss,'#SMF',4)
                        HDR.TYPE='SMF';
			HDR.Version = str2double(ss(5:8));
                        
                elseif all(s([1:4])==[127,abs('ELF')])
                        HDR.TYPE='ELF';
                elseif all(s([1:4])==[77,90,192,0])
                        HDR.TYPE='EXE';
                elseif all(s([1:4])==[77,90,80,0])
                        HDR.TYPE='EXE/DLL';
                elseif all(s([1:4])==[77,90,128,0])
                        HDR.TYPE='DLL';
                elseif all(s([1:4])==[77,90,144,0])
                        HDR.TYPE='DLL';
                elseif all(s([1:8])==[254,237,250,206,0,0,0,18])
                        HDR.TYPE='MEXMAC';

                elseif all(s(1:24)==[208,207,17,224,161,177,26,225,zeros(1,16)]);	% MS-EXCEL candidate
                        HDR.TYPE='BIFF';
                        
                elseif strncmp(lower(ss),'<?php',5)
                        HDR.TYPE='PHP';
                elseif strncmp(ss,'<WORLD>',7)
                        HDR.TYPE='XML';
                elseif all(s(1:2)==[255,254]) & all(s(4:2:end)==0)
                        HDR.TYPE='XML-UTF16';
                elseif ~isempty(findstr(ss,'?xml version'))
                        HDR.TYPE='XML-UTF8';

                elseif all(s([1:2,7:10])==[abs('BM'),zeros(1,4)])
                        HDR.TYPE='BMP';
                        HDR.Endianity = 'ieee-le';
                elseif strncmp(ss,'#FIG',4)
                        HDR.TYPE='FIG';
			HDR.VERSION = strtok(ss(6:end),[10,13]);
                elseif strncmp(ss,'SIMPLE  =                    T / Standard FITS format',30)
                        HDR.TYPE='FITS';
                elseif all(s(1:40)==[137,abs('HDF'),13,10,26,10,0,0,0,0,0,8,8,0,4,0,16,0,3,zeros(1,11),repmat(255,1,8)]) & (HDR.FILE.size==s(41:44)*2.^[0:8:24]')
                        HDR.TYPE='HDF';
                elseif strncmp(ss,'CDF',3)
                        HDR.TYPE='NETCDF';
                elseif strncmp(ss,'%%MatrixMarket matrix coordinate',32)
                        HDR.TYPE='MatrixMarket';
                elseif s(1:4)*2.^[0:8:24]'==5965600,	 % Kodac ICC format
                        HDR.TYPE='ICC';
			HDR.HeadLen = s(5:8)*2.^[0:8:24];
			HDR.T0 = s([20,19,18,17,24,23]);
                elseif strncmp(ss,'IFS',3)
                        HDR.TYPE='IFS';
                elseif strncmp(ss,'OFF',3)
                        HDR.TYPE='OFF';
			HDR.ND = 3;
                elseif strncmp(ss,'4OFF',4)
                        HDR.TYPE='OFF';
			HDR.ND = 4;
                elseif strncmp(ss,'.PBF',4)      
                        HDR.TYPE='PBF';
                elseif (s(1)==16) & any(s(2)==[0,2,3,5])
                        HDR.TYPE='PCX';
			tmp = [2.5, 0, 2.8, 2.8, 0, 3];
                        HDR.Version=tmp(s(2));
			HDR.Encoding = s(3);
			HDR.BitsPerPixel = s(4);
			HDR.NPlanes = s(65);
			
                elseif 0, all(s(1:2)=='P6') & any(s(3)==[10,13])
                        HDR.TYPE='PNG6';
                elseif all(s(1:8)==[139,74,78,71,13,10,26,10])
                        HDR.TYPE='JNG';
                elseif all(s(1:8)==[137,80,78,71,13,10,26,10]) 
                        HDR.TYPE='PNG';
		elseif (ss(1)=='P') & any(ss(2)=='123')	% PBMA, PGMA, PPMA
                        HDR.TYPE='PBMA';
			id = 'BGP';
			HDR.TYPE(2)=id(s(2)-48);
		elseif (ss(1)=='P') & any(ss(2)=='456')	% PBMB, PGMB, PPMB
                        HDR.TYPE='PBMB';
			id = 'BGP';
			HDR.TYPE(2) = id(s(2)-abs('3'));
			[s1,t]=strtok(ss,[10,13]);
			[s1,t]=strtok(t,[10,13]);
			while (s1(1)=='#')	% ignore comment lines
				[s1,t]=strtok(t,[10,13]);
			end;	
			HDR.IMAGE.Size = str2double(s1);
			if s(2)~='4',
				[s3,t]=strtok(t,[9,10,13,32]);
		    		HDR.DigMax = str2double(s3);
			end;
			HDR.HeadLen = length(ss)-length(t)+1;
                elseif strncmp(ss,'/* XPM */',9)
                        HDR.TYPE='XPM';

                elseif strncmp(ss,['#  ',HDR.FILE.Name,'.poly'],8+length(HDR.FILE.Name)) 
                        HDR.TYPE='POLY';
                elseif all(s(1:4)==hex2dec(['FF';'D9';'FF';'E0'])')
                        HDR.TYPE='JPG';
                        HDR.Endianity = 'ieee-be';
                elseif all(s(1:4)==hex2dec(['FF';'D8';'FF';'E0'])')
                        HDR.TYPE='JPG';
                        HDR.Endianity = 'ieee-be';
                elseif all(s(1:4)==hex2dec(['E0';'FF';'D8';'FF'])')
                        HDR.TYPE='JPG';
                        HDR.Endianity = 'ieee-le';
                elseif all(s(1:20)==['L',0,0,0,1,20,2,0,0,0,0,0,192,0,0,0,0,0,0,70])
                        HDR.TYPE='LNK';
                        tmp = fread(fid,inf,'char');
                        HDR.LNK=[s,tmp'];
                elseif all(s(1:3)==[0,0,1])	
                        HDR.TYPE='MPG2MOV';
                elseif strcmp(ss([3:5,7]),'-lh-'); 
                        HDR.TYPE='LZH';
                elseif strcmp(ss([3:5,7]),'-lz-'); 
                        HDR.TYPE='LZH';
                elseif strcmp(ss(1:3),'MMD'); 
                        HDR.TYPE='MED';
                elseif (s(1)==255) & any(s(2)>=224); 
                        HDR.TYPE='MPEG';
                elseif strncmp(ss(5:8),'mdat',4); 
                        HDR.TYPE='MOV';
                elseif all(s(1:2)==[26,63]); 
                        HDR.TYPE='OPT';
                elseif strncmp(ss,'%PDF',4); 
                        HDR.TYPE='PDF';
                elseif strncmp(ss,'QLIIFAX',7); 
                        HDR.TYPE='QFX';
                elseif strncmp(ss,'.RMF',4); 
                        HDR.TYPE='RMF';
                elseif strncmp(ss,'IREZ',4); 
                        HDR.TYPE='RMF';
                elseif all(s(1:5)==[123,92,114,116,102]);           % '{\rtf' 
                        HDR.TYPE='RTF';
                elseif all(s(1:4)==[73,73,42,0]); 
                        HDR.TYPE='TIFF';
                        HDR.Endianity = 'ieee-le';
                elseif all(s(1:4)==[77,77,0,42]); 
                        HDR.TYPE='TIFF';
                        HDR.Endianity = 'ieee-be';
                elseif strncmp(ss,'StockChartX',11); 
                        HDR.TYPE='STX';
                elseif all(ss(1:2)==[25,149]); 
                        HDR.TYPE='TWE';
                elseif strncmp(ss,'TVF 1.1A',7); 
                        HDR.TYPE = ss(1:8);
                elseif all(s(1:12)==[abs('TVF 1.1B'),1,0,0,0]); 
                        HDR.TYPE = ss(1:8);
			HDR.Endianity = 'ieee-le';
                elseif all(s(1:12)==[abs('TVF 1.1B'),0,0,0,1]); 
                        HDR.TYPE = ss(1:8);
			HDR.Endianity = 'ieee-be';
                elseif strncmp(ss,'#VRML',5); 
                        HDR.TYPE='VRML';
                elseif strncmp(ss,'# vtk DataFile Version ',23); 
                        HDR.TYPE='VTK';
			HDR.Version = ss(24:26);
                elseif all(ss(1:5)==[0,0,2,0,4]); 
                        HDR.TYPE='WKS';
                elseif all(ss(1:5)==[0,0,2,0,abs('Q')]); 
                        HDR.TYPE='WQ1';
                elseif all(s(1:8)==hex2dec(['30';'26';'B2';'75';'8E';'66';'CF';'11'])'); 
                        HDR.TYPE='WMV';
                        
                	% compression formats        
                elseif strncmp(ss,'BZh91AH&SY',10); 
                        HDR.TYPE='BZ2';
                elseif all(s(1:3)==[66,90,104]); 
                        HDR.TYPE='BZ2';
                elseif strncmp(ss,'MSCF',4); 
                        HDR.TYPE='CAB';
                elseif all(s(1:3)==[31,139,8]); 
                        HDR.TYPE='gzip';
                elseif all(s(1:3)==[31,157,144]); 
                        HDR.TYPE='Z';
                elseif all(s([1:4])==[80,75,3,4]) & (c>=30)
                        HDR.TYPE='ZIP';
                        HDR.Version = s(5:6)*[1;256];
                        HDR.ZIP.FLAG = s(7:8);
                        HDR.ZIP.CompressionMethod = s(9:10);
                        
                        % converting MS-Dos Date*Time format
                        tmp = s(11:14)*2.^[0:8:31]';
                        HDR.T0(6) = rem(tmp,2^5)*2;	tmp=floor(tmp/2^5);
                        HDR.T0(5) = rem(tmp,2^6);	tmp=floor(tmp/2^6);
                        HDR.T0(4) = rem(tmp,2^5);	tmp=floor(tmp/2^5);
                        HDR.T0(3) = rem(tmp,2^5);	tmp=floor(tmp/2^5);
                        HDR.T0(2) = rem(tmp,2^4); 	tmp=floor(tmp/2^4);
                        HDR.T0(1) = 1980+tmp; 
                        
                        HDR.ZIP.CRC = s(15:18)*2.^[0:8:31]';
                        HDR.ZIP.size2 = s(19:22)*2.^[0:8:31]';
                        HDR.ZIP.size1 = s(23:26)*2.^[0:8:31]';
                        HDR.ZIP.LengthFileName = s(27:28)*[1;256];
                        HDR.ZIP.filename = char(s(31:min(c,30+HDR.ZIP.LengthFileName)));
                        HDR.ZIP.LengthExtra = s(29:30)*[1;256];
                        HDR.HeadLen = 30 + HDR.ZIP.LengthFileName + HDR.ZIP.LengthExtra;
                        HDR.tmp = char(s);
                        HDR.ZIP.Extra = s(31+HDR.ZIP.LengthFileName:min(c,HDR.HeadLen));
                        if strncmp(ss(31:end),'mimetypeapplication/vnd.sun.xml.writer',38)
                                HDR.TYPE='SWX';
                        end;
                elseif strncmp(ss,'ZYXEL',5); 
                        HDR.TYPE='ZYXEL';
                elseif strcmpi(HDR.FILE.Name,ss(1:length(HDR.FILE.Name)));
                        HDR.TYPE='HEA';
                        
                elseif strncmp(ss,['# ',HDR.FILE.Name],length(HDR.FILE.Name)+2); 
                        HDR.TYPE='SMNI';
                elseif all(s(1:16)==[1,0,0,0,1,0,0,0,4,0,0,0,0,0,0,0]),  % should be last, otherwise to many false detections
                        HDR.TYPE='MAT4';
                        HDR.MAT4.opentyp='ieee-be';
			
                        %elseif all(~type_mat4),  % should be last, otherwise to many false detections
                elseif all(s(1:4)==0),  % should be last, otherwise to many false detections
                        HDR.TYPE='MAT4';
                        if type_mat4(1)==1,
                                HDR.MAT4.opentyp='ieee-be';
                        elseif type_mat4(1)==2,
                                HDR.MAT4.opentyp='vaxd';
                        elseif type_mat4(1)==3,
                                HDR.MAT4.opentyp='vaxg';
                        elseif type_mat4(1)==4,
                                HDR.MAT4.opentyp='gray';
                        else
                                HDR.MAT4.opentyp='ieee-le';
                        end;
                        
                elseif ~isempty(findstr(ss,'### Table of event codes.'))
                        fseek(fid,0,-1);
                        line = fgetl(fid);
                        N1 = 0; N2 = 0; 
                        while ~feof(fid),%length(line),
                                if 0, 
                                elseif strncmp(line,'0x',2),
                                        N1 = N1 + 1;
                                        [ix,desc] = strtok(line,char([9,32,13,10]));
                                        ix = hex2dec(ix(3:end));
                                        HDR.EVENT.CodeDesc{N1,1} = desc(2:end);
                                        HDR.EVENT.CodeIndex(N1,1) = ix;
                                elseif strncmp(line,'### 0x',6)
                                        N2 = N2 + 1;
                                        HDR.EVENT.GroupDesc{N2,1} = line(12:end);
                                        tmp = line(7:10);
                                        HDR.EVENT.GroupIndex{N2,1} = tmp;
                                        tmp1 = tmp; tmp1(tmp~='_') = 'F'; tmp1(tmp=='_')='0';
                                        HDR.EVENT.GroupMask(N2,1)  = hex2dec(tmp1);
                                        tmp1 = tmp; tmp1(tmp=='_') = '0';
                                        HDR.EVENT.GroupValue(N2,1) = hex2dec(tmp1);
                                end;	
                                line = fgetl(fid);
                        end;
                        HDR.TYPE = 'EVENTCODES';
                else
                        HDR.TYPE='unknown';

                        status = fseek(fid,3228,-1);
                        [s0,c]=fread(fid,[1,4],'uint8'); 
			if (status & (c==4)) 
			if all((s0(1:4)*(2.^[24;16;8;1]))==1229801286); 	% GE LX2 format image 
                                HDR.TYPE='LX2';
                        end;
			end;
                end;
        end;
        fclose(fid);
        
        if strcmpi(HDR.TYPE,'unknown'),
                % alpha-TRACE Medical software
                if (strcmpi(HDR.FILE.Name,'rawdata') | strcmpi(HDR.FILE.Name,'rawhead')) & isempty(HDR.FILE.Ext),
                        if exist(fullfile(HDR.FILE.Path,'digin'),'file') & exist(fullfile(HDR.FILE.Path,'r_info'),'file');	
                                HDR.TYPE = 'alpha'; %alpha trace medical software 
                        end;
                end;
                TYPE = [];
                
                %%% this is the file type check based on the file extionsion, only.  
                if 0, 
                        
                        % MIT-ECG / Physiobank format
                elseif strcmpi(HDR.FILE.Ext,'HEA'), HDR.TYPE='MIT';
                        
                elseif strcmpi(HDR.FILE.Ext,'DAT') | strcmpi(HDR.FILE.Ext,'ATR'), 
                        tmp = dir(fullfile(HDR.FILE.Path,[HDR.FILE.Name,'.hea']));
                        if isempty(tmp), 
                                tmp = dir(fullfile(HDR.FILE.Path,[HDR.FILE.Name,'.HEA']));
                        end
                        if ~isempty(tmp), 
                                HDR.TYPE='MIT';
                                [tmp,tmp1,tmp2] = fileparts(tmp.name);
                                HDR.FILE.Ext = tmp2(2:end);
                        end
                        
                elseif strcmpi(HDR.FILE.Ext,'rhf'),
                        HDR.FileName=fullfile(HDR.FILE.Path,[HDR.FILE.Name,'.',HDR.FILE.Ext]);
                        HDR.TYPE = 'RG64';
                elseif strcmp(HDR.FILE.Ext,'rdf'),
                        HDR.FileName=fullfile(HDR.FILE.Path,[HDR.FILE.Name,'.',HDR.FILE.Ext(1),'h',HDR.FILE.Ext(3)]);
                        HDR.TYPE = 'RG64';
                elseif strcmp(HDR.FILE.Ext,'RDF'),
                        HDR.FileName=fullfile(HDR.FILE.Path,[HDR.FILE.Name,'.',HDR.FILE.Ext(1),'H',HDR.FILE.Ext(3)]);
                        HDR.TYPE = 'RG64';
                        
                elseif strcmpi(HDR.FILE.Ext,'txt') & (any(strfind(HDR.FILE.Path,'a34lkt')) | any(strfind(HDR.FILE.Path,'egl2ln'))) & any(strmatch(HDR.FILE.Name,{'Traindata_0','Traindata_1','Testdata'}))
                        HDR.TYPE = 'BCI2003_Ia+b';
                        
                elseif any(strmatch(HDR.FILE.Name,{'x_train','x_test'}))
                        HDR.TYPE = 'BCI2003_III';
                        
                elseif strcmpi(HDR.FILE.Ext,'hdm')
                        
                elseif strcmpi(HDR.FILE.Ext,'hc')
                        
                elseif strcmpi(HDR.FILE.Ext,'shape')
                        
                elseif strcmpi(HDR.FILE.Ext,'shape_info')
                        
                elseif strcmpi(HDR.FILE.Ext,'trg')
                        
                elseif strcmpi(HDR.FILE.Ext,'rej')
                        
                elseif strcmpi(HDR.FILE.Ext,'elc')
                        
                elseif strcmpi(HDR.FILE.Ext,'vol')
                        
                elseif strcmpi(HDR.FILE.Ext,'bnd')
                        
                elseif strcmpi(HDR.FILE.Ext,'msm')
                        
                elseif strcmpi(HDR.FILE.Ext,'msr')
                        HDR.TYPE = 'ASA2';    % ASA version 2.x, see http://www.ant-software.nl
                        
                elseif strcmpi(HDR.FILE.Ext,'dip')
                        
                elseif strcmpi(HDR.FILE.Ext,'mri')
                        
                elseif strcmpi(HDR.FILE.Ext,'iso')
                        
                elseif strcmpi(HDR.FILE.Ext,'hdr')
                        
                elseif strcmpi(HDR.FILE.Ext,'img')
                        
                elseif strcmpi(HDR.FILE.Ext,'sx')
                        HDR.TYPE = 'SXI';
                elseif strcmpi(HDR.FILE.Ext,'sxi')
                        HDR.TYPE = 'SXI';
                        
                        % the following are Brainvision format, see http://www.brainproducts.de
                elseif exist(fullfile(HDR.FILE.Path, [HDR.FILE.Name '.vhdr']), 'file')
                        HDR.TYPE = 'BrainVision';
                        HDR.FileName = fullfile(HDR.FILE.Path, [HDR.FILE.Name '.vhdr']);	% point to header file
                elseif strcmpi(HDR.FILE.Ext,'vmrk')
                        HDR.TYPE = 'BrainVisionMarkerFile';
                        
                elseif strcmpi(HDR.FILE.Ext,'ent')
			HDR.TYPE = 'XLTEK-EVENT';		

                elseif strcmpi(HDR.FILE.Ext,'etc')
			HDR.TYPE = 'XLTEK-ETC';
			fid = fopen(HDR.FileName,'r');
			fseek(fid,355,'bof');
			HDR.TIMESTAMP = fread(fid,1,'int32');
			fclose(fid);

                elseif strcmpi(HDR.FILE.Ext,'seg')
                        % If this is really a BrainVision file, there should also be a
                        % header with the same name and extension *.vhdr.
                        if exist(fullfile(HDR.FILE.Path, [HDR.FILE.Name '.vhdr']), 'file')
                                HDR.TYPE          = 'BrainVision';
                                HDR.FileName = fullfile(HDR.FILE.Path, [HDR.FILE.Name '.vhdr']);	% point to header file
                        end
                        
                elseif strcmpi(HDR.FILE.Ext,'vabs')
                                                
                elseif strcmpi(HDR.FILE.Ext,'bni')        %%% Nicolet files 
                        HDR = getfiletype(fullfile(HDR.FILE.Path, [HDR.FILE.Name '.eeg']));
                        
                elseif strcmpi(HDR.FILE.Ext,'eeg')        %%% Nicolet files 
                        fn = fullfile(HDR.FILE.Path, [HDR.FILE.Name '.bni']);
                        if exist(fn, 'file')
                                fid = fopen(fn,'r','ieee-le');
                                HDR.Header = char(fread(fid,[1,inf],'uchar'));
                                fclose(fid);
                        end;
                        if exist(HDR.FileName, 'file')
                                fid = fopen(HDR.FileName,'r','ieee-le');
                                fseek(fid,-4,'eof');
                                datalen = fread(fid,1,'uint32');
                                fseek(fid,datalen,'bof');
                                HDR.Header = char(fread(fid,[1,inf],'uchar'));
                                fclose(fid);
                        end;
                        pos_rate = strfind(HDR.Header,'Rate =');
                        pos_nch  = strfind(HDR.Header,'NchanFile =');
                        
                        if ~isempty(pos_rate) & ~isempty(pos_nch),
                                HDR.SampleRate = str2double(HDR.Header(pos_rate + (6:9)));
                                HDR.NS = str2double(HDR.Header(pos_nch +(11:14)));
                                HDR.SPR = datalen/(2*HDR.NS);
                                HDR.AS.endpos = HDR.SPR;
                                HDR.GDFTYP = 3; % int16;
                                HDR.HeadLen = 0; 
                                HDR.TYPE = 'Nicolet';  
                        end;
                        
                        
                elseif strcmpi(HDR.FILE.Ext,'fif')
                        HDR.TYPE = 'FIF';	% Neuromag MEG data (company is now part of 4D Neuroimaging)
                        
                elseif strcmpi(HDR.FILE.Ext,'bdip')
                        
                elseif strcmpi(HDR.FILE.Ext,'elp')
                        
                elseif strcmpi(HDR.FILE.Ext,'sfp')
                        
                elseif strcmpi(HDR.FILE.Ext,'ela')
                        
                elseif strcmpi(HDR.FILE.Ext,'trl')
                        
                elseif (length(HDR.FILE.Ext)>2) & all(s>31),
                        if all(HDR.FILE.Ext(1:2)=='0') & any(abs(HDR.FILE.Ext(3))==abs([48:57])),	% WSCORE scoring file
                                x = load('-ascii',HDR.FileName);
                                HDR.EVENT.POS = x(:,1);
                                HDR.EVENT.WSCORETYP = x(:,2);
                                HDR.TYPE = 'WCORE_EVENT';
                        end;
                end;
        end;
        
        if 0, strcmpi(HDR.TYPE,'unknown'),
                try
                        [status, HDR.XLS.sheetNames] = xlsfinfo(HDR.FileName)
                        if ~isempty(status)
                                HDR.TYPE = 'EXCEL';
                        end;
                catch
                end;
        end;
end;

%---------------------------------------------------------------------------------%

function [S,EDF] = sdfread(EDF,NoS,StartPos)
% SDFREAD loads selected seconds of an EDF/GDF/BDF File
%
% [S,EDF] = sdfread(EDF [,NoS [,StartPos]] )
% NoS       Number of seconds, default = 1 (second)
% StartPos  Starting position, if not provided the following data is read continously from the EDF file. 
%                    no reposition of file pointer is performed
%
% (Ver > 0.75 requests NoS and StartPos in seconds. Previously (Ver <0.76) the units were Records.) 
%
% EDF=sdfopen(Filename,'r',[[CHAN] | [ReRefMx]],TSR,OFCHK);
% [S,EDF] = sdfread(EDF, NoS, StartPos)
% 
% [S,EDF] = sdfread(EDF, EDF.NRec*EDF.Dur) and
% [S,EDF] = sdfread(EDF, inf) 
% reads til the end
%
% See also: fread, SREAD, SCLOSE, SSEEK, SREWIND, STELL, SEOF

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

%	$Revision: 1.10 $
%	$Id: sdfread.m,v 1.10 2004/11/17 19:39:18 schloegl Exp $
%	(C) 1997-2002,2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/


OptiMEM=1;             % if you get low of memory (your CPU starts swapping), set this to one
OptiSPEED=~OptiMEM;
MAX_BLOCK_NUMBER=16;	% %%max. # of blocks in case of OptiMEM

GDF=strcmp(EDF.VERSION(1:3),'GDF');

if nargin<1
        fprintf(2,'ERROR SDFREAD: missing input arguments\n');
end; if nargin<2
        NoS=1;
end; if nargin<3
        Mode=0;
end; if nargin<4 
        NoR=EDF.NRec;
end; 

if isfield(EDF,'SIE')   % SIESTA; Layer 4
        Mode_RAW=EDF.SIE.RAW; %any(Mode==[[4:7 12:15] [4:7 12:15]+16]);
	%Mode_CAL=EDF.SIE.RR; %any(Mode==[[2 3 6 7 10 11 14 15] [2 3 6 7 10 11 14 15]+16]);
        Mode_REF=0; %any(Mode==[[8:15] [8:15]+16]);
	Mode_SEC=0; %any(Mode==[[1:2:15] [1:2:15]+16]);
        Mode_RS100=EDF.SIE.RS; %bitand(Mode,2^4)>0;
        
        EDF.AS.startrec=EDF.AS.startrec+EDF.AS.numrec;
        EDF.AS.numrec=0;
        
        % prepare input arguments
        if ~EDF.SIE.TimeUnits_Seconds;        % units of time in records      
                NoR=NoS;%chan;
                if ~(nargin<3) 
                        [EDF]=sseek(EDF,StartPos,'bof'); 
                end;
                if isinf(NoR), 
                        NoR=EDF.NRec-EDF.FILE.POS; 
                end;
        else         % units of time in seconds
                % Prepare input arguments, transform NoS and StartPos into units of samples 
                if (nargin>2) %nargin==3 or larger
                        %tmp = floor(StartPos/EDF.Dur);
                        if StartPos+NoS > EDF.Dur*EDF.NRec;
                                fprintf(EDF.FILE.stderr,'Warning SDFREAD: %s has only %i seconds\n',EDF.FileName, EDF.Dur*EDF.NRec);
                                StartPos = min(StartPos*EDF.AS.MAXSPR/EDF.Dur,EDF.AS.MAXSPR*EDF.NRec); % transformation of seconds to samples + Overflowcheck
                                NoS = EDF.AS.MAXSPR*EDF.NRec-StartPos;
                        else
                                StartPos = StartPos*EDF.AS.MAXSPR/EDF.Dur;% EDF.Block.number(4);%/EDF.AS.MAXSPR*EDF.Dur;
                                NoS = NoS*EDF.AS.MAXSPR/EDF.Dur;
                        end;
                        NoR = ceil((StartPos+NoS)/EDF.AS.MAXSPR)-floor(StartPos/EDF.AS.MAXSPR);
                        %EDF.AS.A_Block_number=0;
                elseif nargin==2 %nargin==2
                        StartPos = EDF.Block.number(4); % EDF.Block.number(4);%/EDF.AS.MAXSPR*EDF.Dur;
                        NoS = NoS * EDF.AS.MAXSPR/EDF.Dur; % 
                else  % nargin<2
                        %NoR = 1, %ceil(NoS/EDF.Dur);
                        NoS = EDF.AS.MAXSPR/EDF.Dur; %EDF.Dur; % default one second
                        StartPos = EDF.Block.number(4);%/EDF.AS.MAXSPR*EDF.Dur; % EDF.FILE.POS*EDF.Dur;
                        %StartPos = EDF.FILE.POS*EDF.Dur,
                end;
                if isinf(NoS), 
                        NoS=EDF.NRec*EDF.AS.MAXSPR-EDF.Block.number(4); 
                end;
                
                % Q? whether repositioning is required, otherwise read continously, 
                if floor(StartPos/EDF.AS.MAXSPR)~=EDF.FILE.POS; % if start not next block 
                        if floor(StartPos/EDF.AS.MAXSPR)~=floor(EDF.Block.number(1)/EDF.AS.MAXSPR); % if start not same as Block.data
                                [EDF]=sseek(EDF,floor(StartPos/EDF.AS.MAXSPR),'bof');
                        end;
                end;

                % Q whether last bufferblock is needed or not
                if (StartPos >= EDF.Block.number(2)) | (StartPos < EDF.Block.number(1)) | diff(EDF.Block.number(1:2))==0
                        EDF.Block.number=[0 0 0 0 ];
                        EDF.Block.data=[];
                        NoR=ceil((StartPos+NoS)/EDF.AS.MAXSPR)-floor(StartPos/EDF.AS.MAXSPR);
                else
                        NoR=ceil((StartPos+NoS-EDF.Block.number(2))/EDF.AS.MAXSPR);
                end;
                
        end;
        
        
        %clear chan;
	InChanSelect=EDF.InChanSelect;
        Mode_CHANSAME = ~all(EDF.SPR(InChanSelect)==EDF.SPR(InChanSelect(1)));
        clear Mode;
        
else % Layer 3
	%if chan==0        
                InChanSelect=1:EDF.NS;
        %else
        %        InChanSelect=chan;
	%end;

	if ischar(Mode)         %%% not OCTAVE-compatible
    		arg3=upper(Mode);
    		Mode = any(arg3=='R')*8 + any(arg3=='W')*4 + (any(arg3=='A') & ~any(arg3=='N'))*2 + any(arg3=='S'); 
	end;

        Mode_RAW=any(Mode==[[4:7 12:15] [4:7 12:15]+16]);
        EDF.SIE.RR=any(Mode==[[2 3 6 7 10 11 14 15] [2 3 6 7 10 11 14 15]+16]);
        Mode_SEC=any(Mode==[[1:2:15] [1:2:15]+16]);
        Mode_RS100=0; %bitand(Mode,2^4)>0;
        EDF.SIE.FILT=0;
        
	% Position file pointer and calculate number of Records
	if Mode_SEC
    		if ~all(~rem([NoR StartPos],EDF.Dur))
            		fprintf(EDF.FILE.stderr,'Warning SDFREAD: NoR and/or StartPos do not fit to blocklength of EDF File of %i s.\n',EDF.Dur);
	        end;
    		StartPos=StartPos/EDF.Dur;
	        NoR=NoR/EDF.Dur;
	end;
	if ~(nargin<5) 
    	        EDF=sseek(EDF,StartPos,'bof'); 
        else
                EDF.AS.startrec=EDF.AS.startrec+EDF.AS.numrec;
                EDF.AS.numrec=0;
	end;

        InChanSelect = EDF.InChanSelect;
        
        Mode_CHANSAME = ~all(EDF.SPR(InChanSelect)==EDF.SPR(InChanSelect(1)));
	%if any(EDF.SPR(chan)~=EDF.SPR(chan(1))) fprintf(EDF.FILE.stderr,'Warning SDFREAD: channels do not have the same sampling rate\n');end;
end;
        
bi=[0;cumsum(EDF.SPR)];
Records=NoR;
maxspr=EDF.AS.MAXSPR; %max(EDF.SPR(EDF.SIE.ChanSelect));
count=0;

if Mode_RAW;
        S=zeros(sum(EDF.SPR(InChanSelect)),Records);
        bi=[0;cumsum(EDF.SPR(InChanSelect))];
else
        S=zeros(maxspr*Records,length(InChanSelect));
end;        

if ~EDF.AS.SAMECHANTYP; % all(EDF.GDFTYP(:)~=EDF.GDFTYP(1))
        idx0=0;
        count=0;
        while (count<Records*EDF.AS.spb) & ~sdfeof(EDF), 
                %   for K=1:length(InChanSelect), K=InChanSelect(k);
                for k=1:EDF.NS,
                        %if GDF-format should be used 
                        %datatyp=gdfdatatype(EDF.GDFTYP(k));
                        %if exist('OCTAVE_VERSION')
                        %        tmp1=(datatyp~='');
                        %else
                        %        tmp1=~isempty(datatyp);
                        %end;
                        %if tmp1
                        %        [tmp,cnt]=fread(EDF.FILE.FID,EDF.SPR(k),datatyp);
                        %else 
                        %        fprintf(EDF.FILE.stderr,'Error SDFREAD: Invalid SDF channel type in %s at channel %i',EDF.FileName,k);
                        %end;
                        
                        [tmp,cnt]=fread(EDF.FILE.FID,EDF.SPR(k),gdfdatatype(EDF.GDFTYP(k)));
                        if any(InChanSelect==k), K=find(InChanSelect==k);
                                if Mode_RAW;
                                        S(bi(K)+1:bi(K+1),count+1)=tmp;
                                else 
                                        if ~Mode_CHANSAME
                                                tmp=reshape(tmp(:,ones(1,maxspr/EDF.SPR(k)))',maxspr,1);
                                        end;
                                        %disp([size(tmp) size(S) k K l maxspr])
                                        S(idx0+(1:maxspr),K)=tmp; %RS%
                                end;  
                        end;      
                        count=count+cnt;
                end; 
                idx0 = idx0 + maxspr;
        end;
        S=S(1:idx0,:);
        count=count/EDF.AS.spb;
        
        %AFIR%
        if EDF.SIE.AFIR
                %EDF.AFIR.xin=S(:,find(EDF.AFIR.channel1==EDF.InChanSelect)); 
                EDF.AFIR.xin=S(:,EDF.AFIR.channel1); 
        end;
        
        % Overflow Check for SDF
        if EDF.SIE.TH>1,
                for k=1:length(InChanSelect),K=InChanSelect(k);
	        	tmp = S(:,k);
			[y1,EDF.Block.z1{k}]=filter([1 -1],1,tmp,EDF.Block.z1{k});
            		[y2,EDF.Block.z2{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,y1==0,EDF.Block.z2{k});
            		%y2=y2>0.079*(EDF.SPR(k)/EDF.Dur);
    			[y3,EDF.Block.z3{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,(tmp>=EDF.SIE.THRESHOLD(K,2)) | (tmp<=EDF.SIE.THRESHOLD(K,1)),EDF.Block.z3{k});
            		%y3=y3>0.094*(EDF.SPR(k)/EDF.Dur);
			%OFCHK(bi(k)+1:bi(k+1),:) = y3>0.094 | y2>0.079;
			S(y3>0.094 | y2>0.079, k) = NaN;
		end;
        elseif EDF.SIE.TH,
                for k=1:length(InChanSelect),K=InChanSelect(k);
                        %OFCHK(:,k)=(S(:,k) < EDF.SIE.THRESHOLD(K,1)) | (S(:,k)>= EDF.SIE.THRESHOLD(K,2));
                        S(S(:,k) <= EDF.SIE.THRESHOLD(K,1) | S(:,k)>= EDF.SIE.THRESHOLD(K,2),k) = NaN;
                end;
        end;
        
else %%%%%%%%% if all channels of same type
        
datatyp=gdfdatatype(EDF.GDFTYP(1));        
if Mode_RAW;

        [S, count]=fread(EDF.FILE.FID,[EDF.AS.spb, Records],datatyp);
        
        %count = floor(count/EDF.AS.spb);
        count = (count/EDF.AS.spb);
        if count<1; fprintf(EDF.FILE.stderr,'Warning SDFREAD: only %3.1f blocks were read instead  of %3.1f\n',count,Records); end;

        % Overflow Check for EDF-RAW
        if EDF.SIE.TH>1,
                for k=1:length(InChanSelect),K=InChanSelect(k);
			tmp = S(bi(k)+1:bi(k+1),:);
	                [y1,EDF.Block.z1{k}]=filter([1 -1],1,tmp(:),EDF.Block.z1{k});
        		[y2,EDF.Block.z2{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,y1==0,EDF.Block.z2{k});
        		%y2=y2>0.079*(EDF.SPR(k)/EDF.Dur);
    			[y3,EDF.Block.z3{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,(tmp>=EDF.SIE.THRESHOLD(K,2)) | (tmp<=EDF.SIE.THRESHOLD(K,1)),EDF.Block.z3{k});
        		%y3=y3>0.094*(EDF.SPR(k)/EDF.Dur);
			tmp(y3>0.094 | y2>0.079) = NaN;
			S(bi(k)+1:bi(k+1),:) = tmp;
		end;
        elseif EDF.SIE.TH,
                for k=1:length(InChanSelect),K=InChanSelect(k);
			tmp = S(bi(k)+1:bi(k+1),:);    
                        tmp(tmp <= EDF.SIE.THRESHOLD(K,1) | tmp>= EDF.SIE.THRESHOLD(K,2)) = NaN;
			S(bi(k)+1:bi(k+1),:) = tmp;    
                end;
        end;
        
        if isfield(EDF.SIE,'RAW'), 
                if EDF.SIE.RAW, 
                        fprintf(EDF.FILE.stderr,'Warning SDFREAD: ReReferenzing "R" is not possible in combination with RAW "W"\n');
                end;
        end;
else
        if all(EDF.SPR(InChanSelect)==EDF.AS.MAXSPR)
                if ~OptiMEM % but OptiSPEED
                        [s, count]=fread(EDF.FILE.FID,[EDF.AS.spb,Records],datatyp);
                        count = (count/EDF.AS.spb);
                        S = zeros(maxspr*count,length(InChanSelect)); %%%
                        for k=1:length(InChanSelect), K=InChanSelect(k);
                                S(:,k)=reshape(s(bi(K)+1:bi(K+1),:),maxspr*count,1); %RS%
                        end;

                else %OptiMEM % but ~OptiSPEED
                        S = zeros(maxspr*Records,length(InChanSelect));%%%
                        idx0=0; count=0;
                        for l=1:ceil(Records/MAX_BLOCK_NUMBER),
                                tmp_norr=min(MAX_BLOCK_NUMBER,Records-count); % 16 = # of blocks read 
                                [s, C]=fread(EDF.FILE.FID,[EDF.AS.spb,tmp_norr],datatyp);
                                C = C/EDF.AS.spb;
                                for k=1:length(InChanSelect), K=InChanSelect(k);
                                        S(idx0+(1:maxspr*C),k) = reshape(s(bi(K)+1:bi(K+1),:),maxspr*C,1); %RS%
                                end;
                                idx0 = idx0 + maxspr*C;
                                count=count+C;
                        end;
                        S=S(1:idx0,:);
                end;
                %AFIR%
                if EDF.SIE.AFIR
                        EDF.AFIR.xin=S(:,EDF.AFIR.channel1); 
                end;

                % Overflow Check for EDF-all same sampling rate
                if EDF.SIE.TH > 1,
                	for k=1:length(InChanSelect),K=InChanSelect(k);
				tmp = S(:,k);
		    		[y1,EDF.Block.z1{k}]=filter([1 -1],1,tmp,EDF.Block.z1{k});
            			[y2,EDF.Block.z2{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,y1==0,EDF.Block.z2{k});
            			%y2=y2>0.079*(EDF.SPR(k)/EDF.Dur);
            			[y3,EDF.Block.z3{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,(tmp>=EDF.SIE.THRESHOLD(K,2)) | (tmp<=EDF.SIE.THRESHOLD(K,1)),EDF.Block.z3{k});
            			%y3=y3>0.094*(EDF.SPR(k)/EDF.Dur);
				%OFCHK(bi(k)+1:bi(k+1),:) = (y3>0.094) | (y2>0.079);
				%OFCHK(:,K) = (y3>0.094) | (y2>0.079);
				S(y3>0.094 | y2>0.079, k) = NaN;

			end;
            	elseif EDF.SIE.TH,
                        for k=1:length(InChanSelect),K=InChanSelect(k);
                                %OFCHK(:,k)=(S(:,k) <= EDF.SIE.THRESHOLD(K,1)) | (S(:,K)>= EDF.SIE.THRESHOLD(K,2));
                                S(S(:,k) <= EDF.SIE.THRESHOLD(K,1) | S(:,k)>= EDF.SIE.THRESHOLD(K,2),k) = NaN;
                        end;
                        %OFCHK = OFCHK*abs(EDF.Calib([InChanSelect+1],:)~=0); %RS%
                end;

        else

                if ~OptiMEM % but OptiSPEED
                        [s, count]=fread(EDF.FILE.FID,[EDF.AS.spb,Records],datatyp);
                        count = (count/EDF.AS.spb);
                        S = zeros(maxspr*count,length(InChanSelect));
                        for k=1:length(InChanSelect), K=InChanSelect(k);
                                tmp=reshape(s(bi(K)+1:bi(K+1),:),EDF.SPR(K)*count,1);
                                if EDF.SPR(K) == maxspr
                                        S(:,k)=tmp;%reshape(tmp(:,ones(1,maxspr/EDF.SPR(K)))',maxspr*Records,1); %RS%
                                elseif EDF.SPR(K) > maxspr
                                        if rem(EDF.SPR(K)/maxspr,1)==0
                                                S(:,k)=rs(tmp,EDF.SPR(K),maxspr);
                                        else
                                                S(:,k)=rs(tmp,EDF.SIE.T); %(:,ones(1,maxspr/EDF.SPR(K)))',maxspr*Records,1); %RS%
                                        end;
                                elseif EDF.SPR(K) < maxspr
                                        S(:,k)=reshape(tmp(:,ones(1,maxspr/EDF.SPR(K)))',maxspr*count,1); %RS%
                                end;
                        end;    
                else %OptiMEM % but ~OptiSPEED
                        S = zeros(maxspr*Records,length(InChanSelect));
                        idx0=0; count=0;
                        for l=1:ceil(Records/MAX_BLOCK_NUMBER),
                        %while count < Records
                                tmp_norr = min(MAX_BLOCK_NUMBER,Records-count); % 16 = # of blocks read 
                                [s, C]=fread(EDF.FILE.FID,[EDF.AS.spb,tmp_norr],datatyp);
                                C = C/EDF.AS.spb;
                                for k=1:length(InChanSelect), K=InChanSelect(k); 
                                        tmp0=reshape(s(bi(K)+1:bi(K+1),:),EDF.SPR(K)*C,1);
                                        if EDF.SPR(K)==maxspr
                                                S(idx0+(1:maxspr*C),k)=tmp0;%reshape(tmp(:,ones(1,maxspr/EDF.SPR(K)))',maxspr*Records,1); %RS%
                                        elseif EDF.SPR(K)>maxspr
                                                if rem(EDF.SPR(K)/maxspr,1)==0
                                                        S(idx0+(1:maxspr*C),k)=rs(tmp0,EDF.SPR(K),maxspr);
                                                else
                                                        S(idx0+(1:maxspr*C),k)=rs(tmp0,EDF.SIE.T); %(:,ones(1,maxspr/EDF.SPR(K)))',maxspr*Records,1); %RS%
                                                end;
                                        elseif EDF.SPR(K)<maxspr
                                                S(idx0+(1:maxspr*C),k)=reshape(tmp0(:,ones(1,maxspr/EDF.SPR(K)))',maxspr*C,1); %RS%
                                        end;
                                end;
                                idx0 = idx0 + maxspr*C;
                                count= count+C;
                        end;
                        S=S(1:idx0,:);
                end;
                
                %AFIR%
                if EDF.SIE.AFIR
                        %EDF.AFIR.xin=S(:,find(EDF.AFIR.channel1==InChanSelect)); 
                        EDF.AFIR.xin=S(:,EDF.AFIR.channel1); 
                end;
                
                % Overflow Check for EDF with different sampling rates
                if EDF.SIE.TH > 1,
			fprintf(1,'Warning: this mode (FED) is not tested\n');
                	for k=1:length(InChanSelect),K=InChanSelect(k);
				tmp = S(:,k);
		    		[y1,EDF.Block.z1{k}]=filter([1 -1],1,tmp,EDF.Block.z1{k});
            			[y2,EDF.Block.z2{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,y1==0,EDF.Block.z2{k});
            			%y2=y2>0.079*(EDF.SPR(k)/EDF.Dur);
            			[y3,EDF.Block.z3{k}]=filter(ones(1,EDF.SPR(K)/EDF.Dur)/(EDF.SPR(K)/EDF.Dur),1,(tmp>=EDF.SIE.THRESHOLD(K,2)) | (tmp<=EDF.SIE.THRESHOLD(K,1)),EDF.Block.z3{k});
            			%y3=y3>0.094*(EDF.SPR(k)/EDF.Dur);
				%OFCHK(bi(k)+1:bi(k+1),:) = (y3>0.094) | (y2>0.079);
				%OFCHK(:,K) = (y3>0.094) | (y2>0.079);
				S((y3>0.094) | (y2>0.079),k) = NaN;
			end;
            	elseif EDF.SIE.TH,
                        for k=1:length(InChanSelect), K=InChanSelect(k);
                                %OFCHK(:,k)=(S(:,k) < EDF.SIE.THRESHOLD(K,1)) + (S(:,K)>= EDF.SIE.THRESHOLD(K,2));
                                S(S(:,k) < EDF.SIE.THRESHOLD(K,1) | S(:,k)>= EDF.SIE.THRESHOLD(K,2),k) = NaN;
                        end;
                end;
        end;
end;
end; % SDF

EDF.AS.numrec=count;
EDF.FILE.POS = EDF.AS.startrec + EDF.AS.numrec;
if EDF.AS.numrec~=Records, 
        fprintf(EDF.FILE.stderr,'Warning %s: %s only %i blocks instead of %i read\n',mfilename,EDF.FILE.Name,EDF.AS.numrec,Records);
end;

%%%%% Calibration of the signal 
if Mode_RAW 
        if ~EDF.FLAG.UCAL,          % Autocalib for RAW mode, 
                for k=1:EDF.NS,
                        S(bi(k)+1:bi(k+1),:)=S(bi(k)+1:bi(k+1),:)*EDF.Cal(k)+EDF.Off(k);
                end;
        end;
        % else % calibration is done in SREAD.M 
end;

%%%%% Removing ECG Templates
if EDF.SIE.TECG,
        if (EDF.AS.startrec+EDF.AS.numrec)~=(ftell(EDF.FILE.FID)-EDF.HeadLen)/EDF.AS.bpb;
                fprintf(EDF.FILE.stderr,'ERROR SDFREAD: Mode TECG requires update of EDF [S,EDF]=sdfread(EDF,...)\n');
                EDF=sdftell(EDF);
        end;
        pulse = zeros(EDF.AS.numrec*EDF.SPR(12),1);
        
        Index=[];
        while EDF.TECG.idx(EDF.TECG.idxidx) <= EDF.FILE.POS*EDF.SPR(12)
                Index=[Index EDF.TECG.idx(EDF.TECG.idxidx)-EDF.AS.startrec*EDF.SPR(12)];
                EDF.TECG.idxidx=EDF.TECG.idxidx+1;
        end;

        if ~isempty(Index)
                pulse(Index) = 1;
        end;
        
        %tmp=find(EDF.TECG.idx > EDF.AS.startrec*EDF.SPR(12) & EDF.TECG.idx <= EDF.FILE.POS*EDF.SPR(12));
        %if ~isempty(tmp)
        %        pulse(EDF.TECG.idx(tmp)-EDF.AS.startrec*EDF.AS.MAXSPR) = 1;
        %end;
        
        for i=1:size(S,2),
                [tmp,EDF.TECG.Z(:,i)] = filter(EDF.TECG.QRStemp(:,i),1,pulse,EDF.TECG.Z(:,i));
                S(:,i)=S(:,i)-tmp; % corrects the signal
        end;
end;

%%%%% Filtering
if EDF.SIE.FILT
        for k=1:size(S,2);
                [S(:,k),EDF.Filter.Z(:,k)]=filter(EDF.Filter.B,EDF.Filter.A,S(:,k),EDF.Filter.Z(:,k));
        end;
end;

%AFIR%
% Implements Adaptive FIR filtering for ECG removal in EDF/SDF-tb.
% based on the Algorithm of Mikko Koivuluoma <k7320@cs.tut.fi>
if EDF.SIE.AFIR
        e=zeros(size(S,1),length(EDF.AFIR.channel2));
        
        xinre2 = [EDF.AFIR.x EDF.AFIR.xin'];
        
        ddin=[EDF.AFIR.d; S]; %(:,EDF.AFIR.channel2)];
        
        for n=1:size(EDF.AFIR.xin,1),
                EDF.AFIR.x = xinre2(n + (EDF.AFIR.nord:-1:1)); % x(1:EDF.AFIR.nord-1)];
                
                y = EDF.AFIR.w * EDF.AFIR.x';
                
                en = EDF.AFIR.x * EDF.AFIR.x' + EDF.AFIR.gamma;
                e(n,:) = ddin(n,:) - y';
                
                EDF.AFIR.w = EDF.AFIR.w + (EDF.AFIR.alfa/en) * e(n,:)' * EDF.AFIR.x;
        end;
        EDF.AFIR.d = ddin(size(ddin,1)+(1-EDF.AFIR.delay:0),:);

        S=e; %output
	%S(:,EDF.AFIR.channel2) = e; %OUTPUT
end;

%%%%% select the correct seconds
if ~EDF.SIE.RAW & EDF.SIE.TimeUnits_Seconds 
        if NoR>0
                %EDF.Block,
                %[StartPos,StartPos+NoS,EDF.AS.startrec*EDF.Dur]
                if (StartPos < EDF.AS.startrec*EDF.AS.MAXSPR)
                        tmp = S(size(S,1)+(1-EDF.AS.MAXSPR:0),:);
                        
                        EDF.Block.number(3) = StartPos;
                        EDF.Block.number(4) = (StartPos+NoS);
                        
                        if ~isempty(EDF.Block.data);
                                S = [EDF.Block.data(floor(EDF.Block.number(3)-EDF.Block.number(1))+1:EDF.AS.MAXSPR,:); S(1:floor(EDF.Block.number(4)-EDF.AS.startrec*EDF.AS.MAXSPR),:)];
                        else
                        %        S = [S(1:floor(EDF.Block.number(4)-EDF.AS.startrec*EDF.AS.MAXSPR),:)];
                        end;
                        
                        EDF.Block.number(1:2)=(EDF.FILE.POS+[-1 0])*EDF.AS.MAXSPR;
                        EDF.Block.data = tmp;
                else
                        EDF.Block.number(3) = StartPos;
                        EDF.Block.number(4) = (StartPos+NoS);
                        EDF.Block.number(1:2)=(EDF.FILE.POS+[-1 0])*EDF.AS.MAXSPR;
                        EDF.Block.data = S(size(S,1)+(1-EDF.AS.MAXSPR:0),:);
                        
                        %[floor(EDF.Block.number(3)-EDF.AS.startrec*EDF.AS.MAXSPR)+ 1,floor(EDF.Block.number(4)-EDF.AS.startrec*EDF.AS.MAXSPR)],
                        S = S(floor(EDF.Block.number(3)-EDF.AS.startrec*EDF.AS.MAXSPR)+ 1:floor(EDF.Block.number(4)-EDF.AS.startrec*EDF.AS.MAXSPR),:);
                        %S = S(EDF.AS.MAXSPR/EDF.Dur*(rem(StartPos,EDF.Dur))+(1:NoR*EDF.AS.MAXSPR),:);
                end;
                
        else
                EDF.Block.number(3) = StartPos;
                EDF.Block.number(4) = (StartPos+NoS);
                EDF.Block.number(1:2)=(EDF.FILE.POS+[-1 0])*EDF.AS.MAXSPR;
                S = [EDF.Block.data(floor(EDF.Block.number(3)-EDF.Block.number(1))+1:floor(EDF.Block.number(4)-EDF.Block.number(1)),:)];
                %S = EDF.Block.data(floor(StartPos*EDF.AS.MAXSPR/EDF.Dur+1:floor((StartPos+NoS)*EDF.AS.MAXSPR/EDF.Dur),:)];
        end;
end;
%end;

%%%%% Resampling
if Mode_RS100 & ~Mode_RAW
        S=rs(S,EDF.SIE.T); %RS%
end;

%-------------------------------------------------------------------------------------------------%

function datatyp=gdfdatatype(x)
% GDFDATATYPE converts number into data type according to the definition of the GDF format [1]. 
%
% See also: SDFREAD, SREAD, SWRITE, SCLOSE
%
% References:
% [1] A. Schlögl, O. Filz, H. Ramoser, G. Pfurtscheller, GDF - A general dataformat for biosignals, Technical Report, 2004.
% available online at: http://www.dpmi.tu-graz.ac.at/~schloegl/matlab/eeg/gdf4/TR_GDF.pdf. 

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

%	$Revision: 1.5 $
%	$Id: gdfdatatype.m,v 1.5 2004/09/24 18:01:12 schloegl Exp $
%	(C) 1997-2004 by Alois Schloegl <a.schloegl@ieee.org>	
%    	This is part of the BIOSIG-toolbox http://biosig.sf.net/


if ischar(x),
        datatyp=x;
        return; 
end;

k=1;
EDF.GDFTYP(1)=x;
if EDF.GDFTYP(k)==0
        datatyp=('uchar');
elseif EDF.GDFTYP(k)==1
        datatyp=('int8');
elseif EDF.GDFTYP(k)==2
        datatyp=('uint8');
elseif EDF.GDFTYP(k)==3
        datatyp=('int16');
elseif EDF.GDFTYP(k)==4
        datatyp=('uint16');
elseif EDF.GDFTYP(k)==5
        datatyp=('int32');
elseif EDF.GDFTYP(k)==6
        datatyp=('uint32');
elseif EDF.GDFTYP(k)==7
        datatyp=('int64');
elseif EDF.GDFTYP(k)==8
        datatyp=('uint64');
elseif EDF.GDFTYP(k)==16
        datatyp=('float32');
elseif EDF.GDFTYP(k)==17
        datatyp=('float64');
elseif EDF.GDFTYP(k)==256
        datatyp=('bit1');
elseif EDF.GDFTYP(k)==512
        datatyp=('ubit1');
elseif EDF.GDFTYP(k)==255+12
        datatyp=('bit12');
elseif EDF.GDFTYP(k)==511+12
        datatyp=('ubit12');
elseif EDF.GDFTYP(k)==255+22
        datatyp=('bit22');
elseif EDF.GDFTYP(k)==511+22
        datatyp=('ubit22');
elseif EDF.GDFTYP(k)==255+24
        datatyp=('bit24');
elseif EDF.GDFTYP(k)==511+24
        datatyp=('ubit24');
%elseif EDF.GDFTYP(k)>255 & EDF.GDFTYP(k)< 256+64
%        datatyp=(['bit' int2str(EDF.GDFTYP(k)-255)]);
%elseif EDF.GDFTYP(k)>511 & EDF.GDFTYP(k)< 511+64
%        datatyp=(['ubit' int2str(EDF.GDFTYP(k)-511)]);
else 
        fprintf(2,'Error GDFREAD: Invalid GDF channel type\n');
        datatyp='';
end;
