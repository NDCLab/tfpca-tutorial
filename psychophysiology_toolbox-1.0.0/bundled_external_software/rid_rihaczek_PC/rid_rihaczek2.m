%reduced interference Rihaczek distribution;
function tfd=rid_rihaczek2(x,fbins);

tbins = length(x);

amb = zeros(tbins);
for tau = 1:tbins
    amb(tau,:) = ifft( conj(x) .* x([tau:tbins 1:tau-1]) );
end

ambTemp = [amb(:,tbins/2+1:tbins) amb(:,1:tbins/2)];
amb1 = [ambTemp(tbins/2+1:tbins,:); ambTemp(1:tbins/2,:)];

D=[-1:2/(tbins-1):1]'*[-1:2/(tbins-1):1];
L=D;
K=chwi_krn(D,L,0.001);

ambf = amb1 .* K;

A = zeros(fbins,tbins);

if tbins ~= fbins
  for tt = 1:tbins
      A(:,tt) = datawrap(ambf(:,tt), fbins);
  end
else
   A = ambf;
end

tfd = fft2(A);