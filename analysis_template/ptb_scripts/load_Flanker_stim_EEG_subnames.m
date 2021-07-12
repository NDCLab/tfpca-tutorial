% -----------------------------------------------------------------------------
% List of each subject to be included for analysis.
% -----------------------------------------------------------------------------

subnum = dir(['../ptb_data' filesep '*.mat']);
sub_list = {subnum.name};
for i = 1:length(sub_list)
    sub = sub_list{i};
    subnames{i,1} = sub(1:end-4);
end