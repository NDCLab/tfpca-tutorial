function varargout = pop_Filter_Builder(varargin)
% pop_Filter_Builder M-file for pop_Filter_Builder.fig
%      pop_Filter_Builder, by itself, creates a new pop_Filter_Builder or raises the existing
%      singleton*.
%
%      H = pop_Filter_Builder returns the handle to a new pop_Filter_Builder or the handle to
%      the existing singleton*.
%
%      pop_Filter_Builder('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Filter_Builder.M with the given input arguments.
%
%      pop_Filter_Builder('Property','Value',...) creates a new pop_Filter_Builder or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Filter_Builder_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Filter_Builder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Filter_Builder

% Last Modified by GUIDE v2.5 23-Dec-2004 02:06:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Filter_Builder_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Filter_Builder_OutputFcn, ...
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


% --- Executes just before pop_Filter_Builder is made visible.
function pop_Filter_Builder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Filter_Builder (see VARARGIN)

% Choose default command line output for pop_Filter_Builder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_Filter_Builder wait for user response (see UIRESUME)
% uiwait(handles.pop_Filter_Builder);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_proplo','');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_prophi','');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_order','');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','script_file','filter_builder_script');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_type_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_freqs_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_order_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_highlowpass_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_time_constant_list',' ');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_electrode_list','{''ALL''}');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','filter_subject_list','{''ALL''}');
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','called_from_import_data',0);

    set(handles.Load_File,'String',gui_parameters.filter_builder.load_file)
    set(handles.Filter_Proplo,'String',gui_parameters.filter_builder.filter_proplo)
    set(handles.Filter_Prophi,'String',gui_parameters.filter_builder.filter_prophi)
    set(handles.New_Filter_Order,'String',gui_parameters.filter_builder.filter_order)
    set(handles.Verbosity,'String',gui_parameters.filter_builder.verbosity)
    set(handles.Script_File,'String',gui_parameters.filter_builder.script_file)
    set(handles.Generate_Script,'Value',gui_parameters.filter_builder.generate_script)
    set(handles.Filter_Type,'String',gui_parameters.filter_builder.filter_type_list)
    set(handles.Filter_Frequencies,'String',gui_parameters.filter_builder.filter_freqs_list)
    set(handles.Filter_Order,'String',gui_parameters.filter_builder.filter_order_list)
    set(handles.Filter_Highlowpass,'String',gui_parameters.filter_builder.filter_highlowpass_list)
    set(handles.Filter_Time_Constant,'String',gui_parameters.filter_builder.filter_time_constant_list)
    set(handles.Filter_Electrode_List,'String',gui_parameters.filter_builder.filter_electrode_list)
    set(handles.Filter_Subject_List,'String',gui_parameters.filter_builder.filter_subject_list)

assignin('base','gui_parameters',gui_parameters)

Select_Filter_Type_Callback(handles.Select_Filter_Type,eventdata,handles);
    
% --- Outputs from this function are returned to the command line.
function varargout = pop_Filter_Builder_OutputFcn(hObject, eventdata, handles)
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
set(handles.Filter_Type,'Value',get(hObject,'Value'))
set(handles.Filter_Frequencies,'Value',get(hObject,'Value'))
set(handles.Filter_Order,'Value',get(hObject,'Value'))
set(handles.Filter_Highlowpass,'Value',get(hObject,'Value'))
set(handles.Filter_Time_Constant,'Value',get(hObject,'Value'))
set(handles.Filter_Electrode_List,'Value',get(hObject,'Value'))
set(handles.Filter_Subject_List,'Value',get(hObject,'Value'))


% Resets all dialog boxes
function reset_all(hObject,eventdata,handles)
set(handles.Filter_Frequencies,'Value',1)
set(handles.Filter_Order,'Value',1)
set(handles.Filter_Highlowpass,'Value',1)
set(handles.Filter_Time_Constant,'Value',1)
set(handles.Filter_Type,'Value',1)
set(handles.Filter_Electrode_List,'Value',1)
set(handles.Filter_Frequencies,'String',cellstr(' '))
set(handles.Filter_Order,'String',cellstr(' '))
set(handles.Filter_Highlowpass,'String',cellstr(' '))
set(handles.Filter_Time_Constant,'String',cellstr(' '))
set(handles.Filter_Type,'String',cellstr(' '))
set(handles.Filter_Electrode_List,'String',cellstr('{''ALL''}'))
set(handles.Filter_Subject_List,'String',cellstr('{''ALL''}'))


