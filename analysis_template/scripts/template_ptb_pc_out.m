% ---------------------------------------------------------------------------------------------
%
% apply the factor loading of interested to total power to get a time-frequency decomposition
% 
% ---------------------------------------------------------------------------------------------
% load the total power data that is saved with "template_ptb_cache_out"
load(['../extra_out_data' filesep 'theta_totalPower_stim_MasterTFD.mat']);
MasterTFD = theta_totalPower_stim_MasterTFD.MasterTFD;

% load the PCA loadings from ptb 'output_data' folder
% "xxx-fac1-PCs.mat" stores the 1pc weights/time-frequency PCA loadings (derived from the average power TF surface)
% here we take 1 factor as an example. You can load the data that you are
% interested (i.e. "xxx-fac2-PCs.mat", "xxx-fac3-PCs.mat" etc.)
load(['../output_data' filesep 'Flanker_stim_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat']);

% PC weighting
% before doing this, cut data down to part of surface that pca was run (7:19-freq, 17:49-time)
factors = 1;
channel = 1:31;
DataToWeight = MasterTFD(:, :, channel, 7:19, 17:49);

facs = length(factors);
[sub, con, chan, freqs, time] = size(DataToWeight);
WeightedTFD = zeros(facs, sub, con, chan, freqs, time);
for fa = 1:facs 
    for s = 1:sub
        for co = 1:con
            for ch = 1:chan 
                for f = 1:freqs
                    for t = 1:time
                        WeightedTFD(fa,s,co,ch,f,t) = DataToWeight(s,co,ch,f,t) * Pmat(f,t,fa);
                    end
                end
            end
        end
    end
end

theta_totalPower_stim_MasterTFD_pcWeighted.Pmat = Pmat;
theta_totalPower_stim_MasterTFD_pcWeighted.WeightedTFD = WeightedTFD;
theta_totalPower_stim_MasterTFD_pcWeighted.subs = theta_totalPower_stim_MasterTFD.subs;

save(['../extra_out_data' filesep 'theta_totalPower_stim_MasterTFD_pcWeighted.mat'], 'theta_totalPower_stim_MasterTFD_pcWeighted');
