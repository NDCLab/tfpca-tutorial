function ptfddb(tfd, dbs, t, f, fs)
% ptfddb -- Display an image plot of a TFD with a dB amplitude scale.
%
%  Usage
%    ptfddb(tfd, dbs, t, f, fs)
%
%  Inputs
%    tfd  time-frequency distribution
%    dbs  rabge in dBs (optional, default is 25)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%    fs   font size of axis labels (optional)

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 5, nargin));

if (nargin < 5)
  fs = 10;
end
if (nargin < 4)
  f = [-0.5 0.5];
end
if (nargin < 3)
  t = [1 size(tfd,2)];
end
if (nargin < 2)
  dbs = 25;
end

if isempty(t)
  t = [1 size(tfd,2)];
end
if isempty(f)
  f = [-0.5 0.5];
end

tfd=tfd./sum(sum(tfd));
tfd=20*log10(abs(tfd)+eps);
tfd = tfd - max(max(tfd));
imagesc(t, f, tfd, [-dbs 0]), axis('xy'), xlabel('time','FontSize',fs), ylabel('frequency','FontSize',fs),set(gca,'FontSize',fs);
