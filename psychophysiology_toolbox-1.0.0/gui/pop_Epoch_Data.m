function varargout = pop_Epoch_Data(varargin)
% POP_SCRIPT_NAME M-file for pop_Epoch_Data.fig
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
%      applied to the GUI before pop_Epoch_Data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Epoch_Data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Epoch_Data

% Last Modified by GUIDE v2.5 11-Dec-2004 16:13:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Epoch_Data_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Epoch_Data_OutputFcn, ...
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


% --- Executes just before pop_Epoch_Data is made visible.
function pop_Epoch_Data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Epoch_Data (see VARARGIN)

% Choose default command line output for pop_Epoch_Data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');


gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','data_format','.cnt');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','load_dir',gui_parameters.default_load_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','save_dir',gui_parameters.default_save_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','trigger_numbers','0');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','epoch_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','epoch_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','scale2uv',0);
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','script_file','epoch_data_script');
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','called_from_import_data',0);

    switch gui_parameters.epoch_data.data_format
        case '.cnt'
            set(handles.Select_Data_Format,'Value',1)
        case '.bdf'
            set(handles.Select_Data_Format,'Value',2)
        case '.edf'
            set(handles.Select_Data_Format,'Value',3)
    end

    set(handles.Select_Load_Data_Dir,'String',gui_parameters.epoch_data.load_dir)
    set(handles.Select_Save_Data_Dir,'String',gui_parameters.epoch_data.save_dir)
    set(handles.Select_Data_Load_File,'String',gui_parameters.epoch_data.load_file)
    set(handles.Select_Data_Save_File,'String',gui_parameters.epoch_data.save_file)    
    set(handles.Trigger_Numbers,'String',gui_parameters.epoch_data.trigger_numbers)
    set(handles.Epoch_Start,'String',gui_parameters.epoch_data.epoch_start)
    set(handles.Epoch_End,'String',gui_parameters.epoch_data.epoch_end)
    set(handles.Scale2uV,'Value',gui_parameters.epoch_data.scale2uv)
    set(handles.Verbosity,'String',gui_parameters.epoch_data.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.epoch_data.generate_script)
    set(handles.Script_Name,'String',gui_parameters.epoch_data.script_file)

assignin('base','gui_parameters',gui_parameters)

    
% UIWAIT makes pop_Epoch_Data wait for user response (see UIRESUME)
% uiwait(handles.pop_Epoch_Data);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Epoch_Data_OutputFcn(hObject, eventdata, handles)
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
function Select_Data_Format_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_Data_Format.
function Select_Data_Format_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Data_Format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Data_Format contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Data_Format

% Selects data format
data_selection = get(hObject,'Value');
switch data_selection
    case 1
        gui_parameter_change('.epoch_data','data_format','.cnt');
    case 2
        gui_parameter_change('.epoch_data','data_format','.bdf');
    case 3
        gui_parameter_change('.epoch_data','data_format','.edf');
end


% --- Executes during object creation, after setting all properties.
function Select_Load_Data_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Load_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Select_Load_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Load_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Load_Data_Dir as text
%        str2double(get(hObject,'String')) returns contents of Select_Load_Data_Dir as a double


% --- Executes during object creation, after setting all properties.
function Select_Save_Data_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Select_Save_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Save_Data_Dir as text
%        str2double(get(hObject,'String')) returns contents of Select_Save_Data_Dir as a double


