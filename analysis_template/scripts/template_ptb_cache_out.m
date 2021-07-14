% ---------------------------------------------------------------------------------------------
%
% reorganize the time-frequency data into a subject x condition x channel x freq x time array
% that is convenient for plotting (see template script "template_plots.m")
% and intended statistical analysis (no template script provided)
%
% ---------------------------------------------------------------------------------------------
% load the data from ptb 'data_cache' folder
% 'xxx_ISFA_AMPL_theta__32_t32f32.mat' stores the total power (total power refers to a time-frequency distribution of power values that includes both phase- and non-phase-locked information)
% here should I load average power data or total power data or both?
load(['../data_cache' filesep 'Flanker_stim_ISFA_AMPL_theta__32_t32f32.mat']);

% the example erpcore data has 38 participants, 3 conditions and 31 EEG
% channels. Additionally, 33 refers freq bins and 96 time bins that were
% setup while running tf_pca scripts with ptb. Therrefore, edit those
% parameters based on your own data.
MasterTFD = zeros(38,3,31,33,96);
for sub = 1:38
    for cat = 1:3
        for chan = 1:31
            MasterTFD(sub,cat,chan,:,:) = erptfd.data(intersect(intersect(find(erptfd.subnum == sub),find(erptfd.stim.catcodes == cat)),find(erptfd.elec == chan)) , 1:33, 1:96);
        end
    end
end

theta_totalPower_stim_MasterTFD.MasterTFD = MasterTFD;

% do they have to be in numbers?
for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
theta_totalPower_stim_MasterTFD.subs = subs';

% create folder if not exist
if exist('../extra_out_data','dir') == 0,
    mkdir('../extra_out_data');
end

save(['../extra_out_data' filesep 'theta_totalPower_stim_MasterTFD.mat'], 'theta_totalPower_stim_MasterTFD');

