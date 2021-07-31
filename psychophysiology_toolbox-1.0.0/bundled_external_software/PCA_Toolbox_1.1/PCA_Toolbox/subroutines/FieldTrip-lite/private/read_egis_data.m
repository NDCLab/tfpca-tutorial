function dat = read_egis_data(filename, hdr, begtrial, endtrial, chanindx);

% READ_EGIS_DATA reads the data from an EGI EGIS format file
%
% Use as
%   dat = read_egis_data(filename, hdr, begtrial, endtrial, chanindx);
% where
%   filename       name of the input file
%   hdr            header structure, see READ_HEADER
%   begtrial       first trial to read, mutually exclusive with begsample+endsample
%   endtrial       last trial to read,  mutually exclusive with begsample+endsample
%   chanindx       list with channel indices to read
%
% This function returns a 3-D matrix of size Nchans*Nsamples*Ntrials.
% Note that EGIS session files are defined as always being epoched.
% For session files the trials are organized with the members of each cell grouped
% together.  For average files the "trials" (subjects) are organized with the cells
% also grouped together (e.g., "cell1sub1, cell1sub2, ...).
%_______________________________________________________________________
%
%
% Modified from EGI's EGI Toolbox with permission 2007-06-28 Joseph Dien

% $Log: read_egis_data.m,v $
% Revision 1.3  2007/12/20 08:21:22  roboos
% changed from returning a 2d to a 3d matrix, thanks to Joseph
%
% Revision 1.2  2007/07/16 07:24:40  roboos
% only read the desired trials, updated documentation
%
% Revision 1.1  2007/07/04 13:22:06  roboos
% initial implementation by Joseph Dien with some corrections by Robert
%


fh=fopen([filename],'r');
if fh==-1
    error('wrong filename')
end
fclose(fh);

[fhdr,chdr,ename,cnames,fcom,ftext] = read_egis_header(filename);
fh=fopen([filename],'r');
fhdr(1)=fread(fh,1,'int32'); %BytOrd
[str,maxsize,cEndian]=computer;
if fhdr(1)==16909060
    if cEndian == 'B'
        endian = 'ieee-be';
    elseif cEndian == 'L'
        endian = 'ieee-le';
    end;
elseif fhdr(1)==67305985
    if cEndian == 'B'
        endian = 'ieee-le';
    elseif cEndian == 'L'
        endian = 'ieee-be';
    end;
else
    error('This is not an EGIS average file.');
end;

if fhdr(2) == -1
    fileType = 'ave';
elseif fhdr(2) == 3
    fileType = 'ses';
else
    error('This is not an EGIS file.');
end;

fseek(fh, fhdr(3)+((begtrial-1)*hdr.nChans*hdr.nSamples*2), 'bof');
for segment=1:(endtrial-begtrial+1)
    dat(:,:,segment) = fread(fh, [hdr.nChans, hdr.nSamples],'int16',endian);
end
dat=dat(chanindx, :,:);

if fileType == 'ave'
    dat=dat/fhdr(12); %convert to microvolts
elseif fileType == 'ses'
    dat=dat/5; %convert to microvolts (EGIS sess files created by NetStation use a 5 bins per microvolt scaling)
end;

fclose(fh);
