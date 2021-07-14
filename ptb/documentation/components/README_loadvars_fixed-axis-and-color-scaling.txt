
% ---------------------------------------
  % axis and colormap options
    % plottype: topomap, imageplot, lineplot
    % plotcontent: averages, differences, statstics
    % measuretype: Mean, Peak, Latency, Time Freq  (for plottype topomap only)
    % componenntname: win = given by component definitions from user 
    %                 pca = PC1 to PC~X 
    %                 imageplot/lineplot can use: 'Avg' for average plot, or  
    %                                             'Components' for every component plot  
    % 
    % NOTE: scalefactor and measuretype only valid for topomap plottype, i.e.:  
    %       scalefactor only valid for SETvars.plots.scalefactor.topomap 
    %       measuretype only valid for SETvars.plots.axis.topomap[.~plotcontent][.~measuretype] 
    % 
  % -------------------------------------

  % plottype:ALL                  - defaults to 'default'
  SETvars.plots.colormap[.plottype][.~plotcontent]                                   = 'jet';  

  % plottype:TOPOMAPS             - defaults to .75
  SETvars.plots.scalingfactor[.plottype][.~plotcontent][.~measuretype][.~componentname]=  .8;   

  % plottype:TOPOMAPS             - defaults to autoscale
  SETvars.plots.axis[.plottype][.~plotcontent][.~measuretype][.~componentname]       = [-2 2]; 

  % plottype:IMAGEPLOT/LINEPLOT   - defaults to autoscale 
  SETvars.plots.axis[.plottype][.~plotcontent][.~componentname]                      = [-2 2]; 

  % example 1 - topomaps  
  SETvars.plots.axis.topomap.averages    = [ -8 20];
  SETvars.plots.axis.topomap.differences = [ -1 10];
  SETvars.plots.axis.topomap.statistics  = [.05 .01]; 

  % example 2 - topomaps for specific measuretype.componentname 
  SETvars.plots.axis.topomap.differences.Mean.PC2    = [  -0.2 0.2];

  % example 3 - imageplot 
  SETvars.plots.axis.imageplot.averages       = [-150 150]; 
  SETvars.plots.axis.imageplot.differences    = [ -40  40];  

  % example 4 - imageplot for specific componentname 
  SETvars.plots.axis.imageplot.differences.PC2       = [  -5.0 5.0];

  % example 5 - statistics - inserting new RGB colormap values 
  SETvars.plots.colormap.topomap.statistics =  [ [.3:.001:1]' [.3:.001:1]' [.3:.001:1]']; 

