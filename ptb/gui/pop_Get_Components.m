function varargout = pop_Get_Components(varargin)
% pop_Get_Components M-file for pop_Get_Components.fig
%      pop_Get_Components, by itself, creates a new pop_Get_Components or raises the existing
%      singleton*.
%
%      H = pop_Get_Components returns the handle to a new pop_Get_Components or the handle to
%      the existing singleton*.
%
%      pop_Get_Components('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Get_Components.M with the given input arguments.
%
%      pop_Get_Components('Property','Value',...) creates a new pop_Get_Components or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Get_Components_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Get_Components_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Get_Components

% Last Modified by GUIDE v2.5 02-Dec-2004 21:52:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Get_Components_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Get_Components_OutputFcn, ...
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


% --- Executes just before pop_Get_Components is made visible.
function pop_Get_Components_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Get_Components (see VARARGIN)

% Choose default command line output for pop_Get_Components
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_Get_Components wait for user response (see UIRESUME)
% uiwait(handles.pop_Get_Components);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.get_components','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','save_dir',gui_parameters.default_save_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','create_ascii',1);
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','baseline_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','baseline_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','window_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','window_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','highpass_filter','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','lowpass_filter','');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','AT','NONE');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','review_components',1);
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','script_file','get_components_scripts');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','component_label_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','component_baseline_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','component_window_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','component_minmax_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.get_components','component_measures_list',' ');

    set(handles.Load_File,'String',gui_parameters.get_components.load_file)
    set(handles.Save_Dir,'String',gui_parameters.get_components.save_dir)
    set(handles.Save_File,'String',gui_parameters.get_components.save_file)
    set(handles.Make_Text_File,'Value',gui_parameters.get_components.create_ascii)
    set(handles.Highpass_Filter,'String',gui_parameters.get_components.highpass_filter)
    set(handles.Lowpass_Filter,'String',gui_parameters.get_components.lowpass_filter)
    set(handles.Review_Components,'Value',gui_parameters.get_components.review_components)
    set(handles.Verbosity,'String',gui_parameters.get_components.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.get_components.generate_script)
    set(handles.Script_File,'String',gui_parameters.get_components.script_file)
    set(handles.Component_Label,'String',gui_parameters.get_components.component_label_list)
    set(handles.Component_Baseline,'String',gui_parameters.get_components.component_baseline_list)
    set(handles.Component_Window,'String',gui_parameters.get_components.component_window_list)
    set(handles.Component_Minmax,'String',gui_parameters.get_components.component_minmax_list)
    set(handles.Component_Measures,'String',gui_parameters.get_components.component_measures_list)

default_AT = 'NONE';
AT = evalin('base','AT','default_AT');
assignin('base','AT',AT)

assignin('base','gui_parameters',gui_parameters)


% --- Outputs from this function are returned to the command line.
function varargout = pop_Get_Components_OutputFcn(hObject, eventdata, handles)
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
set(handles.Component_Label,'Value',get(hObject,'Value'))
set(handles.Component_Baseline,'Value',get(hObject,'Value'))
set(handles.Component_Window,'Value',get(hObject,'Value'))
set(handles.Component_Minmax,'Value',get(hObject,'Value'))
set(handles.Component_Measures,'Value',get(hObject,'Value'))


% Resets all dialog boxes
function reset_all(hObject,eventdata,handles)
set(handles.Component_Baseline,'Value',1)
set(handles.Component_Window,'Value',1)
set(handles.Component_Minmax,'Value',1)
set(handles.Component_Measures,'Value',1)
set(handles.Component_Label,'Value',1)
set(handles.Component_Baseline,'String',cellstr(' '))
set(handles.Component_Window,'String',cellstr(' '))
set(handles.Component_Minmax,'String',cellstr(' '))
set(handles.Component_Measures,'String',cellstr(' '))
set(handles.Component_Label,'String',cellstr(' '))


