function varargout = pop_Extract_Trials(varargin)
% POP_EXTRACT_TRIALS M-file for pop_Extract_Trials.fig
%      POP_EXTRACT_TRIALS, by itself, creates a new POP_EXTRACT_TRIALS or raises the existing
%      singleton*.
%
%      H = POP_EXTRACT_TRIALS returns the handle to a new POP_EXTRACT_TRIALS or the handle to
%      the existing singleton*.
%
%      POP_EXTRACT_TRIALS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_EXTRACT_TRIALS.M with the given input arguments.
%
%      POP_EXTRACT_TRIALS('Property','Value',...) creates a new POP_EXTRACT_TRIALS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Extract_Trials_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Extract_Trials_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Extract_Trials

% Last Modified by GUIDE v2.5 16-Apr-2005 12:44:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Extract_Trials_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Extract_Trials_OutputFcn, ...
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


% --- Executes just before pop_Extract_Trials is made visible.
function pop_Extract_Trials_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Extract_Trials (see VARARGIN)

% Choose default command line output for pop_Extract_Trials
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','load_dir',gui_parameters.default_load_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','load_extension','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','update_existing_file',0);
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','save_dir',gui_parameters.default_save_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','resampling_rate','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','baseline_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','baseline_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','epoch_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','epoch_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','preprocessing1','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','preprocessing2','');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','signal_domain','time');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','trigger_list','ALL');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','electrode_list','ALL');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','electrodes_select',1);
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.extract_trials','script_file','extract_trials_script');

default_AT = 'NONE';
AT = evalin('base','AT','default_AT');
assignin('base','AT',AT)

    set(handles.Load_Dir,'String',gui_parameters.extract_trials.load_dir)
    set(handles.Load_File,'String',gui_parameters.extract_trials.load_file)
    set(handles.Load_Extension,'String',gui_parameters.extract_trials.load_extension)
    set(handles.Update_Existing_File,'Value',gui_parameters.extract_trials.update_existing_file)
    set(handles.Save_Dir,'String',gui_parameters.extract_trials.save_dir)
    set(handles.Save_File,'String',gui_parameters.extract_trials.save_file)
    set(handles.Resampling_Rate,'String',gui_parameters.extract_trials.resampling_rate)
    set(handles.Baseline_Start,'String',gui_parameters.extract_trials.baseline_start)
    set(handles.Baseline_End,'String',gui_parameters.extract_trials.baseline_end)
    set(handles.Epoch_Start,'String',gui_parameters.extract_trials.epoch_start)
    set(handles.Epoch_End,'String',gui_parameters.extract_trials.epoch_end)
    set(handles.Preprocessing_Script1,'String',gui_parameters.extract_trials.preprocessing1)
    set(handles.Preprocessing_Script2,'String',gui_parameters.extract_trials.preprocessing2)
    switch gui_parameters.extract_trials.signal_domain
        case 'time'
            set(handles.Signal_Domain,'Value',1)
        case 'freq-amplitude'
            set(handles.Signal_Domain,'Value',2)
        case 'freq-power'
            set(handles.Signal_Domain,'Value',3)
        case 'TFT'
            set(handles.Signal_Domain,'Value',4)	
    end
    set(handles.Trigger_List,'String',gui_parameters.extract_trials.trigger_list)
    set(handles.Electrode_List,'String',gui_parameters.extract_trials.electrode_list)
    switch gui_parameters.extract_trials.electrodes_select
        case 'keep'
            set(handles.Electrodes_Select,'Value',1)
        case 'skip'
            set(handles.Electrodes_Select,'Value',2)
    end
    set(handles.Verbosity,'String',gui_parameters.extract_trials.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.extract_trials.generate_script)
    set(handles.Script_Name,'String',gui_parameters.extract_trials.script_file)

assignin('base','gui_parameters',gui_parameters)


% UIWAIT makes pop_Extract_Trials wait for user response (see UIRESUME)
% uiwait(handles.pop_Extract_Trials);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Extract_Trials_OutputFcn(hObject, eventdata, handles)
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
function Load_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Load_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Load_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Load_Dir as text
%        str2double(get(hObject,'String')) returns contents of Load_Dir as a double

