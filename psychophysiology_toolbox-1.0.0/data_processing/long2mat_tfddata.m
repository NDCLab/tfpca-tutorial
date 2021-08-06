function [outmat] = long2mat_erptfd(inmat,fqbins,timebins),
%long2mat_erptfd(inmat,fqbins,timebins),
% 
% rearranges TFDs in vectors back to matrices 
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 
  trials   = size(inmat,1);
  outmat = zeros(trials,fqbins,timebins);
 
% reshape to mat
  for tt=1:trials, 
   outmattemp=zeros(fqbins,timebins);
   for fqb=1:fqbins,
     outmattemp(fqb,:)=inmat(tt,((fqb-1)*timebins)+1:((fqb-1)*timebins)+timebins);
   end
   outmat(tt,:,:)=outmattemp;
  end
  
