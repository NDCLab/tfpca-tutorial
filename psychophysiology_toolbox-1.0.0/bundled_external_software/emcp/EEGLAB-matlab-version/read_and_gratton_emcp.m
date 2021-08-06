%  read in and filter data...maybe...

files = {'PFK0805.bdf'}
% ,'pfk1501.bdf','pfk1801.bdf'}

for infiles = 1:length(files)
    indir = [pwd '\'];
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    if (0)
        EEG = pop_biosig_bg( [indir files{infiles}],  'ref',65);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,  'setname', 'Read Data','overwrite','on');
        EEG=pop_chanedit(EEG,  'load',{ [indir 'esti3.ced'], 'filetype', 'autodetect'});
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );
        EEG = pop_reref( EEG, [], 'refstate',-65);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'overwrite', 'on');
        EEG = eeg_checkset( EEG );
        EEG = pop_reref( EEG, [65 66] , 'refstate', 'averef');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'overwrite', 'on');
        EEG = pop_resample( EEG, 256);
        EEG = pop_epoch( EEG, {  '1' '2' '3' '4' '5' '6' '7' '8' '11' '12' '21' '22'}, [-0.5 1.5], 'newname', 'CNT file resampled epochs', 'epochinfo', 'yes');
        EEG = pop_rmbase( EEG, [-200    0]);
      %  reject large values from EEG channels only
%         EEG = pop_eegthresh(EEG,1,[1:64] ,-500,500,-0.2,1.5,0,1);
%         EEG = pop_rejspec(EEG,1,[1:64],[-50 -40],[50 40],[0 20],[2 40],0,1);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on');
        EEG = pop_saveset( EEG, 'filename', [files{infiles} '_read_12bin.set'], 'filepath',indir,'savemode','onefile');
    else
        EEG = pop_loadset([files{infiles} '_read_12bin.set']);
    end
    selection_cards =  {'1 2','3 4','5 6','7 8'};
    EEG = gratton_emcp(EEG,selection_cards,{'LVEOGUP','LVEOGLO'},{'HEOGL','HEOGR'});
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'overwrite','on');
    EEG = pop_saveset( EEG, 'filename', [files{infiles} '_gratton_emcp_12bin.set'], 'filepath',indir,'savemode','onefile');

end