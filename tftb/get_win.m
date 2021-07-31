function [W,WN]=get_win(A,NUM,L,S)
%GET_WIN Applies or returns window function arrays. 
%   [W,WN] = GET_WIN(A,NUM,L,S) applies a window function with number 
%   NUM to each column of the array A and returns the result in W. The
%   available window functions are Rectangular (NUM=1), Gaussian (NUM=2),
%   Hamming (NUM=3), Hanning (NUM=4), Bartlett (NUM=5), Triangular (NUM=6),
%   and Blackman (N=7). WN contains the name of the applied window. The
%   length of the window is the largest odd number smaller than SIZE(A,1)
%   unless the optional parameter L is specified. If L is specified then
%   the length of the applied window is 2*L-1 (as long as 2*L-1<=SIZE(A,1)). 
%   The optional parameter S controls if the window is centered (S='center')
%   or decentered (S='decenter'). If S is omitted then the window is
%   centered by default.
%   [W,WN] = GET_WIN([ R N ],NUM,L,S) simply returns the window function
%   array W that would be applied to an input array A of SIZE(A)=[ R N ]
%   (with R and N being scalars). Similarly
%   [W,WN] = GET_WIN(R,NUM,L,S) simply returns the window function vector
%   W that would be applied to an input array A of SIZE(A)=[ R 1 ].
%
%   EXAMPLE: x=logon(50,0.3,200)+logon(130,0.7,200)+logon(140,-0.5,200);
%            [W,f,t]=wigner(x,256);
%            figure; imagesc(t,f,W); set(gca,'YDir','normal');
%            A=dochange(W,'tfd','acf');
%            A=get_win(A,2);
%            A=dochange(A,'acf','tfd');
%            figure; imagesc(t,f,A); set(gca,'YDir','normal');
%
%   See also GET_KRN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% get size parameters
R=size(A,1); N=size(A,2); mltf=1;
if (R==1) & (N==2); N=round(A(2)); R=round(A(1)); mltf=0; end
if (R==1) & (N==1); R=round(A(1)); mltf=0; end

% default values
if nargin<3; L=fix(0.5*(R+1)); end
if nargin<4; S='center'; end
if 2*L-1>R; L=fix(0.5*(R+1)); end

% check for right syntax
S=lower(S);
if ~(strcmp(S,'center') | strcmp(S,'decenter'));
   error('Syntax error in "(de)center" parameter.'); end

% compute window array
[W,WN]=alg005m_(NUM,L,R,N,S); W=W.';

% multiply with input
if mltf; W=W.*A; end
