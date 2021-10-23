% This template sript is mainly for plotting data that was created by template_ptb_pc_out.m,
% template_ptb_cache_out.m and template_dbpower.m.
% Examples for plotting tf surface with or without dbpower conversion, as well as with or without pc weighting. 
% Also includes example of plotting just the pc weights themselves.

% ------------------------------------------------------------------------
% 
%                     Weighted TFD(total power) Plotting
%
% ------------------------------------------------------------------------
load(['../exported_data' filesep 'Theta_TotalPower_resp_TFD_pcWeighted.mat']);

WeightedTFD_total = Theta_TotalPower_resp_TFD_pcWeighted.WeightedTFD_total;

% select conditions - the example data has 3 conditions: 
% 1: congruent & correct;
% 2: incongruent & error;
% 3: incongruent & correct;
W1TFD_congruent_corr = squeeze(WeightedTFD_total(:,:,1,:,:,:));
W1TFD_incongruent_error = squeeze(WeightedTFD_total(:,:,2,:,:,:));
W1TFD_incongruent_corr = squeeze(WeightedTFD_total(:,:,3,:,:,:));

% average across channels of interested - the example data is interested in
% MFC region, which corresponds to 20 electrode. Therefore, please edit the
% electrodes based on your own data and interested channels/regions.
chansToAvg = [20];
W1TFD_cong_corr_MFC = squeeze(mean(W1TFD_congruent_corr(:,chansToAvg,:,:),2));
W1TFD_incong_err_MFC = squeeze(mean(W1TFD_incongruent_error(:,chansToAvg,:,:),2));
W1TFD_incong_corr_MFC = squeeze(mean(W1TFD_incongruent_corr(:,chansToAvg,:,:),2));
% % uncomment the following 3 lines if you have more than 1 interested factors
% W1TFD_cong_corr_MFC = squeeze(mean(W1TFD_congruent_corr(:,:,chansToAvg,:,:),3));
% W1TFD_incong_err_MFC = squeeze(mean(W1TFD_incongruent_error(:,:,chansToAvg,:,:),3));
% W1TFD_incong_corr_MFC = squeeze(mean(W1TFD_incongruent_corr(:,:,chansToAvg,:,:),3));

% average across subjects
W1TFD_cong_corr_MFC_subAvg = squeeze(mean(W1TFD_cong_corr_MFC,1));
W1TFD_incong_err_MFC_subAvg = squeeze(mean(W1TFD_incong_err_MFC,1));
W1TFD_incong_corr_MFC_subAvg = squeeze(mean(W1TFD_incong_corr_MFC,1));
% % uncomment the following 3 lines if you have more than 1 interested factors
% W1TFD_cong_corr_MFC_subAvg = squeeze(mean(W1TFD_cong_corr_MFC,2));
% W1TFD_incong_err_MFC_subAvg = squeeze(mean(W1TFD_incong_err_MFC,2));
% W1TFD_incong_corr_MFC_subAvg = squeeze(mean(W1TFD_incong_corr_MFC,2));

% interested comparison
% error minus correct difference 
W1TFD_incong_errorDiff_MFC_subAvg = W1TFD_incong_err_MFC_subAvg - W1TFD_incong_corr_MFC_subAvg;
% incongruent minus congruent difference
W1TFD_cong_incong_Diff_MFC_subAvg = W1TFD_incong_corr_MFC_subAvg - W1TFD_cong_corr_MFC_subAvg;

% single TFD plot
DataToPlot_1 = W1TFD_incong_errorDiff_MFC_subAvg;
DataToPlot_2 = W1TFD_cong_incong_Diff_MFC_subAvg;
% % uncomment the following 4 lines if you have more than 1 interested
% % factors. the following 4 lines give an example if you are interested in
% % factor 1 and factor 3. Therefore, edit the interested factors based on
% % your own data.
% DataToPlot = squeeze(W1TFD_incong_errorDiff_MFC_subAvg(1,:,:));
% DataToPlot = squeeze(W1TFD_incong_errorDiff_MFC_subAvg(3,:,:));
% DataToPlot = squeeze(W1TFD_cong_incong_Diff_MFC_subAvg(1,:,:));
% DataToPlot = squeeze(W1TFD_cong_incong_Diff_MFC_subAvg(3,:,:));

% plot 1 - error minus correct difference
[height1 width1] = size(DataToPlot_1);
figure(1);
colormap jet
contourf([1:width1], [1:height1], DataToPlot_1, 30, 'linecolor', 'none');
set(gca,'clim',[-2 2]);
set(gca, 'ylim', [1 13]);
set(gca, 'YTick', [1:6:13]);
set(gca, 'YTickLabel', [3 6 9]);
set(gca, 'xlim', [1 33]);
set(gca, 'xTick', [1 17 33]);
set(gca, 'xTickLabel', [-500 0 500]);
set(gcf, 'Color', [1 1 1]);
set(gca,'tickdir', 'out', 'box', 'off');
set(gca, 'FontSize', 16);
xlabel('\it Time Relative to Response (ms)', 'FontSize', 16);
ylabel('\it Frequency (Hz)', 'FontSize', 16);
title('Error Minus Correct Difference', ' ', 'FontSize', 18, 'FontWeight','normal');
colorbar();

