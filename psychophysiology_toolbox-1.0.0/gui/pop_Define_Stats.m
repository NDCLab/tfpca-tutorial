function varargout = pop_Define_Stats(varargin)
% pop_Define_Stats M-file for pop_Define_Stats.fig
%      pop_Define_Stats, by itself, creates a new pop_Define_Stats or raises the existing
%      singleton*.
%
%      H = pop_Define_Stats returns the handle to a new pop_Define_Stats or the handle to
%      the existing singleton*.
%
%      pop_Define_Stats('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Define_Stats.M with the given input arguments.
%
%      pop_Define_Stats('Property','Value',...) creates a new pop_Define_Stats or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Define_Stats_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Define_Stats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Define_Stats

% Last Modified by GUIDE v2.5 04-Jan-2005 12:53:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Define_Stats_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Define_Stats_OutputFcn, ...
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


% --- Executes just before pop_Define_Stats is made visible.
function pop_Define_Stats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Define_Stats (see VARARGIN)

% Choose default command line output for pop_Define_Stats
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_Define_Stats wait for user response (see UIRESUME)
% uiwait(handles.pop_Define_Stats);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','comparisons',[]);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','colormaps',[]);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars.colormaps','difference_colormap','hsv');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars.colormaps','statistical_colormap','gray');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars.colormaps','min_uv','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars.colormaps','max_uv','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars.colormaps','max_p','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars.colormaps','min_p','');

switch gui_parameters.generate_loaddata_loadvars.colormaps.difference_colormap
    case 'hsv'
        set(handles.Difference_Colormap,'Value',1)
    case 'gray'
        set(handles.Difference_Colormap,'Value',2)
    case 'jet'
        set(handles.Difference_Colormap,'Value',3)
    case 'bone'
        set(handles.Difference_Colormap,'Value',4)
    case 'spring'
        set(handles.Difference_Colormap,'Value',5)
    case 'summer'
        set(handles.Difference_Colormap,'Value',6)
    case 'autumn'
        set(handles.Difference_Colormap,'Value',7)
    case 'winter'
        set(handles.Difference_Colormap,'Value',8)
    case 'cool'
        set(handles.Difference_Colormap,'Value',9)
    case 'hot'
        set(handles.Difference_Colormap,'Value',10)
    case 'colorcube'
        set(handles.Difference_Colormap,'Value',11)
    case 'flag'
        set(handles.Difference_Colormap,'Value',12)
    case 'prism'
        set(handles.Difference_Colormap,'Value',13)
    case 'copper'
        set(handles.Difference_Colormap,'Value',14)
    case 'pink'
        set(handles.Difference_Colormap,'Value',15)
    case 'white'
        set(handles.Difference_Colormap,'Value',16)
end

switch gui_parameters.generate_loaddata_loadvars.colormaps.statistical_colormap
    case 'hsv'
        set(handles.Statistical_Colormap,'Value',1)
    case 'gray'
        set(handles.Statistical_Colormap,'Value',2)
    case 'jet'
        set(handles.Statistical_Colormap,'Value',3)
    case 'bone'
        set(handles.Statistical_Colormap,'Value',4)
    case 'spring'
        set(handles.Statistical_Colormap,'Value',5)
    case 'summer'
        set(handles.Statistical_Colormap,'Value',6)
    case 'autumn'
        set(handles.Statistical_Colormap,'Value',7)
    case 'winter'
        set(handles.Statistical_Colormap,'Value',8)
    case 'cool'
        set(handles.Statistical_Colormap,'Value',9)
    case 'hot'
        set(handles.Statistical_Colormap,'Value',10)
    case 'colorcube'
        set(handles.Statistical_Colormap,'Value',11)
    case 'flag'
        set(handles.Statistical_Colormap,'Value',12)
    case 'prism'
        set(handles.Statistical_Colormap,'Value',13)
    case 'copper'
        set(handles.Statistical_Colormap,'Value',14)
    case 'pink'
        set(handles.Statistical_Colormap,'Value',15)
    case 'white'
        set(handles.Statistical_Colormap,'Value',16)
