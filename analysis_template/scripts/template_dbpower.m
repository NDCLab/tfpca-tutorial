% ---------------------------------------------------------------------------------------------
% 
%                             Avg power with db power conversion
%
% ---------------------------------------------------------------------------------------------
% load the average power data that has been already saved in "../extra_out_data" folder with "template_ptb_cache_out.m"
load(['../extra_out_data' filesep 'AvgPower_resp_MasterTFD.mat']);
avgTFD = AvgPower_resp_MasterTFD.avgTFD;

[subNum, conNum, chanNum, FreqNum, SampNum]= size(avgTFD);

% Baseline Correct - 1000ms/32Hz = 31.25 ms in a sample
% want to baseline correct from -400 to -200, which would be approximately
% samples 19.2 to 25.6 - but can't do portions of sample so will use 19 to
% 26, which is a baseline of -406.25 to -187.5
% create vector of values per condition that will be subtracted from all other points

% mean over the baseline period
MasterTFD_baseline_avg = squeeze(mean(avgTFD(:,:,:,:,19:26),5));

% Create matrix for the baseline removed data
MasterTFD_baseRemoved_avg = zeros(subNum, conNum, chanNum, FreqNum, SampNum);

%%% For Power%%%%
for t = 1:SampNum
    % 10*log10 is the db power normalization
    MasterTFD_baseRemoved_avg(:,:,:,:,t) = 10 * log10((1000 + avgTFD(:,:,:,:,t)) ./ (1000 + MasterTFD_baseline_avg));
end %end time loop

% %%% For ITPS %%%%
% for t = 1:SampNum
%     % 10*log10 is the db power normalization
%     MasterTFD_baseRemoved(:,:,:,:,t) = ((1000 + MasterTFD(:,:,:,:,t)) - (1000 + MasterTFD_baseline));
% end %end time loop

% save
AvgPower_resp_MasterTFD_baseRemoved.MasterTFD_baseRemoved_avg = MasterTFD_baseRemoved_avg;
AvgPower_resp_MasterTFD_baseRemoved.subs = AvgPower_resp_MasterTFD.subs;

save(['../extra_out_data' filesep 'AvgPower_resp_MasterTFD_baseRemoved.mat'], 'AvgPower_resp_MasterTFD_baseRemoved');


% ---------------------------------------------------------------------------------------------
% 
%                          Total power with db power conversion
%
% ---------------------------------------------------------------------------------------------
% load the total power data that has been already saved in "../extra_out_data" folder with "template_ptb_cache_out.m"
load(['../extra_out_data' filesep 'TotalPower_resp_MasterTFD.mat']);
totalTFD = TotalPower_resp_MasterTFD.totalTFD;

[subNum, conNum, chanNum, FreqNum, SampNum]= size(totalTFD);

% Baseline Correct - 1000ms/32Hz = 31.25 ms in a sample
% want to baseline correct from -400 to -200, which would be approximately
% samples 19.2 to 25.6 - but can't do portions of sample so will use 19 to
% 26, which is a baseline of -406.25 to -187.5
% create vector of values per condition that will be subtracted from all other points

% mean over the baseline period
MasterTFD_baseline_total = squeeze(mean(totalTFD(:,:,:,:,19:26),5));

% Create matrix for the baseline removed data
MasterTFD_baseRemoved_total = zeros(subNum, conNum, chanNum, FreqNum, SampNum);

%%% For Power%%%%
for t = 1:SampNum
    % 10*log10 is the db power normalization
    MasterTFD_baseRemoved_total(:,:,:,:,t) = 10 * log10((1000 + totalTFD(:,:,:,:,t)) ./ (1000 + MasterTFD_baseline_total));
end %end time loop

% %%% For ITPS %%%%
% for t = 1:SampNum
%     % 10*log10 is the db power normalization
%     MasterTFD_baseRemoved(:,:,:,:,t) = ((1000 + MasterTFD(:,:,:,:,t)) - (1000 + MasterTFD_baseline));
% end %end time loop

TotalPower_resp_MasterTFD_baseRemoved.MasterTFD_baseRemoved_total = MasterTFD_baseRemoved_total;
TotalPower_resp_MasterTFD_baseRemoved.subs = TotalPower_resp_MasterTFD.subs;

save(['../extra_out_data' filesep 'TotalPower_resp_MasterTFD_baseRemoved.mat'], 'TotalPower_resp_MasterTFD_baseRemoved');

