function [cnt,head,elec,event] = bdf2mat(infile,outfile,scale2uV,verbose),
% [cnt,head,elec,event] = bdf2mat(infile[,outfile][,scale2uV][,verbose])  
% 
%  infile         Biosemi 24-bit continuous binary data file 
% 
%  outfile        matlab format of the data (leave empty to suppress outfile)  
%  
%  scale2uV       0=no 1=yes, (default 1 if omitted)  
%                 (unscaled data can be rescaled to uV later using bdf2mat_scale2uV)
% 
%  verbose        1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
% 
%  Variables produced (saved in outfile if specified):
%
%      cnt    - continuous EEG data 
%          cnt.data     - trials, waveforms in rows
%          cnt.elec     - elec number
%          cnt.elecname - electrode names 
%          cnt.event    - event vector (trigger value in bin; no event = -1) 
%
%          cnt.elecnames       - electrode names - row # = elecnumber   
%          cnt.samplerate      - samplreate  
%          cnt.original_format - label of original binary format  
% 
%      elec   - detail about electrodes (e.g. names -- elec.lab)
%      event  - detail about events 
%      head   - detail about about data file (e.g. A/D rate)
% 
%      NOTE: elec and head are needed for bdf2mat_scale2uV  
%
%  Units - int24 are stored as int32, data is converted to  
%          uVolts during conversion if scale2uV = 1 
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 

  % input parameters 
  if exist('scale2uV')      ==0, scale2uV    = 1; end
  if exist('verbose')       ==0, verbose       = 0; end

  % main 
  if verbose>=1, disp(['Opening file: ' infile]); end  
  EDF = openbdf(infile);

  if verbose>=1, disp(['reading in continuous data ... ' ]); end 
 %if scale2uV==1, 
    [DAT,signal]=readbdf(EDF,[1:EDF.Head.NRec],0);
 %else, 
 %  [DAT,signal]=readbdf(EDF,[1:EDF.Head.NRec],1);
 %end 

  if verbose>=1, disp(['Parsing header into relevant variables ... ' ]); end 
  cnt.data = DAT.Record; 
  cnt.elec = [1:length(cnt.data(:,1))]'; 
  cnt.event = double(cnt.data(strmatch('Status',DAT.Head.Label),:)); 
  cnt.elecnames = DAT.Head.Label; 
  cnt.samplerate = max(DAT.Head.SampleRate); 
  cnt.original_format = 'bdf-cnt'; 

  head = DAT.Head; 
  elec = DAT.Head; 
  event = 'event information generally stored in Status channel for BDF files'; 

  % Scale to Microvolts 
  if scale2uV == 1,
    cnt=bdf2mat_scale2uV(cnt,head,elec,verbose); 
  else,
    cnt.scaled2uV = 0;
  end

  % CLOSE and SAVE 
  
  if exist('outfile','var')==1 & isempty(outfile)==0, 
    if verbose>=1, disp(['message: Saving file: ' outfile ' ... ']); end
    save(outfile,'head','elec','sweep','erp');
  end

function [DAT,H1]=openbdf(FILENAME)
% EDF=openedf(FILENAME)
% Opens an EDF File (European Data Format for Biosignals) in MATLAB (R)
% <A HREF="http://www.medfac.leidenuniv.nl/neurology/knf/kemp/edf.htm">About EDF</A> 

%	Copyright (C) 1997-1998 by Alois Schloegl
%	a.schloegl@ieee.org
%	Ver 2.20 	18.Aug.1998
%	Ver 2.21 	10.Oct.1998
%	Ver 2.30 	 5.Nov.1998
%
%	For use under Octave define the following function
% function s=upper(s); s=toupper(s); end;

% V2.12    Warning for missing Header information  
% V2.20    EDF.AS.* changed
% V2.30    EDF.T0 made Y2K compatible until Year 2090

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the  License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
% Name changed Sept 6,2002  T.S. Lorig

SLASH='/';		% defines Seperator for Subdirectories
BSLASH=setstr(92);

cname=computer;
if cname(1:2)=='PC' SLASH=BSLASH; end;

fid=fopen(FILENAME,'r','ieee-le');          
if fid<0 
	fprintf(2,['Error LOADEDF: File ' FILENAME ' not found\n']);  
	return;
end;

EDF.FILE.FID=fid;
EDF.FILE.OPEN = 1;
EDF.FileName = FILENAME;

PPos=min([max(find(FILENAME=='.')) length(FILENAME)+1]);
SPos=max([0 find((FILENAME=='/') | (FILENAME==BSLASH))]);
EDF.FILE.Ext = FILENAME(PPos+1:length(FILENAME));
EDF.FILE.Name = FILENAME(SPos+1:PPos-1);
if SPos==0
	EDF.FILE.Path = pwd;
else
	EDF.FILE.Path = FILENAME(1:SPos-1);
end;
EDF.FileName = [EDF.FILE.Path SLASH EDF.FILE.Name '.' EDF.FILE.Ext];

