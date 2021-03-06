function varargout = pop_Advanced_Components(varargin)
% pop_Advanced_Components M-file for pop_Advanced_Components.fig
%      pop_Advanced_Components, by itself, creates a new pop_Advanced_Components or raises the existing
%      singleton*.
%
%      H = pop_Advanced_Components returns the handle to a new pop_Advanced_Components or the handle to
%      the existing singleton*.
%
%      pop_Advanced_Components('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Advanced_Components.M with the given input arguments.
%
%      pop_Advanced_Components('Property','Value',...) creates a new pop_Advanced_Components or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Advanced_Components_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Advanced_Components_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Advanced_Components

% Last Modified by GUIDE v2.5 14-Dec-2004 16:34:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Advanced_Components_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Advanced_Components_OutputFcn, ...
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


% --- Executes just before pop_Advanced_Components is made visible.
function pop_Advanced_Components_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Advanced_Components (see VARARGIN)

% Choose default command line output for pop_Advanced_Components
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_Advanced_Components wait for user response (see UIRESUME)
% uiwait(handles.pop_Advanced_Components);


% Sets some defaults
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','data_format','.mat');    
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','use_tfd',0);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','use_pca',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','plot_averages',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','plot_diffs',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','merge_plots',0);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','resampling_rate','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','create_ascii',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','number_factors','0');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','rotation',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','time_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','time_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','freq_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','freq_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','time_sample_rate','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','freq_sample_rate','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','freq_weight',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','component_name','components');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','baseline_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','baseline_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','window_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','window_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','script_file','advanced_components_script');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','component_label_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','component_baseline_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','component_window_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','component_minmax_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.advanced_components','component_measures_list',' ');

assignin('base','gui_parameters',gui_parameters)

    set(handles.Load_File,'String',gui_parameters.advanced_components.load_file)
    set(handles.Use_Tfd,'Value',gui_parameters.advanced_components.use_tfd)
    set(handles.Use_Pca,'Value',gui_parameters.advanced_components.use_pca)
    set(handles.Plot_Averages,'Value',gui_parameters.advanced_components.plot_averages)
    set(handles.Plot_Differences,'Value',gui_parameters.advanced_components.plot_diffs)
    set(handles.Merge_Plots,'Value',gui_parameters.advanced_components.merge_plots)
    set(handles.Resampling_Rate,'String',gui_parameters.advanced_components.resampling_rate) 
    set(handles.Make_Text_File,'Value',gui_parameters.advanced_components.create_ascii)
    set(handles.Number_Factors,'String',gui_parameters.advanced_components.number_factors)
    set(handles.Rotation,'Value',gui_parameters.advanced_components.rotation)
    set(handles.Time_Start,'String',gui_parameters.advanced_components.time_start)
    set(handles.Time_End,'String',gui_parameters.advanced_components.time_end)
    set(handles.Frequency_Start,'String',gui_parameters.advanced_components.freq_start)
    set(handles.Frequency_End,'String',gui_parameters.advanced_components.freq_end)
    set(handles.Time_Sample_Rate,'String',gui_parameters.advanced_components.time_sample_rate)
    set(handles.Frequency_Sample_Rate,'String',gui_parameters.advanced_components.freq_sample_rate)
    set(handles.Frequency_Weight,'Value',gui_parameters.advanced_components.freq_weight)
    set(handles.Component_Name,'String',gui_parameters.advanced_components.component_name)
    set(handles.Baseline_Start,'String',gui_parameters.advanced_components.baseline_start)
    set(handles.Baseline_End,'String',gui_parameters.advanced_components.baseline_end)
    set(handles.Window_Start,'String',gui_parameters.advanced_components.window_start)
    set(handles.Window_End,'String',gui_parameters.advanced_components.window_end)
    set(handles.Verbosity,'String',gui_parameters.advanced_components.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.advanced_components.generate_script)
    set(handles.Script_File,'String',gui_parameters.advanced_components.script_file)
    set(handles.Component_Label,'String',gui_parameters.advanced_components.component_label_list)
    set(handles.Component_Baseline,'String',gui_parameters.advanced_components.component_baseline_list)
    set(handles.Component_Window,'String',gui_parameters.advanced_components.component_window_list)
    set(handles.Component_Minmax,'String',gui_parameters.advanced_components.component_minmax_list)
    set(handles.Component_Measures,'String',gui_parameters.advanced_components.component_measures_list)


