function [resample] = resampedesign(cfg, design);

% RESAMPLEDESIGN returns a resampling matrix, in which each row can be
% used to resample either the original design matrix or the original data.
% The random resampling is done given user-specified constraints on the
% experimental design, e.g. to swap within paired observations but not
% between pairs.
%
% Use as
%   [resample] = randomizedesign(cfg, design)
% where the configuration can contain
%   cfg.resampling       = 'permutation' or 'bootstrap'
%   cfg.numrandomization = number (e.g. 300), can be 'all' in case of two conditions
%   cfg.ivar             = number or list with indices, independent variable(s)
%   cfg.uvar             = number or list with indices, unit variable(s)
%   cfg.wvar             = number or list with indices, within-cell variable(s)
%   cfg.cvar             = number or list with indices, control variable(s)
%
% See also STATISTICS_MONTECARLO

% Copyright (C) 2005-2007, Robert Oostenveld
%
% $Log: resampledesign.m,v $
% Revision 1.3  2007/07/18 15:07:54  roboos
% changed output, now also reindexing matrix for permutation (just like in case of bootstrap) instead of the permuted design itself
% implemented control variable for constraining the resampling within blocks
% changed the check for overlapping ivar/uvar/wvar/cvar
% updated documentation
%
% Revision 1.2  2007/07/17 10:37:29  roboos
% updated help
%
% Revision 1.1  2007/07/04 16:04:53  roboos
% renamed randomizedesign to resampledesign
% first implementation of bootstrapping, sofar only for unpaired data
% added cfg.resampling=bootstrap/permutation
%
% Revision 1.7  2006/10/30 10:09:48  roboos
% removed the check that each repeated measurement should have the same number of elements (for uvar)
%
% Revision 1.6  2006/07/14 07:10:26  roboos
% do not treat uvar and wvar the same, wvar is not dealt with yet
%
% Revision 1.5  2006/06/13 11:36:11  roboos
% renamed cfg.bvar into cfg.wvar (within-block variable)
%
% Revision 1.4  2006/06/07 12:55:14  roboos
% changed a print statement
%
% Revision 1.3  2006/06/07 09:27:12  roboos
% rewrote most of the function, added support for uvar and cvar (instead of unitfactor), added support for a block variable cfg.wvar (for keeping all tapers within a trial together)
%

if ~isfield(cfg, 'ivar'), cfg.ivar = []; end
if ~isfield(cfg, 'uvar'), cfg.uvar = []; end
if ~isfield(cfg, 'wvar'), cfg.wvar = []; end  % within-cell variable, to keep repetitions together
if ~isfield(cfg, 'cvar'), cfg.cvar = []; end

if size(design,1)>size(design,2)
  % this function wants the replications in the column direction
  % the matrix seems to be transposed
  design = transpose(design);
end

Nvar  = size(design,1);   % number of factors or regressors
Nrepl = size(design,2);   % number of replications

if ~isempty(intersect(cfg.ivar, cfg.uvar)), warning('there is an intersection between cfg.ivar and cfg.uvar'); end
if ~isempty(intersect(cfg.ivar, cfg.wvar)), warning('there is an intersection between cfg.ivar and cfg.wvar'); end
if ~isempty(intersect(cfg.ivar, cfg.cvar)), warning('there is an intersection between cfg.ivar and cfg.cvar'); end
if ~isempty(intersect(cfg.uvar, cfg.wvar)), warning('there is an intersection between cfg.uvar and cfg.wvar'); end
if ~isempty(intersect(cfg.uvar, cfg.cvar)), warning('there is an intersection between cfg.uvar and cfg.cvar'); end
if ~isempty(intersect(cfg.wvar, cfg.cvar)), warning('there is an intersection between cfg.wvar and cfg.cvar'); end

fprintf('total number of measurements     = %d\n', Nrepl);
fprintf('total number of variables        = %d\n', Nvar);
fprintf('number of independent variables  = %d\n', length(cfg.ivar));
fprintf('number of unit variables         = %d\n', length(cfg.uvar));
fprintf('number of within-cell variables = %d\n', length(cfg.wvar));
fprintf('number of control variables      = %d\n', length(cfg.cvar));
fprintf('using a %s resampling approach\n', cfg.resampling);

