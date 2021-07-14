function [erptfd] = baseline_erptfd(erptfd_inname,blsbin,blebin,bltype,verbose),

%  erptfd = baseline_erptfd(erptfd,blsms,blems,bltype,verbose),
% 
%    erptfd_inname - erptfd data structure or filename containing erptfd structure  
% 
%    blsbin      - baseline start bin  
% 
%    blebin      - baseline end bin  
% 
%    bltype     - optional: 'mean', 'median' -- default is 'median' 
% 
% EXAMPLE: erptfd = baseline(erptfd,1,64)
% 
% valid datatypes: TFD (not time, freq-power, freq-amplitude)   
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% load and prep data 
  if isstr(erptfd_inname),
    load(erptfd_inname);
  else,
    erptfd = erptfd_inname; erptfd_inname = 'erptfd';
  end

  if isfield(erptfd,'domain') && ~isequal(erptfd.domain,'TFD'),
    disp(['ERROR: ' mfilename ' only valid for TFD domain datatype']);
    return
  end

% vars 
  if ~exist('bltype','var'),  bltype = 'median';      end
  if ~exist('verbose','var'), verbose= 0;             end
  if ~exist('blsbin','var'),  blsbin = 1;             end
  if ~exist('blebin','var'),  blebin = erptfd.tbin-1; end 

  bltype = lower(bltype);

% baseline correct 
  for jj = 1:size(erptfd.data,1),
    eval([' mdata = ' bltype '(erptfd.data(jj,:,blsbin:blebin),3);' ]);
    erptfd.data(jj,:,:) = erptfd.data(jj,:,:) - mdata(1,:,ones(1,size(erptfd.data(jj,:,:),3))) ;
  end


