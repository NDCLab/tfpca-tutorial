function predictor
% predictor -- predict your performance in running races
%
%  Usage
%    predictor
%
% This is an interactive plotting program.
%    left mouse button or 'f' to increase speed
%    right mouse button or 's' to decrease speed
%    'm' for miles
%    'k' for kilometers
%    't' for total time
%    'p' for pace
%    'q' to quit
% Data taken without permission from Galloway's book on running.

fprintf(1,'Race pace predictor:\n');
fprintf(1,'\t- left mouse button or ''f'' to increase speed\n');
fprintf(1,'\t- right mouse button or ''s'' to decrease speed\n');
fprintf(1,'\t- ''m'' for miles\n');
fprintf(1,'\t- ''k'' for kilometers\n');
fprintf(1,'\t- ''t'' for total time\n');
fprintf(1,'\t- ''p'' for pace\n');
fprintf(1,'\t- ''q'' to quit\n');
fprintf(1,'Data taken without permission from Galloway''s book on running.\n');

km = [5 8 10 15 20 25 30 42.26];
data = [...
21.00 34.50 44.18 68.37 93.31 118.53 144.40 209.34 ; ...
20.49 34.31 43.55 67.59 92.40 117.47 143.20 207.36 ; ...
20.27 33.55 43.08 66.47 91.00 115.40 140.44 203.48 ; ...
19.56 33.03 42.02 65.03 88.37 112.37 137.00 198.21 ; ...
19.46 32.46 41.40 64.29 87.51 111.38 135.48 196.36 ; ...
19.36 32.30 41.19 63.56 87.06 110.40 134.38 194.53 ; ...
19.27 32.13 40.58 63.24 86.21 109.43 133.28 193.11 ; ...
19.17 31.57 40.38 62.52 85.38 108.47 132.20 191.32 ; ...
19.08 31.42 40.18 62.20 84.55 107.52 131.13 189.53 ; ...
18.59 31.26 39.58 61.50 84.12 106.58 130.07 188.17 ; ...
18.50 31.11 39.39 61.19 83.31 106.05 129.02 186.42 ; ...
18.41 30.56 39.20 60.49 82.50 105.13 127.58 185.09 ; ...
18.32 30.42 39.01 60.20 82.10 104.22 126.55 183.37 ; ...
18.23 30.27 38.43 59.51 81.30 103.31 125.53 182.07 ; ...
18.15 30.13 38.24 59.21 80.51 102.41 124.53 180.39 ; ...
18.07 29.59 38.06 58.55 80.13 101.52 123.53 179.11 ; ...
17.58 29.45 37.49 58.27 79.35 101.04 122.54 177.45 ; ...
17.50 29.32 37.31 58.00 78.58 100.17 121.56 176.21 ; ...
13.33 22.22 28.24 43.45 59.30  75.28  91.41 132.19 ];
data = floor(data) + (data-floor(data))*100/60;

me = [...
93 5     22.15 ; ...
93 8     38.30 ; ...
94 10    46.51 ; ...
94 16.13 75.00 ; ...
94 10    46.22 ; ...
95 5     20.56 ; ...
95 10    45.50 ; ...
95 8     34.56 ; ...
95 10    45.07 ; ...
96 10    44.42 ; ...
96 16.13 75.03 ; ...
96 16.13 69.51 ; ...
96 10    43.22 ; ...
97 10    41.40 ; ...
98 10    44.00 ; ...
98 5     20.08];
temp = me(:,3);
me(:,3) = floor(temp) + (temp-floor(temp))*100/60;

N = size(data,1);
M = size(data,2);
unit = 'm';
c = 1/1.612903;
xl = 'miles';  
tdisp = 'p';
yl = 'splits';
i = 1;

done = 0;

while (done==0),

  time = data(i,:);
  split = data(i,:)./(c*km);
  plot(c*km,split,'-',c*km,split,'o')

  if (tdisp=='t')
    h = floor(time/60);
    m = floor(time - h*60);
    s = round((time - floor(time))*60);
    ytl = sprintf('%d:%2d:%2d', [h; m; s]);
    ytl = strrep(ytl,' ','0');
    ytl = reshape(ytl,7,M)';
  else
    m = floor(split);
    s = round((split - floor(split))*60);
    ytl = sprintf('%d:%2d', [m; s]);
    ytl = strrep(ytl,' ','0');
    ytl = reshape(ytl,4,M)';
    hold on, plot(c*me(:,2), me(:,3)./(c*me(:,2)), '*'), hold off
    text(c*(me(:,2)+0.5), me(:,3)./(c*me(:,2)), num2str(me(:,1),2));
  end
  set(gca,'XTick',c*km, 'YTick',split, 'YTickLabel',ytl);
  xlabel(xl), ylabel(yl), title('pace predictor'), grid on
  axis([c*min(km) c*max(km) min(split) max(split)])

  [x, y, b] = ginput(1);
  switch char(b)
    case 'q', done=1;
    case 'm', c=1/1.612903; xl='miles';
    case 'k', c=1; xl='kilometers';
    case 'p', tdisp='p'; yl='splits';
    case 't', tdisp='t'; yl='time';
    case {char(1),'f'}, i=i+1;
    case {char(3),'s'}, i=i-1;
  end
  i = min(N,max(1,i));
end
