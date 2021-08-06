function [retval] = pca_plot_suptitle_multi(suptitles), 

% suptitle_multi(suptitles) 
% 
%  suptitles(N).text - each N is a new title line, up to 3  
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

% Edited on 08.08.19 by JH for compatibility with Matlab 2018b. Old version (commented out) padded the title with a large amount of blank. This caused the text to print off of the page when printing the eps file. In the edited version below, the blank padding ensures that all elements of the suptitles structure are as long as the longest element.

suptitles_out=[]; 

for j=1:length(suptitles), 

 %if rem(length(suptitles(j).text),2)~=0, suptitles(j).text = [suptitles(j).text ' ']; end 
 %suptitles(j).text = [(blanks(100-length(suptitles(j).text)/2)) suptitles(j).text (blanks(100-length(suptitles(j).text)/2))];
 %suptitles_out = [suptitles_out; suptitles(j).text;]; 

%end 

  if rem(length(suptitles(j).text),2)~=0, suptitles(j).text = [suptitles(j).text ' ']; end 

end

suptitles_padding =  max(cellfun(@length,{suptitles.text}))/2;

for k = 1:length(suptitles)

  suptitles(k).text = [(blanks(suptitles_padding-length(suptitles(k).text)/2)) suptitles(k).text (blanks(suptitles_padding-length(suptitles(k).text)/2))];
  suptitles_out = [suptitles_out; suptitles(k).text;]; 

end 

suptitle([suptitles_out]);

