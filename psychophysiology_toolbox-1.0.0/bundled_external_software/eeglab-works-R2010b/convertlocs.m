% convertlocs() - Convert electrode locations between coordinate systems
%                 using the EEG.chanlocs structure.
%
% Usage: >> newchans = convertlocs( EEG, 'command');
%
% Input:
%   chanlocs  - An EEGLAB EEG dataset OR a EEG.chanlocs channel locations structure
%   'command' - ['cart2topo'|'sph2topo'|'sphbesa2topo'| 'sph2cart'|'topo2cart'|'sphbesa2cart'|
%               'cart2sph'|'sphbesa2sph'|'topo2sph'| 'cart2sphbesa'|'sph2sphbesa'|'topo2sphbesa'|
%               'cart2all'|'sph2all'|'sphbesa2all'|'topo2all']
%                These command modes convert between four coordinate frames: 3-D Cartesian 
%                (cart), Matlab spherical (sph), Besa spherical (sphbesa), and 2-D polar (topo)
%               'auto' -- Here, the function finds the most complex coordinate frame 
%                 and constrains all the others to this one. It searches first for Cartesian 
%                 coordinates, then for spherical and finally for polar. Default is 'auto'.
%
% Optional input
%   'verbose' - ['on'|'off'] default is 'off'.
%
% Outputs:
%   newchans - new EEGLAB channel locations structure
%
% Ex:  CHANSTRUCT = convertlocs( CHANSTRUCT, 'cart2topo');
%      % Convert Cartesian coordinates to 2-D polar (topographic). 
%
% Author: Arnaud Delorme, CNL / Salk Institute, 22 Dec 2002
%
% See also: readlocs()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) Arnaud Delorme, CNL / Salk Institute, 22 Dec 2002, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: convertlocs.m,v $
% Revision 1.25  2006/01/12 23:42:02  arno
% fixing spherical conversion
%
% Revision 1.24  2006/01/10 23:07:56  arno
% fixing meanrad
%
% Revision 1.23  2006/01/10 22:52:42  arno
% same
%
% Revision 1.22  2006/01/10 22:50:53  arno
% not forcing spherical channel coord to 1
%
% Revision 1.21  2006/01/10 22:47:38  arno
% revert version 1.17
%
% Revision 1.17  2005/05/24 17:20:30  arno
% remove cell2mat
%
% Revision 1.16  2004/01/29 16:48:15  scott
% changed verbose default to 'off'
%
% Revision 1.15  2004/01/01 19:21:55  scott
% help msg edit
%
% Revision 1.14  2003/12/17 00:44:36  arno
% allowing channels with empty coordinates
%
% Revision 1.13  2003/12/06 02:11:39  arno
% header
%
% Revision 1.12  2003/12/02 17:53:16  arno
% updating help messages
%
% Revision 1.11  2003/05/13 23:48:59  arno
% debug convert to besa
%
% Revision 1.10  2003/05/13 23:40:39  arno
% messages
%
% Revision 1.9  2003/05/13 23:27:05  arno
% debuging verbose
%
% Revision 1.8  2003/05/13 23:19:48  arno
% debug last
%
% Revision 1.7  2003/05/13 23:18:00  arno
% adding verbose option
%
% Revision 1.6  2002/12/27 22:59:47  arno
% adding warning message
%
% Revision 1.5  2002/12/27 22:46:45  scott
% edit header msg -sm
%
% Revision 1.4  2002/12/27 22:20:07  arno
% same
%
% Revision 1.3  2002/12/27 22:18:26  arno
% debugging besa coords
%
% Revision 1.2  2002/12/24 16:53:41  arno
% convertelocs -> convertlocs
%
% Revision 1.1  2002/12/24 01:24:30  arno
% Initial revision
%

function chans = convertlocs(chans, command, varargin);

if nargin < 1
   help convertlocs;
   return;
end;

if nargin < 2
   command = 'auto';
end;
if nargin == 4 & strcmpi(varargin{2}, 'on')
    verbose = 1;
else
    verbose = 0; % off
end;

% test if value exists for default
% --------------------------------
if strcmp(command, 'auto')
    if isfield(chans, 'X') & ~isempty(chans(1).X)
        command = 'cart2all';
        if verbose
            disp('Make all coordinate frames uniform using Cartesian coords');
        end;
    else
        if isfield(chans, 'sph_theta') & ~isempty(chans(1).sph_theta)
            command = 'sph2all';
            if verbose
                disp('Make all coordinate frames uniform using spherical coords');
            end;
        else
            if isfield(chans, 'sph_theta_besa') & ~isempty(chans(1).sph_theta_besa)
                command = 'sphbesa2all';
                if verbose
                    disp('Make all coordinate frames uniform using BESA spherical coords');
                end;
            else
                command = 'topo2all';
                if verbose
                    disp('Make all coordinate frames uniform using polar coords');
                end;
            end;
        end;
    end;
end;

% convert
% -------         
switch command
 case 'topo2sph',
   theta  = {chans.theta};
   radius = {chans.radius};
   indices = find(~cellfun('isempty', theta));
   [sph_phi sph_theta] = topo2sph( [ [ theta{indices} ]' [ radius{indices}]' ] );
   if verbose
       disp('Warning: electrodes forced to lie on a sphere for polar to 3-D conversion');
   end;
   for index = 1:length(indices)
      chans(indices(index)).sph_theta  = sph_theta(index);
      chans(indices(index)).sph_phi    = sph_phi  (index);
   end;
   if isfield(chans, 'sph_radius'),
       meanrad = mean([ chans(indices).sph_radius ]);
       if isempty(meanrad), meanrad = 1; end;
   else
       meanrad = 1;
   end;
   sph_radius(1:length(indices)) = {meanrad};
