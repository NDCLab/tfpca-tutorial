function [outmat] = pcatfd_long2mat(inmat,fqbins,timebins),
%pcatfd_long2mat(inmat,fqbins,timebins),
% 
% rearranges TFDs in vectors back to matrices 
%  
% Psychophysiology Toolbox, Components, University of Minnesota  
 
outmat = zeros(fqbins,timebins,length(inmat(:,1)));
 
%reshape to mat
for t=1:length(inmat(:,1)),
 outmattemp=zeros(fqbins,timebins);
 for r=1:fqbins,
   outmattemp(r,:)=inmat(t,((r-1)*timebins)+1:((r-1)*timebins)+timebins);
 end
 outmat(:,:,t)=outmattemp;
end
   
