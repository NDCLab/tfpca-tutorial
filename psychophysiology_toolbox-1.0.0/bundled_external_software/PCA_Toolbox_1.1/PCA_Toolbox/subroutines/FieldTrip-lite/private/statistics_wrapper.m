function [stat] = statistics_wrapper(cfg, varargin);

% STATISTICS_WRAPPER performs the selection of the biological data for
% timelock, frequency or source data and sets up the design vector or
% matrix.
%
% The specific configuration options for selecting timelock, frequency
% of source data are described in TIMELOCKSTATISTICS, FREQSTATISTICS and
% SOURCESTATISTICS, respectively.
%
% After selecting the data, control is passed on to a data-independent
% statistical subfunction that computes test statistics plus their associated
% significance probabilities and critical values under some null-hypothesis. The statistical
% subfunction that is called is STATISTICS_xxx, where cfg.method='xxx'. At
% this moment, we have implemented two statistical subfunctions:
% STATISTICS_ANALYTIC, which calculates analytic significance probabilities and critical
% values (exact or asymptotic), and STATISTICS_MONTECARLO, which calculates
% Monte-Carlo approximations of the significance probabilities and critical values.
%
% The specific configuration options for the statistical test are
% described in STATISTICS_xxx.

% This function depends on PREPARE_TIMEFREQ_DATA which has the following options:
% cfg.avgoverchan
% cfg.avgoverfreq
% cfg.avgovertime
% cfg.channel
% cfg.channelcmb
% cfg.datarepresentation (set in STATISTICS_WRAPPER cfg.datarepresentation = 'concatenated')
% cfg.frequency
% cfg.latency
% cfg.precision
% cfg.previous (set in STATISTICS_WRAPPER cfg.previous = [])
% cfg.version (id and name set in STATISTICS_WRAPPER)

% Copyright (C) 2005-2006, Robert Oostenveld
%
% $Log: statistics_wrapper.m,v $
% Revision 1.43  2007/08/06 10:15:44  roboos
% do not automatically add cfg.dim in case of source_trials, since
% after sourcegrandaverage the code makes an incorrect guess about
% the dimensions (which was the problem that caused stripes in the source
% reconstructions of Juan)
%
% Revision 1.42  2007/07/31 08:32:03  jansch
% added support for managing single trial beamed csds
%
% Revision 1.41  2007/05/30 07:08:11  roboos
% use checkdata instead of fixinside
%
% Revision 1.40  2007/05/08 08:22:50  roboos
% only test for the dimension of the source volume if present
%
% Revision 1.39  2007/04/03 11:47:26  roboos
% removed the specific handling for actvsblT, shoul dnow be done with redefinetrial
%
% Revision 1.38  2007/03/27 15:32:18  erimar
% Passed the dimord to called function. Updated help.
%
% Revision 1.37  2007/02/27 09:52:59  roboos
% added check on the size of the design matrix
%
% Revision 1.36  2007/02/12 16:54:45  ingnie
% fixed bug for singleton time and/or frequency dimension (channel data)
%
% Revision 1.35  2007/01/29 11:08:22  roboos
% changed the reformatting of the output (thanks to Juan for reporting a bug)
% it now works correctly for each combination of avgoverchan/avgoverfreq/avgovertime
%
% Revision 1.34  2006/09/05 18:50:25  roboos
% fixed two small bugs in get_source_avg subfunction
%
% Revision 1.33  2006/08/07 12:34:36  jansch
% fixed bug in assignment of dimensionality in case of source.trial
%
% Revision 1.32  2006/07/27 12:23:48  roboos
% add cfg.dim and cfg.inside in case of source data
%
% Revision 1.31  2006/07/20 15:33:54  roboos
% added other relevant defaults for prepare_timefreq_data
% VS: ----------------------------------------------------------------------
%
% Revision 1.30  2006/07/12 14:24:58  roboos
% added any to isnan
%
% Revision 1.29  2006/07/12 14:19:09  roboos
% neighbourselection output changed, hence modification needed here as well
%
% Revision 1.28  2006/07/06 12:44:33  jansch
% removed a bug in the assignment of the volume's dimension to the configuration
% in the case of sources as inputs
%
% Revision 1.27  2006/06/27 10:53:26  roboos
% replaced nan(n,m) by nan*zeros(n,m) for compatibility with matlab versions prior to 7.0
%
% Revision 1.26  2006/06/21 10:34:45  roboos
% removed part of the old cvs history
% moved the selection of source data to seperate subfunctions
%
% Revision 1.25  2006/06/13 14:55:27  ingnie
% added defaults cfg.channel = 'all', and cfg.latency = 'all'
%
% Revision 1.24  2006/06/09 12:32:50  erimar
% Correct typo.
%
% Revision 1.23  2006/06/09 12:23:45  erimar
% Added call to NEIGHBOURSELECTION, for construction of the neighbourhood
% geometry in cfg.neighbours.
%
% Revision 1.22  2006/06/07 18:31:52  roboos
% the stat.mask cannot contain nans because it is logical, therefore fill the outside voxels with "false" values
%
% Revision 1.21  2006/06/07 12:56:26  roboos
% ensure that the design is horizontal, i.e. Nvar X Nrepl

