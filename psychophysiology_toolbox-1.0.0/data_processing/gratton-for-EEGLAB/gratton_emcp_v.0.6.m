%
% gratton_emcp() - Run the eye movement correction procedure developed
%                  by Gratton, Coles, and Donchin (1983) on an epoched eeglab
%                  dataset.
% Usage:
%   >> OUT_EEG = gratton_emcp( EEG, selection_cards, eog_channel_pairs )
%
% Required Inputs:
%
%   EEG                 - input epoched EEG dataset
%   selection_cards     - [cell array of strings] specifying averaging bins (see below)
%   eog_channel_pairs   - [cell array of strings] one or more EOG channels or pairs of channels,
%                                                 the first of which records blinks (see below)
%
% Output%
%
%   OUT_EEG             - corrected EEG dataset, including new structure EEG.emcp with diagnostic information
%
%  Examples:
%
%  1. Performs traditional Gratton emcp with one vertical bipolar and one horizontal bipolar EOG channel:
%
%    selection_cards =  {'1 2','3 4', '5 6','7 8'};
%    EEG = gratton_emcp(EEG,selection_cards,{'VEOG'},{'HEOG'});
%
%  2. Performs traditional Gratton emcp with vertical and horizontal channels derived from monopolar recordings:
%
%    selection_cards =  {'1 2','3 4', '5 6','7 8'};
%    EEG = gratton_emcp(EEG,selection_cards,{'LVEOGUP','LVEOGLO'},{'HEOGL','HEOGR'});
%
%  3. Regression has three EOG channels: left vertical, horizontal, right vertical:
%
%    selection_cards =  {'1 2','3 4', '5 6','7 8'};
%    EEG = gratton_emcp(EEG,selection_cards,{'LVEOGUP','LVEOGLO'},{'HEOGL','HEOGR'},{'RVEOGUP','RVEOGLO'});
%
%  4. First channel in the regression is vertical EOG consisting of the average of left and right vertical channels:
%
%    selection_cards =  {'1 2','3 4', '5 6','7 8'};
%    EEG = gratton_emcp(EEG,selection_cards,{'LVEOGUP RVEOGUP','LVEOGLO REOGLO'},{'HEOGL','HEOGR'});
%
%  5. Correct for a single EOG channel (must be a bipolar vertical channel, corrects only blinks and vertical EOG)
%
%    selection_cards =  {'1 2','3 4', '5 6','7 8'};
%    EEG = gratton_emcp(EEG,selection_cards,{'VEOG'});
%
%
%
%  A structure EEG.emcp containing diagnostic information is added to output EEG dataset. Example:
%
%          bintotals: [0 0 80 80]       - number matching each selection card
%              table: [91x40 char]      - easy-to-read table of diagnostic information
%          markblink: [512x321 logical] - which data points (pts x epochs) are blinks
%      blink_factors: [72x2 double]     - propagation factors for blinks
%    saccade_factors: [72x2 double]     - propagation factors for saccades
%     regress_blinks: 11773             - number of blink points in regression
%   regress_saccades: 70147             - number of saccade points in regression
% regress_propblinks: 0.1437            - blink proportion in regression
%     overall_blinks: 23943             - number of blink points in all data
%   overall_saccades: 140409            - number of saccade points in all data
% overall_propblinks: 0.1457            - blink proportion in all data
%
% Author:
%
%   Bill Gehring, University of Michigan
%   Version 0.1, July 2007, Initial version
%   Version 0.2, July 2007, Added capability for multiple EOG channels and average EOG channels
%   Version 0.3, 2007-Jul    - Add checks for zero blinks and zero saccades,
%                            - Performance tuning, including bsxfun for ver >= R2007a
%   Version 0.4, 2007-Aug-07 - Change to symmetrical blink template, a la
%                              original emcp (set EMCPX to 0, see below)
%   Version 0.5 September 2008, rounding error fixed in calculating msTen, bsxfun removed
%   Version 0.6 June 2012, clean up some stuff to share code for Emily K,
%   use length (EEG.chanlocs) instead of size(EEG.chanlocs,2) because of
%   inconsistent dimensions in different versions of EEGLAB
%
%   Based on the algorithm reported in:
%

