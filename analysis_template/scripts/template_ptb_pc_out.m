% ---------------------------------------------------------------------------------------------
%
% Apply the factor loading of interest to average and total power respectively 
% to get time-frequency decompositions
% 
% ---------------------------------------------------------------------------------------------
% load the average and total power data that has been already saved in "../extra_out_data" folder with "template_ptb_cache_out.m"
load(['../extra_out_data' filesep 'AvgPower_resp_MasterTFD.mat']);
avgTFD = AvgPower_resp_MasterTFD.avgTFD;

load(['../extra_out_data' filesep 'TotalPower_resp_MasterTFD.mat']);
totalTFD = TotalPower_resp_MasterTFD.totalTFD;

% load the PCA loadings from ptb 'output_data' folder
% "xxx-fac1-PCs.mat" stores the 1pc weights/time-frequency PCA loadings (derived from the average power TF surface)
% here take 1 factor as an example. You can load the data that you are
% interested (i.e. "xxx-fac2-PCs.mat", "xxx-fac3-PCs.mat" etc.)
load(['../output_data' filesep 'Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat']);

% PC weighting
% before doing this, cut data down to part of surface that pca was run (7:19 - freq3-8hz, 17:49 - time-500ms~500ms)
% avg power with pc weighting 
factors = 1;
channel = 1:31;
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

Theta_AvgPower_resp_MasterTFD_pcWeighted.Pmat = Pmat;
Theta_AvgPower_resp_MasterTFD_pcWeighted.WeightedTFD_avg = WeightedTFD_avg;
Theta_AvgPower_resp_MasterTFD_pcWeighted.subs = AvgPower_resp_MasterTFD.subs;

% total power with pc weighting 
factors = 1;
channel = 1:31;
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

Theta_TotalPower_resp_MasterTFD_pcWeighted.Pmat = Pmat;
Theta_TotalPower_resp_MasterTFD_pcWeighted.WeightedTFD_total = WeightedTFD_total;
Theta_TotalPower_resp_MasterTFD_pcWeighted.subs = TotalPower_resp_MasterTFD.subs;

% save data into '../extra_out_data'
save(['../extra_out_data' filesep 'Theta_AvgPower_resp_MasterTFD_pcWeighted.mat'], 'Theta_AvgPower_resp_MasterTFD_pcWeighted');
save(['../extra_out_data' filesep 'Theta_TotalPower_resp_MasterTFD_pcWeighted.mat'], 'Theta_TotalPower_resp_MasterTFD_pcWeighted');

