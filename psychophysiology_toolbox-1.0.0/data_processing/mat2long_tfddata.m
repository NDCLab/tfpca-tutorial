function [outmat] = mat2long_tfd(inmat),
%pcatfd_mat2long(inmat),
% 
% rearranges TFD matrices into vectors 
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 
  trials   = size(inmat,1);
  fqbins   = size(inmat,2);
  timebins = size(inmat,3);

  outmat=[];
  outmattemp=[];

% reshape data 
  for fqb=1:fqbins,
    outmattemp=squeeze(inmat(:,fqb,:));
    outmat=[outmat  outmattemp ];
  end

