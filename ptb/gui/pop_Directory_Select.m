function varargout = pop_Directory_Select(varargin)
% POP_DIRECTORY_SELECT M-file for pop_Directory_Select.fig
%      POP_DIRECTORY_SELECT, by itself, creates a new POP_DIRECTORY_SELECT or raises the existing
%      singleton*.
%
%      H = POP_DIRECTORY_SELECT returns the handle to a new POP_DIRECTORY_SELECT or the handle to
%      the existing singleton*.
%
%      POP_DIRECTORY_SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_DIRECTORY_SELECT.M with the given input arguments.
%
%      POP_DIRECTORY_SELECT('Property','Value',...) creates a new POP_DIRECTORY_SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Directory_Select_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Directory_Select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Directory_Select

% Last Modified by GUIDE v2.5 20-Dec-2004 10:14:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Directory_Select_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Directory_Select_OutputFcn, ...
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


% --- Executes just before pop_Directory_Select is made visible.
function pop_Directory_Select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Directory_Select (see VARARGIN)

% Choose default command line output for pop_Directory_Select
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

% Sets working directory to current directory, if no default load
% directory has been specified
gui_parameters = gui_parameter_default(gui_parameters,'.directory_select','browse_dir',pwd);
handles.current_dir = gui_parameters.directory_select.browse_dir;
handles.old_dir = gui_parameters.directory_select.browse_dir;
gui_parameters = gui_parameter_default(gui_parameters,'.directory_select','selected_dir',pwd);
assignin('base','gui_parameters',gui_parameters)

% Refreshes handles structure
guidata(hObject,handles)

% Populates list box
refresh_listbox(handles.current_dir,handles);

% UIWAIT makes pop_Directory_Select wait for user response (see UIRESUME)
 uiwait(handles.pop_Directory_Select);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Directory_Select_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

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
function Dir_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dir_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Gets GUI data for modifications
%guidata(handles.pop_Directory_Select,handles)
% Sets text on top of box to working directory
%set(handles.File_Path,'String',pwd);


% --- Executes on selection change in Dir_List.
function varargout = Dir_List_Callback(hObject, eventdata, handles)
% hObject    handle to Dir_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Dir_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dir_List

% ------------------------
% A spiffy listbox callback, adapted from the lbox2 example
% ------------------------
click_response = get(handles.pop_Directory_Select,'SelectionType');
if strcmp(click_response,'open')
    fileseps = find(handles.current_dir == char(filesep));
    selection_index = get(handles.Dir_List,'Value');
    Dir_List = get(handles.Dir_List,'String');
    filename = Dir_List{selection_index};
    if handles.is_dir(handles.sorted_index(selection_index)) % If directory double-clicked on
        if strcmp(filename,'..') % Changing into directory above
            if length(fileseps) == 1 % If at root directory
                handles.current_dir = filesep;    
            else
                handles.current_dir = handles.old_dir(1:fileseps(length(fileseps))-1);
            end
        elseif strcmp(filename,'.') % Changing into current directory
            handles.current_dir = handles.old_dir;
        else % Changing into all other directories
            if length(fileseps) == 1 & ((length(handles.old_dir) < 4 & ispc) | length(handles.old_dir) == 1) % If at root directory 
                handles.current_dir = [filesep filename];
            else
                handles.current_dir = [handles.old_dir filesep filename];
            end
        end
	gui_parameter_change('.directory_select','browse_dir',handles.current_dir);
        handles.old_dir = handles.current_dir;
        guidata(hObject,handles)
        refresh_listbox(handles.current_dir,handles);
    end
end

% ------------------------
% Function to populate list box, adapted from lbox2 in Matlab docs
% ------------------------
function refresh_listbox(dir_path,handles)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir]';
handles.sorted_index = [sorted_index];

% Includes only directories
handles.dirs = zeros(length(handles.sorted_index),1);
new_index = [];
dir_counter = 0;
for i = 1:length(handles.sorted_index)
    if handles.is_dir(i) == 1
        dir_counter = dir_counter + 1;
        handles.dirs(i) = 1;
        new_index = [new_index; dir_counter];
    end
end

handles.file_names = handles.file_names(handles.dirs==1,:);
handles.is_dir = handles.is_dir(handles.dirs==1,:);
handles.sorted_index = new_index;

guidata(handles.pop_Directory_Select,handles)
set(handles.Dir_List,'String',handles.file_names, ...
    'Value',1)
set(handles.File_Path,'String',dir_path)
set(handles.File_Type,'String','Displaying only directories');


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exports selected_dir to workspace
selection_index = get(handles.Dir_List,'Value');
Dir_List = get(handles.Dir_List,'String');
handles.selected_dir = [handles.current_dir filesep Dir_List{selection_index}];
gui_parameter_change('.directory_select','selected_dir',handles.selected_dir);
gui_parameter_change('.directory_select','browse_dir',handles.current_dir);
% Closes active window
close

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets selected file as empty (if it doesn't exist already), 
% then closes active window
no_dir = 'No directory selected.';
gui_parameter_change('.directory_select','selected_dir',no_dir);
close
