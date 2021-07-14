function varargout = pop_Update_Data(varargin)
% POP_SCRIPT_NAME M-file for pop_Update_Data.fig
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
%      applied to the GUI before pop_Update_Data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Update_Data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Update_Data

% Last Modified by GUIDE v2.5 02-Jan-2005 02:09:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Update_Data_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Update_Data_OutputFcn, ...
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


% --- Executes just before pop_Update_Data is made visible.
function pop_Update_Data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Update_Data (see VARARGIN)

% Choose default command line output for pop_Update_Data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.update_data','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','reduce_text','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','resampling_rate','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','reduce_text_list','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','combine_file_list','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','combine_files_save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','update_erp_master_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','update_erp_append_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.update_data','script_file','update_data_script');


    set(handles.New_Reduce_Text,'String',gui_parameters.update_data.reduce_text)
    set(handles.Resampling_Rate,'String',gui_parameters.update_data.resampling_rate)
    set(handles.Reduce_Text_List,'String',gui_parameters.update_data.reduce_text_list)
    set(handles.Combine_File_List,'String',gui_parameters.update_data.combine_file_list)
    set(handles.Combine_Files_Save_File,'String',gui_parameters.update_data.combine_files_save_file)
    set(handles.Update_Erp_Master_File,'String',gui_parameters.update_data.update_erp_master_file)
    set(handles.Update_Erp_Append_File,'String',gui_parameters.update_data.update_erp_append_file)
    set(handles.Verbosity,'String',gui_parameters.update_data.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.update_data.generate_script)
    set(handles.Script_Name,'String',gui_parameters.update_data.script_file)

assignin('base','gui_parameters',gui_parameters)
    
% UIWAIT makes pop_Update_Data wait for user response (see UIRESUME)
% uiwait(handles.pop_Update_Data);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Update_Data_OutputFcn(hObject, eventdata, handles)
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
function Update_Erp_Master_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Update_Erp_Master_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Update_Erp_Master_File_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Erp_Master_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Update_Erp_Master_File as text
%        str2double(get(hObject,'String')) returns contents of Update_Erp_Master_File as a double

gui_parameter_change('.update_data','update_erp_master_file',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Update_Erp_Append_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Update_Erp_Append_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Update_Erp_Append_File_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Erp_Append_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Update_Erp_Append_File as text
%        str2double(get(hObject,'String')) returns contents of Update_Erp_Append_File as a double

gui_parameter_change('.update_data','update_erp_append_file',get(hObject,'String'));


% --- Executes on button press in Update_Erp.
function Update_Erp_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Erp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets the parameters for update_erp
update_erp_master = get(handles.Update_Erp_Master_File,'String');
update_erp_append = get(handles.Update_Erp_Append_File,'String');

% Runs the update_erp function
update_erp(update_erp_master,update_erp_append);
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

% Writes out a lovely script in script_dir, if desired
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
        fprintf(fid,'%% Sets the parameters for update_erp\n');
        fprintf(fid,'update_erp_master = ''%s'';\n',get(handles.Update_Erp_Master_File,'String'));
        fprintf(fid,'update_erp_append = ''%s'';\n',get(handles.Update_Erp_Append_File,'String'));
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'%% Runs the update_erp function\n');
        fprintf(fid,'update_erp(update_erp_master,update_erp_append);\n');
        fclose(fid);
    end
end
    
% Closes active window
close(pop_Update_Data)

% Function to generate a header for each script
function script_header(fid)
fprintf(fid,'%% Script generated on %s\n',datestr(date));
fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');

% --- Executes on button press in Browse_Update_Erp_Master_File.
function Browse_Update_Erp_Master_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Update_Erp_Master_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.update_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    selected_file = gui_parameters.file_select.selected_file;
    set(handles.Update_Erp_Master_File,'String',selected_file)
    gui_parameter_change('.update_data','update_erp_master_file',get(hObject,'String'));
end

% --- Executes on button press in Browse_Update_Erp_Append_File.
function Browse_Update_Erp_Append_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Update_Erp_Append_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.update_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    selected_file = gui_parameters.file_select.selected_file;
    set(handles.Update_Erp_Append_File,'String',selected_file)
    gui_parameter_change('.update_data','update_erp_append_file',get(hObject,'String'));
end

% --- Executes during object creation, after setting all properties.
function New_Combine_File_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Combine_File_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Combine_File_Name_Callback(hObject, eventdata, handles)
% hObject    handle to New_Combine_File_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Combine_File_Name as text
%        str2double(get(hObject,'String')) returns contents of New_Combine_File_Name as a double


