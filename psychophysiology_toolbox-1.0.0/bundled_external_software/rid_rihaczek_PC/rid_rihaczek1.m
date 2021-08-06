% tfd=rid_rihaczek(x,fbins); 
% 
%  x     - signal to transform 
%  fbins - frequency bins of resolution  
% 
% Rihaczek Distribution - with reduced interference  
% 
% From Selin Aviente (2007)  
% 

function tfd=rid_rihaczek(x,fbins);

% vars 
tbins = length(x);

% run RID 

for tau = 1:tbins
    amb(tau,:) = ifft( conj(x) .* x([tau:tbins 1:tau-1]) );
end

ambTemp = [    amb(:,fbins/2+1:fbins)      amb(:,1:fbins/2)];
amb1    = [ambTemp(tbins/2+1:tbins,:); ambTemp(1:tbins/2,:)];

D=[-1:2/(fbins-1):1]'*[-1:2/(tbins-1):1];
L=D;
K=chwi_krn(D,L,0.001);

ambf = amb1 .* K;
tfd = fft2(ambf); 

% keep positive only 
tfd=flipud(tfd(1:round(end/2)+1,:));  

