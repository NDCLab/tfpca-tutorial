function [fft2b] = ffts(fft2b)
 
%[retval] = ffts(fft2b) 
% 
%  This takes an input matrix (fft2b), and does an fft on each row,
%  returning a half size matrix representing one side of the fft. 
%  Submitted matrix is padded with zeros to the next power of 2.  
% 
% abs = is for magnitude (square root of the power), square for power.  
% conj = power (square of absolute value) 
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

n=1;    
while exist('goodsize')==0,   
  if pow2(n)>=size(fft2b,2), 
    goodsize=pow2(n);  
  end 
  n=n+1;  
end  
 
fft2b = fft(fft2b',goodsize); 
fft2b = fft2b'; 
fft2b = abs(fft2b).*abs(fft2b);        %fft2b = fft2b.*conj(fft2b); 
fft2b = fft2b./goodsize;  
fft2b = fft2b(:,1:size(fft2b,2)/2); 