gui_parameter_change('.extract_trials','load_dir',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Load_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Load_File as text
%        str2double(get(hObject,'String')) returns contents of Load_File as a double

gui_parameter_change('.extract_trials','load_file',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Load_Extension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Load_Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Load_Extension_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Load_Extension as text
%        str2double(get(hObject,'String')) returns contents of Load_Extension as a double

gui_parameter_change('.extract_trials','load_extension',get(hObject,'String'));


% --- Executes on button press in Browse_Load_Dir.
function Browse_Load_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls directory selector and sets load and save text boxes
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp(gui_parameters.directory_select.selected_dir,'No directory selected.')
    set(handles.Load_Dir,'String',gui_parameters.directory_select.selected_dir)
    set(handles.Save_Dir,'String',gui_parameters.directory_select.selected_dir)
    gui_parameter_change('.extract_trials','load_dir',get(handles.Load_Dir,'String'));
end

% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.extract_trials.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1);
    set(handles.Load_File,'String',file_name);
    gui_parameter_change('.extract_trials','load_file',get(handles.Load_File,'String'));
end


% --- Executes during object creation, after setting all properties.
function Save_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_File_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Save_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Save_Dir as text
%        str2double(get(hObject,'String')) returns contents of
%        Save_Dir as a double

gui_parameter_change('.extract_trials','save_dir',get(hObject,'String'));


% --- Executes on button press in Browse_Save_Dir.
function Browse_Save_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls directory selector, then sets save box text
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp(gui_parameters.directory_select.selected_dir,'No directory selected.')
    set(handles.Save_Dir,'String',gui_parameters.directory_select.selected_dir)
    gui_parameter_change('.extract_trials','save_dir',get(handles.Save_Dir,'String'));
end


% --- Executes during object creation, after setting all properties.
function Save_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Save_File as text
%        str2double(get(hObject,'String')) returns contents of Save_File as a double

gui_parameter_change('.extract_trials','save_file',get(hObject,'String'));


% --- Executes on button press in Browse_Save_File.
function Browse_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.extract_trials.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1);
    set(handles.Save_File,'String',file_name)
    gui_parameter_change('.extract_trials','save_file',get(handles.Save_File,'String'));
