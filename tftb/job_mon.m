function q=job_mon(h,n)
%JOB_MON Controls a job monitor GUI.
%   MON_HANDLE = JOB_MON(JOB_TITLE,TOTAL_NO_UNITS) opens a 
%   job monitor figure in the center of the sceen. The name
%   of the figure is taken from the string JOB_TITLE. The
%   total number of 'units' to be processed by the job must
%   be declared with the positive integer TOTAL_NO_UNITS.
%   
%   The 'units' can be any entity that measures the amount of
%   processing performed during a computation (e.g. the total 
%   number of cycles in a for-loop, or the total number of
%   flops required to finish the computation). Note that the
%   'remaining time' estimates displayed in the monitor rely on
%   the fact that each 'unit' requires approximately the same
%   amount of computation time.
%   
%   Whenever a significant portion of the total number of
%   'units' has been processed you should update the job monitor
%   figure with INTERRUPT_FLAG=JOB_MON(MON_HANDLE,NO_OF_UNITS).   
%   NO_OF_UNITS denotes the amount of 'units' processed since
%   the last call of JOB_MON. INTERRUPT_FLAG is set to logical
%   one if the job monitor figure window was closed during
%   (or prior to) the call of JOB_MON. Note that JOB_MON will
%   halt the computation unless (i.e. will not return until) the
%   mouse-pointer is removed from the monitor window, or the
%   monitor window is closed.
%
%   You can update the 'activity'-entry of the job monitor 
%   with SET(MON_HANDLE,'Tag',NEW_ACTIVITY_STRING). The new
%   'activity'-entry will be displayed with the next call of 
%   JOB_MON.
%   
%   Use TOTAL_NO_FLOPS=JOB_MON('done',MON_HANDLE) in order to
%   close the job monitor. TOTAL_NO_FLOPS contains the total
%   number of flops that were processed by MATLAB since the job
%   monitor was opened.
%
%   See JM_EXMPL for an example application of JOB_MON.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check which case of job_mon is called
if ~isstr(h);
   
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% JOB-MONITOR PENDING
%
%%%%%%%%%%%%%%%%%%%%%%%%%