%	Gratton, G., Coles, M. G. H., & Donchin, E. (1983).  A new method for
%	off-line removal of ocular artifact.  Electroencephalography and
%	Clinical Neurophysiology, 55, 468-484.  (Reports the original algorithm
%	for one channel of vertical EOG).
%

%	Miller, G. A., Gratton, G., & Yee, C. M. (1988).  Generalized
%	implementation of an eye movement correction procedure.
%	Psychophysiology, 25, 241-243. (Reports a distribution of this program
%	for the RT11 operating system FORTRAN IV that corrects for vertical EOG
%	and horizontal EOG.)
%

%   Derived from the original C code developed at the University of
%   Illinois Cognitive Psychophysiology Laboratory, available at
%   http://www.umich.edu/~wgehring/emcp2001.zip.
%
%  Notes:
%

%  What is a selection card?  Selection cards (yes, they used to be paper
%  cards) identify epochs according to time-locking events (i.e.,
%  EEG.epoch.eventtypes that have latency of 0). Epochs identified by a
%  selection card are used to create an average waveform, and those
%  averages are subtracted from each single trial before correction factors
%  are computed.  The aim of this is so that the correction factors are not
%  affected by event-related activity (real ERPs).  In practice, you want
%  to choose averages that will differ meaningfully, so if you have an
%  oddball task where trial type 1 is frequent and trial type 2 is
%  infrequent, you should have separate selection cards for trial types 1
%  and 2.  Before the regression is performed, all EEG epochs with trial
%  type 1 will have the frequent average subtracted.
%
%  In the example shown above, four averages are computed. The syntax is
%  that trial types between single quotes are OR'd together, so the first
%  selection card will match any epoch with the time-locking event 1 or 2.
%
%  Epochs that do not match a selection card are not used in calculating
%  the regression, but those data are corrected (using the correction
%  factors used on the other data).  This is useful if you have separate
%  stimulus-locked and response-locked epochs from the same trial. You can
%  specify selection cards only for the stimulus-locked epochs, which
%  ensures that each data point is only used once in the regression.
%
%  Assumptions of the procedure:
%
%  1) The EEG dataset must have at least one channel that can be used to derive

%     vertical EOG.
%
%  2) The epochs identified by the selection cards should be
%     non-overlapping, otherwise data points will be used more than once in
%     computing the regression.
%
%  3) EEG data are already scaled in microVolts.
%
%  4) The datafile is epoched.
%
%  Differences from original Gratton procedure:
%
%  In the case where each epoch matches one selection card and there is
%  one vertical and ine horizontal EOG channel, the output from this
%  function should match the emcpx C code output from the Cognitive
%  Psychophysiology Laboratory at Illinois. (see
%  http://www.umich.edu/~wgehring/emcp2001.zip).
%

%  "Trash data" are data epochs that do not match one of the selection
%  cards. All epochs in the data file are corrected, even those that don't
%  match a selection card. If there are such trash data in the input EEG
%  data, the output of this function will be slightly different from the
%  Illinois C program as the C code used trash data epochs to compute the
%  variance but left the trash data out of other computations.  Greg
%  Miller's FORTRAN code (which more closely corresponds to Gratton's
%  original FORTRAN code) used the trash data in all steps of computing the
%  regression. Thus, it is unclear whether the use of the trash data in the
%  C code for one step of the procedure but not for others was a desired
%  feature.  In any case, the trash data play no role in computing the
%  correction factors in the present function. Modern epoched datasets can
%  be time-locked to any event (e.g., stimulus, response), so computing a
%  single average across such hetereogeneous events and subtracting it from
%  single trials does not make sense. Leaving the trash data out also
%  allows the desirable feature in which certain data are excluded from
%  computing the correction factors.
%

%  The function does not do the following things that the original code
%  did:
%

%  1. The original Gratton code checked for data out of scale and flat
%     lines and discarded those trials.
%
%  2. In some cases it tried to reconstruct the blink on the VEOG channel
%     when data on the channel went out of scale.  (Because of #1 and #2,
%     artifact rejection and other data screening should take place prior to
%     emcp, because the procedure is sensitive to bad data.)
%


