function [s,cfg] = statfun_actvsblT(cfg, dat, design);

% STATFUN_actvsblT calculates the activation-versus-baseline T-statistic 
% on the biological data in dat (the dependent variable), using the information on 
% the independent variable (iv) in cfg.design. 
%
% Note: It does not make sense to use this test statistic when
% baseline-correction was performed by subtracting the time average of the
% baseline period. Instead of this type of baseline-correction, one may
% subtract the time average of the combined baseline and activation
% period.
%
% The external interface of this function has to be
%   [s,cfg] = statfun_actvsblT(cfg, dat, design);
% where
%   dat    contains the biological data, Nsamples x Nreplications
%   design contains the independent variable (iv) and the unit-of-observation (UO) 
%          factor,  Nreplications x Nvar
%
% Configuration options:
%   cfg.computestat    = 'yes' or 'no', calculate the statistic (default='yes')
%   cfg.computecritval = 'yes' or 'no', calculate the critical values of the test statistics (default='no')
%   cfg.computeprob    = 'yes' or 'no', calculate the p-values (default='no')
%
% The following options are relevant if cfg.computecritval='yes' and/or
% cfg.computeprob='yes'.
%   cfg.alpha = critical alpha-level of the statistical test (default=0.05)
%   cfg.tail = -1, 0, or 1, left, two-sided, or right (default=1)
%              cfg.tail in combination with cfg.computecritval='yes'
%              determines whether the critical value is computed at
%              quantile cfg.alpha (with cfg.tail=-1), at quantiles
%              cfg.alpha/2 and (1-cfg.alpha/2) (with cfg.tail=0), or at
%              quantile (1-cfg.alpha) (with cfg.tail=1).
%
% Design specification:
%   cfg.ivar        = row number of the design that contains the labels of the conditions that must be 
%                        compared (default=1). The first condition, indicated by 1, corresponds to the 
%                        activation period and the second, indicated by 2, corresponds to the baseline period.
%   cfg.uvar        = row number of design that contains the labels of the UOs (subjects or trials)
%                        (default=2). The labels are assumed to be integers ranging from 1 to 
%                        the number of UOs.
%

% Copyright (C) 2006, Eric Maris
%
% $Log: statfun_actvsblT.m,v $
% Revision 1.7  2007/04/02 20:40:32  erimar
% Corrected an error in the calculation of the time-average of the data.
% Updated help.
%
% Revision 1.6  2007/03/27 15:30:17  erimar
% Calculate the number of time samples on the basis of the information in
% cfg.dim and size(dat).
%
% Revision 1.5  2006/09/12 12:13:07  roboos
% removed default values for cfg.ivar and uvar, defaults should be specified elsewhere
%
% Revision 1.4  2006/06/07 12:51:18  roboos
% renamed cfg.ivrownr into cfg.ivar
% renamed cfg.uorownr into cfg.uvar
% renamed pval into prob for consistency with other fieldtrip functions
%
% Revision 1.3  2006/05/17 11:59:55  erimar
% Corrected bugs after extensive checking of the properties of this
% statfun.
%
% Revision 1.2  2006/05/12 15:29:44  erimar
% Added functionality to calculate one- and two-sided critical
% values and p-values.
%
% Revision 1.1  2006/05/05 13:09:47  erimar
% First version of statfun_actvsblT.
%
%

% set defaults
if ~isfield(cfg, 'computestat'),       cfg.computestat='yes';     end;
if ~isfield(cfg, 'computecritval'),    cfg.computecritval='no';   end;
if ~isfield(cfg, 'computeprob'),       cfg.computeprob='no';      end;
if ~isfield(cfg, 'alpha'),             cfg.alpha=0.05;            end;
if ~isfield(cfg, 'tail'),              cfg.tail=1;                end;

% perform some checks on the configuration
if strcmp(cfg.computeprob,'yes') & strcmp(cfg.computestat,'no')
    error('P-values can only be calculated if the test statistics are calculated.');
end;

% calculate the number of time samples
switch cfg.dimord
  case 'chan_freq_time'
    nchan = cfg.dim(1);
    nfreq = cfg.dim(2);
    ntime = cfg.dim(3);
    [nsmpls,nrepl] = size(dat);
    nsmplsdivntime = floor(nsmpls/ntime);
  otherwise
    error('Inappropriate dimord for the statistics function STATFUN_ACTVSBLT.');
end;

sel1 = find(design(cfg.ivar,:)==1);
sel2 = find(design(cfg.ivar,:)==2);
n1  = length(sel1);
n2  = length(sel2);
if (n1+n2)<size(design,2) || (n1~=n2)
  error('Invalid specification of the design array.');
end;
nunits = max(design(cfg.uvar,:));
df = nunits - 1;
if nunits<2
    error('The data must contain at least two units (trials or subjects).')
end;
if (nunits*2)~=(n1+n2)
  error('Invalid specification of the design array.');
end;

if strcmp(cfg.computestat,'yes')
% compute the statistic
    % calculate the time averages of the activation and the baseline period
    % for all units-of-observation.
    meanreshapeddat=mean(reshape(dat,nchan,nfreq,ntime,nrepl),3);
    timeavgdat=repmat(eye(nchan*nfreq),ntime,1)*reshape(meanreshapeddat,(nchan*nfreq),nrepl);

    % store the positions of the 1-labels and the 2-labels in a nunits-by-2 array
    poslabelsperunit=zeros(nunits,2);
    poslabel1=find(design(cfg.ivar,:)==1);
    poslabel2=find(design(cfg.ivar,:)==2);
    [dum,i]=sort(design(cfg.uvar,poslabel1),'ascend');
    poslabelsperunit(:,1)=poslabel1(i);
    [dum,i]=sort(design(cfg.uvar,poslabel2),'ascend');
    poslabelsperunit(:,2)=poslabel2(i);

    % calculate the differences between the conditions
    diffmat=zeros(nsmpls,nunits);
    diffmat=dat(:,poslabelsperunit(:,1))-timeavgdat(:,poslabelsperunit(:,2));

    % calculate the dependent samples t-statistics
    avgdiff=mean(diffmat,2);
    vardiff=var(diffmat,0,2);
    s.stat=sqrt(nunits)*avgdiff./sqrt(vardiff);
end;

if strcmp(cfg.computecritval,'yes')
  % also compute the critical values
  s.df      = df;
  if cfg.tail==-1
    s.critval = tinv(cfg.alpha,df);
  elseif  cfg.tail==0
    s.critval = [tinv(cfg.alpha/2,df),tinv(1-cfg.alpha/2,df)];
  elseif cfg.tail==1
    s.critval = tinv(1-cfg.alpha,df);
  end;
end

if strcmp(cfg.computeprob,'yes')
  % also compute the p-values
  s.df      = df;
  if cfg.tail==-1
    s.prob = tcdf(s.stat,s.df);
  elseif  cfg.tail==0
    s.prob = 2*tcdf(-abs(s.stat),s.df);
  elseif cfg.tail==1
    s.prob = 1-tcdf(s.stat,s.df);
  end;
end

