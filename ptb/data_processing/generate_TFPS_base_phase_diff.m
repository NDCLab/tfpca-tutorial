function [phdif] = generate_TFPS_base_phase_diff(Rx,Ry), 

% [plv,phdiff] = generate_TFPS_base_phase_diff(Rx,Ry),
% 
%  X - complex TFD 1 
%  Y - complex TFD 2 
% 
%  plv - phase-locking value (absolute value of phase difference) 
%  phdiff - phase difference between X and Y 
% 
%  From Selin Aviente (2007)  
%  

% check data formatting
if length(size(Rx))~=2, disp([' ERROR: only 2D matrices allowed']); return; end 
if length(size(Ry))~=2, disp([' ERROR: only 2D matrices allowed']); return; end

% create phase difference 
phdif=(Rx./abs(Rx+eps)).*conj(Ry./abs(Ry+eps));

% create phase-locking value 
% need to take the absolute value of the sum of these, then divide by N  
%plv=abs(phdif); 

% cut matrices for use 
%phdif=phdif(1:round(end/2)+1,:);  
%plv  =  plv(1:round(end/2)+1,:); 

