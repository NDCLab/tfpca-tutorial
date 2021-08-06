Functions and brief explanations 


FUNCTION 					EXPLANATION 
------------------------------------------------------------------------------------------------------------------------

extract_averages.m  				Average file create program  
extract_trials.m 				Trial file create program 

	extract_base_evaluate_2extract.m 	Average/Trial support program (called by some others as well)  
	extract_base_loadprep_data.m 		Average/Trial support program (called by some others as well)  
	extract_base_ms.m 			Average/Trial support program (called by some others as well)  

	extract_processing_60Hz.m		EXAMPLE Average/Trial pre-procssing script (P1&P2 parameters)  
	extract_processing_EMGIIR.m		EXAMPLE Average/Trial pre-procssing script (P1&P2 parameters)  
	extract_processing_PA.m			EXAMPLE Average/Trial pre-procssing script (P1&P2 parameters)  
	extract_processing_PP.m			EXAMPLE Average/Trial pre-procssing script (P1&P2 parameters)  
	extract_processing_SCR.m		EXAMPLE Average/Trial pre-procssing script (P1&P2 parameters)  

get_components.m 				Window-based component score generator 
review_components.m 				Manual review frontend for window-based component score generator 

plot_erpdata.m 					Plot multiple electrodes averages in grid layout by criterion 
plot_erpdata_trial_notfinished.m		Plot multiple electrodes trials in grid layout by criterion -- not finished  

tag_artifacts.m 				Artifact tagging  - can use standalone, called by most other functions 

combine_files.m 				Combine Average or Trial files to aggregate even larger datasets 
						(somewhat crude at the moment, assumes only subjects differ) 