%  3. The emcpx version of emcp used a slightly asymmetrical blink template.
%     Miller's original Fortran code used a symmetrical template, this version
%     returns to using a symmetrical template.  (The asymmetrical template would
%     not produce equivalent results at different sampling rates.)
%

%  4. The emcp algorithm identifies a blink based on a blink template. The first point
%     that can be tagged as a blink is therefore the first one that falls in the middle of
%     the template when the first point of the template is compared with the first point of
%     the data. Thus if the template is 63 datapoints, the first point is 32 (the middle).  By
%     this logic, the final point checked should also fall in the middle of the template
%     when the last point of the template corresponds to the last point of the data.  For a
%     512 point waveform, that would mean 512-63+32 = 481. However, the emcpx and
%     and Miller versions stopped 1/3 of a blink prior to this (at 460 in this example). The
%     present version assumes that the amount of unchecked data at the beginning of the
%     waveform should be the same as at the end, i.e. 1/2 of the template (481 in the example).
%
%     If EMCPX is set to 1, the changes in #3 and #4 above are reversed so that the output
%     should correspond exactly to the output of the emcpx C code.
%

function EEG = gratton_emcp_share(EEG, selection_cards, varargin)
%
tic;
starttime = cputime;
if nargin < 3
    disp(['syntax error'])
    disp([' syntax: EEG = gratton_emcp(EEG, selection_cards, eog_channel_pairs)']);
    disp(['example: EEG = gratton_emcp(EEG,{''1 2'',''3 4''},{''LVEOGUP'',''LVEOGLO''},{''HEOGR'',''HEOGL''})']);
    return
end
if EEG.trials == 1
    error('EEG dataset must be epoched');
    return
end
disp('gratton_emcp(): Correcting data for eye movement artifacts')
for i = 1:length(varargin)
    chanpair{i} = varargin{i};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Determine which channels to use for EOG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[electrodes{1:length(EEG.chanlocs)}] = deal(EEG.chanlocs.labels);
electrodes = electrodes';

EEGdata = zeros(EEG.nbchan + length(chanpair),EEG.pnts,EEG.trials);
table_label=cell(1,length(chanpair));
for i = 1:length(chanpair)
    if length(chanpair{i}) > 2
        error('too many channel labels')
        return
    end
    for chans=1:length(chanpair{i})
        [LABEL1, LABEL2] = strtok(chanpair{i}{chans});  % parse the string
        if ~isempty(strtrim(LABEL2))  %if there was > one label in the string, take the average
            [s,r] = strtok(strtrim(LABEL2));
            if ~isempty(r)
                error('too many channel labels')
                return
            end
            chan1 = find(strcmpi(electrodes,LABEL1));
            chan2 = find(strcmpi(electrodes,strtrim(LABEL2)));
            % create subtracted channels
            EOGCHAN{i}{chans} = (EEG.data(chan1,:,:)+ EEG.data(chan2,:,:))/2;
            EOGLABEL{i}{chans} = ['mean(' LABEL1 ',' strtrim(LABEL2) ')'];
        else
            if(~isempty(strtok(LABEL2)))
                error('too many channel labels')
                return
            else
                chan1 = find(strcmpi(electrodes,LABEL1));
                EOGCHAN{i}{chans} = EEG.data(chan1,:,:);
            end
            EOGLABEL{i}{chans} = LABEL1;
        end
    end
    if length(chanpair{i}) == 2   %subtract if there are two
        EOGCHAN{i}{1} = EOGCHAN{i}{1} - EOGCHAN{i}{2};
        table_label{i} = [strtrim(EOGLABEL{i}{1}) '-' strtrim(EOGLABEL{i}{2})];
    else  %channel data already derived
        table_label{i} = strtrim(EOGLABEL{i}{1});
    end
    EEGdata(i,:,:) = EOGCHAN{i}{1};
