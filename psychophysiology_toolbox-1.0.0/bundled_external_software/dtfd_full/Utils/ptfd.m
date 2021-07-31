function ptfd(tfd, t, f, fs)
% ptfd -- Display an image plot of a TFD with a linear amplitude scale.
%
%  Usage
%    ptfd(tfd, t, f, fs)
%
%  Inputs
%    tfd  time-frequency distribution
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%    fs   font size of axis labels (optional)

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 4, nargin));

if (nargin < 4)
  fs = 10;
end
if (nargin < 3)
  f = [-0.5 0.5];
end
if (nargin < 2)
  t = [1 size(tfd,2)];
end

if isempty(t)
  t = [1 size(tfd,2)];
end
if isempty(f)
  f = [-0.5 0.5];
end

imagesc(t, f, abs(tfd)), axis('xy'), xlabel('time','FontSize',fs), ylabel('frequency','FontSize',fs), set(gca,'FontSize',fs);
