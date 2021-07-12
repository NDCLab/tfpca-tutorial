% -----------------------------------------------------------------------------
% List of each subject to be included for analysis.
% -----------------------------------------------------------------------------

subnum = dir(['./output_data' filesep 'Flanker_stim_ISFA_AMPL_*-PCs.mat']);
sub_list = {subnum.name};
for i = 1:length(sub_list)
    sub = sub_list{i};
    
    % delete ISFA pcs
    delete (['./output_data' filesep sub]);
    delete (['./output_data' filesep sub(1:end-8) '.log']);
    delete (['./output_data' filesep sub(1:end-8) '.mat']);
    
    % rename avg power pcs
    sub_suffix = sub(end-11:end);
    old_name = {dir(['./output_data' filesep 'Flanker_stim_AVGS_AMPL_*' sub_suffix]).name};
    status = movefile(['output_data' filesep old_name{1}], ['output_data' filesep sub], 'f');
    if status == 1,
        disp(['Copy and rename avg power pcs for total power successfully.']);
    else,
        disp(['Fail to copy and rename avg power pcs for total power. Please do it manually.']);
    end
end