% set the defaults
if ~isfield(cfg, 'channel'),              cfg.channel = 'all';                     end
if ~isfield(cfg, 'latency'),              cfg.latency = 'all';                     end
if ~isfield(cfg, 'frequency'),            cfg.frequency = 'all';                   end
if ~isfield(cfg, 'avgoverchan'),          cfg.avgoverchan = 'no';                  end
if ~isfield(cfg, 'avgovertime'),          cfg.avgovertime = 'no';                  end
if ~isfield(cfg, 'avgoverfreq'),          cfg.avgoverfreq = 'no';                  end

% determine the type of the input and hence the output data
if ~exist('OCTAVE_VERSION')
  [s, i] = dbstack;
  if length(s)>1
    [caller_path, caller_name, caller_ext] = fileparts(s(2).name);
  else
    caller_path = '';
    caller_name = '';
    caller_ext  = '';
  end
  % evalin('caller', 'mfilename') does not work for Matlab 6.1 and 6.5
  istimelock = strcmp(caller_name,'timelockstatistics');
  isfreq = strcmp(caller_name,'freqstatistics');
  issource = strcmp(caller_name,'sourcestatistics');
else
  % cannot determine the calling function in Octave, try looking at the
  % data instead
  istimelock = isfield(varargin{1},'time') && ~isfield(varargin{1},'freq') && isfield(varargin{1},'avg');
  isfreq = isfield(varargin{1},'time') && isfield(varargin{1},'freq');
  issource = isfield(varargin{1},'pos') || isfield(varargin{1},'transform');
end

if (istimelock+isfreq+issource)~=1
  error('Could not determine the type of the input data');
end

% for backward compatibility
if isfield(cfg, 'approach')
  warning('you should use cfg.method instead of cfg.approach');
  cfg.method = cfg.approach;
  cfg = rmfield(cfg, 'approach');
end

% this is not backward compatible
if isfield(cfg, 'transform') && ~isempty(cfg.transform)
  error('cfg.transform is not supported adny more, you should transform your data manually')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% collect the biological data (the dependent parameter)
