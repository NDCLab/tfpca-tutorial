% topoplot() - plot a topographic map of a scalp data field in a 2-D
%              circular view (looking down at the top of the head) 
%              using interpolation on a fine cartesian grid.
% Usage:
%        >>  topoplot(datavector, chan_locs);
%        >>  [h val grid] = topoplot(datavector, chan_locs, 'Param1','Value1', ...)
% Inputs:
%    		datavector - vector of values at the corresponding locations.
%                        if a single channel number, show location of that 
%                        channel (use with 'style', 'blank' only)
%   		chan_locs  - name of an EEG electrode position file (see
%                        >> topoplot 'example' for format). May also be an
%                        EEG.chanlocs structure (see >> help pop_editset)
% Optional Parameters:
%   'maplimits'       - 'absmax' scale to +/- the absolute-max; 'maxmin', scale to 
%                        the data range; [clim1,clim2], user-definined lo/hi limits
%                        {default = 'absmax'}
%   'style'           - 'straight' - plot colored map only
%                       'contour'  - plot contour lines only
%                       'both'     - plot both colored map and contour lines
%                       'fill'     - plot constant color between contour lines
%                       'blank'    - plot electrode locations only
%                                    {default = 'both'}
%   'electrodes'      - 'on','off','labels','numbers','pointlabels','pointnumbers'
%   'numcontour'      - number of contour lines {default = 6}
%   'shading'         - 'flat','interp'  {default = 'flat'}
%   'interplimits'    - ['electrodes'|'head'] 'electrodes', to furthest electrode; 
%                       'head', to edge of head {default 'head'}.
%   'shrink'           - ['on'|'off'|'force'|factor] 'on': normalize electrode 
%                        polar coordinates if maximum radius > 0.5 so that
%                        maximu radius is 0.5. 'force': normalize radius so 
%                        that the maximum is 0.5. 'factor': apply a normalizing
%                        factor (percentage of the maximum) {default = 'off'}.
%                        Note that the chan_locs structure may have an optional
%                        shrink field (same format as this parameter).
%   'colormap'        -  (n,3) any sized colormap
%   'dipole'          -  [XI YI XE YE ZE] plot dipole on the top of the scalp
%                        map from coordinate XI,YI to coordinates XE, YE, ZE (head 
%                        model has radius 1). If several rows, plot one dipole per row.
%   'dipnorm'         - ['on'|'off'] normalize deipole length {default = 'off'}.
%   'diporient'       - [-1|1] invert dipole orientation {default = 1}.
%   'diplen'          - [real] scale dipole length {default = 1}.
%   'dipscale'        - [real] scale dipole size {default = 1}.
%   'dipcolor'        - [color] change dipole color {default = 'k' (black)}.
%                        The dipole bar is scaled by length L. Dipole size (scaling) 
%                        is S and its color is C (3 real numbers between 0 and 1).
%                        Coordinates returned by dipplot() may be used.
%   'headcolor'       - color of head cartoon {default black}
%   'verbose'         - ['on'|'off'] default is 'on'.
%   'noplot'          - ['on'|'off'|[rad theta]] do not plot (but return interpolated data).
%                        If [rad theta] are coordinates of a (possibly missing) channel, 
%                        returns interpolated value for channel location. For location 
%                        conventions, see >> topoplot 'example'
%   'gridscale'       - [int >> 1] - interpolated data matrix size (rows) (default: 67)
%   'efontsize'       - detail
%   'electcolor'      - detail
%   'emarker'         - detail
%   'emarkersize'     - detail
%   'emarkersize1chan' - detail
%  
% Outputs:
%         h           - axes handle
%         val         - interpolated value at given 'noplot' channel location, if any.
%         grid        - interpolated data image (gridscale,gridscale) (off-head points = NaN).
%
% Eloc_file format:
%    chan_number degrees radius reject_level amp_gain channel_name
%    (Angle-0 =Cz-to-Fz; C3-angle =-90; Radius at edge of image = 0.5)
%    For a sample eloc file: >> topoplot 'example'
%
% Note: 1) topoplot only works when map limits are >= the max and min 
%          interpolated data values.
%       2) topoplot will ignore any electrode with a position outside 
%          the head (radius > 0.5). To make the head round, >> axis square
%
% Authors: Andy Spydell, Colin Humphries & Arnaud Delorme 
%          CNL / Salk Institute, Aug, 1996
%
% See also: timtopo(), envtopo()

