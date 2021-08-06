% readneurolocs() - read neuroscan polar location file (.asc)
%
% Usage:
%   >> CHANLOCS = readneurolocs( filename );
%   >> CHANLOCS = readneurolocs( filename, plot, czindex, fzindex, c3index );
%
% Inputs:
%   filename       - file name
%
% Optional inputs:
%   plot           - [0|1] if 1, plot the electrode locations. Default 0.
%   czindex        - index of electrode Cz if the label is not defined 
%                    in the file. Default is [] (find electrode label
%                    automatically).
%   fzindex        - index of electrode Fz if the label is not defined 
%                    in the file. (for 3D accurate conversion of electrode 
%                    positions). Set it to [] so that the data will not
%                    be rescaled along the y axis.
%   c3index        - index of electrode c3 if the label is not defined 
%                    in the file. (for 3D accurate conversion of electrode 
%                    positions). Set it to [] so that the data will not
%                    be rescaled along the x axis.
%
% Outputs:
%   CHANLOCS       - EEGLAB channel location data structure. See
%                    help readlocs()
%
% Author: Arnaud Delorme, CNL / Salk Institute, 4 March 2003
%
% See also: readlocs()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2003 Arnaud Delorme, Salk Institute, arno@salk.edu
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

% $Log: readneurolocs.m,v $
% Revision 1.2  2003/03/04 20:04:17  arno
% debuging
%
% Revision 1.1  2003/03/04 19:18:35  arno
% Initial revision
%

function chanlocs = readneurolocs( filename, plottag, indexcz, indexfz)
    
    if nargin < 1
        help readneurolocs;
        return;
    end;
    if nargin < 2
        plottag = 0;
    end;
    
    % read location file
    % ------------------
    locs  = loadtxt( filename );
    
    % remove trailing control channels
    % --------------------------------
    while isnumeric( locs{end,1} ) & locs{end,1} ~= 0
        locs  = locs(1:end-1,:);
    end;    
    
    % find first numerical index
    % --------------------------
    index = 1;
    while isstr( locs{index,1} )
        index = index + 1;
    end;
        
    % extract location array
    % ----------------------   
    nchans = size( locs, 1 ) - index +1;
    chans  = cell2mat(locs(end-nchans+1:end, 1:5));
    names  = locs(end-nchans*2+1: end-nchans, 2);
    for index = 1:length(names)
        if ~isstr(names{index})
            names{index} = int2str(names{index});
        end;
    end;
    
    % find Cz and Fz
    % --------------
    if exist('indexcz') ~= 1
        indexcz = strmatch( 'cz', lower(names') );
        if isempty(indexcz), 
            error('Can not find Cz electrode, define the electrode index manually in readneurolocs()');
        end;
    end;
    if exist('indexfz') ~= 1
        indexfz = strmatch( 'fz', lower(names') );
    end;
    if exist('indexc3') ~= 1
        indexc3 = strmatch( 'c3', lower(names') );
    end;
    
    % plot all channels
    % -----------------
    x = chans(:,3);
    y = chans(:,4);    
    if plottag
        figure;
        for index = 1:length(x)
            plot( x(index), y(index), '+');
            hold on; % do not erase
            text( x(index)+0.01, y(index), int2str(index));
        end;
    end;
    
    x = - x + x(indexcz);
    y = - y + y(indexcz);

    % shrink coordinates
    % ------------------
    if ~isempty(indexfz)
        y = y/y(indexfz)*0.25556;
        disp('Readneurolocs: electrode location scaled along the y axis for standard Fz location');
        if isempty(indexc3), indexc3 = indexfz; end;
    end;
    if ~isempty(indexc3)
        x = x/x(indexc3)*0.25556;
        disp('Readneurolocs: electrode location scaled along the x axis for standard C3 location');
    end;

    % convert to polar
    % ----------------
    [theta r] = cart2pol(x, y);    
    
    % create structure
    % ----------------
    for index = 1:length(names)
        chanlocs(index).labels = names{index};
        chanlocs(index).theta  = theta(index)/pi*180-90;
        chanlocs(index).radius = r(index);
    end;
        