end

    set(handles.Min_uv,'String',gui_parameters.generate_loaddata_loadvars.colormaps.min_uv)
    set(handles.Max_uv,'String',gui_parameters.generate_loaddata_loadvars.colormaps.max_uv)
    set(handles.Max_P,'String',gui_parameters.generate_loaddata_loadvars.colormaps.max_p)
    set(handles.Min_P,'String',gui_parameters.generate_loaddata_loadvars.colormaps.min_p)

    if ~isempty(gui_parameters.generate_loaddata_loadvars.comparisons)
	    comparisons_cell = [];
        for i = 1:length(gui_parameters.generate_loaddata_loadvars.comparisons)
            comparisons_cell{i,1} = gui_parameters.generate_loaddata_loadvars.comparisons(i).label;
        end
        set(handles.Stat_List,'String',comparisons_cell)
        Stat_List_Callback(handles.Stat_List,eventdata,handles);  
    end

assignin('base','gui_parameters',gui_parameters)

% --- Outputs from this function are returned to the command line.
function varargout = pop_Define_Stats_OutputFcn(hObject, eventdata, handles)
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
set(handles.Stat_Expression,'Value',get(hObject,'Value'))
set(handles.Stat_Label,'Value',get(hObject,'Value'))


% Resets all dialog boxes
function reset_all(hObject,eventdata,handles)
set(handles.Stat_Value,'Value',1)
set(handles.Stat_Expression,'Value',1)
set(handles.Stat_Label,'Value',1)
set(handles.Stat_Value,'String',cellstr(' '))
set(handles.Stat_Expression,'String',cellstr(' '))
set(handles.Stat_Label,'String',cellstr(' '))


% Updates a given Stat definition
function update_Stat(hObject,eventdata,handles,stat_def)
if ~ischar(stat_def); stat_def = char(stat_def); end
gui_parameter_change('.generate_loaddata_loadvars',['comparisons(' stat_def ').stats'],get(handles.Stat_Value,'String'));
gui_parameter_change('.generate_loaddata_loadvars',['comparisons(' stat_def ').set.label'],get(handles.Stat_Label,'String'));
gui_parameter_change('.generate_loaddata_loadvars',['comparisons(' stat_def ').set.var.crit'],get(handles.Stat_Expression,'String'));

value_pos = get(handles.New_Value,'Value'); % Assigns within/between variable, based on New_Value selection
switch value_pos
    case {1,2,3,4,5}
        gui_parameter_change('.generate_loaddata_loadvars',['comparisons(' stat_def ').type'],'between-subjects');
    case {6,7}
        gui_parameter_change('.generate_loaddata_loadvars',['comparisons(' stat_def ').type'],'within-subjects');
end

new_length = length(get(handles.Stat_Label,'String'));
set(handles.Stat_Label,'Value',new_length)
highlighter(handles.Stat_Label,eventdata,handles)