% Grays out appropriate parts of the window
Use_Pca_Callback(handles.Use_Pca,eventdata,handles);
Use_Tfd_Callback(handles.Use_Tfd,eventdata,handles);
    
% --- Outputs from this function are returned to the command line.
function varargout = pop_Advanced_Components_OutputFcn(hObject, eventdata, handles)
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

gui_parameter_change('.advanced_components','baseline_start',get(hObject,'String'));


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

gui_parameter_change('.advanced_components','baseline_end',get(hObject,'String'));


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

gui_parameter_change('.advanced_components','window_start',get(hObject,'String'));


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

gui_parameter_change('.advanced_components','window_end',get(hObject,'String'));


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
    
    gui_parameter_change('.advanced_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.advanced_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.advanced_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.advanced_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.advanced_components','component_measures_list',get(handles.Component_Measures,'String'));

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

    gui_parameter_change('.advanced_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.advanced_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.advanced_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.advanced_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.advanced_components','component_measures_list',get(handles.Component_Measures,'String'));
    
end


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameter_change('.advanced_components','generate_script',get(hObject,'Value'));


% --- Executes on button press in Browse_Script_File.
function Browse_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.advanced_components.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file seletor and sets file name
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file) ~= 1
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))+1);
    set(handles.Script_File,'String',file_name)
    gui_parameter_change('.advanced_components','script_file',get(handles.Script_File,'String'));
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

gui_parameter_change('.advanced_components','script_file',get(hObject,'String'));


% --- Executes on button press in Get_Components.
function Get_Components_Callback(hObject, eventdata, handles)
% hObject    handle to Get_Components (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.Resampling_Rate,'String'))

% Sets values for all component extraction functions
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
file_name = get(handles.Load_File,'String');

use_tfd = get(handles.Use_Tfd,'Value');
use_pca = get(handles.Use_Pca,'Value');
plot_averages = get(handles.Plot_Averages,'Value');
plot_diffs = get(handles.Plot_Differences,'Value');

if ispc
    merge_plots = 0;
else
    merge_plots = get(handles.Merge_Plots,'Value');
end
    
resampling_rate = str2num(get(handles.Resampling_Rate,'String'));
create_ascii = get(handles.Make_Text_File,'Value');
number_factors = str2num(get(handles.Number_Factors,'String'));
decomposition = 'acov';

rotation_pos = get(handles.Rotation,'Value');
switch rotation_pos
    case 1
        rotation = 'vmx';
    case 2
        rotation = 'pmx';
    case 3
        rotation = 'none';
end
 
time_start = str2num(get(handles.Time_Start,'String'));
time_end = str2num(get(handles.Time_End,'String'));
freq_start = str2num(get(handles.Frequency_Start,'String'));
freq_end = str2num(get(handles.Frequency_End,'String'));
time_sample_rate = str2num(get(handles.Time_Sample_Rate,'String'));
freq_sample_rate = str2num(get(handles.Frequency_Sample_Rate,'String'));

freq_pos = get(handles.Frequency_Weight,'Value');
switch freq_pos
    case 1
        freq_weight = 'F';
    case 2
        freq_weight = 'L';
    case 3
        freq_weight = 'S';
    case 4
        freq_weight = 'K';
    case 5
        freq_weight = 'B';
end

components_name = get(handles.Component_Name,'String');