% Copyright (C) Colin Humphries & Scott Makeig, CNL / Salk Institute, Aug, 1996
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

% $Log: topoplot.m,v $
% Revision 1.71  2004/01/20 04:25:05  scott
% help msg edit
% .,
%
% Revision 1.70  2003/12/17 15:49:45  arno
% debug chan with no coordinates
%
% Revision 1.69  2003/12/17 01:25:37  arno
% debug plot electrode subset
%
% Revision 1.68  2003/12/17 00:57:17  arno
% subset of electrodes
%
% Revision 1.67  2003/11/29 23:34:00  scott
% help msg
%
% Revision 1.66  2003/11/06 16:31:18  arno
% changing dipnorm
%
% Revision 1.65  2003/11/06 02:04:41  arno
% correct orientation
%
% Revision 1.64  2003/11/06 01:40:31  arno
% diporient
%
% Revision 1.63  2003/11/06 01:00:57  arno
% adjusting corrdinates
% for dipole
%
% Revision 1.62  2003/11/05 20:35:21  arno
% dipole options
%
% Revision 1.61  2003/11/05 19:44:32  arno
% header text
%
% Revision 1.60  2003/08/08 17:36:12  arno
% shrink factor overwrite problem fixed
%
% Revision 1.59  2003/08/08 17:34:41  arno
% -cos -> cos
%
% Revision 1.58  2003/08/07 20:49:12  arno
% option 'masksurf' to speed up display
%
% Revision 1.57  2003/08/07 16:02:35  scott
% typo
%
% Revision 1.56  2003/08/07 16:01:49  scott
% debug
%
% Revision 1.55  2003/08/07 15:56:54  scott
% debug
%
% Revision 1.54  2003/08/07 15:54:49  scott
% debug last
%
% Revision 1.53  2003/08/07 15:51:05  scott
% added 'noplot' option to return interpolated channel value
%
% Revision 1.52  2003/07/18 01:34:07  scott
% text placement
%
% Revision 1.51  2003/07/18 01:33:19  scott
% text placement
%
% Revision 1.50  2003/07/18 01:31:49  scott
% debug
%
% Revision 1.49  2003/07/18 01:27:17  scott
% debug
%
% Revision 1.48  2003/07/18 01:26:05  scott
% debug
%
% Revision 1.47  2003/07/18 01:18:12  scott
% debug last
%
% Revision 1.46  2003/07/18 01:17:34  scott
% formatting, debug axes size message
%
% Revision 1.45  2003/07/17 23:42:32  scott
% nothing
%
% Revision 1.44  2003/07/17 23:13:03  scott
% rm debug message
%
% Revision 1.43  2003/07/16 16:29:46  arno
% replacing with topoplottest - added image output, gridscale arg
%
% Revision 1.41  2003/07/15 23:55:40  arno
% retreiving version 1.28
%
% Revision 1.28  2003/06/27 18:53:04  arno
% header msg
%
% Revision 1.27  2003/05/12 22:27:44  arno
% debug verbose
%
% Revision 1.26  2003/05/12 22:23:38  arno
% adding verbose option
%
% Revision 1.25  2002/11/27 01:23:53  arno
% change warning message
%
% Revision 1.24  2002/11/12 23:06:48  arno
% still debugging last insert
%
% Revision 1.23  2002/11/12 22:19:01  arno
% typo
%
% Revision 1.22  2002/11/12 21:43:51  scott
% tmpelocs -> tmpeloc
%
% Revision 1.21  2002/11/12 19:33:24  arno
% remove last channel of eloc structure if necessary (common ref)
%
% Revision 1.20  2002/11/01 03:50:08  erik
% same
%
% Revision 1.19  2002/11/01 03:47:40  erik
% added test for locs_file string to readlocs call
%
% Revision 1.18  2002/10/31 22:51:25  luca
% now also plotting n < nchans single channels
%
% Revision 1.17  2002/10/30 18:50:37  arno
% debugging dipole
%
% Revision 1.16  2002/10/30 16:41:21  arno
% adding the dipole option
%
% Revision 1.15  2002/10/26 20:09:35  arno
% error typo
%
% Revision 1.14  2002/10/14 00:40:44  arno
% *** empty log message ***
%
% Revision 1.13  2002/09/23 18:09:11  arno
% fixing single channel plotting
%
% Revision 1.12  2002/08/13 17:45:58  arno
% undo last change
%
% Revision 1.11  2002/08/13 17:44:37  arno
% remove color setting
%
% Revision 1.10  2002/08/12 01:34:53  arno
% color
%
% Revision 1.9  2002/08/11 22:31:20  arno
% color
%
% Revision 1.8  2002/05/01 18:49:20  arno
% modifying default shrink
%
% Revision 1.7  2002/05/01 02:40:10  arno
% typo
%
% Revision 1.6  2002/04/24 17:30:47  arno
% auto shrink
%
% Revision 1.5  2002/04/24 17:07:28  arno
% debugging error message problem
%
% Revision 1.4  2002/04/17 18:40:23  arno
% display real electrode number
%
% Revision 1.3  2002/04/06 03:47:44  arno
% adding emarkersize1chan input
%
% Revision 1.2  2002/04/06 03:37:24  arno
% adding single channel vector input
%
% Revision 1.1  2002/04/05 17:36:45  jorn
% Initial revision
%

