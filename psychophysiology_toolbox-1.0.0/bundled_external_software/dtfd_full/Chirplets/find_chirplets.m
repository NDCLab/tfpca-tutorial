function [PP1, res] = find_chirplets(x, Q, level, M, verbose, c, d, emits)
% find_chirplets -- find several chirplets in a signal
% 
%  Usage
%    [P, res] = find_chirplets(x, Q, level, M, verbose, c, d, emits)
%
%  Inputs
%    x         signal
%    Q         number of chirplets to look for
%    level     level of difficulty (optional, default is 2)
%    M         resolution parameter (optional, default is 64)
%    verbose   verbose flag (optional, default is 0)
%    c,d       intializations when level=1 (optional, defaults are 0 and 50)
%    emits     maximum number of iterations for EM algorithm (optional,
%              default is 5)
%
%  Outputs
%    P         M by 5 matrix of chirplet parameters (see chirplets.m)
%    res       norm of the residual for 0 to Q chirplets
%
% level 1: est_tf -> est_c -> est_d -> QN
% level 2: est_cd_global -> est_tf -> est_c -> est_d -> QN
% level 3: est_cd_global -> (est_tf -> est_c -> est_d) x 3 -> QN

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2,8,nargin));

if (nargin<3) level = 2; end
if (nargin<4) M = 64; end
if (nargin<5) verbose = 0; end
if (nargin<6) c = 0; end
if (nargin<7) d = 50; end
if (nargin<8) emits = 5; end

x = x(:);
N = length(x);
res = norm(x);

if (verbose)
  sx = tfdshift(spec2(x,1,128,8,10)); 
  subplot(211), ptfddb(sx,50,[1 N],[0 2*pi]), drawnow
end

PP1 = [];
done = 0;
i = 1;
e = x; % residual
while (~done)
  
  % find a chirplet
  P = best_chirplet(e, level, M, verbose, c, d);
  if (verbose) fprintf(1,'chirplet %d -> A = %6.2f, t = %6.2f, f = %4.2f, c = %7.4f, d = %6.2f\n', i, abs(P(1)), P(2:5)), end
  PP1 = [PP1 ; P];

  % refine with the EM algorithm
  PP0 = zeros(size(PP1));
  j = 1;
  if (verbose & i>1) fprintf(1,'em iteration: '), end
  while ( sum(sum(abs(PP1(:,2:5)-PP0(:,2:5)) > ones(i,1)*[.1 .001 1e-5 .1])) & ...
	  (j <= emits) & ...
	  (i > 1) )

    % save current as previous
    PP0 = PP1;

    % update current with delta residual
    for k = 1:i,
      z = chirplets(N, PP1);
      zk = chirplets(N, PP1(k,:));
      P = best_chirplet(x-(z-zk), 0, M, 0, PP1(k,4),PP1(k,5),PP1(k,2),PP1(k,3));
      PP1(k,:) = P;
    end
    if (verbose) fprintf(1,'%d ', j), end
    j = j + 1;
  end
  
  % get the residual
  y = chirplets(N,PP1);
  e = x - y;
  res = [res ; norm(e)];
  
  % show details if asked for...
  if (verbose & i>1)
    fprintf(1,'\n')
    for k = 1:i,
      fprintf(1,'chirplet %d -> A = %6.2f, t = %7.2f, f = %4.2f, c = %7.4f, d = %6.2f\n', k, abs(PP1(k,1)), PP1(k,2:5))
    end
    fprintf(1,'\n')
  end
  
  if (verbose)
    sy = tfdshift(spec2(y,1,128,8,10)); 
    subplot(212), ptfddb(sy,50,[1 N],[0 2*pi]), drawnow
  end
 
  % termination criteria
  if (Q==0)
    [xx yy button] = ginput(1);
    if (button == 'q') done=1; end
  elseif (Q==i)
    done = 1;
  end

  i = i + 1;
end