components = [strvcat(get(handles.Component_Label,'String')) strvcat(get(handles.Component_Baseline,'String')) ...
        strvcat(get(handles.Component_Window,'String')) strvcat(get(handles.Component_Minmax,'String')) ...
        strvcat(get(handles.Component_Measures,'String'))];
components = components(1:end-1,:);

verbosity = str2num(get(handles.Verbosity,'String'));

% DO NOT ALTER ANYTHING BELOW THIS LINE!
% Gets advanced components, based on Use_Pca and Use_Tfd selections

if use_pca == 0 & use_tfd == 0
    win_startup(file_name,resampling_rate,components_name,components,plot_averages,plot_diffs,merge_plots, ...
        create_ascii,verbosity);
elseif use_pca == 0 & use_tfd == 1
    wintfd_startup(file_name,resampling_rate,time_sample_rate,freq_sample_rate,freq_weight,components_name, ...
        components,plot_averages,plot_diffs,merge_plots,create_ascii,verbosity);
elseif use_pca == 1 & use_tfd == 0
    pca_startup(file_name,resampling_rate,time_start,time_end,decomposition,rotation,number_factors,plot_averages, ...
        plot_diffs,merge_plots,create_ascii,verbosity);
elseif use_pca == 1 & use_tfd == 1
    pcatfd_startup(file_name,resampling_rate,time_sample_rate,time_start,time_end,freq_sample_rate,freq_start, ...
        freq_end,freq_weight,decomposition,rotation,number_factors,plot_averages,plot_diffs,merge_plots, ...
        create_ascii,verbosity);
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

        fprintf(fid,'%% Sets values for all component extraction functions\n');
        fprintf(fid,'file_name = ''%s'';\n',get(handles.Load_File,'String'));
        fprintf(fid,'use_tfd = %s;\n',num2str(get(handles.Use_Tfd,'Value')));
        fprintf(fid,'use_pca = %s;\n',num2str(get(handles.Use_Pca,'value')));
        fprintf(fid,'plot_averages = %s;\n',num2str(get(handles.Plot_Averages,'Value')));
        fprintf(fid,'plot_diffs = %s;\n',num2str(get(handles.Plot_Differences,'Value')));

        if ispc
            fprintf(fid,'merge_plots = 0;\n');
        else
            fprintf(fid,'merge_plots = %s;\n',num2str(get(handles.Merge_Plots,'Value')));
        end

        fprintf(fid,'resampling_rate = [%s];\n',get(handles.Resampling_Rate,'String'));
        fprintf(fid,'create_ascii = %s;\n',num2str(get(handles.Make_Text_File,'Value')));
        fprintf(fid,'number_factors = [%s];\n',get(handles.Number_Factors,'String'));
        fprintf(fid,'decomposition = ''acov'';\n');
    
        rotation_pos = get(handles.Rotation,'Value');
        switch rotation_pos
            case 1
                fprintf(fid,'rotation = ''vmx'';\n');
            case 2
                fprintf(fid,'rotation = ''pmx'';\n');
            case 3
                fprintf(fid,'rotation = ''none'';\n');
        end

        fprintf(fid,'time_start = [%s];\n',get(handles.Time_Start,'String'));
        fprintf(fid,'time_end = [%s];\n',get(handles.Time_End,'String'));
        fprintf(fid,'freq_start = [%s];\n',get(handles.Frequency_Start,'String'));
        fprintf(fid,'freq_end = [%s];\n',get(handles.Frequency_End,'String'));
        fprintf(fid,'time_sample_rate = [%s];\n',get(handles.Time_Sample_Rate,'String'));
        fprintf(fid,'freq_sample_rate = [%s];\n',get(handles.Frequency_Sample_Rate,'String'));

        fprintf(fid,'freq_weight = [%s];\n',get(handles.Frequency_Weight,'String'));
        
        freq_pos = get(handles.Frequency_Weight,'Value');
        switch freq_pos
            case 1
                fprintf(fid,'freq_weight = ''F'';\n');
            case 2
                fprintf(fid,'freq_weight = ''L'';\n');
            case 3
                fprintf(fid,'freq_weight = ''S'';\n');
            case 4
                fprintf(fid,'freq_weight = ''K'';\n');
            case 5
                fprintf(fid,'freq_weight = ''B'';\n');
        end
        
        fprintf(fid,'components_name = ''%s'';\n',get(handles.Component_Name,'String'));

        components = [strvcat(get(handles.Component_Label,'String')) strvcat(get(handles.Component_Baseline,'String')) ...
                strvcat(get(handles.Component_Window,'String')) strvcat(get(handles.Component_Minmax,'String')) ...
                strvcat(get(handles.Component_Measures,'String'))];
        components = components(1:end-1,:);
        for i = 1:length(components(:,1))
            fprintf(fid,'components(%s,:) = ''%s'';\n',num2str(i),components(i,:));
        end

        fprintf(fid,'verbosity = [%s];\n',get(handles.Verbosity,'String'));
        fprintf(fid,'\n%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'\n%% Gets advanced components, based on Use_Pca and Use_Tfd values\n');
        if use_pca == 0 & use_tfd == 0
            fprintf(fid,'win_startup(file_name,resampling_rate,components_name,components,plot_averages,plot_diffs,merge_plots,...\n');
            fprintf(fid,'    create_ascii,verbosity);\n');
        elseif use_pca == 0 & use_tfd == 1
            fprintf(fid,'wintfd_startup(file_name,resampling_rate,time_sample_rate,freq_sample_rate,freq_weight,components_name, ...\n');
            fprintf(fid,'    components,plot_averages,plot_diffs,merge_plots,create_ascii,verbosity);\n');
        elseif use_pca == 1 & use_tfd == 0
            fprintf(fid,'pca_startup(file_name,resampling_rate,time_start,time_end,decomposition,rotation,number_factors,plot_averages, ...\n');
            fprintf(fid,'    plot_diffs,merge_plots,create_ascii,verbosity);\n');
        elseif use_pca == 1 & use_tfd == 1
            fprintf(fid,'pcatfd_startup(file_name,resampling_rate,time_sample_rate,time_start,time_end,freq_sample_rate,freq_start, ...\n');
            fprintf(fid,'    freq_end,freq_weight,docomposition,rotation,number_factors,plot_averages,plot_diffs,merge_plots, ...\n');
            fprintf(fid,'    create_ascii,verbosity);\n');
        end
    
        fclose(fid);
    end
end

% Closes Advanced Components window
close(pop_Advanced_Components)

end

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

gui_parameter_change('.advanced_components','load_file',get(hObject,'String'));


% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 % Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.advanced_components.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls directory selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = [file_name(1:fileseps(length(fileseps))) filesep file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1)];
    set(handles.Load_File,'String',file_name)
    gui_parameter_change('.advanced_components','load_file',get(handles.Load_File,'String'));
