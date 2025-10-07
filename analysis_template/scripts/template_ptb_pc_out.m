% Here assume that the average power and the total power have already been
% converted to an easy-to-understand format in (template_ptb_cache_out.m)
% and the resulting data has been saved to (../exported_data).
%
% This template sript is mainly for applying pc weights (in ../output_data)
% to the average power and the total power. The resulting data along with the pc weight used
% will also be converted to a format that is easy to plot/analyze etc.
%
% Finally, the data will be saved to (../exported_data).
%
% This template takes 1 factor solution as the example.

% ---------------------------------------------------------------------------------------------
%
% Apply the pc weigth of interest to average and total power respectively.
% 
% ---------------------------------------------------------------------------------------------
% load the average and total power data that has been already saved 
% in "../exported_data" folder with "template_ptb_cache_out.m"
load(['../exported_data' filesep 'AvgPower_resp_TFD.mat']);
avgTFD = AvgPower_resp_TFD.avgTFD;

load(['../exported_data' filesep 'TotalPower_resp_TFD.mat']);
totalTFD = TotalPower_resp_TFD.totalTFD;

% load the pc weight from ptb 'output_data' folder
% "xxx-fac1-PCs.mat" stores a 1-factor pc weight (derived from the average power TF surface)
% here take 1 factor as an example. You can load the pc weight that you are
% interested (i.e. "xxx-fac2-PCs.mat", "xxx-fac3-PCs.mat" etc.)
load(['../output_data' filesep 'Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat']);

% PC weighting
% before doing this, cut data down to part of surface that pca was run (7:19 - freq3-8hz, 17:49 - time-500ms~500ms)
% avg power with pc weighting 
factors = size(Pmat,3);

chan_number = size(avgTFD, 3);
channel = 1:chan_number;

% cut data down to part of surface that tf-pca was run (freq3-9hz and time-500ms~500ms)
% To calculate the freq3-9hz: 3*2+1=7 - start freqency; 9*2+1=19 - end frenqency.
% To calculate the time500ms~500ms: the example data has 32 sampling rate
% and epoch is from -1000ms~2000ms. The time bin starts from 1 (no negative values) 
% and 0ms is the 33 timebin. Therefore, -500ms is 33-32/2=17; 500ms is 33+32/2=49.
% Edit those parameters (7:19 & 17:49) based on your own data.
DataToWeight_avg = avgTFD(:, :, channel, 7:19, 17:49);

facs = length(factors);
[sub, con, chan, freqs, time] = size(DataToWeight_avg);
WeightedTFD_avg = zeros(facs, sub, con, chan, freqs, time);
for fa = 1:facs 
    for s = 1:sub
        for co = 1:con
            for ch = 1:chan 
                for f = 1:freqs
                    for t = 1:time
                        WeightedTFD_avg(fa,s,co,ch,f,t) = DataToWeight_avg(s,co,ch,f,t) * Pmat(f,t,fa);
                    end
                end
            end
        end
    end
end

Theta_AvgPower_resp_TFD_pcWeighted.Pmat = Pmat;
Theta_AvgPower_resp_TFD_pcWeighted.WeightedTFD_avg = WeightedTFD_avg;
Theta_AvgPower_resp_TFD_pcWeighted.subs = AvgPower_resp_TFD.subs;

% total power with pc weighting 
factors = size(Pmat,3);

chan_number = size(totalTFD, 3);
channel = 1:chan_number;

% cut data down to part of surface that tf-pca was run (freq3-9hz and time-500ms~500ms)
% To calculate the freq3-9hz: 3*2+1=7 - start freqency; 9*2+1=19 - end frenqency.
% To calculate the time500ms~500ms: the example data has 32 sampling rate
% and epoch is from -1000ms~2000ms. The time bin starts from 1 (no negative values) 
% and 0ms is the 33 timebin. Therefore, -500ms is 33-32/2=17; 500ms is 33+32/2=49.
% Edit those parameters (7:19 & 17:49) based on your own data.
DataToWeight_total = totalTFD(:, :, channel, 7:19, 17:49);

facs = length(factors);
[sub, con, chan, freqs, time] = size(DataToWeight_total);
WeightedTFD_total = zeros(facs, sub, con, chan, freqs, time);
for fa = 1:facs 
    for s = 1:sub
        for co = 1:con
            for ch = 1:chan 
                for f = 1:freqs
                    for t = 1:time
                        WeightedTFD_total(fa,s,co,ch,f,t) = DataToWeight_total(s,co,ch,f,t) * Pmat(f,t,fa);
                    end
                end
            end
        end
    end
end

Theta_TotalPower_resp_TFD_pcWeighted.Pmat = Pmat;
Theta_TotalPower_resp_TFD_pcWeighted.WeightedTFD_total = WeightedTFD_total;
Theta_TotalPower_resp_TFD_pcWeighted.subs = TotalPower_resp_TFD.subs;

% save data into '../exported_data'
save(['../exported_data' filesep 'Theta_AvgPower_resp_TFD_pcWeighted.mat'], 'Theta_AvgPower_resp_TFD_pcWeighted');
save(['../exported_data' filesep 'Theta_TotalPower_resp_TFD_pcWeighted.mat'], 'Theta_TotalPower_resp_TFD_pcWeighted');

