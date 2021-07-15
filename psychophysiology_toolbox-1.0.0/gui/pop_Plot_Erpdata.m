function varargout = pop_Plot_Erpdata(varargin)
% POP_PLOT_ERPDATA M-file for pop_Plot_Erpdata.fig
%      POP_PLOT_ERPDATA, by itself, creates a new POP_PLOT_ERPDATA or raises the existing
%      singleton*.
%
%      H = POP_PLOT_ERPDATA returns the handle to a new POP_PLOT_ERPDATA or the handle to
%      the existing singleton*.
%
%      POP_PLOT_ERPDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_PLOT_ERPDATA.M with the given input arguments.
%
%      POP_PLOT_ERPDATA('Property','Value',...) creates a new POP_PLOT_ERPDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Plot_Erpdata_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Plot_Erpdata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Plot_Erpdata

% Last Modified by GUIDE v2.5 02-Dec-2004 23:16:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Plot_Erpdata_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Plot_Erpdata_OutputFcn, ...
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


% --- Executes just before pop_Plot_Erpdata is made visible.
function pop_Plot_Erpdata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Plot_Erpdata (see VARARGIN)

% Choose default command line output for pop_Plot_Erpdata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','save_dir',gui_parameters.default_save_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','save_extension','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','baseline_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','baseline_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','epoch_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','epoch_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','select_aggregation',1);
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','y_min','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','y_max','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','highpass_filter','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','lowpass_filter','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','plot_index_list','ALL');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','plot_average_list','ALL');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','plot_linetype_list','');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','plot_electrode_list','{''''}');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','AT','NONE');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','generate_script',1);
gui_parameters = gui_parameter_default(gui_parameters,'.plot_erpdata','script_file','plot_erpdata_script');

    set(handles.Load_File,'String',gui_parameters.plot_erpdata.load_file)
    set(handles.Save_Dir,'String',gui_parameters.plot_erpdata.save_dir)
    set(handles.Save_File,'String',gui_parameters.plot_erpdata.save_file)
    switch gui_parameters.plot_erpdata.save_extension
        case ''
	    set(handles.Select_Extension,'Value',1)
        case 'bmp'
            set(handles.Select_Extension,'Value',2)
        case 'epsc'
            set(handles.Select_Extension,'Value',3)
        case 'epsc2'
            set(handles.Select_Extension,'Value',4)
        case 'ill'
            set(handles.Select_Extension,'Value',5)
        case 'jpeg'
            set(handles.Select_Extension,'Value',6)
        case 'pdf'
            set(handles.Select_Extension,'Value',7)
        case 'png'
            set(handles.Select_Extension,'Value',8)
        case 'tiff'
            set(handles.Select_Extension,'Value',9)
    end
    set(handles.Baseline_Start,'String',gui_parameters.plot_erpdata.baseline_start)
    set(handles.Baseline_End,'String',gui_parameters.plot_erpdata.baseline_end)
    set(handles.Epoch_Start,'String',gui_parameters.plot_erpdata.epoch_start)
    set(handles.Epoch_End,'String',gui_parameters.plot_erpdata.epoch_end)
    set(handles.Select_Aggregation,'Value',gui_parameters.plot_erpdata.select_aggregation)
    set(handles.Y_Min,'String',gui_parameters.plot_erpdata.y_min)
    set(handles.Y_Max,'String',gui_parameters.plot_erpdata.y_max)
    set(handles.Highpass_Filter,'String',gui_parameters.plot_erpdata.highpass_filter)
    set(handles.Lowpass_Filter,'String',gui_parameters.plot_erpdata.lowpass_filter)
    set(handles.Index_List,'String',gui_parameters.plot_erpdata.plot_index_list)
    set(handles.Average_List,'String',gui_parameters.plot_erpdata.plot_average_list)
    set(handles.Linetype_List,'String',gui_parameters.plot_erpdata.plot_linetype_list)
    set(handles.Electrode_List,'String',gui_parameters.plot_erpdata.plot_electrode_list)
    set(handles.Verbosity,'String',gui_parameters.plot_erpdata.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.plot_erpdata.generate_script)
    set(handles.Script_Name,'String',gui_parameters.plot_erpdata.script_file)

default_AT = 'NONE';
AT = evalin('base','AT','default_AT');
assignin('base','AT',AT)

assignin('base','gui_parameters',gui_parameters)

% UIWAIT makes pop_Plot_Erpdata wait for user response (see UIRESUME)
% uiwait(handles.pop_Plot_Erpdata);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Plot_Erpdata_OutputFcn(hObject, eventdata, handles)
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


% Highlights all elements of an average to plot
function highlighter(hObject,eventdata,handles)
set(handles.Index_List,'Value',get(hObject,'Value'))
set(handles.Average_List,'Value',get(hObject,'Value'))
set(handles.Linetype_List,'Value',get(hObject,'Value'))

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

gui_parameter_change('.plot_erpdata','load_file',get(hObject,'String'));


% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.plot_erpdata.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    set(handles.Load_File,'String',file_name);
    gui_parameter_change('.plot_erpdata','load_file',get(handles.Load_File,'String'));

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


% --- Executes on button press in Browse_Save_Dir.
function Browse_Save_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls director selector, then sets save box text
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
if strcmp(gui_parameters.directory_select.selected_dir,'No directory selected.') ~= 1
    set(handles.Save_Dir,'String',gui_parameters.directory_select.selected_dir)
    gui_parameter_change('.plot_erpdata','save_dir',get(handles.Save_Dir,'String'));
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

gui_parameter_change('.plot_erpdata','save_file',get(hObject,'String'));


% --- Executes on button press in Browse_Save_File.
function Browse_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.plot_erpdata.data_format;
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
    gui_parameter_change('.plot_erpdata','save_file',get(handles.Save_File,'String'));
end


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

gui_parameter_change('.plot_erpdata','baseline_start',get(hObject,'String'));


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

gui_parameter_change('.plot_erpdata','baseline_end',get(hObject,'String'));


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

gui_parameter_change('.plot_erpdata','epoch_start',get(hObject,'String'));


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

gui_parameter_change('.plot_erpdata','epoch_end',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Select_Aggregation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Aggregation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_Aggregation.
function Select_Aggregation_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Aggregation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Aggregation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Aggregation

% Assigns domain of analysis based on selection

gui_parameter_change('.plot_erpdata','select_aggregation',get(hObject,'Value'));


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

gui_parameter_change('.plot_erpdata','highpass_filter',get(hObject,'String'));


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

gui_parameter_change('.plot_erpdata','lowpass_filter',get(hObject,'String'));


% --- Executes on button press in Tag_Artifacts.
function Tag_Artifacts_Callback(hObject, eventdata, handles)
% hObject    handle to Tag_Artifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the tag_artifacts dialog box
pop_Tag_Artifacts;

% --- Executes during object creation, after setting all properties.
function Average_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Average_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Average_List.
function Average_List_Callback(hObject, eventdata, handles)
% hObject    handle to Average_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Average_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Average_List

highlighter(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function New_Average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Average_Callback(hObject, eventdata, handles)
% hObject    handle to New_Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Average as text
%        str2double(get(hObject,'String')) returns contents of New_Average as a double


% --- Executes on button press in Add_Average.
function Add_Average_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Updates Index_List, Average_List and Linetype_List, if New_Index and New_Average boxes aren't empty
if isempty(get(handles.New_Index,'String')) ~= 1 & isempty(get(handles.New_Average,'String')) ~= 1 

    plot_index_list = get(handles.Index_List,'String');
    if iscell(plot_index_list) ~= 1 & isempty(plot_index_list) ~= 1; plot_index_list = cellstr(plot_index_list); end
    length_nl = length(plot_index_list);
    plot_index_list{length_nl+1} = get(handles.New_Index,'String');
    set(handles.Index_List,'String',plot_index_list)
    set(handles.New_Index,'String','')

    plot_average_list = get(handles.Average_List,'String');
    if iscell(plot_average_list) ~= 1 & isempty(plot_average_list) ~= 1; plot_average_list = cellstr(plot_average_list); end
    length_al = length(plot_average_list);
    plot_average_list{length_al+1} = get(handles.New_Average,'String');
    set(handles.Average_List,'String',plot_average_list)
    set(handles.New_Average,'String','')
    
    plot_linetype_list = get(handles.Linetype_List,'String');
    if iscell(plot_linetype_list) ~= 1; plot_linetype_list = cellstr(plot_linetype_list); end
    length_ll = length(plot_linetype_list);
    if isempty(get(handles.New_Linetype,'String'))
        plot_linetype_list{length_ll+1} = ' ';
    else
        plot_linetype_list{length_ll+1} = get(handles.New_Linetype,'String');
    end
    set(handles.Linetype_List,'String',plot_linetype_list)
    set(handles.New_Linetype,'String','')

    gui_parameter_change('.plot_erpdata','plot_index_list',get(handles.Index_List,'String'));
    gui_parameter_change('.plot_erpdata','plot_average_list',get(handles.Average_List,'String'));
    gui_parameter_change('.plot_erpdata','plot_linetype_list',get(handles.Linetype_List,'String'));

    set(handles.Index_List,'Value',length_nl+1)
    highlighter(handles.Index_List,eventdata,handles);
end
    

% --- Executes on button press in Remove_Average.
function Remove_Average_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets position of highlighted trigger, then deletes it
nlist_pos = get(handles.Index_List,'Value');
plot_index_list = get(handles.Index_List,'String');
if iscell(plot_index_list) ~= 1; plot_index_list = cellstr(plot_index_list); end
if isempty(plot_index_list) ~= 1; plot_index_list(nlist_pos) = []; end
if length(plot_index_list) == 1; plot_index_list = char(plot_index_list); end
if nlist_pos > 1; set(handles.Index_List,'Value',nlist_pos-1); end
set(handles.Index_List,'String',plot_index_list)

alist_pos = get(handles.Average_List,'Value');
plot_average_list = get(handles.Average_List,'String');
if iscell(plot_average_list) ~= 1; plot_average_list = cellstr(plot_average_list); end
if isempty(plot_average_list) ~= 1; plot_average_list(alist_pos) = []; end
if length(plot_average_list) == 1; plot_average_list = char(plot_average_list); end
if alist_pos > 1; set(handles.Average_List,'Value',alist_pos-1); end
set(handles.Average_List,'String',plot_average_list)

llist_pos = get(handles.Linetype_List,'Value');
plot_linetype_list = get(handles.Linetype_List,'String');
if iscell(plot_linetype_list) ~= 1; plot_linetype_list = cellstr(plot_linetype_list); end
if isempty(plot_linetype_list) ~= 1; plot_linetype_list(llist_pos) = []; end
if length(plot_linetype_list) == 1; plot_linetype_list = char(plot_linetype_list); end
if llist_pos > 1; set(handles.Linetype_List,'Value',llist_pos-1); end
set(handles.Linetype_List,'String',plot_linetype_list)

gui_parameter_change('.plot_erpdata','plot_index_list',get(handles.Index_List,'String'));
gui_parameter_change('.plot_erpdata','plot_average_list',get(handles.Average_List,'String'));
gui_parameter_change('.plot_erpdata','plot_linetype_list',get(handles.Linetype_List,'String'));

highlighter(handles.Index_List,eventdata,handles);

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
electrode_list = get(handles.Electrode_List,'String');
el_pos = get(handles.Electrode_List,'Value');
if ischar(electrode_list)
    spaces = find(electrode_list == ' ');
    if isempty(spaces)
        current_electrode = [electrode_list(1:2) electrode_list(length(electrode_list)-1:length(electrode_list))];
    else
        if strcmp(electrode_list,' ''''}') ~= 1 % If not already empty row
            current_electrode = [electrode_list(1:spaces(length(spaces))-1) '''}'];
            if length(electrode_list) == 2; electrode_list = ' ''''}'; end
        end
    end
    electrode_list = current_electrode;
else
    current_electrode = char(electrode_list(el_pos));
    spaces = find(current_electrode == ' ');
    if isempty(spaces)
        current_electrode = [current_electrode(1:2) current_electrode(length(current_electrode)-1:length(current_electrode))];
    else
        if strcmp(current_electrode, ' ''''}') ~= 1 % If not already empty row
            current_electrode = [current_electrode(1:spaces(length(spaces))-1) '''}'];
            if length(current_electrode) == 2; current_electrode = ' ''''}'; end
        end
    end
    electrode_list(el_pos) = cellstr(current_electrode);
end
gui_parameter_change('.plot_erpdata','plot_electrode_list',electrode_list);
set(handles.Electrode_List,'String',electrode_list)


% --- Executes on button press in Add_Electrode.
function Add_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Updates Electrode_List, if New_Electrode box isn't empty
if isempty(get(handles.New_Electrode,'String')) ~= 1
    electrode_list = get(handles.Electrode_List,'String');
    el_pos = get(handles.Electrode_List,'Value');
    if ischar(electrode_list)
        current_electrode = electrode_list(1:length(electrode_list)-2);
        if length(current_electrode) == 2
            current_electrode = [current_electrode get(handles.New_Electrode,'String') '''}'];
        else
            current_electrode = [current_electrode ' ' get(handles.New_Electrode,'String') '''}'];
        end
        electrode_list = current_electrode;
    else
        current_electrode = char(electrode_list(el_pos));
        current_electrode = current_electrode(1:length(current_electrode)-2);
        if length(current_electrode) == 2
            current_electrode = [current_electrode get(handles.New_Electrode,'String') '''}'];
        else
            current_electrode = [current_electrode ' ' get(handles.New_Electrode,'String') '''}'];
        end
        electrode_list(length(electrode_list)) = cellstr(current_electrode);
    end
    gui_parameter_change('.plot_erpdata','plot_electrode_list',electrode_list);
    set(handles.Electrode_List,'String',electrode_list)
    set(handles.New_Electrode,'String','')
end


% --- Executes on button press in Plot_Data.
function Plot_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.Index_List,'String')) ~= 1
% Sets values for the extraction function
file_name = get(handles.Load_File,'String');
out_file = [get(handles.Save_Dir,'String') filesep get(handles.Save_File,'String')];

format_list = get(handles.Select_Extension,'String');
file_format = char(format_list(get(handles.Select_Extension,'Value')));
spaces = find(file_format == ' ');
file_format = file_format(1:spaces(1));
if strcmp(file_format,' '); file_format = ''; end

aggregation_list = get(handles.Select_Aggregation,'String');
select_aggregation = char(aggregation_list(get(handles.Select_Aggregation,'Value')));

elec_array = strvcat(get(handles.Electrode_List,'String'));
elec_array_string = '';
for i = 1:length(elec_array(:,1))
    elec_array_string = [elec_array_string elec_array(i,:) ';'];
end
elec_array = eval(elec_array_string);

plot_index_list = strvcat(get(handles.Index_List,'String'));
if strcmp(plot_index_list,'ALL') | strcmp(plot_index_list,'all')
    averages2extract = 'ALL';
else
    for i = 1:length(cellstr(get(handles.Index_List,'String')))
        averages2extract(i).name = ['' plot_index_list(i,:) ''];
    end
end

plot_average_list = strvcat(get(handles.Average_List,'String'));
if strcmp(plot_average_list,'ALL') | strcmp(plot_average_list,'all')
    averages2extract = 'ALL';
else
    for i = 1:length(cellstr(get(handles.Average_List,'String')))
        averages2extract(i).text = ['' plot_average_list(i,:) ''];
    end
end

if isstruct(averages2extract) 
    plot_linetype_list = strvcat(get(handles.Linetype_List,'String'));
    for i = 1:length(cellstr(get(handles.Linetype_List,'String')))
        averages2extract(i).linetype = ['' plot_linetype_list(i,:) ''];
    end
end

baseline_start = str2num(get(handles.Baseline_Start,'String'));
baseline_end = str2num(get(handles.Baseline_End,'String'));
epoch_start = str2num(get(handles.Epoch_Start,'String'));
epoch_end = str2num(get(handles.Epoch_End,'String'));
y_min = str2num(get(handles.Y_Min,'String'));
y_max = str2num(get(handles.Y_Max,'String'));
filter = [str2num(get(handles.Highpass_Filter,'String')) str2num(get(handles.Lowpass_Filter,'String'))];
AT = evalin('base','AT');
verbosity = str2num(get(handles.Verbosity,'String'));

% DO NOT ALTER BELOW THIS LINE!
figure('Name','plot_erpdata figure','Tag','plot_erpdata_figure')
plot_erpdata(file_name,out_file,file_format,select_aggregation,elec_array, ...
    averages2extract,baseline_start,baseline_end,epoch_start,epoch_end,y_min,y_max, ...
    filter,AT,verbosity);

% Writes a lovely script in save_data_dir, if desired
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
        fprintf(fid,'%% Script generated on %s\n',datestr(date));
        fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
        fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
        fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
        fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');
        fprintf(fid,'%% Sets values for the plotting function\n');
        fprintf(fid,'file_name = ''%s'';\n',get(handles.Load_File,'String'));
        fprintf(fid,'out_file = ''%s%s%s'';\n',get(handles.Save_Dir,'String'),filesep,get(handles.Save_File,'String'));
        fprintf(fid,'file_format = ''%s'';\n',file_format);
        fprintf(fid,'select_aggregation = ''%s'';\n',char(aggregation_list(get(handles.Select_Aggregation,'Value'))));
        elec_array = strvcat(get(handles.Electrode_List,'String'));
        elec_array_string = '';
        for i = 1:length(elec_array(:,1))
            elec_array_string = [elec_array_string elec_array(i,:) ';'];
        end
        fprintf(fid,'elec_array = %s\n',elec_array_string);
        for i = 1:length(get(handles.Index_List,'String'))
            fprintf(fid,'averages2extract(%s).name = ''%s'';\n',num2str(i),['' plot_index_list(i,:) '']);
        end
        for i = 1:length(get(handles.Average_List,'String'))
            fprintf(fid,'averages2extract(%s).text = ''%s'';\n',num2str(i),['' strrep(plot_average_list(i,:),'''','''''') '']);
        end
        for i = 1:length(get(handles.Linetype_List,'String'))
            fprintf(fid,'averages2extract(%s).linetype = ''%s'';\n',num2str(i),['' plot_linetype_list(i,:) '']);
        end
        fprintf(fid,'baseline_start = [%s];\n',get(handles.Baseline_Start,'String'));
        fprintf(fid,'baseline_end = [%s];\n',get(handles.Baseline_End,'String'));
        fprintf(fid,'epoch_start = [%s];\n',get(handles.Epoch_Start,'String'));
        fprintf(fid,'epoch_end = [%s];\n',get(handles.Epoch_End,'String'));
        fprintf(fid,'y_min = [%s];\n',get(handles.Y_Min,'String'));
        fprintf(fid,'y_max = [%s];\n',get(handles.Y_Max,'String'));
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
        fprintf(fid,'verbosity = %s;\n\n',get(handles.Verbosity,'String'));
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'figure(''Name'',''plot_erpdata figure'',''Tag'',''plot_erpdata_figure'')\n');
        fprintf(fid,'plot_erpdata(file_name,out_file,file_format,select_aggregation,elec_array, ...\n');
        fprintf(fid,'averages2extract,baseline_start,baseline_end,epoch_start,epoch_end,y_min,y_max, ...\n');
        fprintf(fid,'filter,AT,verbosity);\n');

        fclose(fid);
    end
end

% Closes the dialog box
close(pop_Plot_Erpdata)

end

% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Generate_Script

gui_parameter_change('.plot_erpdata','generate_script',get(hObject,'Value'));


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
%        str2double(get(hObject,'String')) returns contents of Script_Name
%        as a double

gui_parameter_change('.plot_erpdata','script_file',get(hObject,'String'));


% --- Executes on button press in Browse_Script_Name.
function Browse_Script_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Script_Name (see GCBO)
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
    gui_parameter_change('.plot_erpdata','script_dir',get(handles.Script_Name,'String'));
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

gui_parameter_change('.plot_erpdata','verbosity',get(hObject,'String'));


% --- Executes on button press in Clear_All_Averages.
function Clear_All_Averages_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Averages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot_index_list = get(handles.Index_List,'String');
plot_index_list(:) = [];
set(handles.Index_List,'String',plot_index_list)

plot_average_list = get(handles.Average_List,'String');
plot_average_list(:) = [];
set(handles.Average_List,'String',plot_average_list)

plot_linetype_list = get(handles.Linetype_List,'String');
plot_linetype_list(:) = [];
set(handles.Linetype_List,'String',plot_linetype_list)

gui_parameter_change('.plot_erpdata','plot_index_list',get(handles.Index_List,'String'));
gui_parameter_change('.plot_erpdata','plot_average_list',get(handles.Average_List,'String'));
gui_parameter_change('.plot_erpdata','plot_linetype_list',get(handles.Linetype_List,'String'));


% --- Executes during object creation, after setting all properties.
function Index_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Index_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Index_List.
function Index_List_Callback(hObject, eventdata, handles)
% hObject    handle to Index_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Index_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Index_List

highlighter(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function New_Index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Index_Callback(hObject, eventdata, handles)
% hObject    handle to New_Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Index as text
%        str2double(get(hObject,'String')) returns contents of New_Index as a double


% --- Executes during object creation, after setting all properties.
function Select_Extension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_Extension.
function Select_Extension_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Extension contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Extension

save_extension = get(hObject,'Value');
switch save_extension
    case 1
        gui_parameter_change('.plot_erpdata','save_extension','');
    case 2
        gui_parameter_change('.plot_erpdata','save_extension','bmp');
    case 3
        gui_parameter_change('.plot_erpdata','save_extension','epsc');
    case 4
        gui_parameter_change('.plot_erpdata','save_extension','epsc2');
    case 5
        gui_parameter_change('.plot_erpdata','save_extension','ill');
    case 6
        gui_parameter_change('.plot_erpdata','save_extension','jpeg');
    case 7
        gui_parameter_change('.plot_erpdata','save_extension','pdf');
    case 8
        gui_parameter_change('.plot_erpdata','save_extension','png');
    case 9
        gui_parameter_change('.plot_erpdata','save_extension','tiff');
end


% --- Executes during object creation, after setting all properties.
function Y_Min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Y_Min_Callback(hObject, eventdata, handles)
% hObject    handle to Y_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_Min as text
%        str2double(get(hObject,'String')) returns contents of Y_Min as a double

gui_parameter_change('.plot_erpdata','y_min',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Y_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Y_Max_Callback(hObject, eventdata, handles)
% hObject    handle to Y_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_Max as text
%        str2double(get(hObject,'String')) returns contents of Y_Max as a double

gui_parameter_change('.plot_erpdata','y_max',get(hObject,'String'));


% --- Executes on button press in Add_Electrode_Row.
function Add_Electrode_Row_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Electrode_Row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

electrode_list = get(handles.Electrode_List,'String');
if ~iscell(electrode_list), electrode_list = cellstr(electrode_list); end
length_el = length(electrode_list);
el_pos = get(handles.Electrode_List,'Value');
if length(char(electrode_list(el_pos))) > 4 % If not a row-starter entry
    if isempty(electrode_list)
        electrode_list{1} = '{''''}';
    else
        current_electrode = char(electrode_list{el_pos});
        electrode_list{el_pos} =  current_electrode(1:length(current_electrode)-1);
        electrode_list{length_el+1} = ' ''''}';
    end
    set(handles.Electrode_List,'String',electrode_list)
    set(handles.Electrode_List,'Value',el_pos+1)
end

% --- Executes during object creation, after setting all properties.
function Linetype_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Linetype_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Linetype_List.
function Linetype_List_Callback(hObject, eventdata, handles)
% hObject    handle to Linetype_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Linetype_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Linetype_List

highlighter(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function New_Linetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Linetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function New_Linetype_Callback(hObject, eventdata, handles)
% hObject    handle to New_Linetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Linetype as text
%        str2double(get(hObject,'String')) returns contents of New_Linetype as a double


% --- Executes on button press in Delete_Electrode_Row.
function Delete_Electrode_Row_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Electrode_Row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

electrode_list = get(handles.Electrode_List,'String');
if iscell(electrode_list) ~= 1; electrode_list = cellstr(electrode_list); end
el_pos = get(handles.Electrode_List,'Value');
electrode_list(el_pos) = []; % Delete current row
if el_pos > 1 % If more than one row of electrodes
    current_electrode = char(electrode_list{el_pos-1});
    electrode_list{el_pos-1} = [current_electrode '}'];
elseif el_pos == 1 % If at first row of electrodes
    if isempty(electrode_list) % If all electrodes have been deleted
        electrode_list{el_pos} = '{''''}';
    else % If there are still electrodes in first row
        current_electrode = char(electrode_list{el_pos});
        electrode_list{el_pos} = ['{' current_electrode(2:end)];
    end
    el_pos = 2;
end
gui_parameter_change('.plot_erpdata','plot_electrode_list',electrode_list);
set(handles.Electrode_List,'String',electrode_list)
set(handles.Electrode_List,'Value',el_pos-1)


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot_pos = get(handles.Index_List,'Value');
plot_index = get(handles.Index_List,'String');

if plot_pos > 1 % If not at first or last row
    % Gets current lists
    plot_index = get(handles.Index_List,'String');
    plot_average = get(handles.Average_List,'String');
    plot_linetype = get(handles.Linetype_List,'String');
    
    % Extracts relevant lines
    index_old = plot_index{plot_pos}; index_new = plot_index{plot_pos-1};
    average_old = plot_average{plot_pos}; average_new = plot_average{plot_pos-1};
    linetype_old = plot_linetype{plot_pos}; linetype_new = plot_linetype{plot_pos-1};
    
    % Switches lines
    plot_index{plot_pos-1} = index_old; plot_index{plot_pos} = index_new;
    plot_average{plot_pos-1} = average_old; plot_average{plot_pos} = average_new;
    plot_linetype{plot_pos-1} = linetype_old; plot_linetype{plot_pos} = linetype_new;
    
    % Sets new lists
    set(handles.Index_List,'String',plot_index)
    set(handles.Average_List,'String',plot_average)
    set(handles.Linetype_List,'String',plot_linetype)

    gui_parameter_change('.plot_erpdata','plot_index_list',get(handles.Index_List,'String'));
    gui_parameter_change('.plot_erpdata','plot_average_list',get(handles.Average_List,'String'));
    gui_parameter_change('.plot_erpdata','plot_linetype_list',get(handles.Linetype_List,'String'));
    
    % Updates highlighted row
    set(handles.Index_List,'Value',plot_pos-1)
    highlighter(handles.Index_List,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot_pos = get(handles.Index_List,'Value');
plot_index = get(handles.Index_List,'String');

if plot_pos < length(plot_index) % If not at last row
    % Gets current lists
    plot_index = get(handles.Index_List,'String');
    plot_average = get(handles.Average_List,'String');
    plot_linetype = get(handles.Linetype_List,'String');

    % Extracts relevant lines
    index_old = plot_index{plot_pos}; index_new = plot_index{plot_pos+1};
    average_old = plot_average{plot_pos}; average_new = plot_average{plot_pos+1};
    linetype_old = plot_linetype{plot_pos}; linetype_new = plot_linetype{plot_pos+1};

    % Switches lines
    plot_index{plot_pos+1} = index_old; plot_index{plot_pos} = index_new;
    plot_average{plot_pos+1} = average_old; plot_average{plot_pos} = average_new;
    plot_linetype{plot_pos+1} = linetype_old; plot_linetype{plot_pos} = linetype_new;

    % Sets new lists
    set(handles.Index_List,'String',plot_index)
    set(handles.Average_List,'String',plot_average)
    set(handles.Linetype_List,'String',plot_linetype)

    gui_parameter_change('.plot_erpdata','plot_index_list',get(handles.Index_List,'String'));
    gui_parameter_change('.plot_erpdata','plot_average_list',get(handles.Average_List,'String'));
    gui_parameter_change('.plot_erpdata','plot_linetype_list',get(handles.Linetype_List,'String'));

    % Updates highlighted row
    set(handles.Index_List,'Value',plot_pos+1)
    highlighter(handles.Index_List,eventdata,handles);
end