% plot 2 - incongruent minus congruent difference
[height2 width2] = size(DataToPlot_2);
figure(2);
colormap jet
contourf([1:width2], [1:height2], DataToPlot_2, 30, 'linecolor', 'none');
set(gca,'clim',[-.25 .25]);
set(gca, 'ylim', [1 13]);
set(gca, 'YTick', [1:6:13]);
set(gca, 'YTickLabel', [3 6 9]);
set(gca, 'xlim', [1 33]);
set(gca, 'xTick', [1 17 33]);
set(gca, 'xTickLabel', [-500 0 500]);
set(gcf, 'Color', [1 1 1]);
set(gca,'tickdir', 'out', 'box', 'off');
set(gca, 'FontSize', 16);
xlabel('\it Time Relative to Response (ms)', 'FontSize', 16);
ylabel('\it Frequency (Hz)', 'FontSize', 16);
title('Incongruent Minus Congruent Difference', ' ', 'FontSize', 18, 'FontWeight','normal');
colorbar();


% ------------------------------------------------------------------------
% 
%              Topo Plotting of Weighted TFD(total power)
%
% ------------------------------------------------------------------------
% extract pc weighted total power in each condition
% this template script taks 1 factor pc weight as the example. 
% Therefore, add other interested pc weights based on your own data.
F1_TFD_congruent_corr = squeeze(WeightedTFD_total(1,:,1,:,:,:));
F1_TFD_incongruent_error = squeeze(WeightedTFD_total(1,:,2,:,:,:));
F1_TFD_incongruent_corr = squeeze(WeightedTFD_total(1,:,3,:,:,:));

% average across time
F1_congruent_corr_FavgTemp = squeeze(mean(F1_TFD_congruent_corr,4));
F1_incongruent_error_FavgTemp = squeeze(mean(F1_TFD_incongruent_error,4));
F1_incongruent_corr_FavgTemp = squeeze(mean(F1_TFD_incongruent_corr,4));

% average across frequency
F1_congruent_corr_Favg = squeeze(mean(F1_congruent_corr_FavgTemp,3));
F1_incongruent_error_Favg = squeeze(mean(F1_incongruent_error_FavgTemp,3));
F1_incongruent_corr_Favg = squeeze(mean(F1_incongruent_corr_FavgTemp,3));

% average across subjects
F1_congruent_corr_Favg_subAvg = squeeze(mean(F1_congruent_corr_Favg,1));
F1_incongruent_error_Favg_subAvg = squeeze(mean(F1_incongruent_error_Favg,1));
F1_incongruent_corr_Favg_subAvg = squeeze(mean(F1_incongruent_corr_Favg,1));

% interested comparison
% error minus correct difference 
F1_error_Favg_subAvg_DIFF = F1_incongruent_error_Favg_subAvg - F1_incongruent_corr_Favg_subAvg;
% incongruent minus congruent difference
F1_cong_Favg_subAvg_DIFF = F1_incongruent_corr_Favg_subAvg - F1_congruent_corr_Favg_subAvg;

% single topoplot1 - error minus correct difference 
DataToPlot = F1_error_Favg_subAvg_DIFF;
figure(3);
topoplot([DataToPlot],'../erp_core_35_locs.ced','maplimits', [-.1 .1], 'electrodes', 'ptsnumbers', 'gridscale', 100,  'whitebk', 'on');
colorbar;

% single topoplot2 - incongruent minus congruent difference 
DataToPlot = F1_cong_Favg_subAvg_DIFF;
figure(4);
topoplot([DataToPlot],'../erp_core_35_locs.ced','maplimits', [-.1 .1], 'electrodes', 'ptsnumbers', 'gridscale', 100,  'whitebk', 'on');
colorbar;


% ------------------------------------------------------------------------
% 
%              Plottig for Total power with dB conversion 
%
% ------------------------------------------------------------------------
load(['../exported_data' filesep 'TotalPower_resp_TFD_baseRemoved.mat']);
TFD_baseRemoved_total = TotalPower_resp_TFD_baseRemoved.TFD_baseRemoved_total;

% select conditions
TFD_congruent_corr = squeeze(TFD_baseRemoved_total(:,1,:,:,:));
TFD_incongruent_error = squeeze(TFD_baseRemoved_total(:,2,:,:,:));
TFD_incongruent_corr = squeeze(TFD_baseRemoved_total(:,3,:,:,:));

