function varargout = pop_Rereference_Data(varargin)
% POP_SCRIPT_NAME M-file for pop_Rereference_Data.fig
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
%      applied to the GUI before pop_Rereference_Data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Rereference_Data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Rereference_Data

% Last Modified by GUIDE v2.5 20-Dec-2004 09:45:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Rereference_Data_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Rereference_Data_OutputFcn, ...
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


% --- Executes just before pop_Rereference_Data is made visible.
function pop_Rereference_Data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Rereference_Data (see VARARGIN)

% Choose default command line output for pop_Rereference_Data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','load_dir',gui_parameters.default_load_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','save_dir',gui_parameters.default_save_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','data_format','.cnt');
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','ldr_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','script_file','rereference_data_script');
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','called_from_import_data',0);

    set(handles.Select_Load_Data_Dir,'String',gui_parameters.rereference_data.load_dir)
    set(handles.Select_Save_Data_Dir,'String',gui_parameters.rereference_data.save_dir)
    set(handles.Select_Data_Load_File,'String',gui_parameters.rereference_data.load_file)
    set(handles.Select_Data_Save_File,'String',gui_parameters.rereference_data.save_file)
    set(handles.Ldr_File,'String',gui_parameters.rereference_data.ldr_file)
    set(handles.Verbosity,'String',gui_parameters.rereference_data.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.rereference_data.generate_script)
    set(handles.Script_Name,'String',gui_parameters.rereference_data.script_file)

assignin('base','gui_parameters',gui_parameters)


% UIWAIT makes pop_Rereference_Data wait for user response (see UIRESUME)
% uiwait(handles.pop_Rereference_Data);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Rereference_Data_OutputFcn(hObject, eventdata, handles)
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

gui_parameter_change('.rereference_data','load_dir',get(hObject,'String'));


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

gui_parameter_change('.rereference_data','save_dir',get(hObject,'String'));


% --- Executes on button press in Rereference_Data_Directory_Button.
function Rereference_Data_Directory_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Rereference_Data_Directory_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets the parameters for each file's rereferencing
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
data_format = gui_parameters.rereference_data.data_format;
data_format = data_format(2:4);
load_data_dir = get(handles.Select_Load_Data_Dir,'String');
save_data_dir = get(handles.Select_Save_Data_Dir,'String');
ldr_file = get(handles.Ldr_File,'String');
verbosity = str2num(get(handles.Verbosity,'String'));

% If function called on its own
if gui_parameters.rereference_data.called_from_import_data ~=1

    % Makes a list of all files with the appropriate extension
    % and rereferences data from each file
    file_list = dir([load_data_dir filesep '*.mat']);
    for i = 1:length(file_list)
        current_file = char(file_list(i).name);
        dotpos = find(current_file == '.');
        file_list(i).name = cellstr(current_file(1:dotpos(length(dotpos))-1));
    end

    for i = 1:length(file_list)
        base_name = char(file_list(i).name);
        dotpos = find(base_name == '.');
        save_name = base_name(1:dotpos(length(dotpos)-1));
        load([load_data_dir filesep char(file_list(i).name)])

        if exist('cnt')
            cnt = rereference(cnt,ldr_file,verbosity);
            save([save_data_dir filesep save_name],'head','elec','sweep','cnt')
            clear head elec sweep cnt
        elseif exist('erp')
            erp = rereference(erp,ldr_file,verbosity);
            save([save_data_dir filesep save_name],'head','elec','sweep','erp')
            clear head elec sweep erp
        end
    
    end

    % Writes out a lovely script in default_script_dir, if desired
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
            fprintf(fid,'ldr_file = ''%s'';\n',get(handles.Ldr_File,'String'));
            fprintf(fid,'verbosity = %s;\n',verbosity);
            fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
            fprintf(fid,'%% Makes a list of all files with the appropriate extension\n');
            fprintf(fid,'%% and rereferences data in each file\n');
            fprintf(fid,'file_list = dir([load_data_dir filesep ''*.mat'']);\n');
            fprintf(fid,'for i = 1:length(file_list)\n');
            fprintf(fid,'    current_file = char(file_list(i).name);\n');
            fprintf(fid,'    dotpos = find(current_file == ''.'');\n');
            fprintf(fid,'    file_list(i).name = cellstr(current_file(1:dotpos(length(dotpos))-1));\n');
            fprintf(fid,'end\n\n');
            fprintf(fid,'for i = 1:length(file_list)\n');
            fprintf(fid,'    base_name = char(file_list(i).name);\n');
            fprintf(fid,'    dotpos = find(base_name == ''.'');\n');
            fprintf(fid,'    save_name = base_name(1:dotpos(length(dotpos)-1));\n');
            fprintf(fid,'    load([load_data_dir filesep char(file_list(i).name)])\n');
            fprintf(fid,'    if exist(''cnt'')\n');
            fprintf(fid,'        cnt = rereference(cnt,ldr_file,verbosity);\n');
            fprintf(fid,'        save([save_data_dir filesep save_name],''head'',''elec'',''sweep'',''cnt'')\n');
            fprintf(fid,'        clear head elec sweep cnt\n');
            fprintf(fid,'    elseif exist(''erp'')\n');
            fprintf(fid,'        erp = rereference(erp,ldr_file,verbosity);\n');
            fprintf(fid,'        save([save_data_dir filesep save_name],''head'',''elec'',''sweep'',''erp'')\n');
            fprintf(fid,'        clear head elec sweep erp\n');
            fprintf(fid,'    end\n');
            fprintf(fid,'end\n');
            fclose(fid);
        end
    end