% Topoplot Version 2.1
% Original development history:
% Begun by Andy Spydell and Scott Makeig, NHRC,  7-23-96
% 8-96 Revised by Colin Humphries, CNL / Salk Institute, La Jolla CA
%   -changed surf command to imagesc (faster)
%   -can now handle arbitrary scaling of electrode distances
%   -can now handle non integer angles in chan_locs
% 4-4-97 Revised again by Colin Humphries, reformat by SM
%   -added parameters
%   -changed chan_locs format
% 2-26-98 Revised by Colin
%   -changed image back to surface command
%   -added fill and blank styles
%   -removed extra background colormap entry (now use any colormap)
%   -added parameters for electrode colors and labels
%   -now each topoplot axes use the caxis command again.
%   -removed OUTPUT parameter
% 3-11-98 changed default emarkersize, improve help msg -sm
% 5-24-01 made default emarkersize vary with number of channels -sm
% 01-25-02 reformated help & license, added link -ad 
% 03-15-02 added readlocs and the use of eloc input structure -ad 
% 03-25-02 added 'labelpoint' options and allow Vl=[] -ad &sm
% 03-25-02 added details to "Unknown parameter" warning -sm & ad

function [handle,chanval,Zi] = topoplot2(Vl,loc_file,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8,p9,v9,p10,v10)

% User Defined Defaults:
noplot  = 'off';
handle = [];
Zi = [];

chanval = NaN;
icadefs % read defaults:  MAXTOPOPLOTCHANS, DEFAULT_ELOC
INTERPLIMITS = 'head';  % head, electrodes
MAPLIMITS = 'absmax';   % absmax, maxmin, [values]
GRID_SCALE = 67;
CONTOURNUM = 6;
STYLE = 'both';       % both,straight,fill,contour,blank
HCOLOR = [0 0 0];ECOLOR = [0 0 0];
CONTCOLOR = [0 0 0];
ELECTRODES = 'on';      % ON OFF LABEL
EMARKER = '.';
EMARKERSIZE = [];     % DEFAULTS SET IN CODE 
EFSIZE = get(0,'DefaultAxesFontSize');
HLINEWIDTH = 2;
SHADING = 'flat';     % flat or interp
shrinkfactor = 'off';
DIPOLE  = [];
DIPNORM   = 'off';
DIPLEN    = 1;
DIPSCALE  = 1;
DIPORIENT  = 1;
DIPCOLOR  = [0 0 0];
VERBOSE = 'on';
MASKSURF = 'off';

%
%%%%%%%%%%%%%%%%%%%%%%% Handle arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin< 1
   help topoplot;
   return
end
nargs = nargin;
if nargs < 2
  loc_file = DEFAULT_ELOC;