end
EEGdata(length(chanpair)+1:end,:,:) = EEG.data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Identify blinks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Compute blink template information based on epoched data
parameters.trialLength = EEG.pnts;
blinkCriteria = 14.0*1.0;  %  slope
msTen = round(10.0/(1000/EEG.srate));   %rounding error fixed Sept 2008
thirdOfBlink = msTen*7;  %third of blink is 70 ms
if ~mod(thirdOfBlink,2)
    thirdOfBlink = thirdOfBlink + 1;  %force odd
end
middleOfBlink = round((thirdOfBlink+1)/2);  %point # for template center
lengthOfWind = thirdOfBlink*3.0;  % length of blink window 210 ms
initBlinkScan = thirdOfBlink + middleOfBlink;  %first point for scan

EMCPX = 1
if EMCPX
    endBlinkScan = EEG.pnts - initBlinkScan - thirdOfBlink + 1;  %last point to scan
else
    endBlinkScan = EEG.pnts - thirdOfBlink - middleOfBlink + 1;  %last point to scan  -- better???????
 end
windVariance = 2.0;
markBlink = false(EEG.pnts,EEG.trials);
covariance = zeros(EEG.pnts,EEG.trials);

for pt = initBlinkScan:endBlinkScan
    if EMCPX   %asymmetrical template
        start1 = pt - initBlinkScan+1;  %1  this puts pt in the middle of the template
        end1 = start1 + thirdOfBlink;   %22
        start2 = end1 + 1; %23
        end2 = start1 + 2 * thirdOfBlink; %43
        start3 = end2+1;  %44
        end3 = pt + initBlinkScan-1;  %63
        covariance(pt,:) = covariance(pt,:) - squeeze(sum(EEGdata(1,start1:end1,:),2))';
        covariance(pt,:) = covariance(pt,:) + 2 * squeeze(sum(EEGdata(1,start2:end2,:),2))';
        covariance(pt,:) = covariance(pt,:) - squeeze(sum(EEGdata(1,start3:end3,:),2))';
    else      %symmetrical template
        start1 = pt - initBlinkScan+1;  %1
        end1 = start1 + thirdOfBlink - 1;  %21
        start2 = end1 + 1; %22
        end2 = start1 + 2 * thirdOfBlink - 1; %42
        start3 = end2+1;  %43
        end3 = start1 + 3 * thirdOfBlink - 1;  %63
        covariance(pt,:) = covariance(pt,:) - squeeze(sum(EEGdata(1,start1:end1,:),2))';
        covariance(pt,:) = covariance(pt,:) + 2 * squeeze(sum(EEGdata(1,start2:end2,:),2))';
        covariance(pt,:) = covariance(pt,:) - squeeze(sum(EEGdata(1,start3:end3,:),2))';
    end

end

covariance = covariance/lengthOfWind;
slope = covariance/(windVariance*windVariance);
markBlink = logical(zeros(EEG.pnts,EEG.trials));
for pt = initBlinkScan:endBlinkScan
    for tr = 1:EEG.trials
        if(abs(slope(pt,tr))>blinkCriteria)
            markBlink(pt-middleOfBlink+1:pt+middleOfBlink-1,tr) = 1;
        end
    end
end
for tr = 1:EEG.trials
    for ch=1:EEG.nbchan+length(chanpair)
        % subtract mean of each waveform from the wavefrom
        EEGdata(ch,:,tr) = EEGdata(ch,:,tr) - mean(EEGdata(ch,:,tr));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Match epochs to selection cards
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
binned_indices = [];
for cards=1:length(selection_cards)
    binEEG(cards).indices =  eeg_getepochevent(EEG, strread(selection_cards{cards},'%s'));

    binEEG(cards).subindices = find(binEEG(cards).indices == 0);
    % used later on to determine which bin a trial falls under:
    EEG.emcp.bintotals(cards) = length(binEEG(cards).subindices);
    if length(binEEG(cards).subindices) > 0
        binned_indices = cat(2,binned_indices,binEEG(cards).subindices);
        binEEG(cards).EEGavg = mean(EEGdata(:,:,binEEG(cards).subindices),3);
        %
        %  subtract the appropriate mean from each trial
        %
        for idx = 1:length(binEEG(cards).subindices)  % do this for EOG?
            EEGdata(:,:,binEEG(cards).subindices(idx)) = EEGdata(:,:,binEEG(cards).subindices(idx)) - binEEG(cards).EEGavg;
        end
    end