%  and the experimental design (the independent parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if issource

  % test that all source inputs have the same dimensions and are spatially aligned
  for i=2:length(varargin)
    if isfield(varargin{1}, 'dim') && (length(varargin{i}.dim)~=length(varargin{1}.dim) || ~all(varargin{i}.dim==varargin{1}.dim))
      error('dimensions of the source reconstructions do not match, use NORMALISEVOLUME first');
    end
    if isfield(varargin{1}, 'pos') && (length(varargin{i}.pos(:))~=length(varargin{1}.pos(:)) || ~all(varargin{i}.pos(:)==varargin{1}.pos(:)))
      error('grid locations of the source reconstructions do not match, use NORMALISEVOLUME first');
    end
    if isfield(varargin{1}, 'transform') && ~all(varargin{i}.transform(:)==varargin{1}.transform(:))
      error('spatial coordinates of the source reconstructions do not match, use NORMALISEVOLUME first');
    end
  end

  Nsource = length(varargin);
  Nvoxel  = length(varargin{1}.inside) + length(varargin{1}.outside);

  % get the source parameter on which the statistic should be evaluated
  if strcmp(cfg.parameter, 'mom') && isfield(varargin{1}.avg, 'csdlabel') && isfield(varargin{1}, 'cumtapcnt')
    [dat, cfg] = get_source_pcc_mom(cfg, varargin{:});
  elseif strcmp(cfg.parameter, 'mom') && ~isfield(varargin{1}.avg, 'csdlabel')
    [dat, cfg] = get_source_lcmv_mom(cfg, varargin{:});
  elseif isfield(varargin{1}, 'trial')
    [dat, cfg] = get_source_trial(cfg, varargin{:});
  else
    [dat, cfg] = get_source_avg(cfg, varargin{:});
  end
  cfg.dimord = 'voxel';
 
elseif isfreq || istimelock
  % get the ERF/TFR data by means of PREPARE_TIMEFREQ_DATA
  cfg.datarepresentation = 'concatenated';
  [cfg, data] = prepare_timefreq_data(cfg, varargin{:});
  cfg = rmfield(cfg, 'datarepresentation');

  dim = size(data.biol);
  if length(dim)<3
    % seems to be singleton frequency and time dimension
    dim(3)=1;
    dim(4)=1;
  elseif length(dim)<4
    % seems to be singleton time dimension
    dim(4)=1;
  end
  cfg.dimord = 'chan_freq_time';
  
  % the dimension of the original data (excluding the replication dimension) has to be known for clustering
  cfg.dim = dim(2:end);
  % all dimensions have to be concatenated except the replication dimension and the data has to be transposed
  dat = transpose(reshape(data.biol, dim(1), prod(dim(2:end))));

  % remove to save some memory
  data.biol = [];
  
  % add gradiometer/electrode information to the configuration
  if ~isfield(cfg,'neighbours')
    cfg.neighbours = neighbourselection(cfg,varargin{1});
  end
  
end

% get the design from the information in cfg and data.
if ~isfield(cfg,'design')
  cfg.design = data.design;
  [cfg] = prepare_design(cfg);
end

if size(cfg.design,2)~=size(dat,2)
  cfg.design = transpose(cfg.design);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the statistic, using the data-independent statistical subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% determine the function handle to the intermediate-level statistics function
if exist(['statistics_' cfg.method])
  statmethod = str2func(['statistics_' cfg.method]);
else
  error(sprintf('could not find the corresponding function for cfg.method="%s"\n', cfg.method));
end
fprintf('using "%s" for the statistical testing\n', func2str(statmethod));

% check that the design completely describes the data
if size(dat,2) ~= size(cfg.design,2)
  error('the size of the design matrix does not match the number of observations in the data');
end

% perform the statistical test
if nargout(statmethod)>1
  [stat, cfg] = statmethod(cfg, dat, cfg.design);
else
  [stat] = statmethod(cfg, dat, cfg.design);
end

if isstruct(stat)
  % the statistical output contains multiple elements, e.g. F-value, beta-weights and probability
  statfield = fieldnames(stat);
else
  % only the probability was returned as a single matrix, reformat into a structure
  dum = stat; stat = []; % this prevents a Matlab warning that appears from release 7.0.4 onwards
  stat.prob = dum;
  statfield = fieldnames(stat);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add descriptive information to the output and rehape into the input format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if issource
  % remember the definition of the volume, assume that they are identical for all input arguments
  try, stat.dim       = varargin{1}.dim;        end
  try, stat.xgrid     = varargin{1}.xgrid;      end
  try, stat.ygrid     = varargin{1}.ygrid;      end
  try, stat.zgrid     = varargin{1}.zgrid;      end
  try, stat.inside    = varargin{1}.inside;     end
  try, stat.outside   = varargin{1}.outside;    end
  try, stat.pos       = varargin{1}.pos;        end
  try, stat.transform = varargin{1}.transform;  end
  for i=1:length(statfield)
    tmp = getsubfield(stat, statfield{i});
    if isfield(varargin{1}, 'inside') && prod(size(tmp))==length(varargin{1}.inside)
      % the statistic was only computed on voxels that are inside the brain
      % sort the inside and outside voxels back into their original place
      if islogical(tmp)
        tmp(varargin{1}.inside)  = tmp;
        tmp(varargin{1}.outside) = false;
      else
        tmp(varargin{1}.inside)  = tmp;
        tmp(varargin{1}.outside) = nan;
      end
    end
    if prod(size(tmp))==prod(varargin{1}.dim)
      % reshape the statistical volumes into the original format
      stat = setsubfield(stat, statfield{i}, reshape(tmp, varargin{1}.dim));
    end
  end
else
  haschan = 1; % this one remains relevant, even after averaging over channels
  hasfreq = strcmp(cfg.avgoverfreq, 'no') && ~any(isnan(data.freq));
  hastime = strcmp(cfg.avgovertime, 'no') && ~any(isnan(data.time));
  stat.dimord = '';
  if haschan
    stat.dimord = [stat.dimord 'chan_'];
    stat.label  = data.label;
    chandim = dim(2);
  end
  if hasfreq
    stat.dimord = [stat.dimord 'freq_'];
    stat.freq   = data.freq;
    freqdim = dim(3);
  end
  if hastime
    stat.dimord = [stat.dimord 'time_'];
    stat.time   = data.time;
    timedim = dim(4);
  end
  if length(stat.dimord)>0
    % remove the last '_'
    stat.dimord = stat.dimord(1:(end-1));
  end
  for i=1:length(statfield)
    try
      % reshape the fields that have the same dimension as the input data
      if     strcmp(stat.dimord, 'chan')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [chandim 1]));
      elseif strcmp(stat.dimord, 'chan_time')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [chandim timedim]));
      elseif strcmp(stat.dimord, 'chan_freq')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [chandim freqdim]));
      elseif strcmp(stat.dimord, 'chan_freq_time')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [chandim freqdim timedim]));
      elseif strcmp(stat.dimord, 'time')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [1 timedim]));
      elseif strcmp(stat.dimord, 'freq')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [1 freqdim]));
      elseif strcmp(stat.dimord, 'freq_time')
        stat = setfield(stat, statfield{i}, reshape(getfield(stat, statfield{i}), [freqdim timedim]));
      end
    end
  end