end



% --- Executes during object creation, after setting all properties.
function Time_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Time_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Time_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_Start as text
%        str2double(get(hObject,'String')) returns contents of Time_Start as a double

gui_parameter_change('.advanced_components','time_start',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Time_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Time_End_Callback(hObject, eventdata, handles)
% hObject    handle to Time_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_End as text
%        str2double(get(hObject,'String')) returns contents of Time_End as a double

gui_parameter_change('.advanced_components','time_end',get(hObject,'String'));


% --- Executes on button press in Plot_Averages.
function Plot_Averages_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Averages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Plot_Averages

gui_parameter_change('.advanced_components','plot_averages',get(hObject,'Value'));


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

gui_parameter_change('.advanced_components','verbosity',get(hObject,'String'));


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

    gui_parameter_change('.advanced_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.advanced_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.advanced_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.advanced_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.advanced_components','component_measures_list',get(handles.Component_Measures,'String'));
    
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

    gui_parameter_change('.advanced_components','component_label_list',get(handles.Component_Label,'String'));
    gui_parameter_change('.advanced_components','component_baseline_list',get(handles.Component_Baseline,'String'));
    gui_parameter_change('.advanced_components','component_window_list',get(handles.Component_Window,'String'));
    gui_parameter_change('.advanced_components','component_minmax_list',get(handles.Component_Minmax,'String'));
    gui_parameter_change('.advanced_components','component_measures_list',get(handles.Component_Measures,'String'));

    % Updates list position
    set(handles.Component_Label,'Value',component_pos+1)
    highlighter(handles.Component_Label,eventdata,handles);
end


% --- Executes during object creation, after setting all properties.
function Frequency_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequency_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Frequency_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frequency_Start as text
%        str2double(get(hObject,'String')) returns contents of Frequency_Start as a double

gui_parameter_change('.advanced_components','freq_start',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Frequency_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequency_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Frequency_End_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frequency_End as text
%        str2double(get(hObject,'String')) returns contents of Frequency_End as a double

gui_parameter_change('.advanced_components','freq_end',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Rotation.
function Rotation_Callback(hObject, eventdata, handles)
% hObject    handle to Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Rotation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Rotation

gui_parameter_change('.advanced_components','rotation',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Number_Factors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Number_Factors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Number_Factors_Callback(hObject, eventdata, handles)
% hObject    handle to Number_Factors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Number_Factors as text
%        str2double(get(hObject,'String')) returns contents of Number_Factors as a double

gui_parameter_change('.advanced_components','number_factors',get(hObject,'String'));


% --- Executes on button press in Use_Pca.
function Use_Pca_Callback(hObject, eventdata, handles)
% hObject    handle to Use_Pca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Use_Pca

% Assigns states of PCA and component specification elements
switch get(hObject,'Value')
    case 0
        state_components = 'on';
        state_pca = 'off';
    case 1
        state_components = 'off';
        state_pca = 'on';
end

set_enable(handles,state_components,'Component_Parameters_Label','Component_Label_Label', ...
    'Baseline_Time_Label','Component_Frequency_Label','Component_Minmax_Label','Component_Measures_Label', ...
    'Component_Label','Component_Baseline','Component_Window','Component_Minmax','Component_Measures', ...
    'New_Component_Label','Baseline_Start','Baseline_End','Window_Start','Window_End', ...
    'Select_Component_Minmax','New_Component_Measure','New_Component_Label_Label','Baseline_Start_Label', ...
    'Baseline_End_Label','Component_Start_Label','Component_End_Label','New_Measure_Label','Move_Up', ...
    'Add_Component','Remove_Component','Clear_All_Component','Move_Down','Component_Name','Component_Name_Label');
set_enable(handles,state_pca,'Pca_Label','Number_Factors_Label','Number_Factors','Rotation_Label', ...
    'Rotation','Time_Bins_Label','Time_Start','Time_End','Start_Time_Label','End_Time_Label');

% Sets additional TFD-relevant PCA handles, if TFD is enabled
if get(handles.Use_Tfd,'Value') & get(handles.Use_Pca,'Value')
    set_enable(handles,'on','Frequency_Bins_Label','Frequency_Start','Frequency_End','Start_Freq_Label','End_Freq_Label');
else
    set_enable(handles,'off','Frequency_Bins_Label','Frequency_Start','Frequency_End','Start_Freq_Label','End_Freq_Label');
end

gui_parameter_change('.advanced_components','use_pca',get(hObject,'Value'));


% --- Executes on button press in Use_Tfd.
function Use_Tfd_Callback(hObject, eventdata, handles)
% hObject    handle to Use_Tfd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Use_Tfd

% Assigns state of TFD elements
switch(get(handles.Use_Tfd,'Value'))
    case 0
        state_tfd = 'off';
        set(handles.Baseline_Time_Label,'String','Baseline bins')
        set(handles.Component_Frequency_Label,'String','Component bins')
        set(handles.Component_Baseline,'Tooltip','Displays component baselines (relative to trigger)')
        set(handles.Baseline_Start,'Tooltip','Start of baseline in bins (relative to trigger)')
        set(handles.Baseline_End,'Tooltip','End of baseline in bins (relative to trigger)')
        set(handles.Component_Window,'Tooltip','Displays component windows (relative to trigger)')
        set(handles.Window_Start,'Tooltip','Start of component in bins (relative to trigger)')
        set(handles.Window_End,'Tooltip','End of component in bins (relative to trigger)')
    case 1
        state_tfd = 'on';
        set(handles.Baseline_Time_Label,'String','Time bins')
        set(handles.Component_Frequency_Label,'String','Frequency bins')
        set(handles.Component_Baseline,'Tooltip','Displays component time bins (relative to trigger)')
        set(handles.Baseline_Start,'Tooltip','First component time point in bins (relative to trigger)')
        set(handles.Baseline_End,'Tooltip','Last component time point in bins (relative to trigger)')
        set(handles.Component_Window,'Tooltip','Displays component frequency bins')
        set(handles.Window_Start,'Tooltip','Lowest frequency in which to pick a component')
        set(handles.Window_End,'Tooltip','Highest frequency in which to pick a component')
end

set_enable(handles,state_tfd,'Tfd_Label','Time_Sample_Rate_Label','Time_Sample_Rate','Freq_Sample_Rate_Label', ...
    'Frequency_Sample_Rate','Frequency_Weight_Label','Frequency_Weight');

% Assigns PCA-relevant states
if get(handles.Use_Tfd,'Value') & get(handles.Use_Pca,'Value')
    set_enable(handles,'on','Frequency_Bins_Label','Frequency_Start','Frequency_End','Start_Freq_Label','End_Freq_Label');
else
    set_enable(handles,'off','Frequency_Bins_Label','Frequency_Start','Frequency_End','Start_Freq_Label','End_Freq_Label');
end

gui_parameter_change('.advanced_components','use_tfd',get(hObject,'Value'));


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

gui_parameter_change('.advanced_components','resampling_rate',get(hObject,'String'));


% --- Executes on button press in Make_Text_File.
function Make_Text_File_Callback(hObject, eventdata, handles)

gui_parameter_change('.advanced_components','create_ascii',get(hObject,'Value'));


% --- Executes on button press in Plot_Differences.
function Plot_Differences_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Differences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Plot_Differences

gui_parameter_change('.advanced_components','plot_diffs',get(hObject,'Value'));


% --- Executes on button press in Merge_Plots.
function Merge_Plots_Callback(hObject, eventdata, handles)
% hObject    handle to Merge_Plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Merge_Plots

gui_parameter_change('.advanced_components','merge_plots',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Time_Sample_Rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_Sample_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Time_Sample_Rate_Callback(hObject, eventdata, handles)
% hObject    handle to Time_Sample_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_Sample_Rate as text
%        str2double(get(hObject,'String')) returns contents of Time_Sample_Rate as a double

gui_parameter_change('.advanced_components','time_sample_rate',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Frequency_Sample_Rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequency_Sample_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Frequency_Sample_Rate_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_Sample_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frequency_Sample_Rate as text
%        str2double(get(hObject,'String')) returns contents of Frequency_Sample_Rate as a double

gui_parameter_change('.advanced_components','freq_sample_rate',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Frequency_Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequency_Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Frequency_Weight_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frequency_Weight as text
%        str2double(get(hObject,'String')) returns contents of Frequency_Weight as a double

gui_parameter_change('.advanced_components','freq_weight',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Component_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Component_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Component_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Component_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Component_Name as text
%        str2double(get(hObject,'String')) returns contents of Component_Name as a double

gui_parameter_change('.advanced_components','component_name',get(hObject,'String'));

