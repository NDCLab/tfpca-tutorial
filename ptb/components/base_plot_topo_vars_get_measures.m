% Psychophysiology Toolbox, Components, University of Minnesota  

  % determine components and measures, and parameters for plots  
  switch runtype
    case {'pcatfd','wintfd'}, plotdrop = 2; measuresN = 5;
    case {'pca',   'win'},    plotdrop = 1; measuresN = 4; end

  component_names = fieldnames(components.components);

  tnames = [];
  for j=1:length(component_names),
    tname = char(component_names(j));
    tnames = strvcat(tnames,char(tname(1:end-1)));  end
  [comp_names,i] = unique(tnames,'rows'); 
   comp_names = tnames(sort(i),:);

  comp_measures = [];
  for j=1:length(comp_names(:,1)),
    comp_measures = [comp_measures; size(strmatch(comp_names(j,:),tnames),1);];
  end

% measuresN max(comp_measures); 
  compsN    = length(comp_names(:,1));
  startplot = measuresN * plotdrop;

