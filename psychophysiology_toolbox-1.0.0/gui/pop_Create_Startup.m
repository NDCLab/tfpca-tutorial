function varargout = pop_Create_Startup(varargin)
% POP_CREATE_STARTUP M-file for pop_Create_Startup.fig
%      POP_CREATE_STARTUP, by itself, creates a new POP_CREATE_STARTUP or raises the existing
%      singleton*.
%
%      H = POP_CREATE_STARTUP returns the handle to a new POP_CREATE_STARTUP or the handle to
%      the existing singleton*.
%
%      POP_CREATE_STARTUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_CREATE_STARTUP.M with the given input arguments.
%
%      POP_CREATE_STARTUP('Property','Value',...) creates a new POP_CREATE_STARTUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Create_Startup_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Create_Startup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Create_Startup

% Last Modified by GUIDE v2.5 18-Jan-2005 16:22:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Create_Startup_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Create_Startup_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pop_Create_Startup is made visible.
function pop_Create_Startup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Create_Startup (see VARARGIN)

% Choose default command line output for pop_Create_Startup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.create_startup','toolbox_dir',evalin('base','psychophys_path'));
gui_parameters = gui_parameter_default(gui_parameters,'.create_startup','startup_dir',pwd);

set(handles.Toolbox_Directory,'String',gui_parameters.create_startup.toolbox_dir)
set(handles.Startup_Directory,'String',gui_parameters.create_startup.startup_dir)

assignin('base','gui_parameters',gui_parameters)


% UIWAIT makes pop_Create_Startup wait for user response (see UIRESUME)
% uiwait(handles.pop_Create_Startup);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Create_Startup_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Sets gui_parameters defaults
function gui_parameters = gui_parameter_default(gui_parameters,gui_parameters_field,parameter,default)
eval(['if ~isfield(gui_parameters' gui_parameters_field ',''' parameter '''), gui_parameters' gui_parameters_field '.' parameter ' = default; end'])

% Changes GUI parameter value
function gui_parameters = gui_parameter_change(gui_parameters_field,parameter,value)
gui_parameters = evalin('base','gui_parameters');
eval(['gui_parameters' gui_parameters_field '.' parameter ' = value;']);
assignin('base','gui_parameters',gui_parameters)
save default_gui_parameters gui_parameters


% --- Executes during object creation, after setting all properties.
function Toolbox_Directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Toolbox_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Toolbox_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Toolbox_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Toolbox_Directory as text
%        str2double(get(hObject,'String')) returns contents of Toolbox_Directory as a double

gui_parameter_change('.create_startup','toolbox_dir',get(hObject,'String'));


% --- Executes on button press in Browse_Toolbox_Directory.
function Browse_Toolbox_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Toolbox_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Toolbox_Directory,'String',selected_dir)
    gui_parameter_change('.create_startup','toolbox_dir',get(handles.Toolbox_Directory,'String'));
end

% --- Executes during object creation, after setting all properties.
function Startup_Directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Startup_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Startup_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Startup_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Startup_Directory as text
%        str2double(get(hObject,'String')) returns contents of Startup_Directory as a double

gui_parameter_change('.create_startup','startup_dir',get(hObject,'String'));


% --- Executes on button press in Browse_Startup_Directory.
function Browse_Startup_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Startup_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Startup_Directory,'String',selected_dir)
    gui_parameter_change('.create_startup','startup_dir',get(handles.Startup_Directory,'String'));
end

% --- Executes on button press in Create_Startup.
function Create_Startup_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Startup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.Startup_Directory,'String')) & ... 
        ~isempty(get(handles.Toolbox_Directory,'String'))
    fid = fopen([get(handles.Startup_Directory,'String') filesep 'startup.m'],'w+');
    if fid == -1
        disp('Script file could not be opened for writing!')
        disp('Possible reasons for this error include:')
        disp('1)  You don''t have permission to write to the file you specified')
        disp('    (check that the account under which you''re logged in is the owner of the script file)')
        disp('2)  You don''t have permission to write to the directory you specified as the script save directory')
        disp('    (you "Set default GUI directories... Save script" in the main GUI window, right?)')
        disp('    (check that the account under which you''re logged in is the owner of the script directory)')
        disp('')
        disp('Make sure you can write to the file you specified, then rerun this window to generate a script.')
        disp('')
    else
        fprintf(fid,'%% Script generated on %s\n',datestr(date));
        fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
        fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
        fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
        fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');
        fprintf(fid,'%% Adds main toolbox path\n');
        fprintf(fid,'addpath %s\n',get(handles.Toolbox_Directory,'String'));
        fprintf(fid,'\n%% Runs psychophysiology toolbox startup script\n');
        fprintf(fid,'psychophysiology_toolbox_startup;\n');
        fprintf(fid,'Main;\n');
        fclose(fid);
    end

    close(pop_Create_Startup)
end
