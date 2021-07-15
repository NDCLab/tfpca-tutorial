%phase coherence between two signals using the Reduced interference
%Rihaczek distribution;
function [phdif,pc,Rx,Ry]=tfrri(x,y,delta);
%x-->first signal;
%y-->second signal;
%delta--> the length of the window for computing the phase coherence
%x and y are assumed to be the same length;
%fbins=2^ceil(log2(length(x)));
fbins=length(x);
Rx=rid_rihaczek(x,fbins);
Ry=rid_rihaczek(y,fbins);
phdif=(Rx./abs(Rx+eps)).*conj(Ry./abs(Ry+eps));
%smooth the phase difference;
[L,M]=size(Rx);
%L is the number of frequency points;
%M is the number of time points;
%compute the coherence for each time and frequency point;
for l=1:L;
  for m=1+delta:M-delta;
    %pc(l,m)=(1/((2*delta)+1))*abs(sum(exp(j*mod(angle(phdif(l,m-delta:m+delta)),pi))));
    pc(l,m)=(1/((2*delta)+1))*abs(sum(exp(j*angle(phdif(l,m-delta:m+delta)))));
    %pc(l,m)=(1/((2*delta)+1))*(sum(exp(j*mod(angle(phdif(l,m-delta:m+delta)),pi))));
    %pc(l,m)=(1/((2*delta)+1))*abs(sum(phdif(l,m-delta:m+delta)));
  end
end
