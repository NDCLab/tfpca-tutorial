% Here assume that the average power and the total power have already been
% converted to an easy-to-understand format in (template_ptb_cache_out.m)
% and the resulting data has been saved to (../exported_data).
%
% This emplate script is mainly for conducting dB power conversion for the average power 
% and the total power.
%
% Finally, the data will be saved to (../exported_data).

% ---------------------------------------------------------------------------------------------
% 
%                             The average power with dB conversion
%
% ---------------------------------------------------------------------------------------------
% load the average power data that has been already saved in "../exported_data" folder with "template_ptb_cache_out.m"
load(['../exported_data' filesep 'AvgPower_resp_TFD.mat']);
avgTFD = AvgPower_resp_TFD.avgTFD;

[subNum, conNum, chanNum, FreqNum, SampNum]= size(avgTFD);

% Baseline Correct - 1000ms/32Hz = 31.25 ms in a sample
% want to baseline correct from -400 to -200, which would be approximately
% samples 19.2 to 25.6 - but can't do portions of sample so will use 19 to
% 26, which is a baseline of -406.25 to -187.5
% create vector of values per condition that will be subtracted from all other points

% mean over the baseline period
TFD_baseline_avg = squeeze(mean(avgTFD(:,:,:,:,19:26),5));

% Create matrix for the baseline removed data
TFD_baseRemoved_avg = zeros(subNum, conNum, chanNum, FreqNum, SampNum);

%%% For Power%%%%
for t = 1:SampNum
    % 10*log10 is the db power normalization
    TFD_baseRemoved_avg(:,:,:,:,t) = 10 * log10((1000 + avgTFD(:,:,:,:,t)) ./ (1000 + TFD_baseline_avg));
end %end time loop

% save
AvgPower_resp_TFD_baseRemoved.TFD_baseRemoved_avg = TFD_baseRemoved_avg;
AvgPower_resp_TFD_baseRemoved.subs = AvgPower_resp_TFD.subs;

save(['../exported_data' filesep 'AvgPower_resp_TFD_baseRemoved.mat'], 'AvgPower_resp_TFD_baseRemoved');


% ---------------------------------------------------------------------------------------------
% 
%                          The total power with dB conversion
%
% ---------------------------------------------------------------------------------------------
% load the total power data that has been already saved in "../exported_data" folder with "template_ptb_cache_out.m"
load(['../exported_data' filesep 'TotalPower_resp_TFD.mat']);
totalTFD = TotalPower_resp_TFD.totalTFD;

[subNum, conNum, chanNum, FreqNum, SampNum]= size(totalTFD);

% Baseline Correct - 1000ms/32Hz = 31.25 ms in a sample
% want to baseline correct from -400 to -200, which would be approximately
% samples 19.2 to 25.6 - but can't do portions of sample so will use 19 to
% 26, which is a baseline of -406.25 to -187.5
% create vector of values per condition that will be subtracted from all other points

% mean over the baseline period
TFD_baseline_total = squeeze(mean(totalTFD(:,:,:,:,19:26),5));

% Create matrix for the baseline removed data
TFD_baseRemoved_total = zeros(subNum, conNum, chanNum, FreqNum, SampNum);

%%% For Power%%%%
for t = 1:SampNum
    % 10*log10 is the db power normalization
    TFD_baseRemoved_total(:,:,:,:,t) = 10 * log10((1000 + totalTFD(:,:,:,:,t)) ./ (1000 + TFD_baseline_total));
end %end time loop

TotalPower_resp_TFD_baseRemoved.TFD_baseRemoved_total = TFD_baseRemoved_total;
TotalPower_resp_TFD_baseRemoved.subs = TotalPower_resp_TFD.subs;

save(['../exported_data' filesep 'TotalPower_resp_TFD_baseRemoved.mat'], 'TotalPower_resp_TFD_baseRemoved');