% Sets enable property of various handles
function set_enable(handles,state,varargin)
for i = 1:length(varargin)
    eval(['set(handles.' varargin{i} ',''Enable'',''' state ''')'])
end


% --- Executes during object creation, after setting all properties.
function Filter_Frequencies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Highlowpass_Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Highlowpass_Baseline.
function Filter_Frequencies_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Highlowpass_Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Highlowpass_Baseline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Highlowpass_Baseline

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Filter_Order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Order.
function Filter_Order_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Order contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Order

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Filter_Highlowpass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Highlowpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Highlowpass.
function Filter_Highlowpass_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Highlowpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Highlowpass contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Highlowpass

highlighter(hObject,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function Filter_Type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Type.
function Filter_Type_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Type

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Filter_Time_Constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Time_Constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Time_Constant.
function Filter_Time_Constant_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Time_Constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Time_Constant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Time_Constant

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Filter_Proplo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Proplo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Filter_Proplo_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Proplo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filter_Proplo as text
%        str2double(get(hObject,'String')) returns contents of Filter_Proplo as a double

gui_parameter_change('.filter_builder','filter_proplo',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Filter_Prophi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Prophi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Filter_Prophi_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Prophi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filter_Prophi as text
%        str2double(get(hObject,'String')) returns contents of Filter_Prophi as a double

gui_parameter_change('.filter_builder','filter_prophi',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function New_Filter_Order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Filter_Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Filter_Order_Callback(hObject, eventdata, handles)
% hObject    handle to New_Filter_Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Filter_Order as text
%        str2double(get(hObject,'String')) returns contents of New_Filter_Order as a double

gui_parameter_change('.filter_builder','filter_order',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function New_Filter_Time_Constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Filter_Time_Constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Filter_Time_Constant_Callback(hObject, eventdata, handles)
% hObject    handle to New_Filter_Time_Constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Filter_Time_Constant as text
%        str2double(get(hObject,'String')) returns contents of New_Filter_Time_Constant as a double


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


% --- Executes on button press in Clear_All_Filter.
function Clear_All_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_all(hObject,eventdata,handles);

% --- Executes on button press in Add_Filter.
function Add_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter_pos = get(handles.Select_Filter_Type,'Value');
 
if (filter_pos==1 & ~isempty(get(handles.Filter_Proplo,'String')) & ~isempty(get(handles.New_Filter_Order,'String'))) | ...
   (filter_pos==2 & ~isempty(get(handles.Filter_Prophi,'String')) & ~isempty(get(handles.New_Filter_Order,'String'))) | ...
   ((filter_pos==3 | filter_pos==4) & ~isempty(get(handles.Filter_Proplo,'String')) & ... 
       ~isempty(get(handles.Filter_Prophi,'String')) & ~isempty(get(handles.New_Filter_Order,'String'))) | ...
   (filter_pos==4 & ~isempty(get(handles.Select_Filter_Highlowpass,'String')) & ...
       ~isempty(get(handles.New_Filter_Time_Constant,'String'))) | ...
   (filter_pos==5 | filter_pos==6 | filter_pos==7)
    
    filter_type = get(handles.Filter_Type,'String');
    if ischar(filter_type); filter_type = cellstr(filter_type); end
    length_cl = length(filter_type);
    select_filter_type = get(handles.Select_Filter_Type,'String');
    select_filter_type = select_filter_type(get(handles.Select_Filter_Type,'Value'));
    filter_type{length_cl} = char(select_filter_type);
    filter_type{length_cl+1} = ' ';
    set(handles.Filter_Type,'String',filter_type)
    set(handles.Select_Filter_Type,'Value',1)

    filter_freqs = get(handles.Filter_Frequencies,'String');
    if ischar(filter_freqs); filter_freqs = cellstr(filter_freqs); end
    length_cb = length(filter_freqs);
    filter_freqs{length_cb} = [get(handles.Filter_Proplo,'String') ' ' ...
            get(handles.Filter_Prophi,'String') ' '];
    filter_freqs{length_cb+1} = ' ';
    set(handles.Filter_Frequencies,'String',filter_freqs)
    set(handles.Filter_Proplo,'String','')
    set(handles.Filter_Prophi,'String','')
    
    filter_order = get(handles.Filter_Order,'String');
    if ischar(filter_order); filter_order = cellstr(filter_order); end
    length_cw = length(filter_order);
    filter_order{length_cw} = get(handles.New_Filter_Order,'String');
    filter_order{length_cw+1} = ' ';
    set(handles.Filter_Order,'String',filter_order)
    set(handles.New_Filter_Order,'String','')
    
    filter_time_constant = get(handles.Filter_Time_Constant,'String');
    if ischar(filter_time_constant); filter_time_constant = cellstr(filter_time_constant); end
    length_cs = length(filter_time_constant);
    filter_time_constant{length_cs} = get(handles.New_Filter_Time_Constant,'String');
    filter_time_constant{length_cs+1} = ' ';
    set(handles.Filter_Time_Constant,'String',filter_time_constant)
    set(handles.New_Filter_Time_Constant,'String','')
    
    filter_highlowpass = get(handles.Filter_Highlowpass,'String');
    if ischar(filter_highlowpass); filter_highlowpass = cellstr(filter_highlowpass); end
    length_cm = length(filter_highlowpass);
    select_filter_highlowpass = get(handles.Select_Filter_Highlowpass,'String');
    select_filter_highlowpass = select_filter_highlowpass(get(handles.Select_Filter_Highlowpass,'Value'));
    filter_highlowpass{length_cm} = char(select_filter_highlowpass);
    filter_highlowpass{length_cm+1} = ' ';
    set(handles.Filter_Highlowpass,'String',filter_highlowpass)
    set(handles.Select_Filter_Highlowpass,'Value',1)
    
    filter_electrode = get(handles.Filter_Electrode_List,'String');
    if ischar(filter_electrode); filter_electrode = cellstr(filter_electrode); end
    length_ce = length(filter_electrode);
    filter_electrode{length_ce+1} = '{''ALL''}';
    set(handles.Filter_Electrode_List,'String',filter_electrode)
    
    filter_subject = get(handles.Filter_Subject_List,'String');
    if ischar(filter_subject); filter_subject = cellstr(filter_subject); end
    length_cu = length(filter_subject);
    filter_subject{length_cu+1} = '{''ALL''}';
    set(handles.Filter_Subject_List,'String',filter_subject)
    
    gui_parameter_change('.filter_builder','filter_type_list',get(handles.Filter_Type,'String'));
    gui_parameter_change('.filter_builder','filter_freqs_list',get(handles.Filter_Frequencies,'String'));
    gui_parameter_change('.filter_builder','filter_order_list',get(handles.Filter_Order,'String'));
    gui_parameter_change('.filter_builder','filter_highlowpass_list',get(handles.Filter_Highlowpass,'String'));
    gui_parameter_change('.filter_builder','filter_time_constant_list',get(handles.Filter_Time_Constant,'String'));
    gui_parameter_change('.filter_builder','filter_electrode_list',get(handles.Filter_Electrode_List,'String'));
    gui_parameter_change('.filter_builder','filter_subject_list',get(handles.Filter_Subject_List,'String'));
    
    set(handles.Filter_Type,'Value',length_cl+1)
    highlighter(handles.Filter_Type,eventdata,handles)
    
end

% --- Executes on button press in Remove_Filter.
function Remove_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter_type = get(handles.Filter_Type,'String');
filter_type = filter_type(get(handles.Filter_Type,'Value'));
if strcmp(filter_type,' ') ~= 1

    % Gets position of highlighted pass, then deletes it
    cblist_pos = get(handles.Filter_Frequencies,'Value');
    filter_freqs = get(handles.Filter_Frequencies,'String');
    if iscell(filter_freqs) ~= 1; filter_freqs = cellstr(filter_freqs); end
    if isempty(filter_freqs) ~= 1; filter_freqs(cblist_pos) = []; end
    if cblist_pos > 1; set(handles.Filter_Frequencies,'Value',cblist_pos-1); end
    set(handles.Filter_Frequencies,'String',filter_freqs)

    cwlist_pos = get(handles.Filter_Order,'Value');
    filter_order = get(handles.Filter_Order,'String');
    if iscell(filter_order) ~= 1; filter_order = cellstr(filter_order); end
    if isempty(filter_order) ~= 1; filter_order(cwlist_pos) = []; end
    if cwlist_pos > 1; set(handles.Filter_Order,'Value',cwlist_pos-1); end
    set(handles.Filter_Order,'String',filter_order)

    cmlist_pos = get(handles.Filter_Highlowpass,'Value');
    filter_highlowpass = get(handles.Filter_Highlowpass,'String');
    if iscell(filter_highlowpass) ~= 1; filter_highlowpass = cellstr(filter_highlowpass); end
    if isempty(filter_highlowpass) ~= 1; filter_highlowpass(cmlist_pos) = []; end
    if cmlist_pos > 1; set(handles.Filter_Highlowpass,'Value',cmlist_pos-1); end
    set(handles.Filter_Highlowpass,'String',filter_highlowpass)

    cllist_pos = get(handles.Filter_Type,'Value');
    filter_type = get(handles.Filter_Type,'String');
    if iscell(filter_type) ~= 1; filter_type = cellstr(filter_type); end
    if isempty(filter_type) ~= 1; filter_type(cllist_pos) = []; end
    if cllist_pos > 1; set(handles.Filter_Type,'Value',cllist_pos-1); end
    set(handles.Filter_Type,'String',filter_type)

    cslist_pos = get(handles.Filter_Time_Constant,'Value');
    filter_time_constant = get(handles.Filter_Time_Constant,'String');
    if iscell(filter_time_constant) ~= 1; filter_time_constant = cellstr(filter_time_constant); end
    if isempty(filter_time_constant) ~= 1; filter_time_constant(cslist_pos) = []; end
    if cslist_pos > 1; set(handles.Filter_Time_Constant,'Value',cslist_pos-1); end
    set(handles.Filter_Time_Constant,'String',filter_time_constant)
    
    celist_pos = get(handles.Filter_Electrode_List,'Value');
    filter_electrode_list = get(handles.Filter_Electrode_List,'String');
    if iscell(filter_electrode_list) ~= 1; filter_electrode_list = cellstr(filter_electrode_list); end
    if isempty(filter_electrode_list) ~= 1; filter_electrode_list(celist_pos) = []; end
    if celist_pos > 1; set(handles.Filter_Electrode_List,'Value',celist_pos-1); end
    set(handles.Filter_Electrode_List,'String',filter_electrode_list)
    
    culist_pos = get(handles.Filter_Subject_List,'Value');
    filter_subject_list = get(handles.Filter_Subject_List,'String');
    if iscell(filter_subject_list) ~= 1; filter_subject_list = cellstr(filter_subject_list); end
    if isempty(filter_subject_list) ~= 1; filter_subject_list(culist_pos) = []; end
    if culist_pos > 1; set(handles.Filter_Subject_List,'Value',culist_pos-1); end
    set(handles.Filter_Subject_List,'String',filter_subject_list)

    gui_parameter_change('.filter_builder','filter_type_list',get(handles.Filter_Type,'String'));
    gui_parameter_change('.filter_builder','filter_freqs_list',get(handles.Filter_Frequencies,'String'));
    gui_parameter_change('.filter_builder','filter_order_list',get(handles.Filter_Order,'String'));
    gui_parameter_change('.filter_builder','filter_highlowpass_list',get(handles.Filter_Highlowpass,'String'));
    gui_parameter_change('.filter_builder','filter_time_constant_list',get(handles.Filter_Time_Constant,'String'));
    gui_parameter_change('.filter_builder','filter_electrode_list',get(handles.Filter_Electrode_List,'String'));
    gui_parameter_change('.filter_builder','filter_subject_list',get(handles.Filter_Subject_List,'String'));
  
end


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameter_change('.filter_builder','generate_script',get(hObject,'Value'));


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
    gui_parameter_change('.filter_builder','script_file',get(handles.Script_File,'String'));
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

gui_parameter_change('.filter_builder','script_file',get(hObject,'String'));


% --- Executes on button press in Create_Filters.
function Create_Filters_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameters = evalin('base','gui_parameters');
if ~isempty(get(handles.Filter_Type,'String')) & gui_parameters.filter_builder.called_from_import_data ~= 1

    % Sets values for all component extraction functions
    file_name = get(handles.Load_File,'String');
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = [file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1)];

    % Creates filtervars variable
    filtervars = [];
    filtervars.electrodes = get(handles.Filter_Electrode_List,'String');
    filtervars.subjects = get(handles.Filter_Subject_List,'String');
    filtervars.filter = cellstr(get(handles.Filter_Type,'String'));
    filtervars.frequencies = get(handles.Filter_Frequencies,'String');
    filtervars.order = get(handles.Filter_Order,'String');
    filtervars.highlowpass = get(handles.Filter_Highlowpass,'String');
    filtervars.time_constant = get(handles.Filter_Time_Constant,'String');

    % Takes out last, extraneous row of filtervars that GUI generates
    for i = 1:length(filtervars.filter)-1
        filtvars(i).electrodes = eval(char(filtervars.electrodes{i}));
        filtvars(i).subjects = eval(char(filtervars.subjects{i}));
        filtvars(i).filter = char(filtervars.filter{i});
        filtvars(i).frequencies = str2num(filtervars.frequencies{i});
        filtvars(i).order = str2num(filtervars.order{i});
        filtvars(i).highlowpass = char(filtervars.highlowpass{i});
        filtvars(i).time_constant = str2num(filtervars.time_constant{i});
    end
    if ~isempty(filtervars), filtervars = filtvars; end
    verbosity = str2num(get(handles.Verbosity,'String'));


    % DO NOT ALTER ANYTHING BELOW THIS LINE!
    % Applies filters sequentially to data file
    load(get(handles.Load_File,'String'))
    erp = build_filters(erp,filtervars,verbosity);
    
    % Writes out a lovely script to do the filter building
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

            fprintf(fid,'verbosity = [%s];\n',num2str(verbosity));
            fprintf(fid,'%% Creates filtervars variable\n');
            fprintf(fid,'filtervars = [];\n');
            for i = 1:length(filtvars)

                electrodes_cell = filtvars(i).electrodes;
	        electrodes_string = '{';
                for j = 1:length(filtvars(i).electrodes)
	            electrodes_string = [electrodes_string '''' char(electrodes_cell{j}) ''';'];
                end
                electrodes_string = [electrodes_string(1:length(electrodes_string)) '}']; 
                fprintf(fid,'\nfiltervars(%s).electrodes = %s;\n',num2str(i),electrodes_string);
	    
                subjects_cell = filtvars(i).subjects;
                subjects_string = '{';
                for j = 1:length(filtvars(i).subjects)
	            subjects_string = [subjects_string '''' char(filtvars(i).subjects{j}) ''';'];
                end
                subjects_string = [subjects_string(1:length(subjects_string)) '}']; 
                fprintf(fid,'filtervars(%s).subjects = %s;\n',num2str(i),subjects_string);	    
	    
                fprintf(fid,'filtervars(%s).filter = ''%s'';\n',num2str(i),char(filtvars(i).filter));
                fprintf(fid,'filtervars(%s).frequencies = [%s];\n',num2str(i),num2str(filtvars(i).frequencies));
                fprintf(fid,'filtervars(%s).order = [%s];\n',num2str(i),num2str(filtvars(i).order));
                fprintf(fid,'filtervars(%s).highlowpass = ''%s'';\n',num2str(i),char(filtvars(i).highlowpass));
                fprintf(fid,'filtervars(%s).time_constant = [%s];\n',num2str(i),num2str(filtvars(i).time_constant));
            end
	    fprintf(fid,'\n\nerp = build_filters(erp,filtervars,verbosity);\n');

            fclose(fid);

        end
    end

end

% Closes Filter_Builder window
close(pop_Filter_Builder)


% --- Executes during object creation, after setting all properties.
function Select_Filter_Highlowpass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Filter_Highlowpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_Filter_Highlowpass.
function Select_Filter_Highlowpass_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Filter_Highlowpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Filter_Highlowpass contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Filter_Highlowpass


% --- Executes during object creation, after setting all properties.
function Select_Filter_Type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Filter_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Select_Filter_Type_Callback(hObject, eventdata, handles)
% hObject    handle to New_Filter_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Filter_Type as text
%        str2double(get(hObject,'String')) returns contents of New_Filter_Type as a double

% Gets current filter definition
filter_list = get(handles.Select_Filter_Type,'String');
filter_pos = get(handles.Select_Filter_Type,'Value');
filter_def = char(filter_list(filter_pos));

% Assigns active states of objects, based on current filter state
switch filter_def
    case {'highpass'}
        set_enable(handles,'on','Filter_Proplo','Filter_Proplo_Label','New_Filter_Order','New_Filter_Order_Label');
        set_enable(handles,'off','Filter_Prophi','Filter_Prophi_Label','Select_Filter_Highlowpass', ...
            'Select_Filter_Highlowpass_Label','New_Filter_Time_Constant','New_Filter_Time_Constant_Label');
    case {'lowpass'}
        set_enable(handles,'on','Filter_Prophi','Filter_Prophi_Label','New_Filter_Order','New_Filter_Order_Label');
        set_enable(handles,'off','Filter_Proplo','Filter_Proplo_Label','Select_Filter_Highlowpass', ...
            'Select_Filter_Highlowpass_Label','New_Filter_Time_Constant','New_Filter_Time_Constant_Label');
    case {'bandpass','stopband'}
        set_enable(handles,'on','Filter_Proplo','Filter_Proplo_Label','Filter_Prophi','Filter_Prophi_Label', ...
            'New_Filter_Order','New_Filter_Order_Label');
        set_enable(handles,'off','Select_Filter_Highlowpass','Select_Filter_Highlowpass_Label', ...
            'New_Filter_Time_Constant','New_Filter_Time_Constant_Label');
    case {'sprIIR'}
        set_enable(handles,'on','Select_Filter_Highlowpass','Select_Filter_Highlowpass_Label', ...
            'New_Filter_Time_Constant','New_Filter_Time_Constant_Label');
        set_enable(handles,'off','Filter_Proplo','Filter_Proplo_Label','Filter_Prophi','Filter_Prophi_Label', ...
	    'New_Filter_Order','New_Filter_Order_Label');
    case {'rectify','invert','delete'}
        set_enable(handles,'off','Filter_Proplo','Filter_Proplo_Label','Filter_Prophi','Filter_Prophi_Label', ...
        'New_Filter_Order','New_Filter_Order_Label','Select_Filter_Highlowpass','Select_Filter_Highlowpass_Label', ...
        'New_Filter_Time_Constant','New_Filter_Time_Constant_Label');
end

gui_parameter_change('.filter_builder','filter_type',filter_pos);


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

gui_parameter_change('.filter_builder','load_file',get(hObject,'String'));


% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 % Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.filter_builder.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    set(handles.Load_File,'String',gui_parameters.file_select.selected_file)
    gui_parameter_change('.filter_builder','load_file',get(handles.Load_File,'String'));
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

gui_parameter_change('.filter_builder','verbosity',get(hObject,'Value'));


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

component_pos = get(handles.Filter_Type,'Value');
filter_type = get(handles.Filter_Type,'String');

if component_pos > 1 & component_pos < length(filter_type) % If not already at the top or bottom of the list
    % Gets current lists
    filter_type = get(handles.Filter_Type,'String');
    filter_freqs = get(handles.Filter_Frequencies,'String');
    filter_order = get(handles.Filter_Order,'String');
    filter_highlowpass = get(handles.Filter_Highlowpass,'String');
    filter_time_constant = get(handles.Filter_Time_Constant,'String');
    filter_electrode_list = get(handles.Filter_Electrode_List,'String');
    filter_subject_list = get(handles.Filter_Subject_List,'String');
    
    % Gets current line and line above it
    label_old = filter_type{component_pos}; label_new = filter_type{component_pos-1};
    baseline_old = filter_freqs{component_pos}; baseline_new = filter_freqs{component_pos-1};
    window_old = filter_order{component_pos}; window_new = filter_order{component_pos-1};
    minmax_old = filter_highlowpass{component_pos}; minmax_new = filter_highlowpass{component_pos-1};
    measures_old = filter_time_constant{component_pos}; measures_new = filter_time_constant{component_pos-1};
    electrode_old = filter_electrode_list{component_pos}; electrode_new = filter_electrode_list{component_pos-1};
    subject_old = filter_subject_list{component_pos}; subject_new = filter_subject_list{component_pos-1};
    
    % Switches lines around
    filter_type{component_pos-1} = label_old; filter_type{component_pos} = label_new;
    filter_freqs{component_pos-1} = baseline_old; filter_freqs{component_pos} = baseline_new;
    filter_order{component_pos-1} = window_old; filter_order{component_pos} = window_new;
    filter_highlowpass{component_pos-1} = minmax_old; filter_highlowpass{component_pos} = minmax_new;
    filter_time_constant{component_pos-1} = measures_old; filter_time_constant{component_pos} = measures_new;
    filter_electrode_list{component_pos-1} = electrode_old; filter_electrode_list{component_pos} = electrode_new;
    filter_subject_list{component_pos-1} = subject_old; filter_subject_list{component_pos} = subject_new;
    
    % Sets updated lists
    set(handles.Filter_Type,'String',filter_type)
    set(handles.Filter_Frequencies,'String',filter_freqs)
    set(handles.Filter_Order,'String',filter_order)
    set(handles.Filter_Highlowpass,'String',filter_highlowpass)
    set(handles.Filter_Time_Constant,'String',filter_time_constant)
    set(handles.Filter_Electrode_List,'String',filter_electrode_list)
    set(handles.Filter_Subject_List,'String',filter_subject_list)

    gui_parameter_change('.filter_builder','filter_type_list',get(handles.Filter_Type,'String'));
    gui_parameter_change('.filter_builder','filter_freqs_list',get(handles.Filter_Frequencies,'String'));
    gui_parameter_change('.filter_builder','filter_order_list',get(handles.Filter_Order,'String'));
    gui_parameter_change('.filter_builder','filter_highlowpass_list',get(handles.Filter_Highlowpass,'String'));
    gui_parameter_change('.filter_builder','filter_time_constant_list',get(handles.Filter_Time_Constant,'String'));
    gui_parameter_change('.filter_builder','filter_electrode_list',get(handles.Filter_Electrode_List,'String'));
    gui_parameter_change('.filter_builder','filter_subject_list',get(handles.Filter_Subject_List,'String'));
    
    % Updates list position
    set(handles.Filter_Type,'Value',component_pos-1)
    highlighter(handles.Filter_Type,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

component_pos = get(handles.Filter_Type,'Value');
filter_type = get(handles.Filter_Type,'String');

if component_pos < length(filter_type) - 1 % If not already at the bottom of the list
    % Gets current lists
    filter_type = get(handles.Filter_Type,'String');
    filter_freqs = get(handles.Filter_Frequencies,'String');
    filter_order = get(handles.Filter_Order,'String');
    filter_highlowpass = get(handles.Filter_Highlowpass,'String');
    filter_time_constant = get(handles.Filter_Time_Constant,'String');
    filter_electrode_list = get(handles.Filter_Electrode_List,'String');
    filter_subject_list = get(handles.Filter_Subject_List,'String');

    % Gets current line and line above it
    label_old = filter_type{component_pos}; label_new = filter_type{component_pos+1};
    baseline_old = filter_freqs{component_pos}; baseline_new = filter_freqs{component_pos+1};
    window_old = filter_order{component_pos}; window_new = filter_order{component_pos+1};
    minmax_old = filter_highlowpass{component_pos}; minmax_new = filter_highlowpass{component_pos+1};
    measures_old = filter_time_constant{component_pos}; measures_new = filter_time_constant{component_pos+1};
    electrode_old = filter_electrode_list{component_pos}; electrode_new = filter_electrode_list{component_pos+1};
    subject_old = filter_subject_list{component_pos}; subject_new = filter_subject_list{component_pos+1};
    
    % Switches lines around
    filter_type{component_pos+1} = label_old; filter_type{component_pos} = label_new;
    filter_freqs{component_pos+1} = baseline_old; filter_freqs{component_pos} = baseline_new;
    filter_order{component_pos+1} = window_old; filter_order{component_pos} = window_new;
    filter_highlowpass{component_pos+1} = minmax_old; filter_highlowpass{component_pos} = minmax_new;
    filter_time_constant{component_pos+1} = measures_old; filter_time_constant{component_pos} = measures_new;
    filter_electrode_list{component_pos+1} = electrode_old; filter_electrode_list{component_pos} = electrode_new;
    filter_subject_list{component_pos+1} = subject_old; filter_subject_list{component_pos} = subject_new;
    
    % Sets updated lists
    set(handles.Filter_Type,'String',filter_type)
    set(handles.Filter_Frequencies,'String',filter_freqs)
    set(handles.Filter_Order,'String',filter_order)
    set(handles.Filter_Highlowpass,'String',filter_highlowpass)
    set(handles.Filter_Time_Constant,'String',filter_time_constant)
    set(handles.Filter_Electrode_List,'String',filter_electrode_list)
    set(handles.Filter_Subject_List,'String',filter_subject_list)
    
    gui_parameter_change('.filter_builder','filter_type_list',get(handles.Filter_Type,'String'));
    gui_parameter_change('.filter_builder','filter_freqs_list',get(handles.Filter_Frequencies,'String'));
    gui_parameter_change('.filter_builder','filter_order_list',get(handles.Filter_Order,'String'));
    gui_parameter_change('.filter_builder','filter_highlowpass_list',get(handles.Filter_Highlowpass,'String'));
    gui_parameter_change('.filter_builder','filter_time_constant_list',get(handles.Filter_Time_Constant,'String'));
    gui_parameter_change('.filter_builder','filter_electrode_list',get(handles.Filter_Electrode_List,'String'));
    gui_parameter_change('.filter_builder','filter_subject_list',get(handles.Filter_Subject_List,'String'));
    
    % Updates list position
    set(handles.Filter_Type,'Value',component_pos+1)
    highlighter(handles.Filter_Type,eventdata,handles);
end


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

gui_parameter_change('.filter_builder','component_name',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Filter_Electrode_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Electrode_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Electrode_List.
function Filter_Electrode_List_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Electrode_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Electrode_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Electrode_List

highlighter(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function New_Filter_Electrode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Filter_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Filter_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to New_Filter_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Filter_Electrode as text
%        str2double(get(hObject,'String')) returns contents of New_Filter_Electrode as a double



% --- Executes on button press in Remove_Electrode.
function Remove_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter_electrode_list = get(handles.Filter_Electrode_List,'String');
el_pos = get(handles.Filter_Electrode_List,'Value');
if ischar(filter_electrode_list)
    semicolons = find(filter_electrode_list == ';');
    if isempty(semicolons)
        current_electrode = [filter_electrode_list(1) filter_electrode_list(length(filter_electrode_list))];
    else
        current_electrode = [filter_electrode_list(1:semicolons(length(semicolons))-1) '}'];
    end
    filter_electrode_list = current_electrode;
else
    current_electrode = char(filter_electrode_list(el_pos));
    semicolons = find(current_electrode == ';');
    if isempty(semicolons)
        current_electrode = [current_electrode(1) current_electrode(length(current_electrode))];
    else
        current_electrode = [current_electrode(1:semicolons(length(semicolons))-1) '}'];
    end
    filter_electrode_list(el_pos) = cellstr(current_electrode);
end
set(handles.Filter_Electrode_List,'String',filter_electrode_list)

% --- Executes on button press in Add_Electrode.
function Add_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.New_Filter_Electrode,'String')) ~= 1
    filter_electrode_list = get(handles.Filter_Electrode_List,'String');
    el_pos = get(handles.Filter_Electrode_List,'Value');
    if ischar(filter_electrode_list)
        current_electrode = filter_electrode_list(1:length(filter_electrode_list)-1);
        if length(current_electrode) == 1
            current_electrode = [current_electrode '''' get(handles.New_Filter_Electrode,'String') '''}'];
        else
            current_electrode = [current_electrode ';''' get(handles.New_Filter_Electrode,'String') '''}'];
        end
        filter_electrode_list = current_electrode;
    else
        current_electrode = char(filter_electrode_list(el_pos));
        current_electrode = current_electrode(1:length(current_electrode)-1);
        if length(current_electrode) == 1
            current_electrode = [current_electrode '''' get(handles.New_Filter_Electrode,'String') '''}'];
        else
            current_electrode = [current_electrode ';''' get(handles.New_Filter_Electrode,'String') '''}'];
        end
        filter_electrode_list(el_pos) = cellstr(current_electrode);
    end
    set(handles.Filter_Electrode_List,'String',filter_electrode_list)
    set(handles.New_Filter_Electrode,'String','')
end


% --- Executes during object creation, after setting all properties.
function Filter_Subject_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter_Subject_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Filter_Subject_List.
function Filter_Subject_List_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Subject_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Filter_Subject_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Filter_Subject_List

highlighter(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function New_Filter_Subject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Filter_Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Filter_Subject_Callback(hObject, eventdata, handles)
% hObject    handle to New_Filter_Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Filter_Subject as text
%        str2double(get(hObject,'String')) returns contents of New_Filter_Subject as a double


% --- Executes on button press in Remove_Subject.
function Remove_Subject_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter_subject_list = get(handles.Filter_Subject_List,'String');
sl_pos = get(handles.Filter_Subject_List,'Value');
if ischar(filter_subject_list)
    semicolons = find(filter_subject_list == ';');
    if isempty(semicolons)
        current_electrode = [filter_subject_list(1) filter_subject_list(length(filter_subject_list))];
    else
        current_electrode = [filter_subject_list(1:semicolons(length(semicolons))-1) '}'];
    end
    filter_subject_list = current_electrode;
else
    current_electrode = char(filter_subject_list(sl_pos));
    semicolons = find(current_electrode == ';');
    if isempty(semicolons)
        current_electrode = [current_electrode(1) current_electrode(length(current_electrode))];
    else
        current_electrode = [current_electrode(1:semicolons(length(semicolons))-1) '}'];
    end
    filter_subject_list(sl_pos) = cellstr(current_electrode);
end
set(handles.Filter_Subject_List,'String',filter_subject_list)

% --- Executes on button press in Add_Subject.
function Add_Subject_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.New_Filter_Subject,'String')) ~= 1
    filter_subject_list = get(handles.Filter_Subject_List,'String');
    sl_pos = get(handles.Filter_Subject_List,'Value');
    if ischar(filter_subject_list)
        current_subject = filter_subject_list(1:length(filter_subject_list)-1);
        if length(current_subject) == 1
            current_subject = [current_subject '''' get(handles.New_Filter_Subject,'String') '''}'];
        else
            current_subject = [current_subject ';''' get(handles.New_Filter_Subject,'String') '''}'];
        end
        filter_subject_list = current_subject;
    else
        current_subject = char(filter_subject_list(sl_pos));
        current_subject = current_subject(1:length(current_subject)-1);
        if length(current_subject) == 1
            current_subject = [current_subject '''' get(handles.New_Filter_Subject,'String') '''}'];
        else
            current_subject = [current_subject ';''' get(handles.New_Filter_Subject,'String') '''}'];
        end
        filter_subject_list(sl_pos) = cellstr(current_subject);
    end
    set(handles.Filter_Subject_List,'String',filter_subject_list)
    set(handles.New_Filter_Subject,'String','')
end