% calling syntax in 'pending' case
% INTERRUPT_FLAG=job_mon(FIG_HANDLE,#OF_UNITS) (q=job_mon(h,n))

% check if figure h still exists
q=logical(0); if ~ishandle(h); q=logical(1); return; end 

% get user data from figure
ud=get(h,'UserData');
% ud(01) = figure handle
% ud(02) = handle to 'Activity' field
% ud(03) = handle to 'Status' field
% ud(04) = handle to 'Remaining' field
% ud(05) = handle to 'Flops' fieled
% ud(06) = handle to 'Percent' field
% ud(07) = handle to bar-patch
% ud(08) = total number of units to process (100%)
% ud(09) = number of units processed by now (x%)
% ud(10) = number of flops at start point
% ud(11) = cputime at start-point
% ud(12) = cputime at last pending call

% compute difference in time from last call
timenow=cputime; timetic=timenow-ud(12);

% accumulate new units
ud(9)=ud(9)+n;

% check if window needs to be updated
% (a minimum time distance avoids flickering)
if timetic>=0.001;
   
	% compute new percentage   
   perc=fix(ud(9)*100/ud(8)); percs=[' ',sprintf('%d',perc),'%'];
   
   % display new percentage
   set(ud(06),'String',percs);
   
   % update bar diagram
   set(ud(7),'XData',(0.01*perc)+0.03*[ 0 1 0 1 0 ]);
   
   % update activity box
   set(ud(2),'String',get(h,'Tag'));
   
   % update flops box
   flo=flops-ud(10); flos=sprintf('%d',round(flo));
   if flo>1e3; flos=sprintf('%d[k]',round(flo/1e3)); end
   if flo>1e6; flos=sprintf('%d[M]',round(flo/1e6)); end
   % include the following line on very fast computers only
   %if flo>1e9; flos=sprintf('%d[G]',round(flo/1e9)); end
   set(ud(5),'String',flos);
   
   % obtaining remaining time estimate
   s=timeest(ud); set(ud(4),'String',s);
   
   % denote current time as processed
   ud(12)=timenow;
   
   % display update
   drawnow;
end

% get handle to window under pointer
g=get(0,'PointerWindow');

% check if pointer is on job_monitor window
if g==h; % if yes ...
   
   % move into 'HALTED' mode
   s=get(h,'Name');
   set(h,'Name',['HALTED [',s,']']);
   set(ud(3),'String','HALTED','BackGroundColor','r');
   drawnow;
   
   % wait
   while h==get(0,'PointerWindow'); end
   
   % add time in halted mode to start-time
   ud(11)=ud(11)+cputime-timenow;
   
   % check if figure h still exists
   q=logical(0); if ~ishandle(h); q=logical(1); return; end 
   
   % prepare to continue
   set(h,'Name',s);
   set(ud(3),'String','RUNNING','BackGroundColor','w');
   
end

% update user data
set(h,'UserData',ud);

return; % JOB-MONITOR PENDING

else if strcmp(lower(h),'done');
      
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% JOB-MONITOR DONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%

% calling syntax in 'done' case
% #FLOPS_FOR_JOB=job_mon('done',FIG_HANDLE) (q=job_mon(h,n))

if ~isstr(n)
   q=NaN;
   if ishandle(n)
   	ud=get(n,'UserData'); q=flops-ud(10);
      delete(n);
   end
else
   error('Second argument must be a figure-handle.');
end

return; % JOB-MONITOR DONE

else
   
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% JOB-MONITOR INIT
%
%%%%%%%%%%%%%%%%%%%%%%%%%

% calling syntax in 'init' case
% FIG_HANDLE=job_mon('TITLE',TOTAL_#OF_UNITS) (q=job_mon(h,n))

% create gui-figure
hv=jobmongu(h);

% obtain access figure handle
q=hv(1);

% hide handle
set(q,'HandleVisibility','off');

% store side-information in user-data
ud=[ hv n 0 flops cputime cputime ];
% ud(01) = figure handle
% ud(02) = handle to 'Activity' field
% ud(03) = handle to 'Status' field
% ud(04) = handle to 'Remaining' field
% ud(05) = handle to 'Flops' fieled
% ud(06) = handle to 'Percent' field
% ud(07) = handle to bar-patch
% ud(08) = total number of units to process (100%)
% ud(09) = number of units processed by now (x%)
% ud(10) = number of flops at start point
% ud(11) = cputime at start-point
% ud(12) = cputime at last pending call
set(q,'Userdata',ud);

return; % JOB-MONITOR INIT

end; end;

return

%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TIME ESTIMATOR
%
%%%%%%%%%%%%%%%%%%%%%%%%%

function s=timeest(ud);
% ud = user data vector
% s  = string with time estimate

% ud(08) = total number of units to process (100%)
% ud(09) = number of units processed by now (x%)
% ud(10) = number of flops at start point
% ud(11) = cputime at start-point
% ud(12) = cputime at last pending call

% estimate based on entire process up to now
if ud(9)<2*eps;
   te=NaN;
else
	te=(ud(8)-ud(9))*(cputime-ud(11))/ud(9);
end

% check for hours, minutes, seconds
h=fix(te/3600); te=te-3600*h; m=fix(te/60); te=ceil(te-60*m);

% format into string
s=[];
if h>0; s=[num2str(h),'hrs : ']; end
if m>0; s=[s,num2str(m),'min : ']; end
s=[s,num2str(te),'sec'];

return; % TIME ESTIMATOR

%%%%%%%%%%%%%%%%%%%%%%%%%
%
% JOB-MONITOR GUI
%
%%%%%%%%%%%%%%%%%%%%%%%%%

function hv=jobmongu(name)
% name = title of the gui-figure
% hv   = handle vector
%        hv(1) = figure handle
%        hv(2) = handle to 'Activity' field
%        hv(3) = handle to 'Status' field
%        hv(4) = handle to 'Remaining' field
%        hv(5) = handle to 'Flops' fieled
%        hv(6) = handle to 'Percent' field
%        hv(7) = handle to bar-patch

% make sure that units of root are in pixel
set(0,'Units','pixel');

% generate figure
h=figure('NumberTitle','off','Menu','no','Name',name,'Resize','off');

% number of uicontrols
N=9; th=zeros(1,N);

% allocate position vector and control offset
lth=zeros(N,4); lof=[ 0 0 -4 -4 ];

% distance offsets and frame offsets
hdof=[ 4 0 0 0 ]; hfof=[ 4 0 0 0 ];
vdof=[ 0 4 0 0 ]; vfof=[ 0 4 0 0 ];

% strings for text controls
s={' Activity:','INITIALIZE',' Status:','RUNNING',...
   ' Remaining:',' ',' Flops:','0',' 100%'};

% generate controls
for c=1:N
   % create controls
   th(c)=uicontrol('Style','text','String',s{c},'Units','Pixel');
   % measure extent of controls
	lth(c,:)=get(th(c),'Extent')+lof;
end

% compute universal height of controls
ht=max(lth(:,4)); lth(:,4)=ht; htv=[ 0 ht 0 0 ];
% compute length of first two text fields
le1=max(lth([ 1 5 ],3)); lth([ 1 5 ],3)=le1; vle1=[ le1 0 0 0 ];
% compute length of third two text fields
le3=max(lth([ 3 7 ],3)); lth([ 3 7 ],3)=le3; vle3=[ le3 0 0 0 ];
% length of the four info display  fields
Q=2.0; lth([ 2 6 ],3)=Q*le1;
P=1.5; lth([ 4 8 ],3)=P*le1;
% compute total length of frame
frle=5*hdof+(P+Q+1)*vle1+vle3;
% compute length of axis
axle=frle-3*hdof-[ lth(9,3) 0 0 0 ];
% compute positioning
lth(1,:)=lth(1,:)+1*vfof+2*htv+3*vdof+1*hfof+1*hdof;
lth(2,:)=lth(2,:)+1*vfof+2*htv+3*vdof+1*hfof+2*hdof+vle1;
lth(3,:)=lth(3,:)+1*vfof+2*htv+3*vdof+1*hfof+3*hdof+vle1+Q*vle1;
lth(4,:)=lth(4,:)+1*vfof+2*htv+3*vdof+1*hfof+4*hdof+vle1+Q*vle1+vle3;
lth(5,:)=lth(5,:)+1*vfof+1*htv+2*vdof+1*hfof+1*hdof;
lth(6,:)=lth(6,:)+1*vfof+1*htv+2*vdof+1*hfof+2*hdof+vle1;
lth(7,:)=lth(7,:)+1*vfof+1*htv+2*vdof+1*hfof+3*hdof+vle1+Q*vle1;
lth(8,:)=lth(8,:)+1*vfof+1*htv+2*vdof+1*hfof+4*hdof+vle1+Q*vle1+vle3;
lth(9,:)=lth(9,:)+vfof+vdof/4+axle+2*hdof+hfof;
% create axis
axh=axes('Units','pixel','Position',vfof+hfof+[ 0 0 axle(1) ht+vdof(2)/2 ]);
% set position of all controls
for c=1:N; set(th(c),'Position',lth(c,:),'HorizontalAlignment','left'); end
for c=2:2:N set(th(c),'BackGroundColor','w','HorizontalAlignment','center'); end
% set frames
uicontrol('Style','frame','Units','pixel','Position',...
   [ hfof(1) vfof(2)+vdof(2)+ht frle(1) 2*ht+3*vdof(2) ])
uicontrol('Style','frame','Units','pixel','Position',...
   [ hfof(1)+axle(1)+hdof(1) vfof(2) lth(9,3)+2*hdof(1) ht+vdof(2)/2 ]);
% window size
wipo=[ frle(1)+2*hfof(1) 3*ht+4*vdof(2)+2*vfof(2) ];
% position of window on screen
sczi=get(0,'ScreenSize'); stpo=(sczi(3:4)-wipo)/2;
set(h,'Position',[ stpo wipo ]);

% define default pointer to be halt pointer
halt_ptr(h,0);

% customize axis
axis([ 0 1 0 1 ]); set(axh,'Box','on','XTick',[],'YTick',[]);
set(axh,'DrawMode','fast');

% add patch
pah=line('XData',0.03*[ 0 1 0 1 0 ],'YData',[ 0.1 0.1 0.9 0.9 0.1 ],'EraseMode','xor');

% return handles in vector
hv=[ h th(2) th(4) th(6) th(8) th(9) pah ];
%        hv(1) = figure handle
%        hv(2) = handle to 'Activity' field
%        hv(3) = handle to 'Status' field
%        hv(4) = handle to 'Remaining' field
%        hv(5) = handle to 'Flops' field
%        hv(6) = handle to 'Percent' field
%        hv(7) = handle to bar-patch
set(hv(6),'String',' 0%');
set(hv(1),'Tag','computing');

return