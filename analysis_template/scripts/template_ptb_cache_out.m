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
% channels. Additionally, 33 refers freq bins and 96 time bins that were
% setup while running tf_pca scripts with ptb. Edit those parameters based
% on your own data.
avgTFD = zeros(38,3,31,33,96);
for sub = 1:38
    for cat = 1:3
        for chan = 1:31
            avgTFD(sub,cat,chan,:,:) = erptfd.data(intersect(intersect(find(erptfd.subnum == sub),find(erptfd.stim.catcodes == cat)),find(erptfd.elec == chan)) , 1:33, 1:96);
        end
    end
end
AvgPower_resp_MasterTFD.avgTFD = avgTFD;

for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
AvgPower_resp_MasterTFD.subs = subs';

% create folder if not exist
if exist('../extra_out_data','dir') == 0,
    mkdir('../extra_out_data');
end

% save data
save(['../extra_out_data' filesep 'AvgPower_resp_MasterTFD.mat'], 'AvgPower_resp_MasterTFD');


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
% channels. Additionally, 33 refers freq bins and 96 time bins that were
% setup while running tf_pca scripts with ptb. Edit those parameters based
% on your own data.
totalTFD = zeros(38,3,31,33,96);
for sub = 1:38
    for cat = 1:3
        for chan = 1:31
            totalTFD(sub,cat,chan,:,:) = erptfd.data(intersect(intersect(find(erptfd.subnum == sub),find(erptfd.stim.catcodes == cat)),find(erptfd.elec == chan)) , 1:33, 1:96);
        end
    end
end
TotalPower_resp_MasterTFD.totalTFD = totalTFD;

for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
TotalPower_resp_MasterTFD.subs = subs';

% save data
save(['../extra_out_data' filesep 'TotalPower_resp_MasterTFD.mat'], 'TotalPower_resp_MasterTFD');

