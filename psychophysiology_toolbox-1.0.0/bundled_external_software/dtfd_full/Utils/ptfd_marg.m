function ptfd_marg(tfd, x, t, f, dbs, fs)
% ptfd_marg -- Display an image plot of a TFD with marginals
%
%  Usage
%    ptfd_marg(tfd, x, t, f, dbs, fs)
%
%  Inputs
%    tfd  time-frequency distribution
%    x    time marginal
%    X    frequency marginal
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%    dbs  dynamic range in dBs (optional)
%    fs   font size of axis labels (optional)

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(3, 6, nargin));

if (nargin < 6)
  fs = 10;
end
if (nargin < 5)
  dbs = 25;
end
if (nargin < 4)
  f = [-0.5 0.5];
end
if (nargin < 3)
  t = [1 size(tfd,2)];
end

if isempty(t)
  t = [1 size(tfd,2)];
end
if isempty(f)
  f = [-0.5 0.5];
end

clf
h_tf = axes('Position', [0.3 0.3 0.6 0.6]);
h_t = axes('Position', [0.3 0.1 0.6 0.15]);
h_f = axes('Position', [0.1 0.3 0.15 0.6]);

subplot(h_tf)
tfd=20*log10(abs(tfd)+eps);
tfd = tfd - max(max(tfd));
imagesc(tfd,[-dbs 0]), axis('xy'), set(gca,'XTickLabel',[], 'YTickLabel',[])
%contour(tfd, [-40 -25 -10],'k'), axis('xy'), set(gca,'XTickLabel',[], 'YTickLabel',[])

subplot(h_t), plot(linspace(t(1),t(end),length(x)),abs(x),'b',linspace(t(1),t(end),length(x)),-abs(x),'b'), xlabel('time','FontSize',fs), axis([t(1) t(end) 1.1*min(real(x)) 1.1*max(real(x))]), set(gca, 'FontSize', fs)

X = 20*log10(abs(fft(x))+eps);
X = X - max(X);
subplot(h_f), plot(X,linspace(f(1),f(end),length(X))), ylabel('frequency','FontSize',fs), axis([-dbs*.5 0 f(1) f(end)]), set(gca, 'FontSize', fs)
