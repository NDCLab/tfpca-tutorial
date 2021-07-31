function varargout = pop_Tag_Artifacts(varargin)
% pop_Tag_Artifacts M-file for pop_Tag_Artifacts.fig
%      pop_Tag_Artifacts, by itself, creates a new pop_Tag_Artifacts or raises the existing
%      singleton*.
%
%      H = pop_Tag_Artifacts returns the handle to a new pop_Tag_Artifacts or the handle to
%      the existing singleton*.
%
%      pop_Tag_Artifacts('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Tag_Artifacts.M with the given input arguments.
%
%      pop_Tag_Artifacts('Property','Value',...) creates a new pop_Tag_Artifacts or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Tag_Artifacts_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Tag_Artifacts_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Tag_Artifacts

% Last Modified by GUIDE v2.5 02-Dec-2004 22:34:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Tag_Artifacts_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Tag_Artifacts_OutputFcn, ...
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


% --- Executes just before pop_Tag_Artifacts is made visible.
function pop_Tag_Artifacts_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Tag_Artifacts (see VARARGIN)

% Choose default command line output for pop_Tag_Artifacts
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_Tag_Artifacts wait for user response (see UIRESUME)
% uiwait(handles.pop_Tag_Artifacts);

% Sets initial state of critical channel objects
at_crit_channel_state(hObject,eventdata,handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.tag_artifacts','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.tag_artifacts','run_script',0);
gui_parameters = gui_parameter_default(gui_parameters,'.tag_artifacts','script_file','tag_artifacts_script');
gui_parameters = gui_parameter_default(gui_parameters,'.tag_artifacts','definitions',struct);

set(handles.Script_Dir,'String',gui_parameters.default_script_dir)
set(handles.Script_File,'String',gui_parameters.tag_artifacts.script_file)
set(handles.Run_Script,'Value',gui_parameters.tag_artifacts.run_script)
set(handles.AT_List,'String',fieldnames(gui_parameters.tag_artifacts.definitions))
AT_List_Callback(handles.AT_List,eventdata,handles)

assignin('base','gui_parameters',gui_parameters)



% --- Outputs from this function are returned to the command line.
function varargout = pop_Tag_Artifacts_OutputFcn(hObject, eventdata, handles)
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


% Highlights the same entry in all listboxes
function highlighter(hObject,eventdata,handles)
set(handles.AT_Minmax,'Value',get(hObject,'Value'))
set(handles.AT_Reference,'Value',get(hObject,'Value'))
set(handles.AT_Artifact,'Value',get(hObject,'Value'))
set(handles.AT_Skip_Electrodes,'Value',get(hObject,'Value'))
set(handles.AT_Label,'Value',get(hObject,'Value'))
set(handles.AT_Crit_Channels,'Value',get(hObject,'Value'))

% Enables or disables critical channel boxes, based on Select_AT_Label value
function at_crit_channel_state(hObject,eventdata,handles)
at_label = get(handles.Select_AT_Label,'String');
at_label = char(at_label(get(handles.Select_AT_Label,'Value')));
switch at_label
    case 'individual'
        state = 'off';
    case 'CRITchannel'
        state = 'on';
end
set_enable(handles,state,'AT_Crit_Channels_Label','AT_Crit_Channels','New_Channel','New_Channel_Label', ...
    'Add_Channel','Remove_Channel');


% Resets all dialog boxes
function reset_all(hObject,eventdata,handles)
set(handles.AT_Minmax,'Value',1)
set(handles.AT_Reference,'Value',1)
set(handles.AT_Artifact,'Value',1)
set(handles.AT_Skip_Electrodes,'Value',1)
set(handles.AT_Label,'Value',1)
set(handles.AT_Crit_Channels,'Value',1)
set(handles.AT_Minmax,'String',cellstr(' '))
set(handles.AT_Reference,'String',cellstr(' '))
set(handles.AT_Artifact,'String',cellstr(' '))
set(handles.AT_Skip_Electrodes,'String',cellstr('{}'))
set(handles.AT_Label,'String',cellstr(' '))
set(handles.AT_Crit_Channels,'String',cellstr('{}'))


% Updates a given AT definition
function update_AT(hObject,eventdata,handles,at_def)
if ischar(at_def) ~= 1; at_def = char(at_def); end
gui_parameter_change('.tag_artifacts',['definitions.' at_def '.label'],get(handles.AT_Label,'String'));
gui_parameter_change('.tag_artifacts',['definitions.' at_def '.minmaxCRIT'],get(handles.AT_Minmax,'String'));
gui_parameter_change('.tag_artifacts',['definitions.' at_def '.rfms'],get(handles.AT_Reference,'String'));
gui_parameter_change('.tag_artifacts',['definitions.' at_def '.atms'],get(handles.AT_Artifact,'String'));
gui_parameter_change('.tag_artifacts',['definitions.' at_def '.skipELECs'],get(handles.AT_Skip_Electrodes,'String'));
gui_parameter_change('.tag_artifacts',['definitions.' at_def '.critELECs'],get(handles.AT_Crit_Channels,'String'));
new_length = length(get(handles.AT_Skip_Electrodes,'String'));
set(handles.AT_Skip_Electrodes,'Value',new_length)
highlighter(handles.AT_Skip_Electrodes,eventdata,handles)

% Sets enable property of various handles
function set_enable(handles,state,varargin)
for i = 1:length(varargin)
    eval(['set(handles.' varargin{i} ',''Enable'',''' state ''')'])
end

% Sets the AT variable for other functions to use
function set_AT(handles,at_list,at_pos)
gui_parameters = evalin('base','gui_parameters');
for i = 1:length(at_list) % Iterates through each entry in at_list
    at_def = char(at_list(i));
    eval([at_def ' = [];'])
    
    for j = 1:length(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.skipELECs']))-1 % Iterates through each AT pass in this AT_List entry
        eval([at_def '(' num2str(j) ').label = char(gui_parameters.tag_artifacts.definitions.' at_def '.label(' num2str(j) ')'');'])
        eval([at_def '(' num2str(j) ').minmaxCRIT = eval(char(gui_parameters.tag_artifacts.definitions.' at_def '.minmaxCRIT(' num2str(j) ')''));'])
        rfms = char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.rfms(' num2str(j) ')']));
        commas = find(rfms == ',');
        eval([at_def '(' num2str(j) ').rfsms = str2num(rfms(1:commas-1));'])
        eval([at_def '(' num2str(j) ').rfems = str2num(rfms(commas+1:length(rfms)));']);
        atms = char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.atms(' num2str(j) ')']));
        commas = find(atms == ',');
        eval([at_def '(' num2str(j) ').atsms = str2num(atms(1:commas-1));'])
        eval([at_def '(' num2str(j) ').atems = str2num(atms(commas+1:length(atms)));']);
        eval([at_def '(' num2str(j) ').skipELECs = eval(char(gui_parameters.tag_artifacts.definitions.' at_def '.skipELECs(' num2str(j) ')''));'])
        eval([at_def '(' num2str(j) ').critELECs = eval(char(gui_parameters.tag_artifacts.definitions.' at_def '.critELECs(' num2str(j) ')''));'])
    end
end
% Assigns AT definition to be used in other scripts
assignin('base','AT',eval(char(at_list(at_pos))))


% --- Executes during object creation, after setting all properties.
function AT_Minmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Minmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_Minmax.
function AT_Minmax_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Minmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_Minmax contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_Minmax

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function AT_Reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_Reference.
function AT_Reference_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_Reference contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_Reference

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function AT_Artifact_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Artifact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_Artifact.
function AT_Artifact_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Artifact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_Artifact contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_Artifact

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function AT_Crit_Channels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Crit_Channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_Crit_Channels.
function AT_Crit_Channels_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Crit_Channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_Crit_Channels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_Crit_Channels

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function AT_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_Label.
function AT_Label_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_Label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_Label

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function AT_Skip_Electrodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Skip_Electrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_Skip_Electrodes.
function AT_Skip_Electrodes_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Skip_Electrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_Skip_Electrodes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_Skip_Electrodes

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Select_AT_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_AT_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_AT_Label.
function Select_AT_Label_Callback(hObject, eventdata, handles)
% hObject    handle to Select_AT_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_AT_Label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_AT_Label

at_crit_channel_state(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function AT_Min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function AT_Min_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_Min as text
%        str2double(get(hObject,'String')) returns contents of AT_Min as a double


% --- Executes during object creation, after setting all properties.
function AT_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function AT_Max_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_Max as text
%        str2double(get(hObject,'String')) returns contents of AT_Max as a double


% --- Executes during object creation, after setting all properties.
function Reference_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reference_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Reference_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Reference_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reference_Start as text
%        str2double(get(hObject,'String')) returns contents of Reference_Start as a double


% --- Executes during object creation, after setting all properties.
function Reference_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reference_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Reference_End_Callback(hObject, eventdata, handles)
% hObject    handle to Reference_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reference_End as text
%        str2double(get(hObject,'String')) returns contents of Reference_End as a double


% --- Executes during object creation, after setting all properties.
function AT_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function AT_Start_Callback(hObject, eventdata, handles)
% hObject    handle to AT_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_Start as text
%        str2double(get(hObject,'String')) returns contents of AT_Start as a double


% --- Executes during object creation, after setting all properties.
function AT_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function AT_End_Callback(hObject, eventdata, handles)
% hObject    handle to AT_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_End as text
%        str2double(get(hObject,'String')) returns contents of AT_End as a double


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


% --- Executes during object creation, after setting all properties.
function New_Channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Channel_Callback(hObject, eventdata, handles)
% hObject    handle to New_Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Channel as text
%        str2double(get(hObject,'String')) returns contents of New_Channel as a double


% --- Executes on button press in Clear_All_Pass.
function Clear_All_Pass_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_all(hObject,eventdata,handles);

% --- Executes on button press in Add_Pass.
function Add_Pass_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.AT_Min,'String')) ~= 1 & isempty(get(handles.AT_Max,'String')) ~= 1 & ...
   isempty(get(handles.Reference_Start,'String')) ~= 1 & isempty(get(handles.Reference_End,'String')) ~= 1 & ...
   isempty(get(handles.AT_Start,'String')) ~= 1 & isempty(get(handles.AT_End,'String')) ~= 1
    
    at_minmax = get(handles.AT_Minmax,'String');
    if ischar(at_minmax); at_minmax = cellstr(at_minmax); end
    length_am = length(at_minmax);
    at_minmax{length_am} = ['[' get(handles.AT_Min,'String') ' ' ...
            get(handles.AT_Max,'String') ']'];
    at_minmax{length_am+1} = ' ';
    set(handles.AT_Minmax,'String',at_minmax)
    set(handles.AT_Min,'String','')
    set(handles.AT_Max,'String','')
    
    at_reference = get(handles.AT_Reference,'String');
    if ischar(at_reference); at_reference = cellstr(at_reference); end
    length_ar = length(at_reference);
    at_reference{length_ar} = [get(handles.Reference_Start,'String'), ',' ...
            get(handles.Reference_End,'String')];
    at_reference{length_ar+1} = ' ';
    set(handles.AT_Reference,'String',at_reference)
    set(handles.Reference_Start,'String','')
    set(handles.Reference_End,'String','')
    
    at_artifact = get(handles.AT_Artifact,'String');
    if ischar(at_artifact); at_artifact = cellstr(at_artifact); end
    length_aa = length(at_artifact);
    at_artifact{length_aa} = [get(handles.AT_Start,'String'), ',' ...
            get(handles.AT_End,'String')];
    at_artifact{length_aa+1} = ' ';
    set(handles.AT_Artifact,'String',at_artifact)
    set(handles.AT_Start,'String','')
    set(handles.AT_End,'String','')
    
    at_label = get(handles.AT_Label,'String');
    if ischar(at_label); at_label = cellstr(at_label); end
    length_al = length(at_label);
    select_at_label = get(handles.Select_AT_Label,'String');
    select_at_label = select_at_label(get(handles.Select_AT_Label,'Value'));
    at_label{length_al} = char(select_at_label);
    at_label{length_al+1} = ' ';
    set(handles.AT_Label,'String',at_label)
    set(handles.Select_AT_Label,'Value',1)
    
    at_skip_electrodes = get(handles.AT_Skip_Electrodes,'String');
    if ischar(at_skip_electrodes); at_skip_electrodes = cellstr(at_skip_electrodes); end
    length_as = length(at_skip_electrodes);
    at_skip_electrodes{length_as+1} = '{}';
    set(handles.AT_Skip_Electrodes,'String',at_skip_electrodes)
    set(handles.New_Electrode,'String','')
    
    at_crit_channels = get(handles.AT_Crit_Channels,'String');
    if ischar(at_crit_channels); at_crit_channels = cellstr(at_crit_channels); end
    length_ac = length(at_crit_channels);
    at_crit_channels{length_ac+1} = '{}';
	set(handles.AT_Crit_Channels,'String',at_crit_channels)
    set(handles.New_Channel,'String','')

    set(handles.AT_Skip_Electrodes,'Value',length_as+1)
    highlighter(handles.AT_Skip_Electrodes,eventdata,handles)
    at_crit_channel_state(hObject,eventdata,handles);

    % Updates AT definition
    at_list = get(handles.AT_List,'String');
    if isempty(at_list) ~= 1
        at_def = char(at_list(get(handles.AT_List,'Value')));
        update_AT(hObject,eventdata,handles,at_def);
    end
end

% --- Executes on button press in Remove_Pass.
function Remove_Pass_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

at_label = get(handles.AT_Label,'String');
at_label = at_label(get(handles.AT_Label,'Value'));
if strcmp(at_label,' ') ~= 1

% Gets position of highlighted pass, then deletes it
amlist_pos = get(handles.AT_Minmax,'Value');
at_minmax = get(handles.AT_Minmax,'String');
if iscell(at_minmax) ~= 1; at_minmax = cellstr(at_minmax); end
if isempty(at_minmax) ~= 1; at_minmax(amlist_pos) = []; end
if amlist_pos > 1; set(handles.AT_Minmax,'Value',amlist_pos-1); end
set(handles.AT_Minmax,'String',at_minmax)

arlist_pos = get(handles.AT_Reference,'Value');
at_reference = get(handles.AT_Reference,'String');
if iscell(at_reference) ~= 1; at_reference = cellstr(at_reference); end
if isempty(at_reference) ~= 1; at_reference(arlist_pos) = []; end
if arlist_pos > 1; set(handles.AT_Reference,'Value',arlist_pos-1); end
set(handles.AT_Reference,'String',at_reference)

aalist_pos = get(handles.AT_Artifact,'Value');
at_artifact = get(handles.AT_Artifact,'String');
if iscell(at_artifact) ~= 1; at_artifact = cellstr(at_artifact); end
if isempty(at_artifact) ~= 1; at_artifact(aalist_pos) = []; end
if aalist_pos > 1; set(handles.AT_Artifact,'Value',aalist_pos-1); end
set(handles.AT_Artifact,'String',at_artifact)

allist_pos = get(handles.AT_Label,'Value');
at_label = get(handles.AT_Label,'String');
if iscell(at_label) ~= 1; at_label = cellstr(at_label); end
if isempty(at_label) ~= 1; at_label(allist_pos) = []; end
if allist_pos > 1; set(handles.AT_Label,'Value',allist_pos-1); end
set(handles.AT_Label,'String',at_label)

aslist_pos = get(handles.AT_Skip_Electrodes,'Value');
at_skip_electrodes = get(handles.AT_Skip_Electrodes,'String');
if iscell(at_skip_electrodes) ~= 1; at_skip_electrodes = cellstr(at_skip_electrodes); end
if isempty(at_skip_electrodes) ~= 1; at_skip_electrodes(aslist_pos) = []; end
if aslist_pos > 1; set(handles.AT_Skip_Electrodes,'Value',aslist_pos-1); end
set(handles.AT_Skip_Electrodes,'String',at_skip_electrodes)

aclist_pos = get(handles.AT_Crit_Channels,'Value');
at_crit_channels = get(handles.AT_Crit_Channels,'String');
if iscell(at_crit_channels) ~= 1; at_crit_channels = cellstr(at_crit_channels); end
if isempty(at_crit_channels) ~= 1; at_crit_channels(aclist_pos) = []; end
if aclist_pos > 1; set(handles.AT_Crit_Channels,'Value',aclist_pos-1); end
set(handles.AT_Crit_Channels,'String',at_crit_channels)

% Updates AT definition
at_list = get(handles.AT_List,'String');
if isempty(at_list) ~= 1
    at_def = char(at_list(get(handles.AT_List,'Value')));
    update_AT(hObject,eventdata,handles,at_def);
end

at_crit_channel_state(hObject,eventdata,handles);

end

% --- Executes during object creation, after setting all properties.
function AT_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in AT_List.
function AT_List_Callback(hObject, eventdata, handles)
% hObject    handle to AT_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AT_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AT_List

gui_parameters = evalin('base','gui_parameters');
at_list = get(handles.AT_List,'String');
if ~isempty(at_list)
    at_pos = get(handles.AT_List,'Value');
    at_def = char(at_list(at_pos));
    set(handles.AT_Minmax,'String',eval(['gui_parameters.tag_artifacts.definitions.' at_def '.minmaxCRIT']))
    set(handles.AT_Reference,'String',eval(['gui_parameters.tag_artifacts.definitions.' at_def '.rfms']))
    set(handles.AT_Artifact,'String',eval(['gui_parameters.tag_artifacts.definitions.' at_def '.atms']))
    set(handles.AT_Skip_Electrodes,'String',eval(['gui_parameters.tag_artifacts.definitions.' at_def '.skipELECs']))
    set(handles.AT_Label,'String',eval(['gui_parameters.tag_artifacts.definitions.' at_def '.label']))
    set(handles.AT_Crit_Channels,'String',eval(['gui_parameters.tag_artifacts.definitions.' at_def '.critELECs']))
    set(handles.AT_Skip_Electrodes,'Value',length(get(handles.AT_Skip_Electrodes,'String')))
    highlighter(handles.AT_Skip_Electrodes,eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function New_AT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_AT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_AT_Callback(hObject, eventdata, handles)
% hObject    handle to New_AT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_AT as text
%        str2double(get(hObject,'String')) returns contents of New_AT as a double


% --- Executes on button press in Run_Script.
function Run_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameter_change('.tag_artifacts','run_script',get(hObject,'Value'));
if get(hObject,'Value')
    state = 'off';
else
    state = 'on';
end
set_enable(handles,state,'AT_List_Label','AT_List','New_AT','New_AT_Label', ...
        'Add_AT','Update_AT','Remove_AT','Plot_Data')


% --- Executes on button press in Remove_AT.
function Remove_AT_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_AT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.AT_List,'String'))
    gui_parameters = evalin('base','gui_parameters');
    at_list = get(handles.AT_List,'String');
    at_pos = get(handles.AT_List,'Value');
    at_def = char(at_list(at_pos));
    if iscell(at_list) ~= 1; at_list = cellstr(at_list); end
    if isempty(at_list) ~= 1; at_list(at_pos) = []; end
    if at_pos > 1; set(handles.AT_List,'Value',at_pos-1); end
    set(handles.AT_List,'String',at_list)
    gui_parameters.tag_artifacts.definitions = rmfield(gui_parameters.tag_artifacts.definitions,at_def);
    assignin('base','gui_parameters',gui_parameters)
    reset_all(hObject,eventdata,handles);
    AT_List_Callback(handles.AT_List,eventdata,handles);
end


% --- Executes on button press in Add_AT.
function Add_AT_Callback(hObject, eventdata, handles)
% hObject    handle to Add_AT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Assigns existing variables to current AT_temp, then resets listboxes for new AT
% definition
if isempty(get(handles.New_AT,'String')) ~= 1

    % Adds new AT entry
    gui_parameters = evalin('base','gui_parameters');
    gui_parameters = gui_parameter_default(gui_parameters,'.tag_artifacts.definitions',get(handles.New_AT,'String'),[]);
    gui_parameters = gui_parameter_default(gui_parameters,['.tag_artifacts.definitions.' get(handles.New_AT,'String')],'label',' ');
    gui_parameters = gui_parameter_default(gui_parameters,['.tag_artifacts.definitions.' get(handles.New_AT,'String')],'minmaxCRIT',' ');
    gui_parameters = gui_parameter_default(gui_parameters,['.tag_artifacts.definitions.',get(handles.New_AT,'String')],'rfms',' ');
    gui_parameters = gui_parameter_default(gui_parameters,['.tag_artifacts.definitions.',get(handles.New_AT,'String')],'atms',' ');
    gui_parameters = gui_parameter_default(gui_parameters,['.tag_artifacts.definitions.' get(handles.New_AT,'String')],'skipELECs','{}');
    gui_parameters = gui_parameter_default(gui_parameters,['.tag_artifacts.definitions.' get(handles.New_AT,'String')],'critELECs','{}');
    assignin('base','gui_parameters',gui_parameters)

    % Updates old stim entry, if it exists
    at_list = get(handles.AT_List,'String');
    at_pos = get(handles.AT_List,'Value');
    if ~isempty(at_list)
        at_def = at_list(at_pos);
        update_AT(hObject,eventdata,handles,at_def);
        reset_all(hObject,eventdata,handles);
    else
        at_pos = 0;
    end
    
    % Updates AT_List
    if ~isempty(at_list)
        at_list{length(cellstr(at_list))+1} = get(handles.New_AT,'String');
    else
        at_list{1} = get(handles.New_AT,'String');
    end
    set(handles.AT_List,'String',at_list)
    set(handles.AT_List,'Value',at_pos+1)
    set(handles.New_AT,'String','')
   
    % Updates new AT entry 
    if at_pos > 0
       at_def = char(at_list(at_pos+1));
       update_AT(hObject,eventdata,handles,at_def);
       AT_List_Callback(handles.AT_List,eventdata,handles);
   end
end


% --- Executes on button press in Update_AT.
function Update_AT_Callback(hObject, eventdata, handles)
% hObject    handle to Update_AT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

at_list = get(handles.AT_List,'String');
at_def = at_list(get(handles.AT_List,'Value'));
update_AT(hObject,eventdata,handles,at_def);
new_length = length(get(handles.AT_Skip_Electrodes,'String'));
set(handles.AT_Skip_Electrodes,'Value',new_length)
highlighter(handles.AT_Skip_Electrodes,eventdata,handles);

% --- Executes on button press in Remove_Electrode.
function Remove_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skip_electrodes = get(handles.AT_Skip_Electrodes,'String');
se_pos = get(handles.AT_Skip_Electrodes,'Value');
if ischar(skip_electrodes)
    semicolons = find(skip_electrodes == ';');
    if isempty(semicolons)
        current_electrode = [skip_electrodes(1) skip_electrodes(length(skip_electrodes))];
    else
        current_electrode = [skip_electrodes(1:semicolons(length(semicolons))-1) '}'];
    end
    skip_electrodes = current_electrode;
else
    current_electrode = char(skip_electrodes(se_pos));
    semicolons = find(current_electrode == ';');
    if isempty(semicolons)
        current_electrode = [current_electrode(1) current_electrode(length(current_electrode))];
    else
        current_electrode = [current_electrode(1:semicolons(length(semicolons))-1) '}'];
    end
    skip_electrodes(se_pos) = cellstr(current_electrode);
end
set(handles.AT_Skip_Electrodes,'String',skip_electrodes)

% --- Executes on button press in Add_Electrode.
function Add_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.New_Electrode,'String')) ~= 1
    skip_electrodes = get(handles.AT_Skip_Electrodes,'String');
    se_pos = get(handles.AT_Skip_Electrodes,'Value');
    if ischar(skip_electrodes)
        current_electrode = skip_electrodes(1:length(skip_electrodes)-1);
        if length(current_electrode) == 1
            current_electrode = [current_electrode '''' get(handles.New_Electrode,'String') '''}'];
        else
            current_electrode = [current_electrode ';''' get(handles.New_Electrode,'String') '''}'];
        end
        skip_electrodes = current_electrode;
    else
        current_electrode = char(skip_electrodes(se_pos));
        current_electrode = current_electrode(1:length(current_electrode)-1);
        if length(current_electrode) == 1
            current_electrode = [current_electrode '''' get(handles.New_Electrode,'String') '''}'];
        else
            current_electrode = [current_electrode ';''' get(handles.New_Electrode,'String') '''}'];
        end
        skip_electrodes(se_pos) = cellstr(current_electrode);
    end
    set(handles.AT_Skip_Electrodes,'String',skip_electrodes)
    set(handles.New_Electrode,'String','')
end

% --- Executes on button press in Remove_Channel.
function Remove_Channel_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

crit_channels = get(handles.AT_Crit_Channels,'String');
cc_pos = get(handles.AT_Crit_Channels,'Value');
if ischar(crit_channels)
    semicolons = find(crit_channels == ';');
    if isempty(semicolons)
        current_channel = [crit_channels(1) crit_channels(length(crit_channels))];
    else
        current_channel = [crit_channels(1:semicolons(length(semicolons))-1) '}'];
    end
    crit_channels = current_channel;
else
    current_channel = char(crit_channels(cc_pos));
    semicolons = find(current_channel == ';');
    if isempty(semicolons)
        current_channel = [current_channel(1) current_channel(length(current_channel))];
    else
        current_channel = [current_channel(1:semicolons(length(semicolons))-1) '}'];
    end
    crit_channels(cc_pos) = cellstr(current_channel);
end
set(handles.AT_Crit_Channels,'String',crit_channels)

% --- Executes on button press in Add_Channel.
function Add_Channel_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.New_Channel,'String')) ~= 1
    crit_channels = get(handles.AT_Crit_Channels,'String');
    cc_pos = get(handles.AT_Crit_Channels,'Value');
    if ischar(crit_channels)
        current_channel = crit_channels(1:length(crit_channels)-1);
        if length(current_channel) == 1
            current_channel = [current_channel '''' get(handles.New_Channel,'String') '''}'];
        else
            current_channel = [current_channel ';''' get(handles.New_Channel,'String') '''}'];
        end
        crit_channels = current_channel;
    else
        current_channel = char(crit_channels(cc_pos));
        current_channel = current_channel(1:length(current_channel)-1);
        if length(current_channel) == 1
            current_channel = [current_channel '''' get(handles.New_Channel,'String') '''}'];
        else
            current_channel = [current_channel ';''' get(handles.New_Channel,'String') '''}'];
        end
        crit_channels(cc_pos) = cellstr(current_channel);
    end
    set(handles.AT_Crit_Channels,'String',crit_channels)
    set(handles.New_Channel,'String','')
end 

% --- Executes on button press in Browse_Script_Dir.
function Browse_Script_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls directory selector and sets text box value
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No directory selected.',gui_parameters.directory_select.selected_dir)
    set(handles.Script_Dir,'String',gui_parameters.directory_select.selected_dir)
end

% --- Executes during object creation, after setting all properties.
function Script_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Script_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Script_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Script_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Script_Dir as text
%        str2double(get(hObject,'String')) returns contents of Script_Dir as a double


% --- Executes on button press in Browse_Script_File.
function Browse_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_File (see GCBO)
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
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))+1);
    set(handles.Script_File,'String',file_name)
    gui_parameter_change('.tag_artifacts','script_file',get(handles.Script_File,'String'));
end

% --- Executes during object creation, after setting all properties.
function Script_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Script_File as text
%        str2double(get(hObject,'String')) returns contents of Script_File as a double

gui_parameter_change('.tag_artifacts','script_file',get(hObject,'String'));


% --- Executes on button press in Generate_AT.
function Generate_AT_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_AT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Runs script, then closes window
if get(handles.Run_Script,'Value') & isempty(get(handles.Script_Dir,'String')) ~= 1 & ...
        isempty(get(handles.Script_File,'String')) ~= 1
    assignin('base','temp_file_path',get(handles.Script_Dir,'String')); %assignin becase evalin can't pull GUI structure "handles" from 'base' workspace
    assignin('base','temp_file_name',get(handles.Script_File,'String'))
    evalin('base','run([temp_file_path filesep temp_file_name ''.m''])');
    evalin('base','clear temp_file_path temp_file_name'); %apparently needed to clear temp vars from 'base' workspace
elseif get(handles.Run_Script,'Value') ~= 1
    gui_parameters = evalin('base','gui_parameters');
    at_list = get(handles.AT_List,'String');
    at_pos = get(handles.AT_List,'Value');
    set_AT(handles,at_list,at_pos);

    % Writes out a lovely script to do these artifact tag definitions and
    % AT assignment
    if isempty(get(handles.Script_Dir,'String')) ~= 1 & isempty(get(handles.Script_File,'String')) ~= 1
        fid = fopen([get(handles.Script_Dir,'String') filesep get(handles.Script_File,'String') '.m'],'w+');
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
            at_list = get(handles.AT_List,'String');
            at_pos = get(handles.AT_List,'Value');
            for i = 1:length(at_list) % Iterates through each entry in AT_List
                at_def = char(at_list(i));
                fprintf(fid,'\n%% Defines the set of AT passes named "%s"\n',at_def);
                fprintf(fid,'%s = [];\n\n',at_def);
                for j = 1:length(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.skipELECs']))-1 % Iterates through each pass in this AT_List entry
                    fprintf(fid,'%s(%s).label = ''%s'';\n',at_def,num2str(j), ...
		        char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.label(' num2str(j) ')'])));
                    fprintf(fid,'%s(%s).minmaxCRIT = %s;\n',at_def,num2str(j), ...
                       char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.minmaxCRIT(' num2str(j) ')'])));
                    rfms = char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.rfms(' num2str(j) ')']));
                    commas = find(rfms == ',');
                    fprintf(fid,'%s(%s).rfsms = [%s];\n',at_def,num2str(j),rfms(1:commas-1));
                    fprintf(fid,'%s(%s).rfems = [%s];\n',at_def,num2str(j),rfms(commas+1:length(rfms)));
                    atms = char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.atms(' num2str(j) ')']));
                    commas = find(atms == ',');
                    fprintf(fid,'%s(%s).atsms = [%s];\n',at_def,num2str(j),atms(1:commas-1));
                    fprintf(fid,'%s(%s).atems = [%s];\n',at_def,num2str(j),atms(commas+1:length(atms)));
                    fprintf(fid,'%s(%s).skipELECs = %s;\n',at_def,num2str(j), ...
                        char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.skipELECs(' num2str(j) ')'])));
                    fprintf(fid,'%s(%s).critELECs = %s;\n\n',at_def,num2str(j), ...
                        char(eval(['gui_parameters.tag_artifacts.definitions.' at_def '.critELECs(' num2str(j) ')'])));
                end
            end
            fprintf(fid,'\n%% Assigns %s as the AT definition to be used in other scripts\n',at_def);
            fprintf(fid,'assignin(''base'',''AT'',%s)',char(at_list(at_pos)));
            fclose(fid);
        end
    end

end

% Closes Tag Artifacts window
close(pop_Tag_Artifacts)

% --- Executes on button press in Plot_Data.
function Plot_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.AT_List,'String')) ~= 1
    at_list = get(handles.AT_List,'String');
    at_def = at_list(get(handles.AT_List,'Value'));
    at_pos = 1;
    set_AT(handles,at_def,at_pos);
    pop_Plot_Erpdata;
end


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

at_pos = get(handles.AT_Label,'Value');
at_label = get(handles.AT_Label,'String');

if at_pos > 1 & at_pos < length(at_label) % If not at top or bottom of list
    % Gets current lists
    at_label = get(handles.AT_Label,'String');
    at_minmax = get(handles.AT_Minmax,'String');
    at_reference = get(handles.AT_Reference,'String');
    at_artifact = get(handles.AT_Artifact,'String');
    at_se = get(handles.AT_Skip_Electrodes,'String');
    at_cc = get(handles.AT_Crit_Channels,'String');
    
    % Gets relevant lines
    label_old = at_label{at_pos}; label_new = at_label{at_pos-1};
    minmax_old = at_minmax{at_pos}; minmax_new = at_minmax{at_pos-1};
    reference_old = at_reference{at_pos}; reference_new = at_reference{at_pos-1};
    artifact_old = at_artifact{at_pos}; artifact_new = at_artifact{at_pos-1};
    se_old = at_se{at_pos}; se_new = at_se{at_pos-1};
    cc_old = at_cc{at_pos}; cc_new = at_cc{at_pos-1};
    
    % Switches lines
    at_label{at_pos-1} = label_old; at_label{at_pos} = label_new;
    at_minmax{at_pos-1} = minmax_old; at_minmax{at_pos} = minmax_new;
    at_reference{at_pos-1} = reference_old; at_reference{at_pos} = reference_new;
    at_artifact{at_pos-1} = artifact_old; at_artifact{at_pos} = artifact_new;
    at_se{at_pos-1} = se_old; at_se{at_pos} = se_new;
    at_cc{at_pos-1} = cc_old; at_cc{at_pos} = cc_new;
    
    % Sets list boxes
    set(handles.AT_Label,'String',at_label)
    set(handles.AT_Minmax,'String',at_minmax)
    set(handles.AT_Reference,'String',at_reference)
    set(handles.AT_Artifact,'String',at_artifact)
    set(handles.AT_Skip_Electrodes,'String',at_se)
    set(handles.AT_Crit_Channels,'String',at_cc)

    % Updates AT definition
    at_list = get(handles.AT_List,'String');
    if isempty(at_list) ~= 1
        at_def = char(at_list(get(handles.AT_List,'Value')));
        update_AT(hObject,eventdata,handles,at_def);
    end
    
    % Updates highlighted position
    set(handles.AT_Label,'Value',at_pos-1)
    highlighter(handles.AT_Label,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

at_pos = get(handles.AT_Label,'Value');
at_label = get(handles.AT_Label,'String');

if at_pos < length(at_label) - 1 % If not at bottom of list
    % Gets current lists
    at_label = get(handles.AT_Label,'String');
    at_minmax = get(handles.AT_Minmax,'String');
    at_reference = get(handles.AT_Reference,'String');
    at_artifact = get(handles.AT_Artifact,'String');
    at_se = get(handles.AT_Skip_Electrodes,'String');
    at_cc = get(handles.AT_Crit_Channels,'String');

    % Gets relevant lines
    label_old = at_label{at_pos}; label_new = at_label{at_pos+1};
    minmax_old = at_minmax{at_pos}; minmax_new = at_minmax{at_pos+1};
    reference_old = at_reference{at_pos}; reference_new = at_reference{at_pos+1};
    artifact_old = at_artifact{at_pos}; artifact_new = at_artifact{at_pos+1};
    se_old = at_se{at_pos}; se_new = at_se{at_pos+1};
    cc_old = at_cc{at_pos}; cc_new = at_cc{at_pos+1};

    % Switches lines
    at_label{at_pos+1} = label_old; at_label{at_pos} = label_new;
    at_minmax{at_pos+1} = minmax_old; at_minmax{at_pos} = minmax_new;
    at_reference{at_pos+1} = reference_old; at_reference{at_pos} = reference_new;
    at_artifact{at_pos+1} = artifact_old; at_artifact{at_pos} = artifact_new;
    at_se{at_pos+1} = se_old; at_se{at_pos} = se_new;
    at_cc{at_pos+1} = cc_old; at_cc{at_pos} = cc_new;

    % Sets list boxes
    set(handles.AT_Label,'String',at_label)
    set(handles.AT_Minmax,'String',at_minmax)
    set(handles.AT_Reference,'String',at_reference)
    set(handles.AT_Artifact,'String',at_artifact)
    set(handles.AT_Skip_Electrodes,'String',at_se)
    set(handles.AT_Crit_Channels,'String',at_cc)

    % Updates AT definition
    at_list = get(handles.AT_List,'String');
    if isempty(at_list) ~= 1
        at_def = char(at_list(get(handles.AT_List,'Value')));
        update_AT(hObject,eventdata,handles,at_def);
    end

    % Updates highlighted position
    set(handles.AT_Label,'Value',at_pos+1)
    highlighter(handles.AT_Label,eventdata,handles);
end

