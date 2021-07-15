% Adjust Y-axis of TFD plots from bins to Hz 
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

    % adjust axes 
      h=get(gca); 
      set(gca,'YTickLabel',num2str([ (((fqendbin-fqstartbin+1) - h.YTick) + ... 
              fqstartbin)*SETvars.TFbin2Hzfactor - (1*SETvars.TFbin2Hzfactor)]','%0.4g')  );
      set(gca,'XTickLabel',num2str(round([(h.XTick+startbin-1)]*SETvars.TFbin2msfactor)') );
      clear h; 
      set(gca,'XTickMode'     ,'manual','YTickMode'     ,'manual')
      set(gca,'XTickLabelMode','manual','YTickLabelMode','manual')

    % labels 
%     ylabel('Hz'); 
%     xlabel('ms'); 