end
if nargs == 1
  if isstr(Vl)
    if any(strcmp(lower(Vl),{'example','demo'}))
      fprintf(['This is an example of an electrode location file,\n',...
               'an ascii file consisting of the following four columns:\n',...
               ' channel_number degrees arc_length channel_name\n\n',...
               'Example:\n',...
               ' 1               -18    .352       Fp1.\n',...
               ' 2                18    .352       Fp2.\n',...
               ' 5               -90    .181       C3..\n',...
               ' 6                90    .181       C4..\n',...
               ' 7               -90    .500       A1..\n',...
               ' 8                90    .500       A2..\n',...
               ' 9              -142    .231       P3..\n',...
               '10               142    .231       P4..\n',...
               '11                 0    .181       Fz..\n',...
               '12                 0    0          Cz..\n',...
               '13               180    .181       Pz..\n\n',...
               'The model head sphere has a diameter of 1.\n',...
               'The vertex (Cz) has arc length 0. Channels with arc \n',...
               'lengths > 0.5 are not plotted nor used for interpolation.\n'...
               'Zero degrees is towards the nasion. Positive angles\n',...
               'point to the right hemisphere; negative to the left.\n',...
               'Channel names should each be four chars, padded with\n',...
               'periods (in place of spaces).\n'])
      return

    end
  end
end
if isempty(loc_file)
  loc_file = 0;
end
if isnumeric(loc_file) & loc_file == 0
  loc_file = DEFAULT_ELOC;
end