% average across select channels - edit the cluster based on your own data 
chansToAvg = [20];
TFD_congruent_corr_FCz = squeeze(mean(TFD_congruent_corr(:,chansToAvg,:,:),2));
TFD_incongruent_error_FCz = squeeze(mean(TFD_incongruent_error(:,chansToAvg,:,:),2));
TFD_incongruent_corr_FCz = squeeze(mean(TFD_incongruent_corr(:,chansToAvg,:,:),2));

% average across subjects... this leaves us with a freq by time matrix 
% that we can plot as a TF surface
TFD_congruent_corr_FCz_subAvg = squeeze(mean(TFD_congruent_corr_FCz,1));
TFD_incongruent_error_FCz_subAvg = squeeze(mean(TFD_incongruent_error_FCz,1));
TFD_incongruent_corr_FCz_subAvg = squeeze(mean(TFD_incongruent_corr_FCz,1));

TFD_Diff_Incong_Error_Correct = TFD_incongruent_error_FCz_subAvg - TFD_incongruent_corr_FCz_subAvg;
TFD_Diff_Incong_cong = TFD_incongruent_corr_FCz_subAvg - TFD_congruent_corr_FCz_subAvg;

% single TFD plot1 - error minus correct difference 
DataToPlot = TFD_Diff_Incong_Error_Correct(:,:);
[height width] = size(DataToPlot);
figure(5);
colormap jet
contourf([1:width],[1:height],DataToPlot,30,'linecolor','none')
set(gca,'clim',[-.05 .05]);
set(gca, 'ylim', [7 19]);
set(gca, 'YTick', [7:6:19]);
set(gca, 'YTickLabel', [3 6 9 ]);
set(gca, 'xlim', [17 49]);
set(gca, 'xTick', [17 33 49]);
set(gca, 'xTickLabel', [-500 0 500]);
set(gcf, 'Color', [1 1 1]);
set(gca, 'FontSize', 16);
xlabel('\it Time Relative to Response (ms)', 'FontSize', 16);
ylabel('\it Frequency (Hz)', 'FontSize', 16)
title('Error Minus Correct Difference', ' ', 'FontSize', 18, 'FontWeight','normal')
colorbar();

% single TFD plot2 - incongruent minus congruent difference 
DataToPlot = TFD_Diff_Incong_cong(:,:);
[height width] = size(DataToPlot);
figure(6);
colormap jet
contourf([1:width],[1:height],DataToPlot,30,'linecolor','none')
%set(gca,'clim',[-.05 .05]);
set(gca,'clim',[-.01 .01]);
set(gca, 'ylim', [7 19]);
set(gca, 'YTick', [7:6:19]);
set(gca, 'YTickLabel', [3 6 9]);
set(gca, 'xlim', [17 49]);
set(gca, 'xTick', [17 33 49]);
set(gca, 'xTickLabel', [-500 0 500]);
set(gcf, 'Color', [1 1 1]);
set(gca, 'FontSize', 16);
xlabel('\it Time Relative to Response (ms)', 'FontSize', 16);
ylabel('\it Frequency (Hz)', 'FontSize', 16)
title('Incongruent Minus Congruent Difference', ' ', 'FontSize', 18, 'FontWeight','normal');
colorbar();


% ------------------------------------------------------------------------
% 
%                           PC Weights Plottig
%
% ------------------------------------------------------------------------
% load the pc weight from ptb 'output_data' folder
% "xxx-fac1-PCs.mat" stores the 1pc weights (derived from the average power TF surface)
% here take 1 factor pc weight as the example. You can load the pc weights that you are
% interested (i.e. "xxx-fac2-PCs.mat", "xxx-fac3-PCs.mat" etc.)
load(['../exported_data' filesep 'Theta_TotalPower_resp_TFD_pcWeighted.mat']);

DataToPlot = Theta_TotalPower_resp_TFD_pcWeighted.Pmat;

[height width] = size(DataToPlot);
figure(7);
colormap jet
contourf([1:width],[1:height],DataToPlot,30,'linecolor','none')

set(gca,'clim',[-.15 .15]);
set(gca, 'ylim', [1 13]);
set(gca, 'YTick', [1:6:13]);
set(gca, 'YTickLabel', [3 6 9]);
set(gca, 'xlim', [1 33]);
set(gca, 'xTick', [1 17 33]);
set(gca, 'xTickLabel', [-500 0 500]);
set(gcf, 'Color', [1 1 1]);
set(gca,'tickdir', 'out', 'box', 'off')
set(gca, 'FontSize', 16);
xlabel('\it Time Relative to Response (ms)', 'FontSize', 16);
ylabel('\it Frequency (Hz)', 'FontSize', 16)
title('PC Weights - 1Factor', ' ', 'FontSize', 18, 'FontWeight','normal');
colorbar();

