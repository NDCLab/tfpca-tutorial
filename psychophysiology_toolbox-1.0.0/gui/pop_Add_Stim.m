function varargout = pop_Add_Stim(varargin)
% pop_Add_Stim M-file for pop_Add_Stim.fig
%      pop_Add_Stim, by itself, creates a new pop_Add_Stim or raises the existing
%      singleton*.
%
%      H = pop_Add_Stim returns the handle to a new pop_Add_Stim or the handle to
%      the existing singleton*.
%
%      pop_Add_Stim('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Add_Stim.M with the given input arguments.
%
%      pop_Add_Stim('Property','Value',...) creates a new pop_Add_Stim or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Add_Stim_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Add_Stim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Add_Stim

% Last Modified by GUIDE v2.5 10-Dec-2004 08:43:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Add_Stim_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Add_Stim_OutputFcn, ...
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


% --- Executes just before pop_Add_Stim is made visible.
function pop_Add_Stim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Add_Stim (see VARARGIN)

% Choose default command line output for pop_Add_Stim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pop_Add_Stim wait for user response (see UIRESUME)
% uiwait(handles.pop_Add_Stim);

% Sets some defaults
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','run_script',0);
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','script_file','generate_stim_script');
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','definitions',struct);
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','trialnums',struct);
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','called_from_import_data',0);

    set(handles.Load_File,'String',gui_parameters.add_stim.load_file)
    set(handles.Run_Script,'Value',gui_parameters.add_stim.run_script)
    set(handles.Script_File,'String',gui_parameters.add_stim.script_file)
    set(handles.Stim_List,'String',fieldnames(gui_parameters.add_stim.definitions));
    Stim_List_Callback(handles.Stim_List,eventdata,handles);
        
assignin('base','gui_parameters',gui_parameters)
    
% --- Outputs from this function are returned to the command line.
function varargout = pop_Add_Stim_OutputFcn(hObject, eventdata, handles)
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
set(handles.Stim_Value,'Value',get(hObject,'Value'))
set(handles.Stim_Expression,'Value',get(hObject,'Value'))
set(handles.Stim_Label,'Value',get(hObject,'Value'))


% Resets all dialog boxes
function reset_all(hObject,eventdata,handles)
set(handles.Stim_Value,'Value',1)
set(handles.Stim_Expression,'Value',1)
set(handles.Stim_Label,'Value',1)
set(handles.Stim_Value,'String',cellstr(' '))
set(handles.Stim_Expression,'String',cellstr(' '))
set(handles.Stim_Label,'String',cellstr(' '))


% Updates a given stim definition
function update_Stim(hObject,eventdata,handles,stim_def)
if ischar(stim_def) ~= 1; stim_def = char(stim_def); end
gui_parameter_change('.add_stim',['definitions.' stim_def '.label'],get(handles.Stim_Label,'String'));
gui_parameter_change('.add_stim',['definitions.' stim_def '.value'],get(handles.Stim_Value,'String'));
gui_parameter_change('.add_stim',['definitions.' stim_def '.expression'],get(handles.Stim_Expression,'String'));
new_length = length(get(handles.Stim_Label,'String'));
set(handles.Stim_Label,'Value',new_length)
highlighter(handles.Stim_Label,eventdata,handles)

% Sets enable property of various handles
function set_enable(handles,state,varargin)
for i = 1:length(varargin)
    eval(['set(handles.' varargin{i} ',''Enable'',''' state ''')'])
end


% --- Executes during object creation, after setting all properties.
function Stim_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stim_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stim_Value.
function Stim_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Stim_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stim_Value contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stim_Value

highlighter(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function Stim_Expression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stim_Expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stim_Expression.
function Stim_Expression_Callback(hObject, eventdata, handles)
% hObject    handle to Stim_Expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stim_Expression contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stim_Expression

highlighter(hObject,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function Stim_Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stim_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Stim_Label.
function Stim_Label_Callback(hObject, eventdata, handles)
% hObject    handle to Stim_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stim_Label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stim_Label

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

if isempty(get(handles.New_Label,'String')) ~= 1 & isempty(get(handles.New_Value,'String')) ~= 1 & ...
   isempty(get(handles.New_Expression,'String')) ~= 1
    
    stim_value = get(handles.Stim_Value,'String');
    if ischar(stim_value); stim_value = cellstr(stim_value); end
    length_am = length(stim_value);
    stim_value{length_am} = get(handles.New_Value,'String');
    stim_value{length_am+1} = ' ';
    set(handles.Stim_Value,'String',stim_value)
    set(handles.New_Value,'String','')
    
    stim_expression = get(handles.Stim_Expression,'String');
    if ischar(stim_expression); stim_expression = cellstr(stim_expression); end
    length_ar = length(stim_expression);
    stim_expression{length_ar} = get(handles.New_Expression,'String');
    stim_expression{length_ar+1} = ' ';
    set(handles.Stim_Expression,'String',stim_expression)
    set(handles.New_Expression,'String','')
    
    stim_label = get(handles.Stim_Label,'String');
    if ischar(stim_label); stim_label = cellstr(stim_label); end
    length_al = length(stim_label);
    stim_label{length_al} = get(handles.New_Label,'String');
    stim_label{length_al+1} = ' ';
    set(handles.Stim_Label,'String',stim_label)
    set(handles.New_Label,'String','')

    set(handles.Stim_Label,'Value',length_al+1)
    highlighter(handles.Stim_Label,eventdata,handles)
    
    stim_list = get(handles.Stim_List,'String');
    if isempty(stim_list) ~= 1
        stim_def = char(stim_list(get(handles.Stim_List,'Value')));
        update_Stim(hObject,eventdata,handles,stim_def);
    end
end

% --- Executes on button press in Remove_Value.
function Remove_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stim_label = get(handles.Stim_Label,'String');
stim_label = stim_label(get(handles.Stim_Label,'Value'));
if strcmp(stim_label,' ') ~= 1

    % Gets position of highlighted pass, then deletes it
    amlist_pos = get(handles.Stim_Value,'Value');
    stim_value = get(handles.Stim_Value,'String');
    if iscell(stim_value) ~= 1; stim_value = cellstr(stim_value); end
    if isempty(stim_value) ~= 1; stim_value(amlist_pos) = []; end
    if amlist_pos > 1; set(handles.Stim_Value,'Value',amlist_pos-1); end
    set(handles.Stim_Value,'String',stim_value)

    arlist_pos = get(handles.Stim_Expression,'Value');
    stim_expression = get(handles.Stim_Expression,'String');
    if iscell(stim_expression) ~= 1; stim_expression = cellstr(stim_expression); end
    if isempty(stim_expression) ~= 1; stim_expression(arlist_pos) = []; end
    if arlist_pos > 1; set(handles.Stim_Expression,'Value',arlist_pos-1); end
    set(handles.Stim_Expression,'String',stim_expression)

    allist_pos = get(handles.Stim_Label,'Value');
    stim_label = get(handles.Stim_Label,'String');
    if iscell(stim_label) ~= 1; stim_label = cellstr(stim_label); end
    if isempty(stim_label) ~= 1; stim_label(allist_pos) = []; end
    if allist_pos > 1; set(handles.Stim_Label,'Value',allist_pos-1); end
    set(handles.Stim_Label,'String',stim_label)
 
    stim_list = get(handles.Stim_List,'String');
    if isempty(stim_list) ~= 1
        stim_def = char(stim_list(get(handles.Stim_List,'Value')));
        update_Stim(hObject,eventdata,handles,stim_def);
    end

end

% --- Executes during object creation, after setting all properties.
function Stim_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stim_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in Stim_List.
function Stim_List_Callback(hObject, eventdata, handles)
% hObject    handle to Stim_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)    stim_list = get(handles.Stim_List,'String');
% Hints: contents = get(hObject,'String') returns Stim_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stim_List

gui_parameters = evalin('base','gui_parameters');
stim_list = get(handles.Stim_List,'String');
if ~isempty(stim_list)
    stim_pos = get(handles.Stim_List,'Value');
    stim_def = char(stim_list(stim_pos));
    set(handles.Stim_Value,'String',eval(['gui_parameters.add_stim.definitions.' stim_def '.value']))
    set(handles.Stim_Expression,'String',eval(['gui_parameters.add_stim.definitions.' stim_def '.expression']))
    set(handles.Stim_Label,'String',eval(['gui_parameters.add_stim.definitions.' stim_def '.label']))
    set(handles.Stim_Label,'Value',length(get(handles.Stim_Label,'String')))
    highlighter(handles.Stim_Label,eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function New_Stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to New_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Stim as text
%        str2double(get(hObject,'String')) returns contents of New_Stim as a double


% --- Executes on button press in Run_Script.
function Run_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameter_change('.add_stim','run_script',get(hObject,'Value'));


% --- Executes on button press in Remove_Stim.
function Remove_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.Stim_List,'String'))
    gui_parameters = evalin('base','gui_parameters');
    stim_list = get(handles.Stim_List,'String');
    stim_pos = get(handles.Stim_List,'Value');
    stim_def = char(stim_list(stim_pos));
    gui_parameters.add_stim.definitions = rmfield(gui_parameters.add_stim.definitions,stim_def);
    assignin('base','gui_parameters',gui_parameters)
    if iscell(stim_list) ~= 1; stim_list = cellstr(stim_list); end
    if isempty(stim_list) ~= 1; stim_list(stim_pos) = []; end
    if stim_pos > 1; set(handles.Stim_List,'Value',stim_pos-1); end
    set(handles.Stim_List,'String',stim_list)
    assignin('base','gui_parameters',gui_parameters)
    reset_all(hObject,eventdata,handles);
    Stim_List_Callback(handles.Stim_List,eventdata,handles);
end


% --- Executes on button press in Add_Stim.
function Add_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameters = evalin('base','gui_parameters');
% Assigns existing variables to current stim_temp, then resets listboxes for new AT
% definition
if isempty(get(handles.New_Stim,'String')) ~= 1

    % Adds new stim entry
    gui_parameters = gui_parameter_default(gui_parameters,'.add_stim.definitions',get(handles.New_Stim,'String'),[]);
    gui_parameters = gui_parameter_default(gui_parameters,['.add_stim.definitions.' get(handles.New_Stim,'String')],'label',' ');
    gui_parameters = gui_parameter_default(gui_parameters,['.add_stim.definitions.' get(handles.New_Stim,'String')],'value',' ');
    gui_parameters = gui_parameter_default(gui_parameters,['.add_stim.definitions.',get(handles.New_Stim,'String')],'expression',' ');
    assignin('base','gui_parameters',gui_parameters)

    % Updates old stim entry, if it exists
    stim_list = get(handles.Stim_List,'String');
    if isempty(stim_list) ~= 1
        stim_pos = get(handles.Stim_List,'Value');
        stim_def = stim_list(stim_pos);
        update_Stim(hObject,eventdata,handles,stim_def);
        reset_all(hObject,eventdata,handles);
    else
	stim_pos = 0;
    end

    % Updates Stim_List
    if ~isempty(stim_list)
        stim_list{length(cellstr(stim_list))+1} = get(handles.New_Stim,'String');
    else
        stim_list{1} = get(handles.New_Stim,'String');
    end
    set(handles.Stim_List,'String',stim_list)
    set(handles.Stim_List,'Value',stim_pos+1)
    set(handles.New_Stim,'String','')
    Stim_List_Callback(handles.Stim_List,eventdata,handles);

end


% --- Executes on button press in Update_Stim.
function Update_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stim_list = get(handles.Stim_List,'String');
stim_def = stim_list(get(handles.Stim_List,'Value'));
update_Stim(hObject,eventdata,handles,stim_def);
new_length = length(get(handles.Stim_Label,'String'));
set(handles.Stim_Label,'Value',new_length)
highlighter(handles.Stim_Label,eventdata,handles);


% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.add_stim.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls directory selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    set(handles.Load_File,'String',gui_parameters.file_select.selected_file)
    gui_parameter_change('.add_stim','load_file',get(handles.Load_File,'String'));
end

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

gui_parameter_change('.add_stim','load_file',get(hObject,'String'));


% --- Executes on button press in Browse_Script_File.
function Browse_Script_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.add_stim.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets file name
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file) ~= 1
    file_name = gui_parameters.file_select.selected_file;
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))+1);
    gui_parameter_change('.add_stim','script_file',file_name);
    set(handles.Script_File,'String',file_name)
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

gui_parameter_change('.add_stim','script_file',get(handles.Script_File,'String'));


% --- Executes on button press in Generate_Stim.
function Generate_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameters = evalin('base','gui_parameters');
if isempty(get(handles.Load_File,'String')) ~= 1 & isempty(get(handles.Script_File,'String')) ~= 1 & ...
        gui_parameters.add_stim.called_from_import_data ~= 1

    if get(handles.Run_Script,'Value') % Runs script, then closes window
        run([get(handles.Load_File,'String') filesep get(handles.Script_File,'String') '.m']);
    else

        stim_list = get(handles.Stim_List,'String');
        stimvars = [];

        for i = 1:length(stim_list) % Iterates through each erp.stim subfield

            stimvars(i).name = char(stim_list(i));
            stim_label = eval(['gui_parameters.add_stim.definitions.' char(stim_list(i)) '.label']);
            stim_value = eval(['gui_parameters.add_stim.definitions.' char(stim_list(i)) '.value']);
            stim_expression = strrep(eval(['gui_parameters.add_stim.definitions.' char(stim_list(i)) '.expression']),'''','''''');

            for j = 1:length(stim_label) - 1 % Iterates through each value for this subfield
                stimvars(i).catcodes(j).name = char(stim_value(j));
                stimvars(i).catcodes(j).text = char(stim_expression(j));
                stimvars(i).catcodes(j).description = char(stim_label(j));
            end            

        end

        load(get(handles.Load_File,'String'));
        if ~isempty(stimvars), erp = generate_stimvars(erp,stimvars); end

        % Generates trialnums variables, if defined
        trialnums = gui_parameters.add_stim.trialnums;
        if ~isempty(trialnums), erp = generate_trialcounts(erp,trialnums); end % If trial number list specified to be written out

        % Writes out a lovely script to create the erp.stim subfields
        if isempty(get(handles.Load_File,'String')) ~= 1 & isempty(get(handles.Script_File,'String')) ~= 1

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
                fprintf(fid,'%% GENERATES NON-TRIAL NUMBER erp.stim SUBFIELDS\n');

                stim_list = get(handles.Stim_List,'String');
                fprintf(fid,'stimvars = [];');

                for i = 1:length(stim_list) % Iterates through each erp.stim subfield

                    fprintf(fid,'\nstimvars(%s).name = ''%s'';\n\n',num2str(i),char(stim_list(i)));
                    stim_label = eval(['gui_parameters.add_stim.definitions.' char(stim_list(i)) '.label']);
                    stim_value = eval(['gui_parameters.add_stim.definitions.' char(stim_list(i)) '.value']);
                    stim_expression = strrep(eval(['gui_parameters.add_stim.definitions.' char(stim_list(i)) '.expression']),'''','''''');

                    for j = 1:length(stim_label) - 1 % Iterates through each value for this subfield
                        fprintf(fid,'stimvars(%s).catcodes(%s).name = ''%s'';\n',num2str(i),num2str(j),char(stim_value(j)));
                        fprintf(fid,'stimvars(%s).catcodes(%s).text = ''%s'';\n',num2str(i),num2str(j),char(stim_expression(j)));
                        fprintf(fid,'stimvars(%s).catcodes(%s).description = ''%s'';\n\n',num2str(i),num2str(j),char(stim_label(j)));
                    end

                end

                fprintf(fid,'\nload(''%s'');\n',get(handles.Load_File,'String')); % DELETE THIS!
                if ~isempty(stimvars), fprintf(fid,'erp = generate_stimvars(erp,stimvars);\n\n'); end

                if ~isempty(trialnums) % If trial number list specified to be written out
                    fprintf(fid,'%% GENERATES TRIAL NUMBER erp.stim SUBFIELDS\n');
                    trialnums = gui_parameters.add_stim.trialnums;
	
                    for i = 1:length(trialnums)

                        fprintf(fid,'\ntrialnums(%s).name = ''%s'';\n',num2str(i),trialnums(i).name);
                        current_chunks = trialnums(i).text;
                        chunk_string = '{';
	 
                        for j = 1:length(current_chunks), chunk_string = [chunk_string '''' char(current_chunks(j)) ''';']; end
                        chunk_string = [chunk_string(1:length(chunk_string)-1) '}'];
                        fprintf(fid,'trialnums(%s).text = %s;\n',num2str(i),chunk_string);
	
	             end   
		
                    fprintf(fid,'\nerp = generate_trialcounts(erp,trialnums);\n'); % If trial number list specified to be written out

                end
            
                fclose(fid);

            end

        end

        gui_parameter_change('.add_stim','trialnums',[]);

    end

end

% Closes Add_Stim window
close(pop_Add_Stim)


% --- Executes on button press in Set_Trials.
function Set_Trials_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Add_Stim_Trials;


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stim_pos = get(handles.Stim_Label,'Value');
stim_label = get(handles.Stim_Label,'String');

if stim_pos > 1 & stim_pos < length(stim_label) % If not at top or bottom of list
    % Gets current lists
    stim_label = get(handles.Stim_Label,'String');
    stim_value = get(handles.Stim_Value,'String');
    stim_expression = get(handles.Stim_Expression,'String');
    
    % Gets relevant lines
    label_old = stim_label{stim_pos}; label_new = stim_label{stim_pos-1};
    value_old = stim_value{stim_pos}; value_new = stim_value{stim_pos-1};
    expression_old = stim_expression{stim_pos}; expression_new = stim_expression{stim_pos-1};
    
    % Switches lines
    stim_label{stim_pos-1} = label_old; stim_label{stim_pos} = label_new;
    stim_value{stim_pos-1} = value_old; stim_value{stim_pos} = value_new;
    stim_expression{stim_pos-1} = expression_old; stim_expression{stim_pos} = expression_new;
    
    % Sets list boxes
    set(handles.Stim_Label,'String',stim_label)
    set(handles.Stim_Value,'String',stim_value)
    set(handles.Stim_Expression,'String',stim_expression)
    
    stim_list = get(handles.Stim_List,'String');
    if isempty(stim_list) ~= 1
        stim_def = char(stim_list(get(handles.Stim_List,'Value')));
        update_Stim(hObject,eventdata,handles,stim_def);
    end
    
    % Updates highlighted position
        set(handles.Stim_Label,'Value',stim_pos-1)
    highlighter(handles.Stim_Label,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stim_pos = get(handles.Stim_Label,'Value');
stim_label = get(handles.Stim_Label,'String');

if stim_pos < length(stim_label) - 1 % If not at top or bottom of list
    % Gets current lists
    stim_label = get(handles.Stim_Label,'String');
    stim_value = get(handles.Stim_Value,'String');
    stim_expression = get(handles.Stim_Expression,'String');

    % Gets relevant lines
    label_old = stim_label{stim_pos}; label_new = stim_label{stim_pos+1};
    value_old = stim_value{stim_pos}; value_new = stim_value{stim_pos+1};
    expression_old = stim_expression{stim_pos}; expression_new = stim_expression{stim_pos+1};

    % Switches lines
    stim_label{stim_pos+1} = label_old; stim_label{stim_pos} = label_new;
    stim_value{stim_pos+1} = value_old; stim_value{stim_pos} = value_new;
    stim_expression{stim_pos+1} = expression_old; stim_expression{stim_pos} = expression_new;

    % Sets list boxes
    set(handles.Stim_Label,'String',stim_label)
    set(handles.Stim_Value,'String',stim_value)
    set(handles.Stim_Expression,'String',stim_expression)

    stim_list = get(handles.Stim_List,'String');
    if isempty(stim_list) ~= 1
        stim_def = char(stim_list(get(handles.Stim_List,'Value')));
        update_Stim(hObject,eventdata,handles,stim_def);
    end

    % Updates highlighted position
    set(handles.Stim_Label,'Value',stim_pos+1)
    highlighter(handles.Stim_Label,eventdata,handles);
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


