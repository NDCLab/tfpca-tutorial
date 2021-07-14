% ---------------------------------------------------------------------------------------------
% 
%                          TIME FREQUENCY BASELINE CORRECTING
%
% ---------------------------------------------------------------------------------------------
% Need to load in from data_cache to make TF plot
% here need to load total power or average power?
load(['../extra_out_data' filesep 'theta_totalPower_stim_MasterTFD.mat']);

MasterTFD = theta_totalPower_stim_MasterTFD.MasterTFD;

[subNum, conNum, chanNum, FreqNum, SampNum]= size(MasterTFD);

% Baseline Correct - 1000ms/32Hz = 31.25 ms in a sample
% want to baseline correct from -400 to -200, which would be approximately
% samples 19.2 to 25.6 - but can't do portions of sample so will use 19 to
% 26, which is a baseline of -406.25 to -187.5
% create vector of values per condition that will be subtracted from all other points

% mean over the baseline period
MasterTFD_baseline = squeeze(mean(MasterTFD(:,:,:,:,19:26),5));

% Create matrix for the baseline removed data
MasterTFD_baseRemoved = zeros(subNum, conNum, chanNum, FreqNum, SampNum);

%%% For Power%%%%
for t = 1:SampNum
    % 10*log10 is the db power normalization
    MasterTFD_baseRemoved(:,:,:,:,t) = 10 * log10((1000 + MasterTFD(:,:,:,:,t)) ./ (1000 + MasterTFD_baseline));
end %end time loop

% %%% For ITPS %%%%
% for t = 1:SampNum
%     % 10*log10 is the db power normalization
%     MasterTFD_baseRemoved(:,:,:,:,t) = ((1000 + MasterTFD(:,:,:,:,t)) - (1000 + MasterTFD_baseline));
% end %end time loop

% create folder if not exist
if exist('../extra_out_data','dir') == 0,
    mkdir('../extra_out_data');
end

theta_totalPower_stim_MasterTFD_baseRemoved.MasterTFD_baseRemoved = MasterTFD_baseRemoved;
theta_totalPower_stim_MasterTFD_baseRemoved.subs = theta_totalPower_stim_MasterTFD.subs;

save(['../extra_out_data' filesep 'theta_totalPower_stim_MasterTFD_baseRemoved.mat'], 'theta_totalPower_stim_MasterTFD_baseRemoved');


% save files with TF values for each participant for each condition - the
% example data has 3 conditions
% select conditions
TFD_congruent_corr = squeeze(MasterTFD_baseRemoved(:,1,:,:,:));
TFD_incongruent_error = squeeze(MasterTFD_baseRemoved(:,2,:,:,:));
TFD_incongruent_corr = squeeze(MasterTFD_baseRemoved(:,3,:,:,:));

% average across select channels - the example data is interested in FCz
% electrode which is 20. Therefore, edit your interested electrodes based
% on your own data.
chansToAvg = [20];
TFD_congruent_corr_FCz = squeeze(mean(TFD_congruent_corr(:,chansToAvg,:,:),2));
TFD_incongruent_error_FCz = squeeze(mean(TFD_incongruent_error(:,chansToAvg,:,:),2));
TFD_incongruent_corr_FCz = squeeze(mean(TFD_incongruent_corr(:,chansToAvg,:,:),2));

% average across the interested freq window - 3-8hz
TFD_congruent_corr_FCz_theta = squeeze(mean(TFD_congruent_corr_FCz(:,7:19,:),2));
TFD_incongruent_error_FCz_theta = squeeze(mean(TFD_incongruent_error_FCz(:,7:19,:),2));
TFD_incongruent_corr_FCz_theta = squeeze(mean(TFD_incongruent_corr_FCz(:,7:19,:),2));

% average across the interested time window - ERN which is 0-100ms which corresponds to 33-36 time bin (rounded from 33-26.2)  
TFD_congruent_corr_FCz_theta_ERNtime = squeeze(mean(TFD_congruent_corr_FCz_theta(:,33:36),2));
TFD_incongruent_error_FCz_theta_ERNtime = squeeze(mean(TFD_incongruent_error_FCz_theta(:,33:36),2));
TFD_incongruent_corr_FCz_theta_ERNtime = squeeze(mean(TFD_incongruent_corr_FCz_theta(:,33:36),2));

ThetaPower = [theta_totalPower_stim_MasterTFD.subs TFD_congruent_corr_FCz_theta_ERNtime(:), TFD_incongruent_error_FCz_theta_ERNtime(:), TFD_incongruent_corr_FCz_theta_ERNtime(:)];

% create folder if not exist
if exist('../extra_out_data','dir') == 0,
    mkdir('../extra_out_data');
end

% save the theta data here as a mat for later intended analysis
csvwrite(['../extra_out_data' filesep 'theta_totalPower_stim_MasterTFD_baseRemoved_cleaned.csv'], ThetaPower);

