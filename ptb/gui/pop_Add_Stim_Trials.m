function varargout = pop_Add_Stim_Trials(varargin)
% pop_Add_Stim_Trials M-file for pop_Add_Stim_Trials.fig
%      pop_Add_Stim_Trials, by itself, creates a new pop_Add_Stim_Trials or raises the existing
%      singleton*.
%
%      H = pop_Add_Stim_Trials returns the handle to a new pop_Add_Stim_Trials or the handle to
%      the existing singleton*.
%
%      pop_Add_Stim_Trials('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in pop_Add_Stim_Trials.M with the given input arguments.
%
%      pop_Add_Stim_Trials('Property','Value',...) creates a new pop_Add_Stim_Trials or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Add_Stim_Trials_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Add_Stim_Trials_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Add_Stim_Trials

% Last Modified by GUIDE v2.5 07-Dec-2004 22:48:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Add_Stim_Trials_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Add_Stim_Trials_OutputFcn, ...
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


% --- Executes just before pop_Add_Stim_Trials is made visible.
function pop_Add_Stim_Trials_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Add_Stim_Trials (see VARARGIN)

% Choose default command line output for pop_Add_Stim_Trials
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','trialnums',[]);

    if isfield('gui.parameters.add_stim.trialnums','name'), set(handles.Trial_List,'String',cellstr(gui_parameters.add_stim.trialnums.name)); end
    set(handles.Trial_List,'Value',1)
    Trial_List_Callback(handles.Trial_List,eventdata,handles);

assignin('base','gui_parameters',gui_parameters)

% UIWAIT makes pop_Add_Stim_Trials wait for user response (see UIRESUME)
% uiwait(handles.pop_Add_Stim_Trials);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Add_Stim_Trials_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Output trialnums as first variable
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
set(handles.Chunk_List,'Value',get(hObject,'Value'))


% Resets all dialog boxes
function reset_all(hObject,eventdata,handles)
set(handles.Chunk_List,'Value',2)
set(handles.Chunk_List,'String',{'erp.elec',' '})


% Updates a given AT definition
function update_Trial(hObject,eventdata,handles,trial_def)
if ischar(trial_def) ~= 1; trial_def = char(trial_def); end
gui_parameters = evalin('base','gui_parameters');
eval(['gui_parameters.add_stim.trialnums(' trial_def ').text = get(handles.Chunk_List,''String'');']);
assignin('base','gui_parameters',gui_parameters)
save default_gui_parameters gui_parameters
new_length = length(get(handles.Chunk_List,'String'));
set(handles.Chunk_List,'Value',new_length)
highlighter(handles.Chunk_List,eventdata,handles)

% Sets enable property of various handles
function set_enable(handles,state,varargin)
for i = 1:length(varargin)
    eval(['set(handles.' varargin{i} ',''Enable'',''' state ''')'])
end


% --- Executes during object creation, after setting all properties.
function Chunk_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Chunk_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Chunk_List.
function Chunk_List_Callback(hObject, eventdata, handles)
% hObject    handle to Chunk_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Chunk_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Chunk_List

highlighter(hObject,eventdata,handles)



% --- Executes on button press in Clear_All_Chunk.
function Clear_All_Chunk_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Chunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_all(hObject,eventdata,handles);

% --- Executes on button press in Add_Chunk.
function Add_Chunk_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Chunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.New_Chunk,'String')) ~= 1
    
    chunk_list = get(handles.Chunk_List,'String');
    if ischar(chunk_list); chunk_list = cellstr(chunk_list); end
    length_cl = length(chunk_list);
    chunk_list{length_cl} = get(handles.New_Chunk,'String');
    chunk_list{length_cl+1} = ' ';
    set(handles.Chunk_List,'String',chunk_list)
    set(handles.New_Chunk,'String','')
    
    set(handles.Chunk_List,'Value',length_cl+1)
    highlighter(handles.Chunk_List,eventdata,handles)
    
    trial_list = get(handles.Trial_List,'String');
    if isempty(trial_list) ~= 1
        trial_def = num2str(get(handles.Trial_List,'Value'));
        update_Trial(hObject,eventdata,handles,trial_def);
    end
end

% --- Executes on button press in Remove_Chunk.
function Remove_Chunk_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Chunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stim_label = get(handles.Chunk_List,'String');
chunk_pos = get(handles.Chunk_List,'Value');
stim_label = stim_label(get(handles.Chunk_List,'Value'));
if strcmp(stim_label,' ') ~= 1

    % Gets position of highlighted pass, then deletes it
    cllist_pos = get(handles.Chunk_List,'Value');
    chunk_list = get(handles.Chunk_List,'String');
    if iscell(chunk_list) ~= 1; chunk_list = cellstr(chunk_list); end
    if isempty(chunk_list) ~= 1; chunk_list(cllist_pos) = []; end
    if cllist_pos > 1; set(handles.Chunk_List,'Value',cllist_pos-1); end
    set(handles.Chunk_List,'String',chunk_list)

    trial_list = get(handles.Trial_List,'String');
    if isempty(trial_list) ~= 1
        trial_def = num2str(get(handles.Trial_List,'Value'));
        update_Trial(hObject,eventdata,handles,trial_def);
    end

end

% --- Executes during object creation, after setting all properties.
function Trial_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trial_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Trial_List.
function Trial_List_Callback(hObject, eventdata, handles)
% hObject    handle to Trial_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Trial_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Trial_List

gui_parameters = evalin('base','gui_parameters');
trial_list = get(handles.Trial_List,'String');
trial_pos = get(handles.Trial_List,'Value');
if isfield('gui_parameters.add_stim.trialnums','text'),	set(handles.Chunk_List,'String',eval(['gui_parameters.add_stim.trialnums(' num2str(trial_pos) ').text'])); end
set(handles.Chunk_List,'Value',length(get(handles.Chunk_List,'String')))
highlighter(handles.Chunk_List,eventdata,handles)

% --- Executes on button press in Remove_Trial.
function Remove_Trial_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(get(handles.Trial_List,'String'))
    gui_parameters = evalin('base','gui_parameters');
    trial_list = get(handles.Trial_List,'String');
    trial_pos = get(handles.Trial_List,'Value');
    trial_def = char(trial_list(trial_pos));
    gui_parameters.add_stim.trialnums(trial_pos) = [];
    if iscell(trial_list) ~= 1; trial_list = cellstr(trial_list); end
    if isempty(trial_list) ~= 1; trial_list(trial_pos) = []; end
    if trial_pos > 1; set(handles.Trial_List,'Value',trial_pos-1); end
    set(handles.Trial_List,'String',trial_list)
    assignin('base','gui_parameters',gui_parameters)
    reset_all(hObject,eventdata,handles);
    Trial_List_Callback(handles.Trial_List,eventdata,handles);
end


% --- Executes on button press in Add_Trial.
function Add_Trial_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Assigns existing variables to current stim_temp, then resets listboxes for new AT
% definition
if isempty(get(handles.New_Trial,'String')) ~= 1

    % Updates old trial_list entry, if exists
    trial_list = get(handles.Trial_List,'String');
    if isempty(trial_list) ~= 1
        trial_pos = get(handles.Trial_List,'Value');
        trial_def = num2str(trial_pos);
        update_Trial(hObject,eventdata,handles,trial_def);
        reset_all(hObject,eventdata,handles);
    else
        trial_pos = 1;
    end
    
    % Adds new trial_list entry
    gui_parameters = evalin('base','gui_parameters');
    gui_parameters = gui_parameter_default(gui_parameters,'.add_stim.trialnums',get(handles.New_Trial,'String'),[]);
    gui_parameters = gui_parameter_default(gui_parameters,['.add_stim.trialnums(' num2str(trial_pos) ')'],'text',{'erp.elec';' '});

    
    % Updates Trial_List
    if ~isempty(trial_list)
        trial_list{length(cellstr(trial_list))+1} = get(handles.New_Trial,'String');
    else
        trial_list{1} = get(handles.New_Trial,'String');
    end
    set(handles.Trial_List,'String',trial_list)
    set(handles.Trial_List,'Value',trial_pos)
    set(handles.New_Trial,'String','')
    Trial_List_Callback(handles.Trial_List,eventdata,handles);  
    assignin('base','gui_parameters',gui_parameters)

end


% --- Executes on button press in Update_Trial.
function Update_Trial_Callback(hObject, eventdata, handles)
% hObject    handle to Update_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trial_def = num2str(handles.Trial_List,'Value');
update_Trial(hObject,eventdata,handles,trial_def);
new_length = length(get(handles.Chunk_List,'String'));
set(handles.Chunk_List,'Value',new_length)
highlighter(handles.Chunk_List,eventdata,handles);


% --- Executes on button press in Done_Trials.
function Done_Trials_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.Trial_List,'String')) ~= 1 % Runs script, then closes window
    trial_list = get(handles.Trial_List,'String');
    gui_parameters = evalin('base','gui_parameters');

    for i = 1:length(trial_list) % Iterates through each erp.stim subfield
        chunk_list = eval(['gui_parameters.add_stim.trialnums(' num2str(i) ').text']);
        trialnums(i).name = char(trial_list(i));
        trialnums(i).text = chunk_list(1:length(chunk_list)-1);
    end

    % Sets trialnums variable
    gui_parameter_change('.add_stim','trialnums',trialnums);
    
    % Closes Add Stim Trials window
    close(pop_Add_Stim_Trials)
    
end

% --- Executes during object creation, after setting all properties.
function New_Chunk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Chunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Chunk_Callback(hObject, eventdata, handles)
% hObject    handle to New_Chunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Chunk as text
%        str2double(get(hObject,'String')) returns contents of New_Chunk as a double


% --- Executes during object creation, after setting all properties.
function New_Trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Trial_Callback(hObject, eventdata, handles)
% hObject    handle to New_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Trial as text
%        str2double(get(hObject,'String')) returns contents of New_Trial as a double
