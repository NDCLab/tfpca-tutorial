function varargout = pop_Create_Master_Script(varargin)
% POP_SCRIPT_NAME M-file for pop_Create_Master_Script.fig
%      POP_SCRIPT_NAME, by itself, creates a new POP_SCRIPT_NAME or raises the existing
%      singleton*.
%
%      H = POP_SCRIPT_NAME returns the handle to a new POP_SCRIPT_NAME or the handle to
%      the existing singleton*.
%
%      POP_SCRIPT_NAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_SCRIPT_NAME.M with the given input arguments.
%
%      POP_SCRIPT_NAME('Property','Value',...) creates a new POP_SCRIPT_NAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Create_Master_Script_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Create_Master_Script_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Create_Master_Script

% Last Modified by GUIDE v2.5 18-Jan-2005 16:24:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Create_Master_Script_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Create_Master_Script_OutputFcn, ...
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


% --- Executes just before pop_Create_Master_Script is made visible.
function pop_Create_Master_Script_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Create_Master_Script (see VARARGIN)

% Choose default command line output for pop_Create_Master_Script
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

% Sets default settings to be displayed on GUI
gui_parameters = gui_parameter_default(gui_parameters,'.create_master_script','data_format','.m');
gui_parameters = gui_parameter_default(gui_parameters,'.create_master_script','master_file_list',struct);
gui_parameters = gui_parameter_default(gui_parameters,'.create_master_script','master_script_file','master_script');

    set(handles.Combine_Scripts_List,'String',fieldnames(gui_parameters.create_master_script.master_file_list))
    set(handles.Master_Script_File,'String',gui_parameters.create_master_script.master_script_file)

assignin('base','gui_parameters',gui_parameters)

    
% UIWAIT makes pop_Create_Master_Script wait for user response (see UIRESUME)
% uiwait(handles.pop_Create_Master_Script);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Create_Master_Script_OutputFcn(hObject, eventdata, handles)
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


% Function to generate a header for each script
function script_header(fid)
fprintf(fid,'%% Script generated on %s\n',datestr(date));
fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');


% --- Executes during object creation, after setting all properties.
function New_Combine_Script_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Combine_Script_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Combine_Script_Name_Callback(hObject, eventdata, handles)
% hObject    handle to New_Combine_Script_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Combine_Script_Name as text
%        str2double(get(hObject,'String')) returns contents of New_Combine_Script_Name as a double


% --- Executes on button press in Create_Master_Script.
function Create_Master_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Master_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Writes out a lovely script in script_dir
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
master_file_list = get(handles.Combine_Scripts_List,'String');
fid = fopen([gui_parameters.default_script_dir filesep get(handles.Master_Script_File,'String') '.m'],'w+');
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
    script_header(fid);
    fprintf(fid,'%% Runs a series of scripts for fully automated processing\n');
    for j = 1:length(master_file_list)
        fprintf(fid,'%s;\n',char(master_file_list{j}));
    end
    fclose(fid);
end

% Closes active window
close(pop_Create_Master_Script)

% --- Executes on button press in Browse_New_Combine_Script_Name.
function Browse_New_Combine_Script_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_New_Combine_Script_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.create_master_script.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls directory selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    set(handles.Load_File,'String',gui_parameters.file_select.selected_file)
    gui_parameter_change('.create_master_script','load_file',get(handles.Load_File,'String'));
end


% --- Executes on button press in Browse_Script_File.
function Browse_Master_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.create_master_script.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls directory selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1);
    gui_parameter_change('.create_master_script','master_script_name',get(hObject,'String'));
    set(handles.Master_Script_File,'String',file_name)
end


% --- Executes on button press in Move_Down_Files.
function Move_Down_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cf_pos = get(handles.Combine_Scripts_List,'Value');
cf_list = get(handles.Combine_Scripts_List,'String');

if cf_pos < length(cf_list) % If not at bottom of list
    list_old = cf_list{cf_pos}; list_new = cf_list{cf_pos+1};
    cf_list{cf_pos+1} = list_old; cf_list{cf_pos} = list_new;
    set(handles.Combine_Scripts_List,'String',cf_list)
    set(handles.Combine_Scripts_List,'Value',cf_pos+1)
    gui_parameter_change('.create_master_script','master_file_list',cf_list);
end


% --- Executes on button press in Remove_Files.
function Remove_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cf_list = get(handles.Combine_Scripts_List,'String');
cf_pos = get(handles.Combine_Scripts_List,'Value');
if ~iscell(cf_list); cf_list = cellstr(cf_list); end
if ~isempty(cf_list); cf_list(cf_pos) = []; end
if cf_pos > 1; set(handles.Combine_Scripts_List,'Value',cf_pos-1); end
set(handles.Combine_Scripts_List,'String',cf_list)
gui_parameter_change('.create_master_script','master_file_list',cf_list);


% --- Executes on button press in Add_Files.
function Add_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.New_Combine_Script_Name,'String'))
    cf_list = get(handles.Combine_Scripts_List,'String');
    length_cf = length(cf_list);
    if ~iscell(cf_list) & length_cf ~= 0; cf_list = cellstr(cf_list); end
    new_combine_file_name = get(handles.New_Combine_Script_Name,'String');
    cf_list{length_cf+1} = new_combine_file_name;
    set(handles.Combine_Scripts_List,'String',cf_list)
    set(handles.New_Combine_Script_Name,'String','')
    gui_parameter_change('.create_master_script','master_file_list',cf_list);
end
    
% --- Executes on button press in Move_Up_Files.
function Move_Up_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cf_pos = get(handles.Combine_Scripts_List,'Value');
cf_list = get(handles.Combine_Scripts_List,'String');

if cf_pos > 1 % If not at top or bottom of list
    list_old = cf_list{cf_pos}; list_new = cf_list{cf_pos-1};
    cf_list{cf_pos-1} = list_old; cf_list{cf_pos} = list_new;
    set(handles.Combine_Scripts_List,'String',cf_list)
    set(handles.Combine_Scripts_List,'Value',cf_pos-1)
    gui_parameter_change('.create_master_script','master_file_list',cf_list);
end

% --- Executes during object creation, after setting all properties.
function Combine_Scripts_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Combine_Scripts_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Combine_Scripts_List.
function Combine_Scripts_List_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_Scripts_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Combine_Scripts_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Combine_Scripts_List


% --- Executes during object creation, after setting all properties.
function Master_Script_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Master_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Master_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Master_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Master_Script_File as text
%        str2double(get(hObject,'String')) returns contents of Master_Script_File as a double