% Sets enable property of various handles
function set_enable(handles,state,varargin)
for i = 1:length(varargin)
    eval(['set(handles.' varargin{i} ',''Enable'',''' state ''')'])
end


% --- Executes during object creation, after setting all properties.
function Stat_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stat_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stat_Value.
function Stat_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Stat_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stat_Value contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stat_Value

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Stat_Expression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stat_Expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stat_Expression.
function Stat_Expression_Callback(hObject, eventdata, handles)
% hObject    handle to Stat_Expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stat_Expression contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stat_Expression

highlighter(hObject,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function Stat_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stat_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stat_Label.
function Stat_Label_Callback(hObject, eventdata, handles)
% hObject    handle to Stat_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stat_Label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stat_Label

highlighter(hObject,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function New_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Value_Callback(hObject, eventdata, handles)
% hObject    handle to New_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Value as text
%        str2double(get(hObject,'String')) returns contents of New_Value as a double

% Updates Stat_Value box, depending on selection
value_pos = get(handles.New_Value,'Value');
switch value_pos
    case {1,6}
        value_def = 'ttest';
    case {2,7}
        value_def = 'wilcoxon';
    case 3
        value_def = 'anova';
    case 4
        value_def = 'kruskalwallis';
    case 5
        value_def = 'correlation';
end

set(handles.Stat_Value,'String',value_def)

switch value_pos
    case {1,2,3,4,5}
        type_def = 'between-subjects';
    case {6,7}
        type_def = 'within-subjects';
end


% Updates current stat in Stat_List, if it exists
stat_list = get(handles.Stat_List,'String');
if ~isempty(stat_list)
    stat_def = num2str(get(handles.Stat_List,'Value'));
    gui_parameter_change(['.generate_loaddata_loadvars.comparisons(' stat_def ')'],'stats',value_def);
    gui_parameter_change(['.generate_loaddata_loadvars.comparisons(' stat_def ')'],'type',type_def);
end


% --- Executes on button press in Clear_All_Value.
function Clear_All_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_all(hObject,eventdata,handles);

% --- Executes on button press in Add_Value.
function Add_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.New_Label,'String')) ~= 1 & isempty(get(handles.New_Expression,'String')) ~= 1
    
    stat_expression = get(handles.Stat_Expression,'String');
    if ischar(stat_expression); stat_expression = cellstr(stat_expression); end
    length_ar = length(stat_expression);
    stat_expression{length_ar} = get(handles.New_Expression,'String');
    stat_expression{length_ar+1} = ' ';
    set(handles.Stat_Expression,'String',stat_expression)
    set(handles.New_Expression,'String','')
    
    stat_label = get(handles.Stat_Label,'String');
    if ischar(stat_label); stat_label = cellstr(stat_label); end
    length_al = length(stat_label);
    stat_label{length_al} = get(handles.New_Label,'String');
    stat_label{length_al+1} = ' ';
    set(handles.Stat_Label,'String',stat_label)
    set(handles.New_Label,'String','')

    set(handles.Stat_Label,'Value',length_al+1)
    highlighter(handles.Stat_Label,eventdata,handles)
    
    stat_list = get(handles.Stat_List,'String');
    if isempty(stat_list) ~= 1
        stat_def = num2str(get(handles.Stat_List,'Value'));
        update_Stat(hObject,eventdata,handles,stat_def);
    end
    
end

% --- Executes on button press in Remove_Value.
function Remove_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stat_label = get(handles.Stat_Label,'String');
stat_label = stat_label(get(handles.Stat_Label,'Value'));
if strcmp(stat_label,' ') ~= 1

    % Gets position of highlighted pass, then deletes it
    arlist_pos = get(handles.Stat_Expression,'Value');
    stat_expression = get(handles.Stat_Expression,'String');
    if iscell(stat_expression) ~= 1; stat_expression = cellstr(stat_expression); end
    if isempty(stat_expression) ~= 1; stat_expression(arlist_pos) = []; end
    if arlist_pos > 1; set(handles.Stat_Expression,'Value',arlist_pos-1); end
    set(handles.Stat_Expression,'String',stat_expression)

    allist_pos = get(handles.Stat_Label,'Value');
    stat_label = get(handles.Stat_Label,'String');
    if iscell(stat_label) ~= 1; stat_label = cellstr(stat_label); end
    if isempty(stat_label) ~= 1; stat_label(allist_pos) = []; end
    if allist_pos > 1; set(handles.Stat_Label,'Value',allist_pos-1); end
    set(handles.Stat_Label,'String',stat_label)

    stat_list = get(handles.Stat_List,'String');
    if isempty(stat_list) ~= 1
        stat_def = num2str(get(handles.Stat_List,'Value'));
        update_Stat(hObject,eventdata,handles,stat_def);
    end

end

% --- Executes during object creation, after setting all properties.
function Stat_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stat_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stat_List.
function Stat_List_Callback(hObject, eventdata, handles)
% hObject    handle to Stat_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stat_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stat_List

gui_parameters = evalin('base','gui_parameters');
stat_list = get(handles.Stat_List,'String');
stat_pos = get(handles.Stat_List,'Value');
stat_def = num2str(stat_pos);
set(handles.Stat_Value,'String',eval(['gui_parameters.generate_loaddata_loadvars.comparisons(' stat_def ').stats']))
set(handles.Stat_Label,'String',eval(['gui_parameters.generate_loaddata_loadvars.comparisons(' stat_def ').set.label']))
set(handles.Stat_Expression,'String',eval(['gui_parameters.generate_loaddata_loadvars.comparisons(' stat_def ').set.var.crit']))
assignin('base','gui_parameters',gui_parameters)
set(handles.Stat_Label,'Value',length(get(handles.Stat_Label,'String')))
highlighter(handles.Stat_Label,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function New_Stat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Stat_Callback(hObject, eventdata, handles)
% hObject    handle to New_Stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Stat as text
%        str2double(get(hObject,'String')) returns contents of New_Stat as a double


% --- Executes on button press in Run_Script.
function Run_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameter_change('.generate_loaddata_loadvars','generate_script',get(hObject,'Value'));


% --- Executes on button press in Remove_Stat.
function Remove_Stat_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.Stat_List,'String'))
    gui_parameters = evalin('base','gui_parameters');
    stat_list = get(handles.Stat_List,'String');
    stat_pos = get(handles.Stat_List,'Value');
    stat_def = num2str(stat_pos);
    eval(['gui_parameters.generate_loaddata_loadvars.comparisons(' stat_def ') = [];'])
    if iscell(stat_list) ~= 1; stat_list = cellstr(stat_list); end
    if isempty(stat_list) ~= 1; stat_list(stat_pos) = []; end
    if stat_pos > 1; set(handles.Stat_List,'Value',stat_pos-1); end
    set(handles.Stat_List,'String',stat_list)
    assignin('base','gui_parameters',gui_parameters)
    reset_all(hObject,eventdata,handles);
    Stat_List_Callback(handles.Stat_List,eventdata,handles);  
end


% --- Executes on button press in Add_Stat.
function Add_Stat_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Assigns existing variables to current stat_temp, then resets listboxes for new AT
% definition
if ~isempty(get(handles.New_Stat,'String'))

    % Updates old stat entry, if it exists
    stat_list = get(handles.Stat_List,'String');
    if ~isempty(stat_list)
        stat_pos = get(handles.Stat_List,'Value');
        stat_def = num2str(stat_pos);
        update_Stat(hObject,eventdata,handles,stat_def)
        reset_all(hObject,eventdata,handles);
    else
        stat_pos = 0;
    end


    % Adds new stat entry
    stat_def = num2str(length(cellstr(stat_list))+1);
    gui_parameters = evalin('base','gui_parameters');
    gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars',['comparisons(' stat_def ').label'],get(handles.New_Stat,'String'));
    gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars',['comparisons(' stat_def ').stats'],' ');
    gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars',['comparisons(' stat_def ').type'],' ');
    gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars',['comparisons(' stat_def ').set.label'],' ');
    gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars',['comparisons(' stat_def ').set.var.crit'],' ');

    assignin('base','gui_parameters',gui_parameters)
   
    % Updates Stat_List
    if ~isempty(stat_list)
    	stat_list{length(cellstr(stat_list))+1} = get(handles.New_Stat,'String');
    else
        stat_list{1} = get(handles.New_Stat,'String');
    end
    set(handles.Stat_List,'String',stat_list)
    set(handles.Stat_List,'Value',stat_pos+1)
    set(handles.New_Stat,'String','')
    Stat_List_Callback(handles.Stat_List,eventdata,handles);
end


% --- Executes on button press in Update_Stat.
function Update_Stat_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stat_list = get(handles.Stat_List,'String')
stat_pos = get(handles.Stat_List,'Value')
stat_def = num2str(stat_pos);
update_Stat(hObject,eventdata,handles,stat_def);
new_length = length(get(handles.Stat_Label,'String'));
set(handles.Stat_Label,'Value',new_length)
highlighter(handles.Stat_Label,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function Difference_Colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Difference_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Difference_Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to Difference_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Difference_Colormap as text
%        str2double(get(hObject,'String')) returns contents of Difference_Colormap as a double

switch get(hObject,'Value')
    case 1
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','hsv');
    case 2
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','gray');
    case 3
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','jet');
   case 4
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','bone');
    case 5
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','spring');
    case 6
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','summer');
    case 7
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','autumn');
    case 8
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','winter');
    case 9
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','cool');
    case 10
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','hot');
    case 11
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','colorcube');
    case 12
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','flag');
    case 13
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','prism');
    case 14
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','copper');
    case 15
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','pink');
    case 16
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','difference_colormap','white');
end


% --- Executes during object creation, after setting all properties.
function Statistical_Colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Statistical_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Statistical_Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to Statistical_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Statistical_Colormap as text
%        str2double(get(hObject,'String')) returns contents of Statistical_Colormap as a double

switch get(hObject,'Value')
    case 1
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','hsv');
    case 2
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','gray');
    case 3
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','jet');
   case 4
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','bone');
    case 5
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','spring');
    case 6
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','summer');
    case 7
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','autumn');
    case 8
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','winter');
    case 9
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','cool');
    case 10
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','hot');
    case 11
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','colorcube');
    case 12
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','flag');
    case 13
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','prism');
    case 14
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','copper');
    case 15
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','pink');
    case 16
        gui_parameter_change('.generate_loaddata_loadvars.colormaps','statistical_colormap','white');
end


% --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Closes window
close(pop_Define_Stats)



% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stat_pos = get(handles.Stat_Label,'Value');
stat_label = get(handles.Stat_Label,'String');

if stat_pos > 1 & stat_pos < length(stat_label) % If not at top or bottom of list
    % Gets current lists
    stat_label = get(handles.Stat_Label,'String');
    stat_expression = get(handles.Stat_Expression,'String');
    
    % Gets relevant lines
    label_old = stat_label{stat_pos}; label_new = stat_label{stat_pos-1};
    expression_old = stat_expression{stat_pos}; expression_new = stat_expression{stat_pos-1};
    
    % Switches lines
    stat_label{stat_pos-1} = label_old; stat_label{stat_pos} = label_new;
    stat_expression{stat_pos-1} = expression_old; stat_expression{stat_pos} = expression_new;
    
    % Sets list boxes
    set(handles.Stat_Label,'String',stat_label)
    set(handles.Stat_Expression,'String',stat_expression)
    
    
    stat_list = get(handles.Stat_List,'String');
    if isempty(stat_list) ~= 1
        stat_def = num2str(get(handles.Stat_List,'Value'));
        update_Stat(hObject,eventdata,handles,stat_def);
    end
    
    % Updates highlighted position
    set(handles.Stat_Label,'Value',stat_pos-1)
    highlighter(handles.Stat_Label,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stat_pos = get(handles.Stat_Label,'Value');
stat_label = get(handles.Stat_Label,'String');

if stat_pos < length(stat_label) - 1 % If not at top or bottom of list
    % Gets current lists
    stat_label = get(handles.Stat_Label,'String');
    stat_expression = get(handles.Stat_Expression,'String');

    % Gets relevant lines
    label_old = stat_label{stat_pos}; label_new = stat_label{stat_pos+1};
    expression_old = stat_expression{stat_pos}; expression_new = stat_expression{stat_pos+1};

    % Switches lines
    stat_label{stat_pos+1} = label_old; stat_label{stat_pos} = label_new;
    stat_expression{stat_pos+1} = expression_old; stat_expression{stat_pos} = expression_new;

    % Sets list boxes
    set(handles.Stat_Label,'String',stat_label)
    set(handles.Stat_Expression,'String',stat_expression)

    stat_list = get(handles.Stat_List,'String');
    if isempty(stat_list) ~= 1
        stat_def = num2str(get(handles.Stat_List,'Value'));
        update_Stat(hObject,eventdata,handles,stat_def);
    end

    % Updates highlighted position
    set(handles.Stat_Label,'Value',stat_pos+1)
    highlighter(handles.Stat_Label,eventdata,handles);
end


% --- Executes during object creation, after setting all properties.
function New_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Label_Callback(hObject, eventdata, handles)
% hObject    handle to New_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Label as text
%        str2double(get(hObject,'String')) returns contents of New_Label as a double


% --- Executes during object creation, after setting all properties.
function New_Expression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Expression_Callback(hObject, eventdata, handles)
% hObject    handle to New_Expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Expression as text
%        str2double(get(hObject,'String')) returns contents of New_Expression as a double


% --- Executes during object creation, after setting all properties.
function Max_P_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Max_P_Callback(hObject, eventdata, handles)
% hObject    handle to Max_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_P as text
%        str2double(get(hObject,'String')) returns contents of Max_P as a double

gui_parameter_change('.generate_loaddata_loadvars.colormaps','max_p',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Min_P_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Min_P_Callback(hObject, eventdata, handles)
% hObject    handle to Min_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_P as text
%        str2double(get(hObject,'String')) returns contents of Min_P as a double

gui_parameter_change('.generate_loaddata_loadvars.colormaps','min_p',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Min_uv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Min_uv_Callback(hObject, eventdata, handles)
% hObject    handle to Min_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_uv as text
%        str2double(get(hObject,'String')) returns contents of Min_uv as a double

gui_parameter_change('.generate_loaddata_loadvars.colormaps','min_uv',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Max_uv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Max_uv_Callback(hObject, eventdata, handles)
% hObject    handle to Max_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_uv as text
%        str2double(get(hObject,'String')) returns contents of Max_uv as a double

gui_parameter_change('.generate_loaddata_loadvars.colormaps','max_uv',get(hObject,'String'));

