% ---------------------------------------------------------------------------------------------------------------------
%  Reads EEGLAB structured matlab files, and convertes them to the Psychophysiology Toolbox format. 
%  The input data has to be "clean" data (after artifacts removal and being epoched). 
%  Note, this template is for the data being processed by ERPLab (Events have been assigned to bins with Binlister).
%     
%  Output data: epoched files become 'erp' structures
% ---------------------------------------------------------------------------------------------------------------------

% Locate raw data on hard drive
data_location = '/Users/yanbinniu/Documents/matlabp/tfpca/george/data';

% Specify location to save processed data
out_location = '/Users/yanbinniu/Documents/matlabp/tfpca/george/output/';


% subject list
subnum = dir([data_location filesep '*.set']);
sub_list = {subnum.name};

for i = 1:length(sub_list)
    sub = sub_list{i};
    subject_list{i}= sub(1:end-4);
end

for s = 1:length(subject_list)
    
    % Open EEGLAB Toolbox  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % Find subject name
    subject = subject_list{s};
    
    % Load the component removed dataset
    EEG = pop_loadset('filename',[subject '.set'], 'filepath', data_location);
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);
    
    % select only cetain trial type
    event_binlabel = {EEG.event.binlabel};
    comp_Corr = find(startsWith(event_binlabel, 'B2,4')); % congruent - correct
    incomp_Error = find(startsWith(event_binlabel, 'B1,5')); % incongruent - error
    incom_Corr = find(startsWith(event_binlabel, 'B2,6')); % incongruent - correct
    
%     keep_cond1 = find(strcmp({EEG.event.code}, event_cond1));
%     keep_cond1 = find(strcmp({EEG.event.code}, event_cond1));

    keepTrials = [comp_Corr incomp_Error incom_Corr];
    
    %remove trials that we dont want
    EEG = pop_selectevent(EEG,'event', keepTrials, 'deleteevents', 'on', 'deleteepochs', 'on', 'invertepochs', 'off');
    EEG = eeg_checkset(EEG);
    
    % delete markers not used as event locking (duplicates of resp or stim )
    EEG = pop_selectevent( EEG, 'latency','-.1 <= .1','deleteevents','on');
    EEG = eeg_checkset(EEG);

    % vars
    numofelecs      = EEG.nbchan;  % size(EEG.data,1);
    numofbins       = EEG.pnts;  % size(EEG.data,2);
    numofsweeps     = EEG.trials;  % size(EEG.data,3);
    erp.elec        = repmat([1:numofelecs]',numofsweeps,1);
    erp.sweep       = ones(size(erp.elec));
    erp.ttype       = ones(size(erp.elec));
    erp.correct     = ones(size(erp.elec));
    erp.accept      = ones(size(erp.elec));
    erp.rt          = ones(size(erp.elec));
    erp.response    = ones(size(erp.elec));
    erp.data        = zeros(length(erp.elec),numofbins);
    erp.elecnames   = char(EEG.chanlocs.labels);
    
    [junk,erp.tbin] = min(abs(EEG.times));
    erp.samplerate  = EEG.srate;
    
    erp.original_format = 'EEGLAB';
    erp.scaled2uV   = 1;
    
    erp.stim.bin = zeros(size(erp.elec));
    for jj = 1:numofsweeps,
        
        % populate the .stim field with all of the (numeric) info about this trial
        if startsWith(EEG.event(jj).binlabel, 'B2,4'),
            erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 4; 
        elseif startsWith(EEG.event(jj).binlabel, 'B1,5'), 
            erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 5;
        elseif startsWith(EEG.event(jj).binlabel, 'B2,6'),
            erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 6;
        else
            erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 99;
        end    
    end %end loop through trials (sweeps)
    
    % erp.sweep
    for jj = 0:numofsweeps-1,
        erp.sweep((jj*numofelecs)+1:(jj+1)*numofelecs) = jj+1;
    end
    
    % erp.data
    for ss = 1:numofsweeps,
        erp.data(erp.sweep==ss, :) = squeeze(EEG.data(:, :, ss));
    end
    
    save(strcat(out_location, subject, '.mat'), 'erp')
end
