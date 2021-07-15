function varargout = pop_File_Select(varargin)
% POP_FILE_SELECT M-file for pop_File_Select.fig
%      POP_FILE_SELECT, by itself, creates a new POP_FILE_SELECT or raises the existing
%      singleton*.
%
%      H = POP_FILE_SELECT returns the handle to a new POP_FILE_SELECT or the handle to
%      the existing singleton*.
%
%      POP_FILE_SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_FILE_SELECT.M with the given input arguments.
%
%      POP_FILE_SELECT('Property','Value',...) creates a new POP_FILE_SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_File_Select_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_File_Select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_File_Select

% Last Modified by GUIDE v2.5 20-Dec-2004 10:11:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_File_Select_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_File_Select_OutputFcn, ...
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


% --- Executes just before pop_File_Select is made visible.
function pop_File_Select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_File_Select (see VARARGIN)

% Choose default command line output for pop_File_Select
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

% Sets working directory to current directory, if no default load
% directory has been specified
gui_parameters = gui_parameter_default(gui_parameters,'.file_select','browse_dir',pwd);
handles.current_dir = gui_parameters.file_select.browse_dir;
handles.old_dir = gui_parameters.file_select.browse_dir;
gui_parameters = gui_parameter_default(gui_parameters,'.file_select','selected_dir',pwd);
assignin('base','gui_parameters',gui_parameters)

% Sets a data format to which file display is limited, if none exists
gui_parameters = gui_parameter_default(gui_parameters,'.file_select','data_format','.mat');
handles.data_format = gui_parameters.file_select.data_format;

% Refreshes handles structure
guidata(hObject,handles)

% Populates list box
refresh_listbox(handles.current_dir,handles);

% UIWAIT makes pop_File_Select wait for user response (see UIRESUME)
 uiwait(handles.pop_File_Select);


% --- Outputs from this function are returned to the command line.
function varargout = pop_File_Select_OutputFcn(hObject, eventdata, handles)
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
function File_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in File_List.
function varargout = File_List_Callback(hObject, eventdata, handles)
% hObject    handle to File_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns File_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from File_List

% ------------------------
% A spiffy listbox callback, adapted from the lbox2 example
% ------------------------
click_response = get(handles.pop_File_Select,'SelectionType');
if strcmp(click_response,'open')
    fileseps = find(handles.current_dir == char(filesep));
    selection_index = get(handles.File_List,'Value');
    file_list = get(handles.File_List,'String');
    filename = file_list{selection_index};
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
        gui_parameter_change('.file_select','browse_dir',handles.current_dir);
        handles.old_dir = handles.current_dir;
        guidata(hObject,handles)
        refresh_listbox(handles.current_dir,handles);
    else % If file double-clicked on
        handles.selected_file = [handles.current_dir filesep filename];
        guidata(hObject,handles)
	gui_parameter_change('.file_select','selected_file',handles.selected_file);
        close
    end
end

% ------------------------
% Function to populate list box, adapted from lbox2 in Matlab docs
% ------------------------
function refresh_listbox(dir_path,handles)
gui_parameters = evalin('base','gui_parameters');
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir]';
handles.sorted_index = [sorted_index];

% Includes only files with right extension
handles.right_files = zeros(length(handles.sorted_index),1);
new_index = [];
good_files_counter = 0;
for i = 1:length(handles.sorted_index)
    if handles.is_dir(i) == 1
        good_files_counter = good_files_counter + 1;
        handles.right_files(i) = 1;
        new_index = [new_index; good_files_counter];
    else
        newfile = handles.file_names{i};
        dotpos = find(newfile == '.');
	
	% Defines newfile, depneding on whether there are any dots in the filename or not
	if ~isempty(dotpos)
	    file_extension = newfile(dotpos(length(dotpos)):length(newfile));
	else
	    file_extension = '';
	end
	
	% Checks current file's extension to see if it matches data_format
        if strcmp(gui_parameters.file_select.data_format,file_extension)
            good_files_counter = good_files_counter + 1;
            handles.right_files(i) = 1;
            new_index = [new_index; good_files_counter];
        end
    end
end

handles.file_names = handles.file_names(handles.right_files==1,:);
handles.is_dir = handles.is_dir(handles.right_files==1,:);
handles.sorted_index = new_index;

guidata(handles.pop_File_Select,handles)
set(handles.File_List,'String',handles.file_names, ...
    'Value',1)
set(handles.File_Path,'String',dir_path)
set(handles.File_Type,'String',['Displaying only ' handles.data_format ' files']);


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exports selected_file to workspace
selection_index = get(handles.File_List,'Value');
file_list = get(handles.File_List,'String');
handles.selected_file = [handles.current_dir filesep file_list{selection_index}];
gui_parameter_change('.file_select','selected_file',handles.selected_file);
gui_parameter_change('.file_select','browse_dir',handles.current_dir);
% Closes active window
close

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets selected file as empty (if it doesn't exist already), 
% then closes active window
no_file = 'No file selected.';
gui_parameter_change('.file_select','selected_file',no_file);
close
