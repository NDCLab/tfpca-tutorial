function [dipout] = beamformer_dics(dip, grad, vol, dat, Cf, varargin)

% BEAMFORMER_DICS scans on pre-defined dipole locations with a single dipole
% and returns the beamformer spatial filter output for a dipole on every
% location.  Dipole locations that are outside the head will return a
% NaN value.
%
% Use as
%   [dipout] = beamformer_dics(dipin, grad, vol, dat, cov, varargin)
% where
%   dipin       is the input dipole model
%   grad        is the gradiometer definition
%   vol         is the volume conductor definition
%   dat         is the data matrix with the ERP or ERF
%   cov         is the data covariance or cross-spectral density matrix
% and
%   dipout      is the resulting dipole model with all details
%
% The input dipole model consists of
%   dipin.pos   positions for dipole, e.g. regular grid
%   dipin.mom   dipole orientation (optional)
%
% Optional arguments are specified in pairs of a property name and a
% property value
%  'Pr'              power of the external reference channel
%  'Cr'              cross spectral density between all data channels and the external reference channel
%  'refdip'          location of dipole with which coherence is computed
%  'lambda'          regularisation parameter
%  'powmethod'       can be 'trace' or 'lambda1'
%  'feedback'        give progress indication, can be 'text', 'gui' or 'none' (default)
%  'projectnoise'    project noise estimate through filter,         can be 'yes' or 'no'
%  'realfilter'      construct a real-valued filter,                can be 'yes' or 'no'
%  'keepfilter'      remember the beamformer filter,                can be 'yes' or 'no'
%  'keepleadfield'   remember the forward computation,              can be 'yes' or 'no'
%  'keepcsd'         remember the estimated cross-spectral density, can be 'yes' or 'no'
%  'reducerank'      reduce the leadfield rank, can be 'no' or a number (e.g. 2)
%  'normalize'       normalize the leadfield
%
% If the dipole definition only specifies the dipole location, a rotating
% dipole (regional source) is assumed on each location. If a dipole moment
% is specified, its orientation will be used and only the strength will
% be fitted to the data.

% Copyright (C) 2003-2006, Robert Oostenveld
%
% $Log: beamformer_dics.m,v $
% Revision 1.5  2007/12/11 11:17:49  roboos
% fixed bug in handling of prespecified dipole moment
%
% Revision 1.4  2006/10/16 15:18:35  roboos
% small change in comment
%
% Revision 1.3  2006/10/16 15:17:24  roboos
% fixed bug for powlambda/powtrace computation of noise (powlambda was hardcoded)
% also keep noise csd matrix if requested (projectnoise & keepcsd)
% fixed obvious bug in progress indicator
%
% Revision 1.2  2006/10/12 10:17:31  roboos
% fixed bug in selecting dipoles on the inside positions only
% output cell-arrays are [] for outside points
% removed catch for mom, fixed dipoles should also work
%
% Revision 1.1  2006/10/12 09:07:07  roboos
% moved code from beamformer into stand-alone functions, for easier use and maintenance
%

if mod(nargin-5,2)
  % the first 5 arguments are fixed, the other arguments should come in pairs
  error('invalid number of optional arguments');
end

% these optional settings do not have defaults
Pr            = keyval('Pr',            varargin);
Cr            = keyval('Cr',            varargin);
refdip        = keyval('refdip',        varargin);
reducerank    = keyval('reducerank',    varargin);
normalize     = keyval('normalize',     varargin);
powmethod     = keyval('powmethod',     varargin); % the default for this is set below
realfilter    = keyval('realfilter',    varargin); % the default for this is set below
% these optional settings have defaults
feedback      = keyval('feedback',      varargin); if isempty(feedback),      feedback = 'text';            end
keepcsd       = keyval('keepcsd',       varargin); if isempty(keepcsd),       keepcsd = 'no';               end
keepfilter    = keyval('keepfilter',    varargin); if isempty(keepfilter),    keepfilter = 'no';            end
keepleadfield = keyval('keepleadfield', varargin); if isempty(keepleadfield), keepleadfield = 'no';         end
lambda        = keyval('lambda',        varargin); if isempty(lambda  ),      lambda = 0;                   end
projectnoise  = keyval('projectnoise',  varargin); if isempty(projectnoise),  projectnoise = 'yes';         end

% convert the yes/no arguments to the corresponding logical values
keepcsd       = strcmp(keepcsd,       'yes');
keepfilter    = strcmp(keepfilter,    'yes');
keepleadfield = strcmp(keepleadfield, 'yes');
projectnoise  = strcmp(projectnoise,  'yes');

% default is to use the largest singular value of the csd matrix, see Gross 2001
if isempty(powmethod)
  powmethod = 'lambda1';
end

