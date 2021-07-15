function P = best_chirplet(x, level, M, verbose, c, d, t, f)
% best_chirplet -- find the chirplet that best fits the signal
% 
%  Usage
%    P = best_chirplet(x, level, M, verbose, c, d, t, f)
%
%  Inputs
%    x         signal
%    level     level of difficulty, 0 (easiest) -> 3 (hardest) (optional,
%              default is 2)
%    M         resolution parameter (optional, default is 64)
%    verbose   verbose flag (optional, default is 0)
%    c,d,t,f   possible intializations; level 0 uses c, d, t, and f;
%              level 1 uses c and d; (optional, defaults are 0, 50, N/2 and
%              0, respectively)
%
%  Outputs
%    P    vector of chirplet parameters (see chirplets.m)
%
% level 0: quasi-Newton (QN)
% level 1: est_tf -> est_c -> est_d -> QN
% level 2: est_cd_global -> est_tf -> est_c -> est_d -> QN
% level 3: est_cd_global -> (est_tf -> est_c -> est_d) x 3 -> QN

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1,8,nargin));

x = x(:);
N = length(x);

% this works better numerically
e = norm(x);
x = x/e;

if (nargin<2) level = 2; end
if (nargin<3) M = 64; end
if (nargin<4) verbose = 0; end
if (nargin<5) c = 0; end
if (nargin<6) d = 50; end
if (nargin<7) t = N/2; end
if (nargin<8) f = 0; end

if (level~=0 & level~=1 & level~=2 & level~=3)
  error('choose a valid level')
end

% estimate chirp-rate and duration globally
r = 5; % robustness parameter
if (level == 2 | level == 3)
  [c, d] = est_cd_global(x, M, r);
  if (verbose) fprintf(1,'est_cd_global -> c = %7.4f, d = %6.2f\n', c, d), end
end

if (level == 1 | level == 2)
  [t f] = est_tf(x, c, d, M);
  f = mod(f, 2*pi);
  if (verbose) fprintf(1,'est_tf -> t = %7.2f, f = %4.2f\n', t, f), end
  c = est_c(x, t, f, M);
  if (verbose) fprintf(1,'est_c -> c = %7.4f\n', c), end
  d = est_d(x, t, f, c, M);
  if (verbose) fprintf(1,'est_d -> d = %6.2f\n', d), end
elseif (level == 3)
  for i=1:3,
    [t f] = est_tf(x, c, d, M);
    f = mod(f, 2*pi);
    if (verbose) fprintf(1,'est_tf -> t = %7.2f, f = %4.2f\n', t, f), end
    c = est_c(x, t, f, M);
    if (verbose) fprintf(1,'est_c -> c = %7.4f\n', c), end
    d = est_d(x, t, f, c, M);
    if (verbose) fprintf(1,'est_d -> d = %6.2f\n', d), end
  end
end

% do a quasi-Newton maximization on the windowed signal
% a longer window is useful here.
Z = 4;
rt = round(t);
if ( (rt-Z*M < 1) & (rt+Z*M > N) )
  xx = [zeros(Z*M-rt+1,1) ; x ; zeros(Z*M-N+rt,1)];
elseif (rt-Z*M < 1)
  xx = [zeros(Z*M-rt+1,1) ; x(1:rt+Z*M)];
elseif (rt+Z*M > N)
  xx = [x(rt-Z*M:N) ; zeros(Z*M-N+rt,1)];
else
  xx = x(rt-Z*M:rt+Z*M);
end

opt = foptions;
P = constr('f_chirp',[Z*M+1+(t-rt) f c d],opt,[1 0 -inf .25],[2*Z*M+1 2*pi inf N/2],'g_chirp',xx);
P(1) = rt + P(1) - (Z*M+1);
P(2) = mod(P(2),2*pi);
if (verbose) fprintf(1,'constr -> t = %7.2f, f = %4.2f, c = %7.4f, d = %6.2f\n', P), end

y = chirplets(N, [1 P]);
A = y'*x;
A = A*e;

P = [A P];