if nargs > 2
  if ~(round(nargs/2) == nargs/2)
    error('topoplot(): Odd number of inputs?')
  end
  for i = 3:2:nargs
    Param = eval(['p',int2str((i-3)/2 +1)]);
    Value = eval(['v',int2str((i-3)/2 +1)]);
    if ~isstr(Param)
      error('topoplot(): Parameter must be a string')
    end
    Param = lower(Param);
    switch lower(Param)
	 case 'colormap'
	  if size(Value,2)~=3
          error('topoplot(): Colormap must be a n x 3 matrix')
	  end
	  colormap(Value)
	 case {'interplimits','headlimits'}
	  if ~isstr(Value)
          error('topoplot(): interplimits value must be a string')
	  end
	  Value = lower(Value);
	  if ~strcmp(Value,'electrodes') & ~strcmp(Value,'head')
          error('topoplot(): Incorrect value for interplimits')
	  end
	  INTERPLIMITS = Value;
	 case 'verbose'
	  VERBOSE = Value;
	 case 'maplimits'
	  MAPLIMITS = Value;
	 case 'masksurf'
	  MASKSURF = Value;
	 case 'gridscale'
	  GRID_SCALE = Value;
	 case 'style'
	  STYLE = lower(Value);
	 case 'numcontour'
	  CONTOURNUM = Value;
	 case 'electrodes'
	  ELECTRODES = lower(Value);
         if strcmpi(ELECTRODES,'pointlabels')
             ELECTRODES = 'labelpoint'; % backwards compatability
         end
         if strcmpi(ELECTRODES,'pointnumbers')
             ELECTRODES = 'numpoint'; % backwards compatability
         end
         if ~strcmpi(ELECTRODES,'labelpoint') ...
            & ~strcmpi(ELECTRODES,'numpoint') ...
            & ~strcmp(ELECTRODES,'on') ...
            & ~strcmp(ELECTRODES,'off') ...
            & ~strcmp(ELECTRODES,'labels') ...
            & ~strcmpi(ELECTRODES,'numbers') 
		 	   fprintf('topoplot(): Unknown value for keyword ''electrodes''.\n');
            return
         end
	 case 'dipole'
	  DIPOLE = Value;
	 case 'dipnorm'
	  DIPNORM = Value;
	 case 'diplen'
	  DIPLEN = Value;
	 case 'dipscale'
	  DIPSCALE = Value;
	 case 'diporient'
	  DIPORIENT = Value;
	 case 'dipcolor'
	  DIPCOLOR = Value;
	 case 'emarker'
	  EMARKER = Value;
	 case 'shrink'
	  shrinkfactor = Value;
	 case {'headcolor','hcolor'}
	  HCOLOR = Value;
	 case {'electcolor','ecolor'}
	  ECOLOR = Value;
	 case {'emarkersize','emsize'}
	  EMARKERSIZE = Value;
	 case 'emarkersize1chan'
	  EMARKERSIZE1CHAN= Value;
	 case {'efontsize','efsize'}
	  EFSIZE = Value;
	 case 'shading'
	  SHADING = lower(Value);
	  if ~any(strcmp(SHADING,{'flat','interp'}))
	     error('Invalid shading parameter')
	  end
         case 'noplot'
          noplot = Value;
          if ~isstr(noplot)
            if length(noplot) ~= 2
              error('''noplot'' location should be [radius, angle]')
            else
              chanrad = noplot(1);
              chantheta = noplot(2);
              noplot = 'on';
            end
          end
         case 'gridscale'
          GRID_SCALE = Value;
          if GRID_SCALE ~= round(GRID_SCALE) | GRID_SCALE < 4
               fprintf('topoplot(): ''gridscale'' value must be integer > 4.\n');
               return
          end
	 otherwise
	  error(['topoplot(): Unknown input parameter ''' Param ''' ???'])
    end
  end
end

[r,c] = size(Vl);
if r>1 & c>1,
  error('topoplot(): input data must be a single vector');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fid = fopen(loc_file);
%if fid<1,
%  fprintf('topoplot(): cannot open chan_locs file (%s).\n',loc_file);
%  return
%end
%A = fscanf(fid,'%d %f %f %s',[7 MAXTOPOPLOTCHANS]);
%fclose(fid);
%A = A';
%labels = setstr(A(:,4:7));
%idx = find(labels == '.');                       % some labels have dots
%labels(idx) = setstr(abs(' ')*ones(size(idx)));  % replace them with spaces
%Th = pi/180*A(:,2);                              % convert degrees to radians
%Rd = A(:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%%%%%%%%%%%%%%%%%%%% Read the channel location information %%%%%%%%%%%%%%%%%%%%%%%%
% 
if isstr(loc_file)
	[tmpeloc labels Th Rd ind] = readlocs(loc_file,'filetype','loc');
else % a locs struct
	[tmpeloc labels Th Rd ind] = readlocs(loc_file);
end
if length(tmpeloc) == length(Vl) + 1 % remove last channel if necessary (common reference channel)
    tmpeloc(end) = [];
    labels(end) = [];
    Th(end) = [];
    Rd(end) = [];
end;

if length(Vl) > 1
    Vl     = Vl(ind);
end;
labels = labels(ind);
if strcmpi(shrinkfactor, 'off') & isfield(tmpeloc, 'shrink'), shrinkfactor = tmpeloc(1).shrink; end;
labels = strvcat(labels);
Th = pi/180*Th;                              % convert degrees to radians
    
%if length(Vl) > 1 & length(Vl) ~= length(Th),
% fprintf('topoplot(): data vector length (%d) must be the same as chan_locs file rows (%d)\n',...
%               length(Vl),length(Th));
%end

if isstr(shrinkfactor)
	if (strcmp(lower(shrinkfactor), 'on') & max(Rd) >0.5) | strcmp(lower(shrinkfactor), ...
                       'force')
		squeeze = 1 - 0.5/max(Rd); %(2*max(r)-1)/(2*rmax);
		if strcmpi(VERBOSE, 'on')
            fprintf('topoplot(): electrode radii shrunk towards vertex by %2.3g to show all\n', ...
                       squeeze);
        end;
		Rd = Rd-squeeze*Rd; % squeeze electrodes in squeeze*100% to have all inside
	end;	
else 
    if strcmpi(VERBOSE, 'on')
        fprintf('topoplot(): electrode radius shrunk towards vertex by %2.3g\n', shrinkfactor);
	end;
    Rd = Rd-shrinkfactor*Rd; % squeeze electrodes by squeeze*100% to have all inside
end;
	  
enum = find(Rd <= 0.5);                     % interpolate on-head channels only
if length(enum) > length(Rd)
    if strcmpi(VERBOSE, 'on')
        fprintf('topoplot(): %d/%d electrode not shown (radius>0.5)\n', ...
                   length(enum)-length(Rd),length(Rd));    
    end; 
end;	
if ~isempty(Vl)
	if length(Vl) == length(Th)
		Vl = Vl(enum);
	else if strcmp(STYLE,'blank')
            tmpVl=[];
            cc=1;
            for kk=1:length(Vl)
                tmpind = find(enum == Vl(kk));
                if isempty(tmpind)
                    if strcmpi(VERBOSE, 'on')
                        disp( [ ...
    'topoplot() Warning: one or more channels are not visible (use "Edit' ...
    ' > Channel locations" to modify the montage shrink factor).' ] );
                    end;
                else
                    tmpVl(cc) = tmpind;
                    cc=cc+1;
                end;
            end
            Vl=tmpVl;
		end;
	end;	
end;
Th = Th(enum);
Rd = Rd(enum);
labels = labels(enum,:);
[x,y] = pol2cart(Th,Rd);      % transform from polar to cartesian coordinates
rmax = 0.5;

if ~strcmpi(STYLE,'blank') % if draw scalp map
  %
  %%%%%%%%%%%%%%%% Find limits for interpolation %%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  if strcmp(INTERPLIMITS,'head')
    xmin = min(-.5,min(x)); xmax = max(0.5,max(x));
    ymin = min(-.5,min(y)); ymax = max(0.5,max(y));
  else % interplimits = rectangle containing electrodes
    xmin = max(-.5,min(x)); xmax = min(0.5,max(x));
    ymin = max(-.5,min(y)); ymax = min(0.5,max(y));
  end
  
  %
  %%%%%%%%%%%%%%%%%%%%%%% Interpolate scalp map data %%%%%%%%%%%%%%%%%%%%
  %
  xi = linspace(xmin,xmax,GRID_SCALE);   % x-axis description (row vector)
  yi = linspace(ymin,ymax,GRID_SCALE);   % y-axis description (row vector)
  [Xi,Yi,Zi] = griddata(y,x,Vl,yi',xi,'invdist'); % interpolate data
  %
  %%%%%%%%%%%%%%%%%%%%%%% Mask out data outside the head %%%%%%%%%%%%%%%%%
  %
  mask = (sqrt(Xi.^2+Yi.^2) <= rmax);
  ii = find(mask == 0);
  Zi(ii) = NaN;
  %
  %%%%%%%%%%%%%%%%%%%%%%% return designated channel value %%%%%%%%%%%%%%%%
  %
  if exist('chanrad')
      chantheta = (chantheta/360)*2*pi;
      chancoords = round(34+33.5*2*chanrad*[cos(-chantheta),-sin(-chantheta)]);
      if chancoords(1)<1 | chancoords(1) > 67 | chancoords(2)<1 | chancoords(2)>67
          error('designated ''noplot'' channel out of bounds')
      else
        chanval = Zi(chancoords(1),chancoords(2));
      end
  end
  %
  %%%%%%%%%%%%%%%%%%%%%%% Return interpolated image only  %%%%%%%%%%%%%%%%%
  %
   if strcmpi(noplot, 'on') 
       fprintf('topoplot(): no plot requested.\n')
       return;
   end
  %
  %%%%%%%%%%%%%%%%%%%% Calculate colormap limits %%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  m = size(colormap,1);
  if isstr(MAPLIMITS)
    if strcmp(MAPLIMITS,'absmax')
      amin = -max(max(abs(Zi)));
      amax = max(max(abs(Zi)));
    elseif strcmp(MAPLIMITS,'maxmin') | strcmp(MAPLIMITS,'minmax')
      amin = min(min(Zi));
      amax = max(max(Zi));
    else
      fprintf('topoplot(): unknown ''maplimits'' value.\n');
      return
    end
  else
    amin = MAPLIMITS(1);
    amax = MAPLIMITS(2);
  end
  delta = xi(2)-xi(1); % length of grid entry
  
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%% Draw interpolated scalp map %%%%%%%%%%%%%%%%%
  %
  cla  % clear current axis
  hold on
  set(gca,'Xlim',[-rmax*1.3 rmax*1.3],'Ylim',[-rmax*1.3 rmax*1.3])
  % pos = get(gca,'position');
  % fprintf('Current axes size %g,%g\n',pos(3),pos(4));

  if strcmp(STYLE,'contour')
    contour(Xi,Yi,Zi,CONTOURNUM,'k');
  elseif strcmp(STYLE,'both')
    tmph = surface(Xi-delta/2,Yi-delta/2,zeros(size(Zi)),Zi,'EdgeColor','none',...
	'FaceColor',SHADING);
    if strcmpi(MASKSURF, 'on')
        set(tmph, 'visible', 'off');
        handle = tmph;
    end;
    contour(Xi,Yi,Zi,CONTOURNUM,'k');
  elseif strcmp(STYLE,'straight')
    tmph = surface(Xi-delta/2,Yi-delta/2,zeros(size(Zi)),Zi,'EdgeColor','none',...
	'FaceColor',SHADING);
    if strcmpi(MASKSURF, 'on')
        set(tmph, 'visible', 'off');
        handle = tmph;
    end;
  elseif strcmp(STYLE,'fill')
    contourf(Xi,Yi,Zi,CONTOURNUM,'k');
  else
    error('topoplot(): Invalid style')
  end
  caxis([amin amax]) % set coloraxis

else % if style 'blank'
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%% Draw blank head %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
   if strcmpi(noplot, 'on') 
       fprintf('topoplot(): no plot requested.\n')
       return;
   end

   cla
   hold on
   set(gca,'Xlim',[-rmax*1.3 rmax*1.3],'Ylim',[-rmax*1.3 rmax*1.3])
   % pos = get(gca,'position');
   % fprintf('Current axes size %g,%g\n',pos(3),pos(4));

  if strcmp(ELECTRODES,'labelpoint') |  strcmp(ELECTRODES,'numpoint')
    text(-0.6,-0.6, ...
    [ int2str(length(Rd)) ' of ' int2str(length(tmpeloc)) ' electrode locations shown']);
    text(-0.6,-0.7, ...
    [ 'Click on electrodes to toggle name/number']);
    % a = textsc('Channel locations', 'title');
    a = title('Channel locations');
    set(a, 'fontweight', 'bold');
  end;

  if length(Vl) < length(enum)
      for kk = 1:length(Vl)
          if exist('EMARKERSIZE1CHAN') == 1
              hp2 = plot(y(Vl(kk)),x(Vl(kk)),'.','Color', 'red', 'markersize', EMARKERSIZE1CHAN);
          else
              hp2 = plot(y(Vl(kk)),x(Vl(kk)),'.','Color', 'red', 'markersize', 40);
              hold on
          end;
      end
  end;
end

if exist('handle') ~= 1
    handle = gca;
end;

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% Draw head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
l = 0:2*pi/100:2*pi;
basex = .18*rmax;  
tip = rmax*1.15; base = rmax-.004;
EarX = [.497 .510 .518 .5299 .5419 .54 .547 .532 .510 .489];
EarY = [.0555 .0775 .0783 .0746 .0555 -.0055 -.0932 -.1313 -.1384 -.1199];

%
% %%%%%%%%%%%%%%%%%%% Plot electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if strcmp(ELECTRODES,'on') 
  if isempty(EMARKERSIZE)
   EMARKERSIZE = 10;
   if length(y)>=32 
    EMARKERSIZE = 8;
   elseif length(y)>=64
    EMARKERSIZE = 6;
   elseif length(y)>=100
    EMARKERSIZE = 3;
   elseif length(y)>=200
    EMARKERSIZE = 1;
   end
  end
  hp2 = plot(y,x,EMARKER,'Color',ECOLOR,'markersize',EMARKERSIZE);
elseif strcmp(ELECTRODES,'labels')
    for i = 1:size(labels,1)
    text(y(i),x(i),labels(i,:),'HorizontalAlignment','center',...
	'VerticalAlignment','middle','Color',ECOLOR,...
	'FontSize',EFSIZE)
  end
elseif strcmp(ELECTRODES,'labelpoint')
 if isempty(EMARKERSIZE)
   EMARKERSIZE = 10;
   if length(y)>=32 
    EMARKERSIZE = 8;
   elseif length(y)>=64
    EMARKERSIZE = 6;
   elseif length(y)>=100
    EMARKERSIZE = 3;
   elseif length(y)>=200
    EMARKERSIZE = 1;
   end
  end
  hp2 = plot(y,x,EMARKER,'Color',ECOLOR,'markersize',EMARKERSIZE);
  for i = 1:size(labels,1)
    hh(i) = text(y(i)+0.01,x(i),labels(i,:),'HorizontalAlignment','left',...
	'VerticalAlignment','middle','Color', ECOLOR,'userdata', num2str(enum(i)), ...
	'FontSize',EFSIZE, 'buttondownfcn', ...
	    ['tmpstr = get(gco, ''userdata'');'...
	     'set(gco, ''userdata'', get(gco, ''string''));' ...
	     'set(gco, ''string'', tmpstr); clear tmpstr;'] );
  end
elseif strcmp(ELECTRODES,'numpoint')
 if isempty(EMARKERSIZE)
   EMARKERSIZE = 10;
   if length(y)>=32 
    EMARKERSIZE = 8;
   elseif length(y)>=64
    EMARKERSIZE = 6;
   elseif length(y)>=100
    EMARKERSIZE = 3;
   elseif length(y)>=200
    EMARKERSIZE = 1;
   end
  end
  hp2 = plot(y,x,EMARKER,'Color',ECOLOR,'markersize',EMARKERSIZE);
  for i = 1:size(labels,1)
    hh(i) = text(y(i)+0.01,x(i),num2str(enum(i)),'HorizontalAlignment','left',...
	'VerticalAlignment','middle','Color', ECOLOR,'userdata', labels(i,:) , ...
	'FontSize',EFSIZE, 'buttondownfcn', ...
	    ['tmpstr = get(gco, ''userdata'');'...
	     'set(gco, ''userdata'', get(gco, ''string''));' ...
	     'set(gco, ''string'', tmpstr); clear tmpstr;'] );
  end
elseif strcmp(ELECTRODES,'numbers')
  for i = 1:size(labels,1)
    text(y(i),x(i),int2str(enum(i)),'HorizontalAlignment','center',...
	'VerticalAlignment','middle','Color',ECOLOR,...
	'FontSize',EFSIZE)
  end
end

%
%%%%%%%%%%%%%%%%%%%%%% Plot dipole on top of the plot %%%%%%%%%%%%%%%%%%%%%
%
if ~isempty(DIPOLE)
    hold on;
    color = 'k';
    % invert x and y from dipplot
    tmp = DIPOLE;
    DIPOLE(:,1) = -tmp(:,2);
    DIPOLE(:,2) =  tmp(:,1);
    DIPOLE(:,3) = -tmp(:,4);
    DIPOLE(:,4) =  tmp(:,3);
    DIPOLE(:,1:4)   = DIPOLE(:,1:4)*0.5;
    DIPOLE(:,3:end)   = DIPOLE(:,3:end)/500;
    if strcmpi(DIPNORM, 'on')
        for index = size(DIPOLE,1)
            DIPOLE(index,3:4) = DIPOLE(index,3:4)/norm(DIPOLE(index,3:end))*0.2;
        end;
    end; 
    DIPOLE(:, 3:4) =  DIPORIENT*DIPOLE(:, 3:4)*DIPLEN;
    for index = 1:size(DIPOLE,1)
        hh = plot( DIPOLE(index, 1), DIPOLE(index, 2), '.');
        set(hh, 'color', DIPCOLOR, 'markersize', DIPSCALE*30);
        hh = line( [DIPOLE(index, 1) DIPOLE(index, 1)+DIPOLE(index, 3)]', ...
                   [DIPOLE(index, 2) DIPOLE(index, 2)+DIPOLE(index, 4)]');
        set(hh, 'color', DIPCOLOR, 'linewidth', DIPSCALE*30/7);
    end;
end;

%
%%%%%%%%%%%%%%%%%%%%% Plot Head, Ears, Nose %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
plot(cos(l).*rmax,sin(l).*rmax,...
    'color',HCOLOR,'Linestyle','-','LineWidth',HLINEWIDTH); % plot head

plot([.18*rmax;0;-.18*rmax],[base;tip;base],...
    'Color',HCOLOR,'LineWidth',HLINEWIDTH); % plot nose
   
plot(EarX,EarY,'color',HCOLOR,'LineWidth',HLINEWIDTH)  % plot left ear
plot(-EarX,EarY,'color',HCOLOR,'LineWidth',HLINEWIDTH) % plot right ear

hold off
axis off
axis square;

try, icadefs; set(gcf, 'color', BACKCOLOR); catch, end; % set std background color

