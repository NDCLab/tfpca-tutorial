% This template sript is mainly for converting the data cache output from ptb (in ../output_data) 
% to a format that is easy to plot/potential statistical analysis etc.

% ---------------------------------------------------------------------------------------------
%
% Reorganize the Average Power data into a subject x condition x channel x freq x time array
% that is convenient for plotting (see template script "template_plots.m") and intended
% statistical analysis (no template script provided).
% Save the result into "extra_out_data" folder.
%
% ---------------------------------------------------------------------------------------------
% load the avg power data from ptb 'data_cache' folder.
% 'Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat' stores the average power data. 
% (average power refers to a time-frequency distribution of power values that includes primarily phase-locked information)
load(['../data_cache' filesep 'Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat']);

% the example erpcore data has 38 participants, 3 conditions and 31 EEG
% channels. Additionally, it also has 33 freq bins and 96 time bins that were
% setup while running tf_pca scripts with ptb.
subs_number = length(erptfd.subs.name);
cat_number = length(erptfd.stimkeys);
chan_number = length(unique(erptfd.elec));
freq_bin_number = size(erptfd.data, 2);
time_bin_number = size(erptfd.data, 3);

avgTFD = zeros(subs_number, cat_number, chan_number, freq_bin_number, time_bin_number);
for sub = 1:subs_number
    for cat = 1:cat_number
        for chan = 1:chan_number
            avgTFD(sub,cat,chan,:,:) = erptfd.data(intersect(intersect(find(erptfd.subnum == sub),find(erptfd.stim.catcodes == cat)),find(erptfd.elec == chan)) , 1:freq_bin_number, 1:time_bin_number);
        end
    end
end
AvgPower_resp_TFD.avgTFD = avgTFD;

for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
AvgPower_resp_TFD.subs = subs';

% create folder if not exist
if exist('../extra_out_data','dir') == 0,
    mkdir('../extra_out_data');
end

% save data
save(['../extra_out_data' filesep 'AvgPower_resp_TFD.mat'], 'AvgPower_resp_TFD');


% ---------------------------------------------------------------------------------------------
%
% Reorganize the Total Power data into a subject x condition x channel x freq x time array
% that is convenient for plotting (see template script "template_plots.m") and intended
% statistical analysis (no template script provided).
% Save the result into "extra_out_data" folder.
%
% ---------------------------------------------------------------------------------------------
% load the data from ptb 'data_cache' folder.
% 'Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat' stores the total power. 
% (total power refers to a time-frequency distribution of power values that includes both phase- and non-phase-locked information)
load(['../data_cache' filesep 'Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat']);

% the example erpcore data has 38 participants, 3 conditions and 31 EEG
% channels. Additionally, it also has 33 freq bins and 96 time bins that were
% setup while running tf_pca scripts with ptb.
subs_number = length(erptfd.subs.name);
cat_number = length(erptfd.stimkeys);
chan_number = length(unique(erptfd.elec));
freq_bin_number = size(erptfd.data, 2);
time_bin_number = size(erptfd.data, 3);

totalTFD = zeros(subs_number, cat_number, chan_number, freq_bin_number, time_bin_number);
for sub = 1:subs_number
    for cat = 1:cat_number
        for chan = 1:chan_number
            totalTFD(sub,cat,chan,:,:) = erptfd.data(intersect(intersect(find(erptfd.subnum == sub),find(erptfd.stim.catcodes == cat)),find(erptfd.elec == chan)) , 1:freq_bin_number, 1:time_bin_number);
        end
    end
end
TotalPower_resp_TFD.totalTFD = totalTFD;

for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
TotalPower_resp_TFD.subs = subs';

% save data
save(['../extra_out_data' filesep 'TotalPower_resp_TFD.mat'], 'TotalPower_resp_TFD');

