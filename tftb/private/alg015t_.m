% ALG015T_ Test for ALG015M_.

% signal length
N=200;

% generate chirp signal
P=fix(N/2);
x=alg009m_([0.2*ones(1,P) 0.8*ones(1,N-P)]);
% take real part
x=real(x);

% fade signal at edges
%w=alg005m_(5,fix((N+1)/2),N,1,'center'); x=x(:).*w(:);

% resolution
R=256;

% compute wigner
[A,f,t,ef]=wigner(x,R,'Hanning','acf');
[C,f,t,ef]=wigner(x,R,'Hanning','speccorr');

% display results
figure
imagesc(t,f,abs(C)); set(gca,'YDir','normal');

% jobmon parameter
timer=0; monhan=0; units=0;

% switch domains
[B,f,t,ef]=alg015m_(A,0,3,timer,monhan,units);

% display result
figure
imagesc(t,f,abs(B)); set(gca,'YDir','normal');

sum(sum(abs(C-B)))