% --- Executes during object creation, after setting all properties.
function Combine_Files_Save_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Combine_Files_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Combine_Files_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_Files_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Combine_Files_Save_File as text
%        str2double(get(hObject,'String')) returns contents of
%        Combine_Files_Save_File as a double

gui_parameter_change('.update_data','combine_files_save_file',get(hObject,'String'));


% --- Executes on button press in Combine_Files.
function Combine_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Sets parameters to execute combine_files
combine_file_list = strvcat(get(handles.Combine_File_List,'String'));
combine_file_save = get(handles.Combine_Files_Save_File,'String');
reduce_text = strvcat(get(handles.New_Reduce_Text,'String'));
resampling_rate = str2num(get(handles.Resampling_Rate,'String'));
verbosity = str2num(get(handles.Verbosity,'String'));

% Combines files
combine_files(combine_file_list,combine_file_save,reduce_text,resampling_rate);
load(combine_file_save)
combine_files_consolidate_subnums;
save(combine_file_save,'erp')

% Writes out a lovely script in script_dir, if desired
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
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
        fprintf(fid,'%% Sets the parameters for combine_files\n');
        for j = 1:length(combine_file_list)
            fprintf(fid,'combine_file_list(%s,:) = ''%s'';\n',num2str(j),combine_file_list(j,:));
        end
        fprintf(fid,'combine_file_save = ''%s'';\n',get(handles.Select_Save_Data_File,'String'));
        for j = 1:length(reduce_text)
            fprintf(fid,'reduce_text(%s,:) = ''%s'';\n',num2str(j),reduce_text(j,:));
        end
        fprintf(fid,'resampling_rate = [%s];\n',get(handles.Resampling_Rate,'String'));
        fprintf(fid,'verbosity = ''%s'';\n',get(handles.Verbosity,'String'));
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'%% Combines files\n');
        fprintf(fid,'combine_files(combine_file_list,combine_file_save,reduce_text,resampling_rate);\n');
        fprintf(fid,'load(combine_file_save)\n');
        fprintf(fid,'combine_files_consolidate_subnums;\n');
        fprintf(fid,'save(combine_file_save,''erp'')\n');
        fclose(fid);
    end
end

% Closes active window
close(pop_Update_Data)

% --- Executes on button press in Browse_Data_File_Load.
function Browse_Data_File_Load_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_File_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.update_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    set(handles.New_Combine_File_Name,'String',file_name)
end


% --- Executes on button press in Browse_Data_Save_File.
function Browse_Data_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.update_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    set(handles.Combine_Files_Save_File,'String',file_name)
    gui_parameter_change('.update_data','combine_files_save_file',get(handles.Combine_Files_Save_File,'String'));
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

gui_parameter_change('.update_data','verbosity',get(hObject,'String'));


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Generate_Script

gui_parameter_change('.update_data','generate_script',get(hObject,'Value'));


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

gui_parameter_change('.update_data','script_file',get(hObject,'String'));


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
    gui_parameter_change('.update_data','script_file',get(handles.Script_Name,'String'));
end

% --- Executes during object creation, after setting all properties.
function New_Reduce_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Reduce_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Reduce_Text_Callback(hObject, eventdata, handles)
% hObject    handle to New_Reduce_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Reduce_Text as text
%        str2double(get(hObject,'String')) returns contents of New_Reduce_Text as a double


% --- Executes during object creation, after setting all properties.
function Resampling_Rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Resampling_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Resampling_Rate_Callback(hObject, eventdata, handles)
% hObject    handle to Resampling_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Resampling_Rate as text
%        str2double(get(hObject,'String')) returns contents of Resampling_Rate as a double

gui_parameter_change('.update_data','resampling_rate',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Reduce_Text_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reduce_Text_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Reduce_Text_List.
function Reduce_Text_List_Callback(hObject, eventdata, handles)
% hObject    handle to Reduce_Text_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Reduce_Text_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Reduce_Text_List

gui_parameter_change('.update_data','reduce_text_list',get(hObject,'String'));


% --- Executes on button press in Move_Down_Reduce_Text.
function Move_Down_Reduce_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down_Reduce_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rt_pos = get(handles.Reduce_Text_List,'Value');
rt_list = get(handles.Reduce_Text_List,'String');

if rt_pos < length(rt_list) % If not at bottom of list
    list_old = rt_list{rt_pos}; list_new = rt_list{rt_pos+1};
    rt_list{rt_pos+1} = list_old; rt_list{rt_pos} = list_new;
    set(handles.Reduce_Text_List,'String',rt_list)
    set(handles.Reduce_Text_List,'Value',rt_pos+1)
    gui_parameter_change('.update_data','reduce_text_list',rt_list);
end
    

% --- Executes on button press in Remove_Reduce_Text.
function Remove_Reduce_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Reduce_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.Reduce_Text_List,'String'))
    rt_list = get(handles.Reduce_Text_List,'String');
    rt_pos = get(handles.Reduce_Text_List,'Value');
    if ~iscell(rt_list); rt_list = cellstr(rt_list); end
    if ~isempty(rt_list); rt_list(rt_pos) = []; end
    if rt_pos > 1; set(handles.Reduce_Text_List,'Value',rt_pos-1); end
    set(handles.Reduce_Text_List,'String',rt_list)
    gui_parameter_change('.update_data','reduce_text_list',rt_list);