end
if isempty(binned_indices)
    error('gratton_emcp(): No trial matches a selection card')
end
binned_indices = sort(binned_indices);
rmarkBlink = markBlink(:,binned_indices);
rblinkpts = numel(find(rmarkBlink));
rsaccpts = numel(find(~rmarkBlink));

disp(['gratton_emcp(): Regression blink points: ' num2str(rblinkpts)])
disp(['gratton_emcp(): Regression saccade points: ' num2str(rsaccpts)])
disp(['gratton_emcp(): Regression blink proportion: ' num2str(rblinkpts/(rblinkpts+rsaccpts))]);

blinkpts = numel(find(markBlink));
saccpts = numel(find(~markBlink));
disp(['gratton_emcp(): Corrected blink points: ' num2str(blinkpts)])
disp(['gratton_emcp(): Corrected saccade points: ' num2str(saccpts)])
disp(['gratton_emcp(): Corrected blink proportion: ' num2str(blinkpts/(blinkpts+saccpts))]);
%  Identify unusual conditions with zero blinks or saccades
%
%  Because the beginning and end of the waveform will not be tagged as blink,
%  rsaccpts and saccpts should always both be > 0
%
warn=[];
if blinkpts == 0     % subject didn't blink
    warn{1} = sprintf('*** Warning:');
    warn{2} = sprintf('*** No blinks found in data.');
    warn{3} = sprintf('*** All data treated as saccades.');
    for i = 1:length(warn)
        disp(['gratton_emcp(): ' char(warn{i})]);
    end
elseif blinkpts > 0 && rblinkpts == 0    % subject only blinked during non-selected trials
    warn{1} = sprintf('*** Warning:');
    warn{2} = sprintf('*** No blinks found in data selected for regression.');
    warn{3} = sprintf('*** All data treated as saccades.');
    for i = 1:length(warn)
        disp(['gratton_emcp(): ' char(warn{i})]);
    end
    markBlink(:)=false;
    blinkpts = numel(find(markBlink));
    saccpts = numel(find(~markBlink));
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Compute regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% take the subset of the data used for computing regression
%
subdata = EEGdata(:,:,binned_indices);
%
% Subtract mean of blinks or saccades used for regression
%
for ch=1:EEG.nbchan+length(chanpair)
    if rblinkpts > 0
        subdata(ch,rmarkBlink) = subdata(ch,rmarkBlink)- mean(subdata(ch,rmarkBlink));
    end
    subdata(ch,~rmarkBlink) = subdata(ch,~rmarkBlink)- mean(subdata(ch,~rmarkBlink));
end
PropBlink = zeros(EEG.nbchan+length(chanpair),length(chanpair));
PropSaccade = zeros(EEG.nbchan+length(chanpair),length(chanpair));
xvecB = subdata(1:length(chanpair),rmarkBlink)';
xvecS = subdata(1:length(chanpair),~rmarkBlink)';