end


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
gui_parameter_change('.extract_trials','resampling_rate',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Baseline_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Baseline_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Baseline_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Baseline_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Baseline_Start as text
%        str2double(get(hObject,'String')) returns contents of Baseline_Start as a double

gui_parameter_change('.extract_trials','baseline_start',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Baseline_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Baseline_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Baseline_End_Callback(hObject, eventdata, handles)
% hObject    handle to Baseline_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Baseline_End as text
%        str2double(get(hObject,'String')) returns contents of Baseline_End as a double

gui_parameter_change('.extract_trials','baseline_end',get(hObject,'String'));


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

gui_parameter_change('.extract_trials','epoch_start',get(hObject,'String'));


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

gui_parameter_change('.extract_trials','epoch_end',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Signal_Domain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Signal_Domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Signal_Domain.
function Signal_Domain_Callback(hObject, eventdata, handles)
% hObject    handle to Signal_Domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Signal_Domain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Signal_Domain

% Assigns domain of analysis based on selection
switch get(hObject,'Value')
    case 1
        gui_parameter_change('.extract_trials','signal_domain','time');
    case 2
        gui_parameter_change('.extract_trials','signal_domain','freq-amplitude');
    case 3
        gui_parameter_change('.extract_trials','signal_domain','freq-power');
    case 4
        gui_parameter_change('.extract_trials','signal_domain','TFT');
end


% --- Executes during object creation, after setting all properties.
function Preprocessing_Script1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Preprocessing_Script1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Preprocessing_Script1_Callback(hObject, eventdata, handles)
% hObject    handle to Preprocessing_Script1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Preprocessing_Script1 as text
%        str2double(get(hObject,'String')) returns contents of Preprocessing_Script1 as a double

gui_parameter_change('.extract_trials','preprocessing1',get(hObject,'String'));


% --- Executes on button press in Browse_Preprocessing_Script1.
function Browse_Preprocessing_Script1_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Preprocessing_Script1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preserves old data format, while shifting it to .m
old_data_format = evalin('base','data_format');
new_data_format = '.m';
assignin('base','data_format',new_data_format)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = '.m';
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    set(handles.Preprocessing_Script1,'String',gui_parameters.file_select.selected_file)
    gui_parameter_change('.extract_trials','preprocessing1',get(handles.Preprocessing_Script1,'String'));
end

% --- Executes during object creation, after setting all properties.
function Preprocessing_Script2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Preprocessing_Script2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Preprocessing_Script2_Callback(hObject, eventdata, handles)
% hObject    handle to Preprocessing_Script2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Preprocessing_Script2 as text
%        str2double(get(hObject,'String')) returns contents of Preprocessing_Script2 as a double

gui_parameter_change('.extract_trials','preprocessing2',get(hObject,'String'));


% --- Executes on button press in Browse_Preprocessing_Script2.
function Browse_Preprocessing_Script2_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Preprocessing_Script2 (see GCBO)
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
    set(handles.Preprocessing_Script2,'String',gui_parameters.file_select.selected_file)
    gui_parameter_change('.extract_trials','preprocessing2',get(handles.Preprocessing_Script2,'String'));
end


% --- Executes on button press in Tag_Artifacts.
function Tag_Artifacts_Callback(hObject, eventdata, handles)
% hObject    handle to Tag_Artifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the tag_artifacts dialog box
pop_Tag_Artifacts;

% --- Executes during object creation, after setting all properties.
function Trigger_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trigger_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Trigger_List.
function Trigger_List_Callback(hObject, eventdata, handles)
% hObject    handle to Trigger_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Trigger_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Trigger_List


% --- Executes during object creation, after setting all properties.
function New_Trigger_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Trigger_Callback(hObject, eventdata, handles)
% hObject    handle to New_Trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Trigger as text
%        str2double(get(hObject,'String')) returns contents of New_Trigger as a double


% --- Executes on button press in Add_Trigger.
function Add_Trigger_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Updates Trigger_List, if New_Trigger box isn't empty
if isempty(get(handles.New_Trigger,'String')) ~= 1
    trigger_list = get(handles.Trigger_List,'String');
    if iscell(trigger_list) ~= 1 & isempty(trigger_list) ~= 1; trigger_list = cellstr(trigger_list); end
    length_tl = length(trigger_list);
    trigger_list{length_tl+1} = get(handles.New_Trigger,'String');
    set(handles.Trigger_List,'String',trigger_list)
    set(handles.New_Trigger,'String','')
    gui_parameter_change('.extract_trials','trigger_list',get(handles.Trigger_List,'String'));
end
    

% --- Executes on button press in Remove_Trigger.
function Remove_Trigger_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets position of highlighted trigger, then deletes it
list_pos = get(handles.Trigger_List,'Value');
trigger_list = get(handles.Trigger_List,'String');
if iscell(trigger_list) ~= 1; trigger_list = cellstr(trigger_list); end
if isempty(trigger_list) ~= 1; trigger_list(list_pos) = []; end
if length(trigger_list) == 1; trigger_list = char(trigger_list); end
if list_pos > 1; set(handles.Trigger_List,'Value',list_pos-1); end
set(handles.Trigger_List,'String',trigger_list)
gui_parameter_change('.extract_trials','trigger_list',get(handles.Trigger_List,'String'));


% --- Executes during object creation, after setting all properties.
function Electrode_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Electrode_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Electrode_List.
function Electrode_List_Callback(hObject, eventdata, handles)
% hObject    handle to Electrode_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Electrode_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Electrode_List


% --- Executes during object creation, after setting all properties.
function Electrodes_Select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Electrodes_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Electrodes_Select.
function Electrodes_Select_Callback(hObject, eventdata, handles)
% hObject    handle to Electrodes_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Electrodes_Select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Electrodes_Select

% Puts this value into main memory
electrodes_select = get(hObject,'String');
electrodes_pos = get(hObject,'Value');
gui_parameter_change('.extract_trials','electrodes_select',char(electrodes_select(electrodes_pos)));


% --- Executes during object creation, after setting all properties.
function New_Electrode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function New_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to New_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Electrode as text
%        str2double(get(hObject,'String')) returns contents of New_Electrode as a double


% --- Executes on button press in Remove_Electrode.
function Remove_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets position of highlighted electrode, then deletes it
list_pos = get(handles.Electrode_List,'Value');
electrode_list = get(handles.Electrode_List,'String');
if iscell(electrode_list) ~= 1; electrode_list = cellstr(electrode_list); end
if isempty(electrode_list) ~= 1; electrode_list(list_pos) = []; end
if length(electrode_list) == 1; electrode_list = char(electrode_list); end
if list_pos > 1; set(handles.Electrode_List,'Value',list_pos-1); end
set(handles.Electrode_List,'String',electrode_list)
gui_parameter_change('.extract_trials','electrode_list',get(handles.Electrode_List,'String'));


% --- Executes on button press in Add_Electrode.
function Add_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Updates Electrode_List, if New_Electrode box isn't empty
if isempty(get(handles.New_Electrode,'String')) ~= 1
    electrode_list = get(handles.Electrode_List,'String');
    if iscell(electrode_list) ~= 1 & isempty(electrode_list) ~= 1; electrode_list = cellstr(electrode_list); end
    length_el = length(electrode_list);
    electrode_list{length_el+1} = get(handles.New_Electrode,'String');
    set(handles.Electrode_List,'String',electrode_list)
    set(handles.New_Electrode,'String','')
    gui_parameter_change('.extract_trials','electrode_list',get(handles.Electrode_List,'String'));
    assignin('base','electrode_list',get(handles.Electrode_List,'String'))
end
			

% --- Executes on button press in Do_Extraction.
function Do_Extraction_Callback(hObject, eventdata, handles)
% hObject    handle to Do_Extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets values for the extraction function
gui_parameters = evalin('base','gui_parameters');
file_in_dir = [get(handles.Load_Dir,'String') filesep];

if isempty(get(handles.Load_File,'String'))
    file_list = struct2cell(dir([file_in_dir '*.mat']));
    file_name = file_list(1,:)';
    for i = 1:length(file_name)
        current_file = char(file_name(i));
        dotpos = find(current_file == '.');
        file_name(i) = cellstr(current_file(1:dotpos(length(dotpos))-1));
    end
else
    file_name = get(handles.Load_File,'String');
end

file_extension = get(handles.Load_Extension,'String');
out_file = [get(handles.Save_Dir,'String') filesep get(handles.Save_File,'String')];
resample_rate = str2num(get(handles.Resampling_Rate,'String'));
signal_domain = gui_parameters.extract_trials.signal_domain;
baseline_start = str2num(get(handles.Baseline_Start,'String'));
baseline_end = str2num(get(handles.Baseline_End,'String'));
epoch_start = str2num(get(handles.Epoch_Start,'String'));
epoch_end = str2num(get(handles.Epoch_End,'String'));
preprocessing1 = get(handles.Preprocessing_Script1,'String');
preprocessing2 = get(handles.Preprocessing_Script2,'String'); % Perhaps create a vector of preprocessing scripts instead?
XX = []; % not yet defined
AT = evalin('base','AT');
triggers = strvcat(get(handles.Trigger_List,'String')); % creates shorthand variable for this handle
if strcmp(triggers,'ALL') | strcmp(triggers,'all')
    ttypes2extract = 'ALL';
else
    for i = 1:length(triggers(:,1))
        ttypes2extract(i).text = [triggers(i,:)]; % Is .text needed?
    end
end

% Perhaps elecs2extract should have 2 fields:
% 1 for the elecs, and one for 'keep' or 'skip'
elec_var = get(handles.Electrodes_Select,'String');
elec_var = char(elec_var(get(handles.Electrodes_Select,'Value')));

elec_array = strvcat(get(handles.Electrode_List,'String'));
if strcmp(elec_array,'ALL') | strcmp(elec_array,'all')
    elecs2extract = 'ALL';
else
    for i = 1:length(get(handles.Electrode_List,'String'))
        eval(['elecs2extract.' elec_var 'ELECs(' num2str(i) ',:) = ''' elec_array(i,:) ''';'])
    end
end

verbosity = str2num(get(handles.Verbosity,'String'));

% DO NOT ALTER BELOW THIS LINE
% Performs the extraction
if gui_parameters.extract_trials.update_existing_file == 1
    extract_trials_update(file_in_dir,file_name,file_extension,out_file,resample_rate,signal_domain, ...
      baseline_start,baseline_end,epoch_start,epoch_end,preprocessing1,preprocessing2,XX,AT, ...
      ttypes2extract,elecs2extract,verbosity);  
else
    extract_trials(file_in_dir,file_name,file_extension,out_file,resample_rate,signal_domain, ...
      baseline_start,baseline_end,epoch_start,epoch_end,preprocessing1,preprocessing2,XX,AT, ...
      ttypes2extract,elecs2extract,verbosity);
end

% Writes a lovely script in default_script_dir, if desired
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
        fprintf(fid,'%% Script generated on %s\n',datestr(date));
        fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
        fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
        fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
        fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');
        fprintf(fid,'%% Sets values for the extraction function\n');
        fprintf(fid,'file_in_dir = ''%s%s'';\n',get(handles.Load_Dir,'String'),filesep);
        if isempty(get(handles.Load_File,'String'))
            fprintf(fid,'file_list = struct2cell(dir([''%s%s*.mat'']));\n',get(handles.Load_Dir,'String'),filesep);
            fprintf(fid,'file_name = file_list(1,:)'';\n');
            fprintf(fid,'for i = 1:length(file_name)\n');
                fprintf(fid,'current_file = char(file_name(i));\n');
                fprintf(fid,'dotpos = find(current_file == ''.'');\n');
                fprintf(fid,'file_name(i) = cellstr(current_file(1:dotpos(length(dotpos))-1));\n');
            fprintf(fid,'end\n\n');
        else
            fprintf(fid,'file_name = ''%s'';\n',get(handles.Load_File,'String'));
        end
        fprintf(fid,'file_extension = ''%s'';\n',get(handles.Load_Extension,'String'));
        fprintf(fid,'out_file = ''%s%s%s.mat'';\n',get(handles.Save_Dir,'String'),filesep,get(handles.Save_File,'String'));
        fprintf(fid,'resample_rate = [%s];\n',get(handles.Resampling_Rate,'String'));
        fprintf(fid,'signal_domain = ''%s'';\n',signal_domain');
        fprintf(fid,'baseline_start = [%s];\n',get(handles.Baseline_Start,'String'));
        fprintf(fid,'baseline_end = [%s];\n',get(handles.Baseline_End,'String'));
        fprintf(fid,'epoch_start = [%s];\n',get(handles.Epoch_Start,'String'));
        fprintf(fid,'epoch_end = [%s];\n',get(handles.Epoch_End,'String'));
        fprintf(fid,'preprocessing1 = ''%s'';\n',get(handles.Preprocessing_Script1,'String'));
        fprintf(fid,'preprocessing2 = ''%s'';\n',get(handles.Preprocessing_Script2,'String'));
        fprintf(fid,'XX = []; %% not yet defined\n');
        fprintf(fid,'clear AT\n');
        if ~isstruct(evalin('base','AT')) && (strcmp(evalin('base','AT'),'NONE') | strcmp(evalin('base','AT'),'none'))
            fprintf(fid,'AT = ''%s'';\n',evalin('base','AT'));
        else
            AT = evalin('base','AT');
            for i = length(AT)
                fprintf(fid,'\nAT(%s).label = ''%s'';\n',num2str(i),AT(i).label);
                fprintf(fid,'AT(%s).minmaxCRIT = [%s];\n',num2str(i),num2str(AT(i).minmaxCRIT));
                fprintf(fid,'AT(%s).rfsms = [%s];\n',num2str(i),num2str(AT(i).rfsms));
                fprintf(fid,'AT(%s).rfems = [%s];\n',num2str(i),num2str(AT(i).rfems));
                fprintf(fid,'AT(%s).atsms = [%s];\n',num2str(i),num2str(AT(i).atsms));
                fprintf(fid,'AT(%s).atems = [%s];\n',num2str(i),num2str(AT(i).atems));
            
                skipelecs_string = '';
                for j = 1:length(AT(i).skipELECs)
                    skipelecs_string = [skipelecs_string '''' char(AT(i).skipELECs(j)) ''';'];
                end
                fprintf(fid,'AT(%s).skipELECs = {%s};\n',num2str(i),skipelecs_string(1:length(skipelecs_string)-1));

                critelecs_string = '';
                for j = 1:length(AT(i).critELECs)
                    critelecs_string = [critelecs_string '''' char(AT(i).critELECs(j)) ''';'];
                end
                fprintf(fid,'AT(%s).critELECs = {%s};\n\n',num2str(i),critelecs_string(1:length(critelecs_string)-1));
            end
        end
        if strcmp(triggers,'ALL') | strcmp(triggers,'all')
            fprintf(fid,'ttypes2extract = ''%s'';\n',get(handles.Trigger_List,'String'));
        else
            for i = 1:length(triggers(:,1))
                fprintf(fid,'ttypes2extract(%s).text = ''%s'';\n',num2str(i),strrep(char(triggers(i,:)),'''',''''''));
            end
        end
        if strcmp(elec_array,'ALL') | strcmp(elec_array,'all')
            fprintf(fid,'elecs2extract = ''%s'';\n',elec_array);
        else
            for i = 1:length(get(handles.Electrode_List,'String'))
                fprintf(fid,'elecs2extract.%sELECs(%s,:) = ''%s'';\n',elec_var,num2str(i),elec_array(i,:));
            end
        end
        fprintf(fid,'verbosity = %s;\n\n',get(handles.Verbosity,'String'));
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'%% Performs the extraction\n');
        if gui_parameters.extract_trials.update_existing_file == 1
            fprintf(fid,'extract_trials_update(file_in_dir,file_name,file_extension,out_file,resample_rate,signal_domain, ...\n');
            fprintf(fid,'    baseline_start,baseline_end,epoch_start,epoch_end,preprocessing1,preprocessing2,XX,AT, ...\n');
            fprintf(fid,'    ttypes2extract,elecs2extract,verbosity);\n');
        else
            fprintf(fid,'extract_trials(file_in_dir,file_name,file_extension,out_file,resample_rate,signal_domain, ...\n');
            fprintf(fid,'    baseline_start,baseline_end,epoch_start,epoch_end,preprocessing1,preprocessing2,XX,AT, ...\n');
            fprintf(fid,'    ttypes2extract,elecs2extract,verbosity);\n');
        end
        fclose(fid);
    end
end

% Closes the dialog box
close(pop_Extract_Trials)

% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Generate_Script

gui_parameter_change('.extract_trials','generate_script',get(hObject,'Value'));


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

gui_parameter_change('.extract_trials','script_file',get(hObject,'String'));


% --- Executes on button press in Browse_Script_Name.
function Browse_Script_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.extract_trials.data_format;
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
    gui_parameter_change('.extract_trials','script_file',get(handles.Script_Name,'String'));
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

gui_parameter_change('.extract_trials','verbosity',get(hObject,'String'));


% --- Executes on button press in Clear_All_Triggers.
function Clear_All_Triggers_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Triggers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trigger_list = get(handles.Trigger_List,'String');
trigger_list(:) = [];
set(handles.Trigger_List,'String',trigger_list);
gui_parameter_change('.extract_trials','trigger_list',get(handles.Trigger_List,'String'));


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trials_pos = get(handles.Trigger_List,'Value');
trials_list = get(handles.Trigger_List,'String');

if trials_pos > 1
    trials_old = trials_list{trials_pos}; trials_new = trials_list{trials_pos-1};
    trials_list{trials_pos-1} = trials_old; trials_list{trials_pos} = trials_new;
    set(handles.Trigger_List,'String',trials_list)
    set(handles.Trigger_List,'Value',trials_pos-1)
    gui_parameter_change('.extract_trials','trigger_list',get(handles.Trigger_List,'String'));
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trials_pos = get(handles.Trigger_List,'Value');
trials_list = get(handles.Trigger_List,'String');

if trials_pos < length(trials_list)
    trials_old = trials_list{trials_pos}; trials_new = trials_list{trials_pos+1};
    trials_list{trials_pos+1} = trials_old; trials_list{trials_pos} = trials_new;
    set(handles.Trigger_List,'String',trials_list)
    set(handles.Trigger_List,'Value',trials_pos+1)
    gui_parameter_change('.extract_trials','trigger_list',get(handles.Trigger_List,'String'));
end


% --- Executes on button press in Update_Existing_File.
function Update_Existing_File_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Existing_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Update_Existing_File

gui_parameter_change('.extract_trials','update_existing_file',get(hObject,'Value'));

