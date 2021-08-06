function [outmat] = pcatfd_mat2long(inmat,fqbins),
%pcatfd_mat2long(inmat,fqbins),
% 
% rearranges TFD matrices into vectors 
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

outmat=[];
outmattemp=[];

for r=1:fqbins,
  outmattemp=squeeze(inmat(r,:,:)); 
  outmat=[outmat; outmattemp;];
end 

outmat = outmat'; 