if rblinkpts > 0
    for ch = 1:EEG.nbchan+length(chanpair)
        yvec = subdata(ch,rmarkBlink)';
        %  Perform regression - no intercept term
        %  Propagation factors are unstandardized coefficients
        XTXI = inv(xvecB' * xvecB);
        PropBlink(ch,:) = XTXI * xvecB' * yvec ;

    end
end
for ch = 1:EEG.nbchan+length(chanpair)
    yvec = subdata(ch,~rmarkBlink)';
    XTXI = inv(xvecS' * xvecS);
    PropSaccade(ch,:) = XTXI * xvecS' * yvec ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Create output table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
key=cell(1,length(chanpair));
for i = 1:length(chanpair)
    if i == 1
        disp(['gratton_emcp(): Vertical EOG data = ' table_label{1}]);
        key{1} =  ['Vertical = ' table_label{1}];
    else
        disp(['gratton_emcp(): EOG Channel #' num2str(i) ' data = ' table_label{i}]);
        key{i} =  ['EOG' num2str(i) ' = ' table_label{i}];
    end
end

emcplabels = [];
for i = 1:length(chanpair)
    if i == 1
        emcplabels = {'Vertical'};
    else
        emcplabels{i} = ['EOG' num2str(i)];
    end
end
emcplabels = strjust(char([ emcplabels, {EEG.chanlocs.labels}]'),'right');
labelwidth = size(emcplabels,2);

chanheader = [];
for i = 1:length(chanpair)
    if i == 1
        chanheader = strjust(sprintf('%8s','Vert'),'center');
    else
        chanheader = [chanheader strjust(sprintf('%8s',['EOG' num2str(i)]),'center')];
    end;
end

chanheader = [chanheader chanheader]; %blinks + saccades
datawidth = size(chanheader,2);
tablewidth = max(labelwidth + size(chanheader,2),size(char(key),2));
if tablewidth<80
    tablewidth = 80;
end
filler = tablewidth-size(emcplabels,2)-datawidth;

blk = strjust(sprintf(['%' num2str(8*length(chanpair)) 's'],'Blinks'),'center');
sac = strjust(sprintf(['%' num2str(8*length(chanpair)) 's'],'Saccades'),'center');

EEG.emcp.table(1,:) = strjust(sprintf(['%' num2str(tablewidth) 's'],'Eye Movement Correction Procedure'),'center');
EEG.emcp.table = [EEG.emcp.table; sprintf(blanks(tablewidth))];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Regression blink points: ' num2str(rblinkpts)]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Regression saccade points: ' num2str(rsaccpts)]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Regression blink proportion: ' num2str(rblinkpts/(rblinkpts+rsaccpts))]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Corrected blink points: ' num2str(blinkpts)]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Corrected saccade points: ' num2str(saccpts)]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Corrected blink proportion: ' num2str(blinkpts/(blinkpts+saccpts))]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Epochs per bin: ' num2str(EEG.emcp.bintotals)]),'left')];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],['Total epochs: ' num2str(EEG.trials)]),'left')];
if ~isempty(warn)
    EEG.emcp.table = [EEG.emcp.table; sprintf(blanks(tablewidth))];
    for i = 1:length(warn)
        EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],char(warn{i})),'left')];
    end
end
EEG.emcp.table = [EEG.emcp.table; sprintf(blanks(tablewidth))];
EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],'Propagation Factors'),'left')];
EEG.emcp.table = [EEG.emcp.table; sprintf(blanks(tablewidth))];
for i=1:length(chanpair)
    EEG.emcp.table = [EEG.emcp.table; strjust(sprintf(['%' num2str(tablewidth) 's'],key{i}),'left')];
end
EEG.emcp.table = [EEG.emcp.table; sprintf(blanks(tablewidth))];
EEG.emcp.table = [EEG.emcp.table; [blanks(labelwidth) strjust(sprintf(['%' num2str(datawidth) 's'],[blk sac]),'center') blanks(filler)]];
EEG.emcp.table = [EEG.emcp.table; [blanks(labelwidth) strjust(sprintf(['%' num2str(datawidth) 's'],chanheader),'center') blanks(filler)]];

tabline =  char(zeros(EEG.nbchan+length(chanpair),datawidth+filler));
for i = 1:EEG.nbchan+length(chanpair)
    tmp = '';
    for j = 1:length(chanpair)
        tmp = [tmp sprintf('%8.4f',PropBlink(i,j))];
    end
    for j = 1:length(chanpair)
        tmp = [tmp sprintf('%8.4f',PropSaccade(i,j))];
    end
    tabline(i,:) = [tmp blanks(filler)];