end

% add version information to the configuration
try
  % get the full name of the function
  cfg.version.name = mfilename('fullpath');
catch
  % required for compatibility with Matlab versions prior to release 13 (6.5)
  [st, i] = dbstack;
  cfg.version.name = st(i);
end
cfg.version.id = '$Id: statistics_wrapper.m,v 1.43 2007/08/06 10:15:44 roboos Exp $';

% remember the configuration of the input data
cfg.previous = [];
for i=1:length(varargin)
  if isfield(varargin{i}, 'cfg')
    cfg.previous{i} = varargin{i}.cfg;
  else
    cfg.previous{i} = [];
  end
end

% remember the exact configuration details
stat.cfg = cfg;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION for extracting the data of interest
% data resemples PCC beamed source reconstruction, multiple trials are coded in mom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dat, cfg] = get_source_pcc_mom(cfg, varargin);
Nsource = length(varargin);
Nvoxel  = length(varargin{1}.inside) + length(varargin{1}.outside);
Ninside = length(varargin{1}.inside);
dim     = varargin{1}.dim;
for i=1:Nsource
  dipsel  = find(strcmp(varargin{i}.avg.csdlabel, 'scandip'));
  ntrltap = sum(varargin{i}.cumtapcnt);
  dat{i}  = zeros(Ninside, ntrltap);
  for j=1:Ninside
    k = varargin{1}.inside(j);
    dat{i}(j,:) = reshape(varargin{i}.avg.mom{k}(dipsel,:), 1, ntrltap);
  end
end
% concatenate the data matrices of the individual input arguments
dat = cat(2, dat{:});
% remember the dimension of the source data
cfg.dim = dim;
% remember which voxels are inside the brain
cfg.inside = varargin{1}.inside;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION for extracting the data of interest
% data resemples LCMV beamed source reconstruction, mom contains timecourse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dat, cfg] = get_source_lcmv_mom(cfg, varargin);
Nsource = length(varargin);
Nvoxel  = length(varargin{1}.inside) + length(varargin{1}.outside);
Ntime   = length(varargin{1}.avg.mom{varargin{1}.inside(1)});
Ninside = length(varargin{1}.inside);
dim     = [varargin{1}.dim Ntime];
dat     = zeros(Ninside*Ntime, Nsource);
for i=1:Nsource
  % collect the 4D data of this input argument
  tmp = nan*zeros(Ninside, Ntime);
  for j=1:Ninside
    k = varargin{1}.inside(j);
    tmp(j,:) = reshape(varargin{i}.avg.mom{k}, 1, dim(4));
  end
  dat(:,i) = tmp(:);