% default is to be consistent with the original description of DICS in Gross 2001
if isempty(realfilter)
  realfilter = 'no';
end

% use these two logical flags instead of doing the string comparisons each time again
powtrace   = strcmp(powmethod, 'trace');
powlambda1 = strcmp(powmethod, 'lambda1');

if ~isempty(Cr)
  % ensure that the cross-spectral density with the reference signal is a column matrix
  Cr = Cr(:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find the dipole positions that are inside/outside the brain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(dip, 'inside') & ~isfield(dip, 'outside');
  [dip.inside, dip.outside] = find_inside_vol(dip.pos, vol);
elseif isfield(dip, 'inside') & ~isfield(dip, 'outside');
  dip.outside    = setdiff(1:size(dip.pos,1), dip.inside);
elseif ~isfield(dip, 'inside') & isfield(dip, 'outside');
  dip.inside     = setdiff(1:size(dip.pos,1), dip.outside);
end

% select only the dipole positions inside the brain for scanning
dip.origpos     = dip.pos;
dip.originside  = dip.inside;
dip.origoutside = dip.outside;
if isfield(dip, 'mom')
  dip.mom = dip.mom(:,dip.inside);
end
if isfield(dip, 'leadfield')
  fprintf('using precomputed leadfields\n');
  dip.leadfield = dip.leadfield(dip.inside);
end
if isfield(dip, 'filter')
  fprintf('using precomputed filters\n');
  dip.filter = dip.filter(dip.inside);
end
if isfield(dip, 'subspace')
  fprintf('using subspace projection\n');
  dip.subspace = dip.subspace(dip.inside);
end
dip.pos     = dip.pos(dip.inside, :);
dip.inside  = 1:size(dip.pos,1);
dip.outside = [];

% dics has the following sub-methods, which depend on the function input arguments
% power only, cortico-muscular coherence and cortico-cortical coherence
if ~isempty(Cr) & ~isempty(Pr) & isempty(refdip)
  % compute cortico-muscular coherence, using reference cross spectral density
  submethod = 'dics_refchan';
elseif isempty(Cr) & isempty(Pr) & ~isempty(refdip)
  % compute cortico-cortical coherence with a dipole at the reference position
  submethod = 'dics_refdip';
elseif isempty(Cr) & isempty(Pr) & isempty(refdip)
  % only compute power of a dipole at the grid positions
  submethod = 'dics_power';
else
  error('invalid combination of input arguments for dics');
end

isrankdeficient = (rank(Cf)<size(Cf,1));
if isrankdeficient & ~isfield(dip, 'filter')
  warning('cross-spectral density matrix is rank deficient')
end

if projectnoise
  % estimate the noise power, which is further assumed to be equal and uncorrelated over channels
  if isrankdeficient
    % estimated noise floor is equal to or higher than lambda
    noise = lambda;
  else
    % estimate the noise level in the covariance matrix by the smallest singular value
    noise = svd(Cf);
    noise = noise(end);
    % estimated noise floor is equal to or higher than lambda
    noise = max(noise, lambda);
  end
end

% the inverse only has to be computed once for all dipoles
if strcmp(realfilter, 'yes')
  % the filter is computed using only the leadfield and the inverse covariance or CSD matrix
  % therefore using the real-valued part of the CSD matrix here ensures a real-valued filter
  invCf = pinv(real(Cf) + lambda * eye(size(Cf)));
else
  invCf = pinv(Cf + lambda * eye(size(Cf)));
end

if isfield(dip, 'subspace')
  fprintf('using subspace projection\n');
  % remember the original data prior to the voxel-dependant subspace projection
  Cf_pre_subspace = Cf;
  if strcmp(submethod, 'dics_refchan')
    Cr_pre_subspace = Cr;
    Pr_pre_subspace = Pr;
  end
end

% start the scanning with the proper metric
progress('init', feedback, 'scanning grid');
switch submethod

  case 'dics_power'
    % only compute power of a dipole at the grid positions
    for i=1:size(dip.pos,1)
      if isfield(dip, 'leadfield')
        % reuse the leadfield that was previously computed
        lf = dip.leadfield{i};
      elseif isfield(dip, 'mom')
        % compute the leadfield for a fixed dipole orientation
        lf = compute_leadfield(dip.pos(i,:), grad, vol, 'reducerank', reducerank, 'normalize', normalize) * dip.mom(:,i);
      else
        % compute the leadfield
        lf = compute_leadfield(dip.pos(i,:), grad, vol, 'reducerank', reducerank, 'normalize', normalize);
      end
      if isfield(dip, 'subspace')
        % do subspace projection of the forward model
        lf = dip.subspace{i} * lf;
        % the cross-spectral density becomes voxel dependent due to the projection
        Cf    = dip.subspace{i} * Cf_pre_subspace * dip.subspace{i}';
        invCf = pinv(dip.subspace{i} * (Cf_pre_subspace + lambda * eye(size(Cf))) * dip.subspace{i}');
      end
      if isfield(dip, 'filter')
        % use the provided filter
        filt = dip.filter{i};
      else
        % construct the spatial filter
        filt = pinv(lf' * invCf * lf) * lf' * invCf;              % Gross eqn. 3, use PINV/SVD to cover rank deficient leadfield
      end
      csd = filt * Cf * ctranspose(filt);                         % Gross eqn. 4 and 5
      if powlambda1
        dipout.pow(i) = lambda1(csd);                             % compute the power at the dipole location, Gross eqn. 8
      elseif powtrace
        dipout.pow(i) = real(trace(csd));                         % compute the power at the dipole location
      end
      if keepcsd
        dipout.csd{i} = csd;
      end
      if projectnoise 
        if powlambda1
          dipout.noise(i) = noise * lambda1(filt * ctranspose(filt));
        elseif powtrace
          dipout.noise(i) = noise * real(trace(filt * ctranspose(filt)));
        end
        if keepcsd
          dipout.noisecsd{i} = noise * filt * ctranspose(filt);
        end
      end
      if keepfilter
        dipout.filter{i} = filt;
      end
      if keepleadfield
        dipout.leadfield{i} = lf;
      end
      progress(i/size(dip.pos,1), 'scanning grid %d/%d\n', i, size(dip.pos,1));
    end

  case 'dics_refchan'
    % compute cortico-muscular coherence, using reference cross spectral density
    for i=1:size(dip.pos,1)
      if isfield(dip, 'leadfield')
        % reuse the leadfield that was previously computed
        lf = dip.leadfield{i};
      elseif isfield(dip, 'mom')
        % compute the leadfield for a fixed dipole orientation
        lf = compute_leadfield(dip.pos(i,:), grad, vol, 'reducerank', reducerank, 'normalize', normalize) .* dip.mom(i,:)';
      else
        % compute the leadfield
        lf = compute_leadfield(dip.pos(i,:), grad, vol, 'reducerank', reducerank, 'normalize', normalize);
      end
      if isfield(dip, 'subspace')
        % do subspace projection of the forward model
        lf = dip.subspace{i} * lf;
        % the cross-spectral density becomes voxel dependent due to the projection
        Cr    = dip.subspace{i} * Cr_pre_subspace;
        Cf    = dip.subspace{i} * Cf_pre_subspace * dip.subspace{i}';
        invCf = pinv(dip.subspace{i} * (Cf_pre_subspace + lambda * eye(size(Cf))) * dip.subspace{i}');
      end
      if isfield(dip, 'filter')
        % use the provided filter
        filt = dip.filter{i};
      else
        % construct the spatial filter
        filt = pinv(lf' * invCf * lf) * lf' * invCf;                   % use PINV/SVD to cover rank deficient leadfield
      end
      if powlambda1
        pow = lambda1(filt * Cf * ctranspose(filt));                   % compute the power at the dipole location, Gross eqn. 4, 5 and 8
      elseif powtrace
        pow = real(trace(filt * Cf * ctranspose(filt)));               % compute the power at the dipole location
      end
      csd = filt*Cr;                                                   % Gross eqn. 6
      if powlambda1
        coh = lambda1(csd)^2 / (pow * Pr);                             % Gross eqn. 9
      elseif powtrace
        coh = real(trace(csd))^2 / (pow * Pr);
      end
      dipout.pow(i) = pow;
      dipout.coh(i) = coh;
      if keepcsd
        dipout.csd{i} = csd;
      end
      if projectnoise
        if powlambda1
          dipout.noise(i) = noise * lambda1(filt * ctranspose(filt));
        elseif powtrace
          dipout.noise(i) = noise * real(trace(filt * ctranspose(filt)));
        end
        if keepcsd
          dipout.noisecsd{i} = noise * filt * ctranspose(filt);
        end
      end
      if keepfilter
        dipout.filter{i} = filt;
      end
      if keepleadfield
        dipout.leadfield{i} = lf;
      end
      progress(i/size(dip.pos,1), 'scanning grid %d/%d\n', i, size(dip.pos,1));
    end

  case 'dics_refdip'
    if isfield(dip, 'subspace')
      error('subspace projections are not supported for beaming cortico-cortical coherence');
    end
    % compute cortio-cortical coherence with a dipole at the reference position
    lf1 = compute_leadfield(refdip, grad, vol, 'reducerank', reducerank, 'normalize', normalize);
    % construct the spatial filter for the first (reference) dipole location
    filt1 = pinv(lf1' * invCf * lf1) * lf1' * invCf;       % use PINV/SVD to cover rank deficient leadfield
    if powlambda1
      Pref = lambda1(filt1 * Cf * ctranspose(filt1));      % compute the power at the first dipole location, Gross eqn. 8
    elseif powtrace
      Pref = real(trace(filt1 * Cf * ctranspose(filt1)));  % compute the power at the first dipole location
    end
    for i=1:size(dip.pos,1)
      if isfield(dip, 'leadfield')
        % reuse the leadfield that was previously computed
        lf2 = dip.leadfield{i};
      elseif isfield(dip, 'mom')
        % compute the leadfield for a fixed dipole orientation
        lf = compute_leadfield(dip.pos(i,:), grad, vol, 'reducerank', reducerank, 'normalize', normalize) .* dip.mom(i,:)';
      else
        % compute the leadfield
        lf2 = compute_leadfield(dip.pos(i,:), grad, vol, 'reducerank', reducerank, 'normalize', normalize);
      end
      if isfield(dip, 'filter')
        % use the provided filter
        filt2 = dip.filter{i};
      else
        % construct the spatial filter for the second dipole location
        filt2 = pinv(lf2' * invCf * lf2) * lf2' * invCf;   %  use PINV/SVD to cover rank deficient leadfield
      end
      csd = filt1 * Cf * ctranspose(filt2);                % compute the cross spectral density between the two dipoles, Gross eqn. 4
      if powlambda1
        pow = lambda1(filt2 * Cf * ctranspose(filt2));     % compute the power at the second dipole location, Gross eqn. 8
      elseif powtrace
        pow = real(trace(filt2 * Cf * ctranspose(filt2))); % compute the power at the second dipole location
      end
      if powlambda1
        coh = lambda1(csd)^2 / (pow * Pref);               % compute the coherence between the first and second dipole
      elseif powtrace
        coh = real(trace((csd)))^2 / (pow * Pref);         % compute the coherence between the first and second dipole
      end
      dipout.pow(i) = pow;
      dipout.coh(i) = coh;
      if keepcsd
        dipout.csd{i} = csd;
      end
      if projectnoise
        if powlambda1
          dipout.noise(i) = noise * lambda1(filt2 * ctranspose(filt2));
        elseif powtrace
          dipout.noise(i) = noise * real(trace(filt2 * ctranspose(filt2)));
        end
        if keepcsd
          dipout.noisecsd{i} = noise * filt2 * ctranspose(filt2);
        end
      end
      if keepleadfield
        dipout.leadfield{i} = lf2;
      end
      progress(i/size(dip.pos,1), 'scanning grid %d/%d\n', i, size(dip.pos,1));
    end

end % switch submethod

progress('close');

dipout.inside  = dip.originside;
dipout.outside = dip.origoutside;
dipout.pos     = dip.origpos;

% reassign the scan values over the inside and outside grid positions
if isfield(dipout, 'leadfield')
  dipout.leadfield(dipout.inside)  = dipout.leadfield;
  dipout.leadfield(dipout.outside) = {[]};
end
if isfield(dipout, 'filter')
  dipout.filter(dipout.inside)  = dipout.filter;
  dipout.filter(dipout.outside) = {[]};
end
if isfield(dipout, 'pow')
  dipout.pow(dipout.inside)  = dipout.pow;
  dipout.pow(dipout.outside) = nan;
end
if isfield(dipout, 'noise')
  dipout.noise(dipout.inside)  = dipout.noise;
  dipout.noise(dipout.outside) = nan;
end
if isfield(dipout, 'coh')
  dipout.coh(dipout.inside)  = dipout.coh;
  dipout.coh(dipout.outside) = nan;
end
if isfield(dipout, 'csd')
  dipout.csd(dipout.inside)  = dipout.csd;
  dipout.csd(dipout.outside) = {[]};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function to obtain the largest singular value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = lambda1(x);
% determine the largest singular value, which corresponds to the power along the dominant direction
s = svd(x);
s = s(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function to compute the pseudo inverse. This is the same as the
% standard Matlab function, except that the default tolerance is twice as
% high.
%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 2007/12/11 11:17:49 $
%   default tolerance increased by factor 2 (Robert Oostenveld, 7 Feb 2004)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = pinv(A,varargin)
[m,n] = size(A);
if n > m
  X = pinv(A',varargin{:})';
else
  [U,S,V] = svd(A,0);
  if m > 1, s = diag(S);
  elseif m == 1, s = S(1);
  else s = 0;
  end
  if nargin == 2
    tol = varargin{1};
  else
    tol = 10 * max(m,n) * max(s) * eps;
  end
  r = sum(s > tol);
  if (r == 0)
    X = zeros(size(A'),class(A));
  else
    s = diag(ones(r,1)./s(1:r));
    X = V(:,1:r)*s*U(:,1:r)';
  end
end