end
EEG.emcp.table = [EEG.emcp.table; [emcplabels tabline] ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Correct the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reconstitute EEGdata so it no longer has bin mean subtracted
% also, this will enable correction of non-selected data
EOGCHAN=[];
EEGdata = zeros(EEG.nbchan + length(chanpair),EEG.pnts,EEG.trials);
for i = 1:length(chanpair)
    for chans=1:length(chanpair{i})
        [LABEL1, LABEL2] = strtok(chanpair{i}{chans});  % parse the string
        if ~isempty(strtrim(LABEL2))  %if there was > one label in the string, take the average
            chan1 = find(strcmpi(electrodes,LABEL1));
            chan2 = find(strcmpi(electrodes,strtrim(LABEL2)));
            % create average channels
            EOGCHAN{i}{chans} = (EEG.data(chan1,:,:)+ EEG.data(chan2,:,:))/2;
        else
            chan1 = find(strcmpi(electrodes,LABEL1));
            EOGCHAN{i}{chans} = EEG.data(chan1,:,:);
        end
    end
    if length(chanpair{i}) == 2   %subtract if there are two
        EOGCHAN{i}{1} = EOGCHAN{i}{1} - EOGCHAN{i}{2};
    end
    EEGdata(i,:,:) = EOGCHAN{i}{1};
end
EEGdata(length(chanpair)+1:end,:,:) = EEG.data;
%
% Subtract epoch mean from ALL trials incl non-binned
%
for tr = 1:EEG.trials
    for ch=1:EEG.nbchan+length(chanpair)
        % subtract mean of each waveform from the wavefrom
        EEGdata(ch,:,tr) = EEGdata(ch,:,tr) - mean(EEGdata(ch,:,tr));
    end
end
%
% Compute mean blink and saccade values used in computing the regression
%
subdata=EEGdata(:,:,binned_indices);
if(rblinkpts > 0)
    for ch = 1:EEG.nbchan+length(chanpair)
        EEGblinkmean(ch) = mean(subdata(ch,rmarkBlink));

    end

    for i = 1:length(chanpair)
        deltaBlink{i} = EEGdata(i,markBlink) - EEGblinkmean(i);

    end
    for ch = 1:EEG.nbchan
        avgAdjustmentB = zeros(1,blinkpts);

        corch = ch+length(chanpair);
        for i = 1:length(chanpair)
            avgAdjustmentB = avgAdjustmentB+ PropBlink(corch,i) * deltaBlink{i};
        end
        EEG.data(ch,markBlink) = EEG.data(ch,markBlink) - (avgAdjustmentB + EEGblinkmean(corch));
    end
end
for ch = 1:EEG.nbchan+length(chanpair)
    EEGsaccademean(ch) = mean(subdata(ch,~rmarkBlink));
end
for i = 1:length(chanpair)
    deltaSaccade{i} = EEGdata(i,~markBlink) - EEGsaccademean(i);
end
for ch = 1:EEG.nbchan
    avgAdjustmentS = zeros(1,saccpts);
    corch = ch+length(chanpair);
    for i = 1:length(chanpair)
        avgAdjustmentS = avgAdjustmentS + PropSaccade(corch,i) * deltaSaccade{i};
    end
    EEG.data(ch,~markBlink) = EEG.data(ch,~markBlink) - (avgAdjustmentS + EEGsaccademean(corch));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Create EEG.emcp with info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG.emcp.markblink = markBlink;
EEG.emcp.blink_factors = PropBlink;
EEG.emcp.saccade_factors = PropSaccade;
EEG.emcp.regress_blinks = rblinkpts;
EEG.emcp.regress_saccades = rsaccpts;
EEG.emcp.regress_propblinks = rblinkpts/(rblinkpts+rsaccpts);
EEG.emcp.overall_blinks = blinkpts;
EEG.emcp.overall_saccades = saccpts;
EEG.emcp.overall_propblinks = blinkpts/(blinkpts+saccpts);
disp(['gratton_emcp(): Number of epochs per bin: ' num2str(EEG.emcp.bintotals) ', total of ' num2str(EEG.trials) ' epochs corrected'])
disp(['gratton_emcp(): Finished in ' num2str(toc,'%.2f') 's real time, ' num2str(cputime-starttime,'%.2f') 's cpu time']);
disp('gratton_emcp(): See EEG.emcp.table for table of correction factors')
% can use this code to show what points are identified as blinks in chan 20
% EEG.data(20,markBlink) = 100;
% EEG.data(20,~markBlink) = 0;