case 'topo2sphbesa',
   chans = convertlocs(chans, 'topo2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa', varargin{:}); % search for spherical coords
case 'topo2cart'
   chans = convertlocs(chans, 'topo2sph', varargin{:}); % search for spherical coords
   if verbose
       disp('Warning: spherical coordinates automatically updated');
   end;
   chans = convertlocs(chans, 'sph2cart', varargin{:}); % search for spherical coords
case 'topo2all',
   chans = convertlocs(chans, 'topo2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2cart', varargin{:}); % search for spherical coords
case 'sph2cart',
   sph_theta  = {chans.sph_theta};
   sph_phi    = {chans.sph_phi};
   indices = find(~cellfun('isempty', sph_theta));
   if ~isfield(chans, 'sph_radius'), sph_radius(1:length(indices)) = {1};
   else                              sph_radius = {chans.sph_radius};
   end;
   inde = find(cellfun('isempty', sph_radius));
   if ~isempty(inde)
       meanrad = mean( [ sph_radius{:} ]);
       sph_radius(inde) = { meanrad };
   end;
   [x y z] = sph2cart([ sph_theta{indices} ]'/180*pi, [ sph_phi{indices} ]'/180*pi, [ sph_radius{indices} ]');
   for index = 1:length(indices)
      chans(indices(index)).X = x(index);
      chans(indices(index)).Y = y(index);
      chans(indices(index)).Z = z(index);
   end;
case 'sph2topo',
 if verbose
     % disp('Warning: all radii constrained to one for spherical to topo transformation');
 end;
 sph_theta  = {chans.sph_theta};
 sph_phi    = {chans.sph_phi};
 indices = find(~cellfun('isempty', sph_theta));
 [chan_num,angle,radius] = sph2topo([ ones(length(indices),1)  [ sph_phi{indices} ]' [ sph_theta{indices} ]' ], 1, 2); % using method 2
 for index = 1:length(indices)
     chans(indices(index)).theta  = angle(index);
     chans(indices(index)).radius = radius(index);
     if ~isfield(chans, 'sph_radius') | isempty(chans(indices(index)).sph_radius)
         chans(indices(index)).sph_radius = 1;
     end;
 end;
case 'sph2sphbesa',
   % using polar coordinates
   sph_theta  = {chans.sph_theta};
   sph_phi    = {chans.sph_phi};
   indices = find(~cellfun('isempty', sph_theta));
   [chan_num,angle,radius] = sph2topo([ones(length(indices),1)  [ sph_phi{indices} ]' [ sph_theta{indices} ]' ], 1, 2);
   [sph_theta_besa sph_phi_besa] = topo2sph([angle radius], 1, 1);
   for index = 1:length(indices)
      chans(indices(index)).sph_theta_besa  = sph_theta_besa(index);
      chans(indices(index)).sph_phi_besa    = sph_phi_besa(index);
   end;   
case 'sph2all',
   chans = convertlocs(chans, 'sph2topo', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2cart', varargin{:}); % search for spherical coords
case 'sphbesa2sph',
   % using polar coordinates
   sph_theta_besa  = {chans.sph_theta_besa};
   sph_phi_besa    = {chans.sph_phi_besa};
   indices = find(~cellfun('isempty', sph_theta_besa));
   [chan_num,angle,radius] = sph2topo([ones(length(indices),1)  [ sph_theta_besa{indices} ]' [ sph_phi_besa{indices} ]' ], 1, 1);
   %for index = 1:length(chans)
   %   chans(indices(index)).theta  = angle(index);
   %   chans(indices(index)).radius = radius(index);
   %   chans(indices(index)).labels = int2str(index);
   %end;   
   %figure; topoplot([],chans, 'style', 'blank', 'electrodes', 'labelpoint');
   
   [sph_phi sph_theta] = topo2sph([angle radius], 2);
   for index = 1:length(indices)
      chans(indices(index)).sph_theta  = sph_theta(index);
      chans(indices(index)).sph_phi    = sph_phi  (index);      
   end;
case 'sphbesa2topo',
   chans = convertlocs(chans, 'sphbesa2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2topo', varargin{:}); % search for spherical coords
case 'sphbesa2cart',
   chans = convertlocs(chans, 'sphbesa2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2cart', varargin{:}); % search for spherical coords   
case 'sphbesa2all',
   chans = convertlocs(chans, 'sphbesa2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2all', varargin{:}); % search for spherical coords
case 'cart2topo',
   chans = convertlocs(chans, 'cart2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2topo', varargin{:}); % search for spherical coords
case 'cart2sphbesa',
   chans = convertlocs(chans, 'cart2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa', varargin{:}); % search for spherical coords
case 'cart2sph',
    if verbose
        disp('WARNING: If XYZ center has not been optimized, optimize it using Edit > Channel Locations');
	end;
    X  = {chans.X};
    Y  = {chans.Y};
    Z  = {chans.Z};
    indices = find(~cellfun('isempty', X));
    [th phi radius] = cart2sph( [ X{indices} ], [ Y{indices} ], [ Z{indices} ]);
	for index = 1:length(indices)
		 chans(indices(index)).sph_theta     = th(index)/pi*180;
		 chans(indices(index)).sph_phi       = phi(index)/pi*180;
		 chans(indices(index)).sph_radius    = radius(index);
	end;
case 'cart2all',
   chans = convertlocs(chans, 'cart2sph', varargin{:}); % search for spherical coords
   chans = convertlocs(chans, 'sph2all', varargin{:}); % search for spherical coords
end;