% --- Executes on button press in Epoch_Data_Directory_Button.
function Epoch_Data_Directory_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Epoch_Data_Directory_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
if gui_parameters.epoch_data.called_from_import_data ~= 1

    % Sets the parameters for each file's epoching
    data_format = gui_parameters.epoch_data.data_format;
    data_format = data_format(2:4);
    load_data_dir = get(handles.Select_Load_Data_Dir,'String');
    save_data_dir = get(handles.Select_Save_Data_Dir,'String');
    trigger_numbers = ['[' get(handles.Trigger_Numbers,'String') ']'];
    epoch_start = str2num(get(handles.Epoch_Start,'String'));
    epoch_end = str2num(get(handles.Epoch_End,'String'));
    verbosity = str2num(get(handles.Verbosity,'String'));

    % Makes a list of all files with the appropriate extension
    % and epochs data from each file
    file_list = dir([load_data_dir filesep '*.' data_format '.mat']);
    for i = 1:length(file_list)
        current_file = char(file_list(i).name);
        dotpos = find(current_file == '.');
        file_list(i).name = cellstr(current_file(1:dotpos(length(dotpos))-1));
    end

    for i = 1:length(file_list)
        base_name = file_list(i).name;
        dotpos = find(base_name == '.');
        save_name = base_name(1:dotpos(length(dotpos)-1));
        load([load_data_dir filesep char(file_list(i).name)])
        [erp,head,elec,sweep] = epoch(cnt,head,elec,str2num(trigger_numbers),epoch_start,epoch_end,scale2uv,verbosity);
        save([save_data_dir filesep save_name],'head','elec','sweep','erp')
    end

    % Writes out a lovely script in save_data_dir, if desired
    if get(handles.Generate_Script,'Value')
        fid = fopen([gui_parameters.default_script_dir filesep get(handles.Script_Name,'String') '.m'],'w+');
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
            fprintf(fid,'%% Sets the parameters for each file extraction\n');
            fprintf(fid,'data_format = ''%s'';\n',data_format);
            fprintf(fid,'load_data_dir = ''%s'';\n',get(handles.Select_Load_Data_Dir,'String'));
            fprintf(fid,'save_data_dir = ''%s'';\n',get(handles.Select_Save_Data_Dir,'String'));
            fprintf(fid,'trigger_numbers = [%s];\n',get(handles.Trigger_Numbers,'String'));
            fprintf(fid,'epoch_start = [%s];\n',get(handles.Epoch_Start,'String'));
            fprintf(fid,'epoch_end = [%s];\n',get(handles.Epoch_End,'String'));
            fprintf(fid,'verbosity = [%s];\n',get(handles.Verbosity,'String'));
            fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
            fprintf(fid,'%% Makes a list of all files with the appropriate extension\n');
            fprintf(fid,'%% and epochs data in each file\n');
            fprintf(fid,'file_list = dir([load_data_dir filesep ''*.'' data_format ''.mat'']);\n');
            fprintf(fid,'for i = 1:length(file_list)\n');
            fprintf(fid,'    current_file = char(file_list(i).name);\n');
            fprintf(fid,'    dotpos = find(current_file == ''.'');\n');
            fprintf(fid,'    file_list(i).name = cellstr(current_file(1:dotpos(length(dotpos))-1));\n');
            fprintf(fid,'end\n\n');
            fprintf(fid,'for i = 1:length(file_list)\n');
            fprintf(fid,'    base_name = file_list(i).name;\n');
            fprintf(fid,'    dotpos = find(base_name == ''.'');\n');
            fprintf(fid,'    save_name = base_name(1:dotpos(length(dotpos)-1));\n');
            fprintf(fid,'    load([load_data_dir filesep char(file_list(i).name)])\n');
            fprintf(fid,'    [erp,head,elec,sweep] = epoch(cnt,head,elec,trigger_numbers,epoch_start,epoch_end,verbosity);\n');
            fprintf(fid,'    save([save_data_dir filesep save_name],''head'',''elec'',''sweep'',''erp'')\n');
            fprintf(fid,'end\n');
            fclose(fid);
        end
    end
end

% Closes active window
close(pop_Epoch_Data)

% Function to generate a header for each script
function script_header(fid)
fprintf(fid,'%% Script generated on %s\n',datestr(date));
fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');

