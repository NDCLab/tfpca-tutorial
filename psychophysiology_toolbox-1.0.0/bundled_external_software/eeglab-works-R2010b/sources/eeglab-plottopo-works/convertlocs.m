% convertlocs() - Convert electrode locations between coordinate systems
%                 using the structure of EEG.chanlocs.
%
% Usage: >> newchans = convertlocs( EEG, 'command');
%
% Input:
%   chanlocs  - EEGLAB EEG dataset OR EEG.chanlocs channel locations structure
%   'command' - ['cart2topo'|'sph2topo'|'sphbesa2topo'|
%               'sph2cart'|'topo2cart'|'sphbesa2cart'|
%               'cart2sph'|'sphbesa2sph'|'topo2sph'|
%               'cart2sphbesa'|'sph2sphbesa'|'topo2sphbesa'|
%               'cart2all'|'sph2all'|'sphbesa2all'|'topo2all']
%                 These command modes convert between four coordinate frames:
%                    3-D cartesian (cart), Matlab spherical (sph),
%                    Besa spherical (sphbesa), and 2-D polar (topo)
%               'auto' -- Here, the function finds the most complex coordinate frame 
%                 and constrains all the others to this one. It searches first for cartesian 
%                 coordinates, then for spherical and finally for polar. Default is 'auto'.
%
% Outputs:
%   newchans - new EEGLAB channel locations structure
%
% Ex:  CHANSTRUCT = convertlocs( CHANSTRUCT, 'cart2topo');
%      % Convert cartesian coordinates to 2-D polar (topographic). 
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

function chans = convertlocs(chans, command);

if nargin < 1
   help convertlocs;
   return;
end;

if nargin < 2
   command = 'auto';
end;

% test if value exists for default
% --------------------------------
if strcmp(command, 'auto')
   if isfield(chans, 'X') & ~isempty(chans(1).X)
      command = 'cart2all';
      disp('Uniformize all coordinate frames using Carthesian coords');
   else
	   if isfield(chans, 'sph_theta') & ~isempty(chans(1).sph_theta)
   	   command = 'sph2all';
	      disp('Uniformize all coordinate frames using spherical coords');
      else
		   if isfield(chans, 'sph_theta_besa') & ~isempty(chans(1).sph_theta_besa)
   		   command = 'sphbesa2all';
      		disp('Uniformize all coordinate frames using BESA spherical coords');
         else
            command = 'topo2all';
		      disp('Uniformize all coordinate frames using polar coords');
         end;
      end;
   end;
end;

% convert
% -------         
switch command
case 'topo2sph',
   [sph_phi sph_theta] = topo2sph( [cell2mat({chans.theta})' cell2mat({chans.radius})'] );
   for index = 1:length(chans)
      chans(index).sph_theta  = sph_theta(index);
      chans(index).sph_phi    = sph_phi  (index);
      chans(index).sph_radius = 1;
   end;
case 'topo2sphbesa',
   chans = convertlocs(chans, 'topo2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa'); % search for spherical coords
case 'topo2cart'
   chans = convertlocs(chans, 'topo2sph'); % search for spherical coords
   disp('Warning: spherical coordinates automatically updated');
   chans = convertlocs(chans, 'sph2cart'); % search for spherical coords
case 'topo2all',
   chans = convertlocs(chans, 'topo2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa'); % search for spherical coords
   chans = convertlocs(chans, 'sph2cart'); % search for spherical coords
case 'sph2cart',
   if ~isfield(chans, 'sph_radius'), sph_radius = ones(length(chans),1);
   else                              sph_radius = cell2mat({chans.sph_radius})';
   end;
   [x y z] = sph2cart(cell2mat({chans.sph_theta})'/180*pi, cell2mat({chans.sph_phi})'/180*pi, sph_radius);
   for index = 1:length(chans)
      chans(index).X = x(index);
      chans(index).Y = y(index);
      chans(index).Z = z(index);
   end;
case 'sph2topo',
   disp('Warning: all radii constrained to one for spherical to topo transformation');
   try, [chan_num,angle,radius] = sph2topo([ones(length(chans),1)  cell2mat({chans.sph_phi})' cell2mat({chans.sph_theta})'], 1, 2); % using method 2
   catch, error('Cannot process empty values'); end;
   for index = 1:length(chans)
      chans(index).theta  = angle(index);
      chans(index).radius = radius(index);
   end;
case 'sph2sphbesa',
   % using polar coordinates
   [chan_num,angle,radius] = sph2topo([ones(length(chans),1)  cell2mat({chans.sph_phi})' cell2mat({chans.sph_theta})'], 1, 2);
   [sph_phi_besa sph_theta_besa] = topo2sph([angle radius], 1, 1);
   for index = 1:length(chans)
      chans(index).sph_theta_besa  = sph_theta_besa(index);
      chans(index).sph_phi_besa    = sph_phi_besa(index);
   end;   
case 'sph2all',
   chans = convertlocs(chans, 'sph2topo'); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa'); % search for spherical coords
   chans = convertlocs(chans, 'sph2cart'); % search for spherical coords
case 'sphbesa2sph',
   % using polar coordinates
   [chan_num,angle,radius] = sph2topo([ones(length(chans),1)  cell2mat({chans.sph_theta_besa})' ...
                       cell2mat({chans.sph_phi_besa})'], 1, 1);
   %for index = 1:length(chans)
   %   chans(index).theta  = angle(index);
   %   chans(index).radius = radius(index);
   %   chans(index).labels = int2str(index);
   %end;   
   %figure; topoplot([],chans, 'style', 'blank', 'electrodes', 'labelpoint');
   
   [sph_phi sph_theta] = topo2sph([angle radius], 2);
   for index = 1:length(chans)
      chans(index).sph_theta  = sph_theta(index);
      chans(index).sph_phi    = sph_phi  (index);      
   end;
case 'sphbesa2topo',
   chans = convertlocs(chans, 'sphbesa2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2topo'); % search for spherical coords
case 'sphbesa2cart',
   chans = convertlocs(chans, 'sphbesa2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2cart'); % search for spherical coords   
case 'sphbesa2all',
   chans = convertlocs(chans, 'sphbesa2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2all'); % search for spherical coords
case 'cart2topo',
   chans = convertlocs(chans, 'cart2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2topo'); % search for spherical coords
case 'cart2sphbesa',
   chans = convertlocs(chans, 'cart2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2sphbesa'); % search for spherical coords
case 'cart2sph',
    disp('WARNING: XYZ center not optimized, optimize center, then recompute coords');
	[th phi radius] = cart2sph(cell2mat({chans.X}), cell2mat({chans.Y}), cell2mat({chans.Z}));
	for index = 1:length(chans)
		 chans(index).sph_theta     = th(index)/pi*180;
		 chans(index).sph_phi       = phi(index)/pi*180;
		 chans(index).sph_radius    = radius(index);
	end;
case 'cart2all',
   chans = convertlocs(chans, 'cart2sph'); % search for spherical coords
   chans = convertlocs(chans, 'sph2all'); % search for spherical coords
end;