H1=setstr(fread(EDF.FILE.FID,256,'char')');     %
EDF.VERSION=H1(1:8);                     % 8 Byte  Versionsnummer 
%if 0 fprintf(2,'LOADEDF: WARNING  Version EDF Format %i',ver); end;
EDF.PID = deblank(H1(9:88));                  % 80 Byte local patient identification
EDF.RID = deblank(H1(89:168));                % 80 Byte local recording identification
%EDF.H.StartDate = H1(169:176);         % 8 Byte		
%EDF.H.StartTime = H1(177:184);         % 8 Byte		
EDF.T0=[str2num(H1(168+[7 8])) str2num(H1(168+[4 5])) str2num(H1(168+[1 2])) str2num(H1(168+[9 10])) str2num(H1(168+[12 13])) str2num(H1(168+[15 16])) ];

% Y2K compatibility until year 2090
if EDF.VERSION(1)=='0'
        if EDF.T0(1) < 91
                EDF.T0(1)=2000+EDF.T0(1);
        else
                EDF.T0(1)=1900+EDF.T0(1);
        end;
else ;
        % in a future version, this is hopefully not needed   
end;

EDF.HeadLen = str2num(H1(185:192));  % 8 Byte  Length of Header
% reserved = H1(193:236);	         % 44 Byte		
EDF.NRec = str2num(H1(237:244));     % 8 Byte  # of data records
EDF.Dur = str2num(H1(245:252));      % 8 Byte  # duration of data record in sec
EDF.NS = str2num(H1(253:256));       % 8 Byte  # of signals

EDF.Label = setstr(fread(EDF.FILE.FID,[16,EDF.NS],'char')');		
EDF.Transducer = setstr(fread(EDF.FILE.FID,[80,EDF.NS],'char')');	
EDF.PhysDim = setstr(fread(EDF.FILE.FID,[8,EDF.NS],'char')');	

EDF.PhysMin= str2num(setstr(fread(EDF.FILE.FID,[8,EDF.NS],'char')'));	
EDF.PhysMax= str2num(setstr(fread(EDF.FILE.FID,[8,EDF.NS],'char')'));	
EDF.DigMin = str2num(setstr(fread(EDF.FILE.FID,[8,EDF.NS],'char')'));	%	
EDF.DigMax = str2num(setstr(fread(EDF.FILE.FID,[8,EDF.NS],'char')'));	%	

% check validity of DigMin and DigMax
if (length(EDF.DigMin) ~= EDF.NS)
        fprintf(2,'Warning OPENEDF: Failing Digital Minimum\n');
        EDF.DigMin = -(2^15)*ones(EDF.NS,1);
end
if (length(EDF.DigMax) ~= EDF.NS)
        fprintf(2,'Warning OPENEDF: Failing Digital Maximum\n');
        EDF.DigMax = (2^15-1)*ones(EDF.NS,1);
end
if (any(EDF.DigMin >= EDF.DigMax))
        fprintf(2,'Warning OPENEDF: Digital Minimum larger than Maximum\n');
end  
% check validity of PhysMin and PhysMax
if (length(EDF.PhysMin) ~= EDF.NS)
        fprintf(2,'Warning OPENEDF: Failing Physical Minimum\n');
        EDF.PhysMin = EDF.DigMin;
end
if (length(EDF.PhysMax) ~= EDF.NS)
        fprintf(2,'Warning OPENEDF: Failing Physical Maximum\n');
        EDF.PhysMax = EDF.DigMax;
end
if (any(EDF.PhysMin >= EDF.PhysMax))
        fprintf(2,'Warning OPENEDF: Physical Minimum larger than Maximum\n');
        EDF.PhysMin = EDF.DigMin;
        EDF.PhysMax = EDF.DigMax;
end  
EDF.PreFilt= setstr(fread(EDF.FILE.FID,[80,EDF.NS],'char')');	%	
tmp = fread(EDF.FILE.FID,[8,EDF.NS],'char')';	%	samples per data record
EDF.SPR = str2num(setstr(tmp));	%	samples per data record

fseek(EDF.FILE.FID,32*EDF.NS,0);

EDF.Cal = (EDF.PhysMax-EDF.PhysMin)./ ...
    (EDF.DigMax-EDF.DigMin);
EDF.Off = EDF.PhysMin - EDF.Cal .* EDF.DigMin;
tmp = find(EDF.Cal < 0);
EDF.Cal(tmp) = ones(size(tmp));
EDF.Off(tmp) = zeros(size(tmp));

EDF.Calib=[EDF.Off';(diag(EDF.Cal))];
%EDF.Calib=sparse(diag([1; EDF.Cal]));
%EDF.Calib(1,2:EDF.NS+1)=EDF.Off';

EDF.SampleRate = EDF.SPR / EDF.Dur;

EDF.FILE.POS = ftell(EDF.FILE.FID);
if EDF.NRec == -1   % unknown record size, determine correct NRec
  fseek(EDF.FILE.FID, 0, 'eof');
  endpos = ftell(EDF.FILE.FID);
  EDF.NRec = floor((endpos - EDF.FILE.POS) / (sum(EDF.SPR) * 2));
  fseek(EDF.FILE.FID, EDF.FILE.POS, 'bof');
  H1(237:244)=sprintf('%-8i',EDF.NRec);      % write number of records
end; 

EDF.Chan_Select=(EDF.SPR==max(EDF.SPR));
for k=1:EDF.NS
	if EDF.Chan_Select(k)
	    EDF.ChanTyp(k)='N';
	else
	    EDF.ChanTyp(k)=' ';
	end;         
	if findstr(upper(EDF.Label(k,:)),'ECG')
	    EDF.ChanTyp(k)='C';
	elseif findstr(upper(EDF.Label(k,:)),'EKG')
	    EDF.ChanTyp(k)='C';
	elseif findstr(upper(EDF.Label(k,:)),'EEG')
	    EDF.ChanTyp(k)='E';
	elseif findstr(upper(EDF.Label(k,:)),'EOG')
	    EDF.ChanTyp(k)='O';
	elseif findstr(upper(EDF.Label(k,:)),'EMG')
	    EDF.ChanTyp(k)='M';
	end;
end;

EDF.AS.spb = sum(EDF.SPR);	% Samples per Block
bi=[0;cumsum(EDF.SPR)]; 

idx=[];idx2=[];
for k=1:EDF.NS, 
	idx2=[idx2, (k-1)*max(EDF.SPR)+(1:EDF.SPR(k))];
end;
maxspr=max(EDF.SPR);
idx3=zeros(EDF.NS*maxspr,1);
for k=1:EDF.NS, idx3(maxspr*(k-1)+(1:maxspr))=bi(k)+ceil((1:maxspr)'/maxspr*EDF.SPR(k));end;

%EDF.AS.bi=bi;
EDF.AS.IDX2=idx2;
%EDF.AS.IDX3=idx3;


DAT.Head=EDF;  
DAT.MX.ReRef=1;

%DAT.MX=feval('loadxcm',EDF);

return;
function [DAT,S]=readbdf(DAT,Records,Mode)
% [DAT,signal]=readedf(EDF_Struct,Records)
% Loads selected Records of an EDF File (European Data Format for Biosignals) into MATLAB
% <A HREF="http://www.medfac.leidenuniv.nl/neurology/knf/kemp/edf.htm">About EDF</A> 
%
% Records1	List of Records for Loading
% Mode		0 	default
%		1 	No AutoCalib
%		Mode+2	Concatanated (channels with lower sampling rate if more than 1 record is loaded)

%	Version 2.11
%	03.02.1998
%	Copyright (c) 1997,98 by Alois Schloegl
%	a.schloegl@ieee.org	
                      
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the  License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program has been modified from the original version for .EDF files
% The modifications are to the number of bytes read on line 53 (from 2 to
% 3) and to the type of data read - line 54 (from int16 to bit24). Finally the name
% was changed from readedf to readbdf
% T.S. Lorig Sept 6, 2002
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3 Mode=0; end;
 
EDF=DAT.Head; 
RecLen=max(EDF.SPR);

S=NaN*zeros(RecLen,EDF.NS);
if rem(Mode,2)==0       % Autocalib
  DAT.Record=      zeros(length(Records)*RecLen,EDF.NS); 
else, 
  DAT.Record=int32(zeros(length(Records)*RecLen,EDF.NS)); 
end 
DAT.Valid=uint8(zeros(1,length(Records)*RecLen));
DAT.Idx=Records(:)';
        
for nrec=1:length(Records),

	NREC=(DAT.Idx(nrec)-1);
	if NREC<0 fprintf(2,'Warning READEDF: invalid Record Number %i \n',NREC);end;

	fseek(EDF.FILE.FID,(EDF.HeadLen+NREC*EDF.AS.spb*3),'bof');
	[s, count]=fread(EDF.FILE.FID,EDF.AS.spb,'bit24');

	S(EDF.AS.IDX2)=s;

	%%%%% Test on  Over- (Under-) Flow
%	V=sum([(S'==EDF.DigMax(:,ones(RecLen,1))) + (S'==EDF.DigMin(:,ones(RecLen,1)))])==0;
	V=sum([(S(:,EDF.Chan_Select)'>=EDF.DigMax(EDF.Chan_Select,ones(RecLen,1))) + ...
	       (S(:,EDF.Chan_Select)'<=EDF.DigMin(EDF.Chan_Select,ones(RecLen,1)))])==0;
	EDF.ERROR.DigMinMax_Warning(find(sum([(S'>EDF.DigMax(:,ones(RecLen,1))) + (S'<EDF.DigMin(:,ones(RecLen,1)))]')>0))=1;
	%	invalid=[invalid; find(V==0)+l*k];
                             
	if floor(Mode/2)==1
		for k=1:EDF.NS,
			DAT.Record(nrec*EDF.SPR(k)+(1-EDF.SPR(k):0),k)=S(1:EDF.SPR(k),k);
		end;
	else
		DAT.Record(nrec*RecLen+(1-RecLen:0),:)=S;
	end;

	DAT.Valid(nrec*RecLen+(1-RecLen:0))=V;
end;
if rem(Mode,2)==0	% Autocalib
	DAT.Record=[ones(RecLen*length(Records),1) DAT.Record]*EDF.Calib;
end;                   

DAT.Record=DAT.Record';
return;         