% Sets enable property of various handles
function set_enable(handles,state,varargin)
for i = 1:length(varargin)
    eval(['set(handles.' varargin{i} ',''Enable'',''' state ''')'])
end


% --- Executes during object creation, after setting all properties.
function Component_Baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Component_Minmax_Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Component_Minmax_Baseline.
function Component_Baseline_Callback(hObject, eventdata, handles)
% hObject    handle to Component_Minmax_Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Component_Minmax_Baseline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Component_Minmax_Baseline

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Component_Window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Component_Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Component_Window.
function Component_Window_Callback(hObject, eventdata, handles)
% hObject    handle to Component_Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Component_Window contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Component_Window

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Component_Minmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Component_Minmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Component_Minmax.
function Component_Minmax_Callback(hObject, eventdata, handles)
% hObject    handle to Component_Minmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Component_Minmax contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Component_Minmax

highlighter(hObject,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function Component_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Component_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Component_Label.
function Component_Label_Callback(hObject, eventdata, handles)
% hObject    handle to Component_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Component_Label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Component_Label

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Component_Measures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Component_Measures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Component_Measures.
function Component_Measures_Callback(hObject, eventdata, handles)
% hObject    handle to Component_Measures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Component_Measures contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Component_Measures

highlighter(hObject,eventdata,handles)

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



% --- Executes during object creation, after setting all properties.
function Window_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Window_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Window_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Window_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Window_Start as text
%        str2double(get(hObject,'String')) returns contents of Window_Start as a double



% --- Executes during object creation, after setting all properties.
function Window_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Window_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Window_End_Callback(hObject, eventdata, handles)
% hObject    handle to Window_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Window_End as text
%        str2double(get(hObject,'String')) returns contents of Window_End as a double



% --- Executes during object creation, after setting all properties.
function New_Component_Measure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Component_Measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Component_Measure_Callback(hObject, eventdata, handles)
% hObject    handle to New_Component_Measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Component_Measure as text
%        str2double(get(hObject,'String')) returns contents of New_Component_Measure as a double


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


% --- Executes on button press in Clear_All_Component.
function Clear_All_Component_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Component (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_all(hObject,eventdata,handles);

% --- Executes on button press in Add_Component.
function Add_Component_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Component (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.Baseline_Start,'String')) ~= 1 & isempty(get(handles.Baseline_End,'String')) ~= 1 & ...
   isempty(get(handles.Window_Start,'String')) ~= 1 & isempty(get(handles.Window_End,'String')) ~= 1 & ...
   isempty(get(handles.Component_Label,'String')) ~= 1 & isempty(get(handles.New_Component_Measure,'String')) ~= 1
    
    component_label = get(handles.Component_Label,'String');
    if ischar(component_label); component_label = cellstr(component_label); end
    length_cl = length(component_label);
    component_label{length_cl} = ['' get(handles.New_Component_Label,'String') ' '];
    component_label{length_cl+1} = ' ';
    set(handles.Component_Label,'String',component_label)
    set(handles.New_Component_Label,'String','')

    component_baseline = get(handles.Component_Baseline,'String');
    if ischar(component_baseline); component_baseline = cellstr(component_baseline); end
    length_cb = length(component_baseline);
    component_baseline{length_cb} = [get(handles.Baseline_Start,'String') ' ' ...
            get(handles.Baseline_End,'String') ' '];
    component_baseline{length_cb+1} = ' ';
    set(handles.Component_Baseline,'String',component_baseline)
    set(handles.Baseline_Start,'String','')
    set(handles.Baseline_End,'String','')
    
    component_window = get(handles.Component_Window,'String');
    if ischar(component_window); component_window = cellstr(component_window); end
    length_cw = length(component_window);
    component_window{length_cw} = [get(handles.Window_Start,'String'), ' ' ...
            get(handles.Window_End,'String') ' '];
    component_window{length_cw+1} = ' ';
    set(handles.Component_Window,'String',component_window)
    set(handles.Window_Start,'String','')
    set(handles.Window_End,'String','')
    
    component_measures = get(handles.Component_Measures,'String');
    if ischar(component_measures); component_measures = cellstr(component_measures); end
    length_cs = length(component_measures);
    component_measures{length_cs} = [get(handles.New_Component_Measure,'String') ' '];
    component_measures{length_cs+1} = ' ';
    set(handles.Component_Measures,'String',component_measures)
    set(handles.New_Component_Measure,'String','')
    
    component_minmax = get(handles.Component_Minmax,'String');
    if ischar(component_minmax); component_minmax = cellstr(component_minmax); end
    length_cm = length(component_minmax);
    select_component_minmax = get(handles.Select_Component_Minmax,'String');
    select_component_minmax = select_component_minmax(get(handles.Select_Component_Minmax,'Value'));
    component_minmax{length_cm} = [char(select_component_minmax) ' '];
    component_minmax{length_cm+1} = ' ';
    set(handles.Component_Minmax,'String',component_minmax)
    set(handles.Select_Component_Minmax,'Value',1)
    
    gui_parameter_change('.get_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.get_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.get_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.get_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.get_components','component_measures_list',get(handles.Component_Measures,'String'));

    set(handles.Component_Label,'Value',length_cl+1)
    highlighter(handles.Component_Label,eventdata,handles)
    
end

% --- Executes on button press in Remove_Component.
function Remove_Component_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Component (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

component_label = get(handles.Component_Label,'String');
component_label = component_label(get(handles.Component_Label,'Value'));
if strcmp(component_label,' ') ~= 1

    % Gets position of highlighted pass, then deletes it
    cblist_pos = get(handles.Component_Baseline,'Value');
    component_baseline = get(handles.Component_Baseline,'String');
    if iscell(component_baseline) ~= 1; component_baseline = cellstr(component_baseline); end
    if isempty(component_baseline) ~= 1; component_baseline(cblist_pos) = []; end
    if cblist_pos > 1; set(handles.Component_Baseline,'Value',cblist_pos-1); end
    set(handles.Component_Baseline,'String',component_baseline)

    cwlist_pos = get(handles.Component_Window,'Value');
    component_window = get(handles.Component_Window,'String');
    if iscell(component_window) ~= 1; component_window = cellstr(component_window); end
    if isempty(component_window) ~= 1; component_window(cwlist_pos) = []; end
    if cwlist_pos > 1; set(handles.Component_Window,'Value',cwlist_pos-1); end
    set(handles.Component_Window,'String',component_window)

    cmlist_pos = get(handles.Component_Minmax,'Value');
    component_minmax = get(handles.Component_Minmax,'String');
    if iscell(component_minmax) ~= 1; component_minmax = cellstr(component_minmax); end
    if isempty(component_minmax) ~= 1; component_minmax(cmlist_pos) = []; end
    if cmlist_pos > 1; set(handles.Component_Minmax,'Value',cmlist_pos-1); end
    set(handles.Component_Minmax,'String',component_minmax)

    cllist_pos = get(handles.Component_Label,'Value');
    component_label = get(handles.Component_Label,'String');
    if iscell(component_label) ~= 1; component_label = cellstr(component_label); end
    if isempty(component_label) ~= 1; component_label(cllist_pos) = []; end
    if cllist_pos > 1; set(handles.Component_Label,'Value',cllist_pos-1); end
    set(handles.Component_Label,'String',component_label)

    cslist_pos = get(handles.Component_Measures,'Value');
    component_measures = get(handles.Component_Measures,'String');
    if iscell(component_measures) ~= 1; component_measures = cellstr(component_measures); end
    if isempty(component_measures) ~= 1; component_measures(cslist_pos) = []; end
    if cslist_pos > 1; set(handles.Component_Measures,'Value',cslist_pos-1); end
    set(handles.Component_Measures,'String',component_measures)

    gui_parameter_change('.get_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.get_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.get_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.get_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.get_components','component_measures_list',get(handles.Component_Measures,'String'));
   
end


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameter_change('.get_components','generate_script',get(hObject,'Value'));


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
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))+1);
    set(handles.Script_File,'String',file_name)
    gui_parameter_change('.get_components','script_file',get(handles.Script_File,'String'));
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

gui_parameter_change('.get_components','script_file',get(hObject,'String'));


% --- Executes on button press in Get_Components.
function Get_Components_Callback(hObject, eventdata, handles)
% hObject    handle to Get_Components (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets values for the component extraction function
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
file_name = get(handles.Load_File,'String');
out_file = [get(handles.Save_Dir,'String') filesep get(handles.Save_File,'String')];
components = [strvcat(get(handles.Component_Label,'String')) strvcat(get(handles.Component_Baseline,'String')) ...
        strvcat(get(handles.Component_Window,'String')) strvcat(get(handles.Component_Minmax,'String')) ...
        strvcat(get(handles.Component_Measures,'String'))];
components = components(1:end-1,:);
filter = [str2num(get(handles.Highpass_Filter,'String')) str2num(get(handles.Lowpass_Filter,'String'))];
AT = evalin('base','AT');
verbosity = str2num(get(handles.Verbosity,'String'));


% DO NOT ALTER ANYTHING BELOW THIS LINE!
if get(handles.Review_Components,'Value')
    review_components(file_name,out_file,components,filter,AT,verbosity);
else
    get_components(file_name,out_file,components,filter,AT,verbosity);
end

% Writes out a lovely script to do the component extraction
if get(handles.Generate_Script,'Value') & isempty(get(handles.Script_File,'String')) ~= 1
    fid = fopen([gui_parameters.default_script_dir filesep get(handles.Script_File,'String') '.m'],'w+');
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
        fprintf(fid,'file_name = ''%s'';\n',get(handles.Load_File,'String'));
        fprintf(fid,'out_file = ''%s%s%s'';\n',get(handles.Save_Dir,'String'),filesep,get(handles.Save_File,'String'));
        fprintf(fid,'components = [\n');
        for i = 1:length(components(:,1))
            fprintf(fid,'              ''%s''\n',components(i,:));
        end
        fprintf(fid,'              ];\n');
        fprintf(fid,'filter = [%s %s];\n',get(handles.Highpass_Filter,'String'),get(handles.Lowpass_Filter,'String'));
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
        fprintf(fid,'verbosity = [%s];\n',get(handles.Verbosity,'String'));
        fprintf(fid,'\n%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        if get(handles.Review_Components,'Value')
            fprintf(fid,'review_components(file_name,out_file,components,filter,AT,verbosity);');
        else
            fprintf(fid,'get_components(file_name,out_file,components,filter,AT,verbosity);');
        end
        fclose(fid);

    end
end

% Closes Get Components window
close(pop_Get_Components)


% --- Executes during object creation, after setting all properties.
function Select_Component_Minmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Component_Minmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_Component_Minmax.
function Select_Component_Minmax_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Component_Minmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Component_Minmax contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Component_Minmax


% --- Executes during object creation, after setting all properties.
function New_Component_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Component_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Component_Label_Callback(hObject, eventdata, handles)
% hObject    handle to New_Component_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Component_Label as text
%        str2double(get(hObject,'String')) returns contents of New_Component_Label as a double


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

gui_parameter_change('.get_components','load_file',get(hObject,'String'));


% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.get_components.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = [file_name(1:fileseps(length(fileseps))) filesep file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1)];
    set(handles.Load_File,'String',file_name)
    gui_parameter_change('.get_components','load_file',get(handles.Load_File,'String'));
end


% --- Executes during object creation, after setting all properties.
function Save_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_Dir (see GCBO)
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
%        str2double(get(hObject,'String')) returns contents of Save_Dir as a double

gui_parameter_change('.get_components','save_dir',get(hObject,'String'));


% --- Executes on button press in Browse_Save_Dir.
function Browse_Save_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
if strcmp(gui_parameters.directory_select.selected_dir,'No directory selected.') ~= 1
    set(handles.Save_Dir,'String',gui_parameters.directory_select.selected_dir)
    gui_parameter_change('.get_components','save_dir',get(handles.Save_Dir,'String'));
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

gui_parameter_change('.get_components','save_file',get(hObject,'String'));


% --- Executes on button press in Browse_Save_File.
function Browse_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.get_components.data_format;
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
    gui_parameter_change('.get_components','save_file',get(handles.Save_File,'String'));
end


% --- Executes during object creation, after setting all properties.
function Highpass_Filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Highpass_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Highpass_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Highpass_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Highpass_Filter as text
%        str2double(get(hObject,'String')) returns contents of Highpass_Filter as a double

gui_parameter_change('.get_components','highpass_filter',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Lowpass_Filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lowpass_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Lowpass_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Lowpass_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lowpass_Filter as text
%        str2double(get(hObject,'String')) returns contents of Lowpass_Filter as a double

gui_parameter_change('.get_components','lowpass_filter',get(hObject,'String'));


% --- Executes on button press in Tag_Artifacts.
function Tag_Artifacts_Callback(hObject, eventdata, handles)
% hObject    handle to Tag_Artifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Tag_Artifacts;

% --- Executes on button press in Review_Components.
function Review_Components_Callback(hObject, eventdata, handles)
% hObject    handle to Review_Components (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Review_Components

gui_parameter_change('.get_components','review_components',get(hObject,'Value'));


% --- Executes on button press in Make_Text_File.
function Make_Text_File_Callback(hObject, eventdata, handles)
% hObject    handle to Make_Text_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Make_Text_File


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

gui_parameter_change('.get_components','verbosity',get(hObject,'Value'));


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

component_pos = get(handles.Component_Label,'Value');
component_label = get(handles.Component_Label,'String')

if component_pos > 1 & component_pos < length(component_label) % If not already at the top or bottom of the list
    % Gets current lists
    component_label = get(handles.Component_Label,'String');
    component_baseline = get(handles.Component_Baseline,'String');
    component_window = get(handles.Component_Window,'String');
    component_minmax = get(handles.Component_Minmax,'String');
    component_measures = get(handles.Component_Measures,'String');
    
    % Gets current line and line above it
    label_old = component_label{component_pos}; label_new = component_label{component_pos-1};
    baseline_old = component_baseline{component_pos}; baseline_new = component_baseline{component_pos-1};
    window_old = component_window{component_pos}; window_new = component_window{component_pos-1};
    minmax_old = component_minmax{component_pos}; minmax_new = component_minmax{component_pos-1};
    measures_old = component_measures{component_pos}; measures_new = component_measures{component_pos-1};
    
    % Switches lines around
    component_label{component_pos-1} = label_old; component_label{component_pos} = label_new;
    component_baseline{component_pos-1} = baseline_old; component_baseline{component_pos} = baseline_new;
    component_window{component_pos-1} = window_old; component_window{component_pos} = window_new;
    component_minmax{component_pos-1} = minmax_old; component_minmax{component_pos} = minmax_new;
    component_measures{component_pos-1} = measures_old; component_measures{component_pos} = measures_new;
    
    % Sets updated lists
    set(handles.Component_Label,'String',component_label)
    set(handles.Component_Baseline,'String',component_baseline)
    set(handles.Component_Window,'String',component_window)
    set(handles.Component_Minmax,'String',component_minmax)
    set(handles.Component_Measures,'String',component_measures)

    gui_parameter_change('.get_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.get_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.get_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.get_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.get_components','component_measures_list',get(handles.Component_Measures,'String'));

    
    % Updates list position
    set(handles.Component_Label,'Value',component_pos-1)
    highlighter(handles.Component_Label,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

component_pos = get(handles.Component_Label,'Value');
component_label = get(handles.Component_Label,'String')

if component_pos < length(component_label) - 1 % If not already at the bottom of the list
    % Gets current lists
    component_label = get(handles.Component_Label,'String');
    component_baseline = get(handles.Component_Baseline,'String');
    component_window = get(handles.Component_Window,'String');
    component_minmax = get(handles.Component_Minmax,'String');
    component_measures = get(handles.Component_Measures,'String');

    % Gets current line and line above it
    label_old = component_label{component_pos}; label_new = component_label{component_pos+1};
    baseline_old = component_baseline{component_pos}; baseline_new = component_baseline{component_pos+1};
    window_old = component_window{component_pos}; window_new = component_window{component_pos+1};
    minmax_old = component_minmax{component_pos}; minmax_new = component_minmax{component_pos+1};
    measures_old = component_measures{component_pos}; measures_new = component_measures{component_pos+1};

    % Switches lines around
    component_label{component_pos+1} = label_old; component_label{component_pos} = label_new;
    component_baseline{component_pos+1} = baseline_old; component_baseline{component_pos} = baseline_new;
    component_window{component_pos+1} = window_old; component_window{component_pos} = window_new;
    component_minmax{component_pos+1} = minmax_old; component_minmax{component_pos} = minmax_new;
    component_measures{component_pos+1} = measures_old; component_measures{component_pos} = measures_new;

    % Sets updated lists
    set(handles.Component_Label,'String',component_label)
    set(handles.Component_Baseline,'String',component_baseline)
    set(handles.Component_Window,'String',component_window)
    set(handles.Component_Minmax,'String',component_minmax)
    set(handles.Component_Measures,'String',component_measures)

    gui_parameter_change('.get_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.get_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.get_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.get_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.get_components','component_measures_list',get(handles.Component_Measures,'String'));


    % Updates list position
    set(handles.Component_Label,'Value',component_pos+1)
    highlighter(handles.Component_Label,eventdata,handles);
end