end
    
% --- Executes on button press in Add_Reduce_Text.
function Add_Reduce_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Reduce_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.New_Reduce_Text,'String'))
    rt_list = get(handles.Reduce_Text_List,'String');
    length_rt = length(rt_list);
    if ~iscell(rt_list) & length_rt ~= 0; rt_list = cellstr(rt_list); end
    new_reduce_text = get(handles.New_Reduce_Text,'String');
    rt_list{length_rt+1} = new_reduce_text;
    set(handles.Reduce_Text_List,'String',rt_list)
    set(handles.New_Reduce_Text,'String','')
    gui_parameter_change('.update_data','reduce_text_list',rt_list);
end

% --- Executes on button press in Move_Up_Reduce_Text.
function Move_Up_Reduce_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up_Reduce_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rt_pos = get(handles.Reduce_Text_List,'Value');
rt_list = get(handles.Reduce_Text_List,'String');

if rt_pos > 1 % If not at top of list
    list_old = rt_list{rt_pos}; list_new = rt_list{rt_pos-1};
    rt_list{rt_pos-1} = list_old; rt_list{rt_pos} = list_new;
    set(handles.Reduce_Text_List,'String',rt_list)
    set(handles.Reduce_Text_List,'Value',rt_pos-1)
    gui_parameter_change('.update_data','reduce_text_list',rt_list);
end

% --- Executes on button press in Move_Down_Files.
function Move_Down_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cf_pos = get(handles.Combine_Files_List,'Value');
cf_list = get(handles.Combine_Files_List,'String');

if cf_pos < length(cf_list) % If not at bottom of list
    list_old = cf_list{cf_pos}; list_new = cf_list{cf_pos+1};
    cf_list{cf_pos+1} = list_old; cf_list{cf_pos} = list_new;
    set(handles.Combine_Files_List,'String',cf_list)
    set(handles.Combine_Files_List,'Value',cf_pos+1)
    gui_parameter_change('.update_data','combine_file_list',cf_list);
end

% --- Executes on button press in Remove_Files.
function Remove_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.Combine_File_List,'String'))
    cf_list = get(handles.Combine_File_List,'String');
    cf_pos = get(handles.Combine_File_List,'Value');
    if ~iscell(cf_list); cf_list = cellstr(cf_list); end
    if ~isempty(cf_list); cf_list(cf_pos) = []; end
    if cf_pos > 1; set(handles.Combine_File_List,'Value',cf_pos-1); end
    set(handles.Combine_File_List,'String',cf_list)
    gui_parameter_change('.update_data','combine_file_list',cf_list);
end
    
% --- Executes on button press in Add_Files.
function Add_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.New_Combine_File_Name,'String'))
    cf_list = get(handles.Combine_File_List,'String');
    length_cf = length(cf_list);
    if ~iscell(cf_list) & length_cf ~= 0; cf_list = cellstr(cf_list); end
    new_combine_file_name = get(handles.New_Combine_File_Name,'String');
    cf_list{length_cf+1} = new_combine_file_name;
    set(handles.Combine_File_List,'String',cf_list)
    set(handles.New_Combine_File_Name,'String','')
    gui_parameter_change('.update_data','combine_file_list',cf_list);
end
    
% --- Executes on button press in Move_Up_Files.
function Move_Up_Files_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cf_pos = get(handles.Combine_Files_List,'Value');
cf_list = get(handles.Combine_Files_List,'String');

if cf_pos > 1 % If not at top of list
    list_old = cf_list{cf_pos}; list_new = cf_list{cf_pos-1};
    cf_list{cf_pos-1} = list_old; cf_list{cf_pos} = list_new;
    set(handles.Combine_Files_List,'String',cf_list)
    set(handles.Combine_Files_List,'Value',cf_pos-1)
    gui_parameter_change('.update_data','combine_file_list',cf_list);
end

% --- Executes during object creation, after setting all properties.
function Combine_File_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Combine_File_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Combine_File_List.
function Combine_File_List_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_File_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Combine_File_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Combine_File_List

gui_parameter_change('.update_data','combine_file_list',get(hObject,'String'));

