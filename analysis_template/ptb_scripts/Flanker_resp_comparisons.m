  % -------------------------------------
  % Comparisons 
  % Listing this script in "Comparisons" will output separate output of each of the comparisons listed below.
  % Each comparison will generate three new plots
  %  - Difference Waveform 
  %  - Difference interpolated topographical maps of amplitude  
  %  - Statistical interpolated topographical maps of p values  
  %
  % See README_comparisons.txt for more information about comparison parameters.
  % -------------------------------------
  % The following example is a within-subjects comparisons of different catcodes to one another. 

  SETvars.comparisons_label = 'resp_comparisons'; %Output label of this comparison file.

  clear comparisons 
  
  comparisons(1).label     = 'Error-Correct';                               %Output name for comparison 1.
  comparisons(1).type      = 'within-subjects';                             %Specifies within-subject parameter.
  comparisons(1).stats     = 'wilcoxon';                                    %Specifics statistical test.
  comparisons(1).set(1).label      = 'Error';                               %Category 1 label for comparison 1.
  comparisons(1).set(1).var.crit   = 'erp.stim.catcodes == 2';              %Category 1 for comparison 1. 
  comparisons(1).set(2).label      = 'Correct';                             %Category 2 label for comparison 1.
  comparisons(1).set(2).var.crit   = 'erp.stim.catcodes == 3';              %Category 2 for comparison 1. 
  
  comparisons(2).label     = 'Incongruent-Congruent';                       %Output name for comparison 1.
  comparisons(2).type      = 'within-subjects';                             %Specifies within-subject parameter.
  comparisons(2).stats     = 'wilcoxon';                                    %Specifics statistical test.
  comparisons(2).set(1).label      = 'Incongruent';                         %Category 1 label for comparison 1.
  comparisons(2).set(1).var.crit   = 'erp.stim.catcodes == 3';              %Category 1 for comparison 1. 
  comparisons(2).set(2).label      = 'Congruent';                           %Category 2 label for comparison 1.
  comparisons(2).set(2).var.crit   = 'erp.stim.catcodes == 1';              %Category 2 for comparison 1. 

  SETvars.comparisons = comparisons; clear comparisons
