% -----------------------------------------------------------------------------
% Loop over the data folder (../ptb_data) to get the list of each subject/data 
% to be included for analysis (each subject's data/file name will be used as the 
% name for this subject).
% -----------------------------------------------------------------------------

subnum = dir(['../ptb_data' filesep '*.mat']);
sub_list = {subnum.name};
for i = 1:length(sub_list)
    sub = sub_list{i};
    subnames{i,1} = sub(1:end-4);
end