% --- Executes on button press in Browse_Load_Data_Dir.
function Browse_Load_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the directory selection dialog box
pop_Directory_Select;
% Sets text for text boxes
gui_parameters = evalin('base','gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Select_Load_Data_Dir,'String',selected_dir)
    set(handles.Select_Save_Data_Dir,'String',selected_dir)
    gui_parameter_change('.epoch_data','load_dir',selected_dir);
    gui_parameter_change('.epoch_data','save_dir',selected_dir);
end
    
% --- Executes on button press in Browse_Save_Data_Dir.
function Browse_Save_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the directory selection dialog box
pop_Directory_Select;
% Sets text for save text box
gui_parameters = evalin('base','gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Select_Save_Data_Dir,'String',selected_dir)
    gui_parameter_change('.epoch_data','save_dir',selected_dir);
end

% --- Executes during object creation, after setting all properties.
function Select_Data_Load_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Select_Data_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Data_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Data_Load_File as text
%        str2double(get(hObject,'String')) returns contents of Select_Data_Load_File as a double

gui_parameter_change('.epoch_data','load_file',get(hOject,'String'));


% --- Executes during object creation, after setting all properties.
function Select_Data_Save_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Select_Data_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Data_Save_File as text
%        str2double(get(hObject,'String')) returns contents of
%        Select_Data_Save_File as a double

gui_parameter_change('.epoch_data','save_file',get(hObject,'String'));


% --- Executes on button press in Epoch_Data_File_Button.
function Epoch_Data_File_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Epoch_Data_File_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Sets parameters to execute data epoching
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
data_format = gui_parameters.epoch_data.data_format;
data_format = data_format(2:4);
load_data_file = get(handles.Select_Data_Load_File,'String');
save_data_file = get(handles.Select_Data_Save_File,'String');
trigger_numbers = str2num(['[' get(handles.Trigger_Numbers,'String') ']']);
epoch_start = str2num(get(handles.Epoch_Start,'String'));
epoch_end = str2num(get(handles.Epoch_End,'String'));
verbosity = str2num(get(handles.Verbosity,'String'));

% Combines parameters, then executes the epoch routine
load(load_data_file)
erp = epoch(cnt,trigger_numbers,epoch_start,epoch_end,verbosity);
save(save_data_file,'erp')

% Writes out a lovely script in save_data_dir, if desired
if get(handles.Generate_Script,'Value')
    fid = fopen([gui_parameters.default_script_dir filesep get(handles.Script_Name,'String') '.m'],'w+');
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
        fprintf(fid,'%% Sets the parameters for each file extraction\n');
        fprintf(fid,'data_format = ''%s'';\n',data_format);
        fprintf(fid,'load_data_file = ''%s'';\n',get(handles.Select_Data_Load_File,'String'));
        fprintf(fid,'save_data_file = ''%s'';\n',get(handles.Select_Data_Save_File,'String'));
        fprintf(fid,'trigger_numbers = [%s];\n',get(handles.Trigger_Numbers,'String'));
        fprintf(fid,'epoch_start = [%s];\n',get(handles.Epoch_Start,'String'));
        fprintf(fid,'epoch_end = [%s];\n',get(handles.Epoch_End,'String'));
        fprintf(fid,'verbosity = [%s];\n',verbosity);
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'%% Epochs data from the specified file\n');
        fprintf(fid,'load(load_data_file)\n');
        fprintf(fid,'erp = epoch(cnt,trigger_numbers,epoch_start,epoch_end,verbosity)\n');
        fprintf(fid,'save(save_data_file,''erp'')\n');
        fclose(fid);
    end
end

% Closes active window
close(pop_Epoch_Data)

% --- Executes on button press in Browse_Data_File_Load.
function Browse_Data_File_Load_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_File_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = '.mat';
assignin('base','gui_parameters',gui_parameters)

% Calls directory selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    set(handles.Select_Data_Load_File,'String',selected_file)
    dotpos = find(selected_file == '.');
    load_file_name = selected_file(1:dotpos(length(dotpos))-1);
    set(handles.Select_Data_Load_File,'String',load_file_name)
    gui_parameter_change('.epoch_data','load_file',get(handles.Select_Data_Load_File,'String'));
end
    
% --- Executes on button press in Browse_Data_Save_File.
function Browse_Data_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.epoch_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls directory selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    dotpos = find(selected_file == '.');
    save_file_name = selected_file(1:dotpos(length(dotpos)-1)-1);
    set(handles.Select_Data_Save_File,'String',save_file_name)
    gui_parameter_change('.epoch_data','save_file',get(handles.Select_Data_Save_File,'String'));
end

% --- Executes on button press in Scale2uV.
function Scale2uV_Callback(hObject, eventdata, handles)
% hObject    handle to Scale2uV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Scale2uV

gui_parameter_change('.epoch_data','scale2uv',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Verbosity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Verbosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Verbosity_Callback(hObject, eventdata, handles)
% hObject    handle to Verbosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Verbosity as text
%        str2double(get(hObject,'String')) returns contents of Verbosity as a double

gui_parameter_change('.epoch_data','verbosity',get(hObject,'String'));


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Generate_Script

gui_parameter_change('.epoch_data','generate_script',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Script_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Script_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Script_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Script_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Script_Name as text
%        str2double(get(hObject,'String')) returns contents of Script_Name as a double

gui_parameter_change('.epoch_data','script_file',get(hObject,'String'));


% --- Executes on button press in Browse_Script_File.
function Browse_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets data_format to .m, while preserving desired data format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = '.m';
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1);
    set(handles.Script_Name,'String',file_name)
    gui_parameter_change('.epoch_data','script_file',get(handles.Script_Name,'String'));
end

% --- Executes during object creation, after setting all properties.
function Trigger_Numbers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trigger_Numbers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Trigger_Numbers_Callback(hObject, eventdata, handles)
% hObject    handle to Trigger_Numbers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Trigger_Numbers as text
%        str2double(get(hObject,'String')) returns contents of Trigger_Numbers as a double

gui_parameter_change('.epoch_data','trigger_numbers',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Epoch_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Epoch_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Epoch_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Epoch_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Epoch_Start as text
%        str2double(get(hObject,'String')) returns contents of Epoch_Start as a double

gui_parameter_change('.epoch_data','epoch_start',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Epoch_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Epoch_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Epoch_End_Callback(hObject, eventdata, handles)
% hObject    handle to Epoch_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Epoch_End as text
%        str2double(get(hObject,'String')) returns contents of Epoch_End as a double

gui_parameter_change('.epoch_data','epoch_end',get(hObject,'String'));