if ~isempty(cfg.cvar)
  % do the resampling for each sub-block
  % the different levels of the control variable indicate the sub-blocks in which the resampling can be done
  blocklevel = unique(design(cfg.cvar,:)', 'rows')';
  for i=1:size(blocklevel,2)
    blocksel{i} = find(all(design(cfg.cvar,:)==repmat(blocklevel(:,i), 1, Nrepl), 1));
    blocklen(i) = length(blocksel{i});
  end
  for i=1:size(blocklevel,2)
    fprintf('------------------------------------------------------------\n');
    if length(cfg.cvar)>1
      fprintf('resampling the subset where the control variable level is [%s]\n', num2str(blocklevel(:,i)));
    else
      fprintf('resampling the subset where the control variable level is %s\n', num2str(blocklevel(:,i)));
    end
    tmpcfg = cfg;
    tmpcfg.cvar = [];
    blockres{i} = blocksel{i}(resampledesign(tmpcfg, design(:, blocksel{i})));
  end
  % concatenate the blocks and return the result
  resample = cat(2, blockres{:});
  return
end

if isnumeric(cfg.numrandomization) && cfg.numrandomization==0
  % no randomizations are requested, return an empty shuffling matrix
  resample = zeros(0,Nrepl);
  return;
end

if length(cfg.wvar)>0
  % keep the elements within a cell together, e.g. multiple tapers in a trial
  % this is realized by replacing the design matrix temporarily with a smaller version
  blkmeas = unique(design(cfg.wvar,:)', 'rows')';
  for i=1:size(blkmeas,2)
    blksel{i} = find(all(design(cfg.wvar,:)==repmat(blkmeas(:,i), 1, Nrepl), 1));
    blklen(i) = length(blksel{i});
  end
  for i=1:size(blkmeas,2)
    if any(diff(design(:, blksel{i}), 1, 2)~=0)
      error('the design matrix variables should be constant within a block');
    end
  end
  orig_design = design;
  orig_Nrepl  = Nrepl;
  % replace the design matrix by a blocked version
  design = zeros(size(design,1), size(blkmeas,2));
  Nrepl  = size(blkmeas,2); 
  for i=1:size(blkmeas,2)
    design(:,i) = orig_design(:, blksel{i}(1));
  end
end

% do some validity checks
if Nvar==1 && length(cfg.uvar)>0
  error('A within-units shuffling requires a at least one unit variable and at least one independent variable');
end

if length(cfg.uvar)==0 && strcmp(cfg.resampling, 'permutation')
  % reshuffle the colums of the design matrix
  if ischar(cfg.numrandomization) && strcmp(cfg.numrandomization, 'all')
    % systematically shuffle the columns in the design matrix
    Nperm = prod(1:Nrepl);
    fprintf('creating all possible permutations (%d)\n', Nperm);
    resample = perms(1:Nrepl);
  elseif ~ischar(cfg.numrandomization)
    % randomly shuffle the columns in the design matrix the specified number of times
    for i=1:cfg.numrandomization
      resample(i,:) = randperm(Nrepl);
    end
  end

elseif length(cfg.uvar)==0 && strcmp(cfg.resampling, 'bootstrap')
  % randomly draw with replacement, keeping the number of elements the same in each class
  % only the test under the null-hypothesis (h0) is explicitely implemented here
  % but the h1 test can be achieved using a control variable
  resample = zeros(cfg.numrandomization, Nrepl);
  for i=1:cfg.numrandomization
    resample(i,:) = randsample(1:Nrepl, Nrepl);
  end

elseif length(cfg.uvar)>0 && strcmp(cfg.resampling, 'permutation')
  % reshuffle the colums of the design matrix, keep the rows of the design matrix with the unit variable intact
  unitlevel = unique(design(cfg.uvar,:)', 'rows')';
  for i=1:size(unitlevel,2)
    unitsel{i} = find(all(design(cfg.uvar,:)==repmat(unitlevel(:,i), 1, Nrepl), 1));
    unitlen(i) = length(unitsel{i});
  end
  if length(cfg.uvar)==1
    fprintf('repeated measurement in variable %d over %d levels\n', cfg.uvar, length(unitlevel));
    fprintf('number of repeated measurements in each level is '); fprintf('%d ', unitlen); fprintf('\n');
  else
    fprintf('repeated measurement in mutiple variables over %d levels\n', length(unitlevel));
    fprintf('number of repeated measurements in each level is '); fprintf('%d ', unitlen); fprintf('\n');
  end
  
  if ischar(cfg.numrandomization) && strcmp(cfg.numrandomization, 'all')
    % create all possible permutations by systematic assignment
    if any(unitlen~=2)
      error('cfg.numrandomization=''all'' is only supported for two repeated measurements');
    end
    Nperm = 2^(length(unitlevel));
    fprintf('creating all possible permutations (%d)\n', 2^(length(unitlevel)));
    resample = zeros(Nperm, Nrepl);
    for i=1:Nperm
      flip  = dec2bin( i-1, length(unitlevel));
      for j=1:length(unitlevel)
        if     strcmp('0', flip(j)),
          resample(i, unitsel{j}(1)) = unitsel{j}(1);
          resample(i, unitsel{j}(2)) = unitsel{j}(2);
        elseif strcmp('1', flip(j)),
          resample(i, unitsel{j}(1)) = unitsel{j}(2);
          resample(i, unitsel{j}(2)) = unitsel{j}(1);
        end
      end
    end
    
  elseif ~ischar(cfg.numrandomization)
    % create the desired number of permutations by random shuffling
    resample = zeros(cfg.numrandomization, Nrepl);
    for i=1:cfg.numrandomization
      for j=1:length(unitlevel)
        resample(i, unitsel{j}) = unitsel{j}(randperm(length(unitsel{j})));
      end
    end
  end
  
elseif length(cfg.uvar)>0 && strcmp(cfg.resampling, 'bootstrap')
  error('Bootstrap resampling is not yet supported for this design.');

else
  error('Unsupported configuration for resampling.');
end

if length(cfg.wvar)>0
  % switch back to the original design matrix and expand the resample ordering
  % matrix so that it reorders all elements within a cell together
  design = orig_design;
  Nrepl  = orig_Nrepl;
  expand = zeros(size(resample,1), Nrepl);
  for i=1:size(resample,1)
    expand(i,:) = cat(2, blksel{resample(i,:)});
  end
  resample = expand;
end

