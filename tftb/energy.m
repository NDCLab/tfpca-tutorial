function E=energy(s)
%ENERGY Returns the energy of signals or distributions.
%   ES = ENERGY(S) returns SUM(S.*CONJ(S)) if S is a
%   vector and SUM(SUM(S)) if S is a matrix.
%   
%   EXAMPLE: x=logon(50,0.3,200)+logon(130,0.7,200)+logon(140,-0.5,200);
%            W=wigner(x,256);
%            disp(['Signal energy:       ',num2str(energy(x))]);
%            disp(['Distribution energy: ',num2str(energy(W))]);


%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if (size(s,1)==1)|(size(s,2)==1);
   E=sum(abs(s.*conj(s)));
else
   E=sum(sum(s));
end