end
% remember the dimension of the source data
cfg.dim = dim;
% remember which voxels are inside the brain
cfg.inside = varargin{1}.inside;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION for extracting the data of interest
% data contains single-trial or single-subject source reconstructions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dat, cfg] = get_source_trial(cfg, varargin);
Nsource = length(varargin);
Nvoxel  = length(varargin{1}.inside) + length(varargin{1}.outside);
for i=1:Nsource
  Ntrial(i) = length(varargin{i}.trial);
end
k = 1;
for i=1:Nsource
  for j=1:Ntrial(i)
    tmp = getsubfield(varargin{i}.trial(j), cfg.parameter);
    if ~iscell(tmp),
      dim = size(tmp);
    else
      dim = [Nvoxel size(tmp{varargin{i}.inside(1)})];
    end
    if i==1 && j==1 && prod(size(tmp))~=Nvoxel,
      warning('the input-data contains more entries than the number of voxels in the volume, the data will be concatenated');
      dat    = zeros(prod(dim), sum(Ntrial)); %FIXME this is old code should be removed
    elseif i==1 && j==1 && iscell(tmp),
      warning('the input-data contains more entries than the number of voxels in the volume, the data will be concatenated');
      dat    = zeros(Nvoxel*prod(size(tmp{varargin{i}.inside(1)})), sum(Ntrial));
    elseif i==1 && j==1,
      dat = zeros(Nvoxel, sum(Ntrial));
    end
    if ~iscell(tmp),
      dat(:,k) = tmp(:);
    else
      Ninside   = length(varargin{i}.inside); 
      %tmpvec    = (varargin{i}.inside-1)*prod(size(tmp{varargin{i}.inside(1)}));
      tmpvec    = varargin{i}.inside;
      insidevec = [];
      for m = 1:prod(size(tmp{varargin{i}.inside(1)}))
        insidevec = [insidevec; tmpvec(:)+(m-1)*Nvoxel]; 
      end
      insidevec = insidevec(:)';
      tmpdat  = reshape(permute(cat(3,tmp{varargin{1}.inside}), [3 1 2]), [Ninside prod(size(tmp{varargin{1}.inside(1)}))]);
      dat(insidevec, k) = tmpdat(:);
    end
    % add original dimensionality of the data to the configuration, is required for clustering
    %FIXME: this was obviously wrong, because often trial-data is one-dimensional, so no dimensional information is present
    %cfg.dim = dim(2:end);
    k = k+1;
  end
end
if isfield(varargin{1}, 'inside')
  fprintf('only selecting voxels inside the brain for statistics (%.1f%%)\n', 100*length(varargin{1}.inside)/prod(varargin{1}.dim));
  for j=prod(dim(2:end)):-1:1
    dat((j-1).*dim(1) + varargin{1}.outside, :) = [];
  end
end
% remember the dimension of the source data
if ~isfield(cfg, 'dim')
  warning('for clustering on trial-based data you explicitely have to specify cfg.dim');
end
% remember which voxels are inside the brain
cfg.inside = varargin{1}.inside;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION for extracting the data of interest
% get the average source reconstructions, the repetitions are in multiple input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dat, cfg] = get_source_avg(cfg, varargin);
Nsource = length(varargin);
Nvoxel  = length(varargin{1}.inside) + length(varargin{1}.outside);
dim     = varargin{1}.dim;
dat = zeros(Nvoxel, Nsource);
for i=1:Nsource
  tmp = getsubfield(varargin{i}, cfg.parameter);
  dat(:,i) = tmp(:);
end
if isfield(varargin{1}, 'inside')
  fprintf('only selecting voxels inside the brain for statistics (%.1f%%)\n', 100*length(varargin{1}.inside)/prod(varargin{1}.dim));
  dat = dat(varargin{1}.inside,:);
end
% remember the dimension of the source data
cfg.dim = dim;
% remember which voxels are inside the brain
cfg.inside = varargin{1}.inside;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION for creating a design matrix
% should be called in the code above, or in prepare_design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cfg] = get_source_design_pcc_mom(cfg, varargin);
% should be implemented

function [cfg] = get_source_design_lcmv_mom(cfg, varargin);
% should be implemented

function [cfg] = get_source_design_trial(cfg, varargin);
% should be implemented

function [cfg] = get_source_design_avg(cfg, varargin);
% should be implemented