end
        
% Closes active window
close(pop_Rereference_Data)

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
gui_parameters = evalin('base','gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Select_Load_Data_Dir,'String',selected_dir)
    set(handles.Select_Save_Data_Dir,'String',selected_dir)
end

% --- Executes on button press in Browse_Save_Data_Dir.
function Browse_Save_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the directory selection dialog box
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Select_Save_Data_Dir,'String',selected_dir)
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

gui_parameter_change('.rereference_data','load_file',get(hObject,'String'));


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

gui_parameter_change('.rereference_data','load_file',get(hObject,'String'));


% --- Executes on button press in Rereference_Data_File_Button.
function Rereference_Data_File_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Rereference_Data_File_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Sets parameters to execute data rereferencing
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
data_format = gui_parameters.rereference_data.data_format;
data_format = data_format(2:4);
load_data_file = get(handles.Select_Data_Load_File,'String');
save_data_file = get(handles.Select_Data_Save_File,'String');
ldr_file = get(handles.Ldr_File,'String');
verbosity = str2num(get(handles.Verbosity,'String'));

% If function called on its own
if gui_parameters.rereference_data.called_from_import_data ~=1

    % Combines parameters, then executes the rereference routine
    load(load_data_file)

    if exist('cnt')
        cnt = rereference(cnt,ldr_file,verbosity);
        save(save_data_file,'head','elec','sweep','cnt')
        clear head elec sweep cnt
    elseif exist('erp')
        erp = rereference(erp,ldr_file,verbosity);
        save(save_data_file,'head','elec','sweep','erp')
        clear head elec sweep erp
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
            fprintf(fid,'load_data_file = ''%s'';\n',get(handles.Select_Data_Load_File,'String'));
            fprintf(fid,'save_data_file = ''%s'';\n',get(handles.Select_Data_Save_File,'String'));
            fprintf(fid,'ldr_file = ''%s'';\n',get(handles.Ldr_File,'String'));
            fprintf(fid,'verbosity = ''%s'';\n',verbosity);
            fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
            fprintf(fid,'%% Rereferences data from the specified file\n');
            fprintf(fid,'load(load_data_file)\n');
            fprintf(fid,'if exist(''cnt'')\n');
            fprintf(fid,'    cnt = rereference(cnt,ldr_file,verbosity);\n');
            fprintf(fid,'    save(save_data_file,''head'',''elec'',''sweep'',''cnt'')\n');
            fprintf(fid,'    clear head elec sweep cnt\n');
            fprintf(fid,'elseif exist(''erp'')\n');
            fprintf(fid,'    erp = rereference(erp,ldr_file,verbosity);\n');
            fprintf(fid,'    save(save_data_file,''head'',''elec'',''sweep'',''erp'')\n');
            fprintf(fid,'    clear head elec sweep erp\n');
            fprintf(fid,'end\n');
            fclose(fid);

        end
    end
end
    
% Closes active window
close(pop_Rereference_Data)

% --- Executes on button press in Browse_Data_File_Load.
function Browse_Data_File_Load_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_File_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.rereference_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    selected_file = gui_parameters.file_select.selected_file;
    set(handles.Select_Data_Load_File,'String',selected_file)
    dotpos = find(selected_file == '.');
    load_file_name = selected_file(1:dotpos(length(dotpos))-1);
    set(handles.Select_Data_Load_File,'String',load_file_name)
    gui_parameter_change('.rereference_data','load_file',get(handles.Select_Data_Load_File,'String'));
end


% --- Executes on button press in Browse_Data_Save_File.
function Browse_Data_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    selected_file = gui_parameters.file_select.selected_file;
    set(handles.Select_Data_Load_File,'String',selected_file)
    dotpos = find(selected_file == '.');
    save_file_name = selected_file(1:dotpos(length(dotpos)-1)-1);
    set(handles.Select_Data_Save_File,'String',save_file_name)
    gui_parameter_change('.rereference_data','save_file',get(handles.Select_Data_Save_File,'String'));
end

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

gui_parameter_change('.rereference_data','verbosity',get(hObject,'String'));


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Generate_Script

gui_parameter_change('.rereference_data','generate_script',get(hObject,'Value'));


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

gui_parameter_change('.rereference_data','script_file',get(hObject,'String'));


% --- Executes on button press in Browse_Script_File.
function Browse_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
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
    gui_parameter_change('.rereference_data','script_file',get(handles.Script_Name,'String'));
end


% --- Executes during object creation, after setting all properties.
function Ldr_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ldr_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Ldr_File_Callback(hObject, eventdata, handles)
% hObject    handle to Ldr_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ldr_File as text
%        str2double(get(hObject,'String')) returns contents of Ldr_File as a double

gui_parameter_change('.rereference_data','ldr_file',get(hObject,'String'));


% --- Executes on button press in Browse_Ldr.
function Browse_Ldr_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Ldr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = '.ldr';
assignin('base','gui_parameters',gui_parameters)


% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    set(handles.Ldr_File,'String',file_name)
    gui_parameter_change('.rereference_data','ldr_file',get(handles.Ldr_File,'String'));
end

