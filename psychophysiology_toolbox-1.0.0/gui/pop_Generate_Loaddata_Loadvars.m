function varargout = pop_Generate_Loaddata_Loadvars(varargin)
% POP_GENERATE_LOADDATA_LOADVARS M-file for pop_Generate_Loaddata_Loadvars.fig
%      POP_GENERATE_LOADDATA_LOADVARS, by itself, creates a new POP_GENERATE_LOADDATA_LOADVARS or raises the existing
%      singleton*.
%
%      H = POP_GENERATE_LOADDATA_LOADVARS returns the handle to a new POP_GENERATE_LOADDATA_LOADVARS or the handle to
%      the existing singleton*.
%
%      POP_GENERATE_LOADDATA_LOADVARS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_GENERATE_LOADDATA_LOADVARS.M with the given input arguments.
%
%      POP_GENERATE_LOADDATA_LOADVARS('Property','Value',...) creates a new POP_GENERATE_LOADDATA_LOADVARS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Generate_Loaddata_Loadvars_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Generate_Loaddata_Loadvars_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Generate_Loaddata_Loadvars

% Last Modified by GUIDE v2.5 04-Jan-2005 12:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Generate_Loaddata_Loadvars_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Generate_Loaddata_Loadvars_OutputFcn, ...
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


% --- Executes just before pop_Generate_Loaddata_Loadvars is made visible.
function pop_Generate_Loaddata_Loadvars_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Generate_Loaddata_Loadvars (see VARARGIN)

% Choose default command line output for pop_Generate_Loaddata_Loadvars
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Sets all kinds of defaults
default_null = [];
comparisons = evalin('base','comparisons','default_null');
assignin('base','comparisons',comparisons)
colormaps = evalin('base','colormaps','default_null');
assignin('base','colormaps',colormaps)

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','data_format','.mat');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','chunk_variable','subnum');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','min_valid_trials','1');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','plot_file_format',4);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','topomap_style',1);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','electrode_to_plot','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','scaling_factor','.8');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','default_colormap',1);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','pca_association',1);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','cache_erp',0);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','cache_tfd',1);
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','tfd_baseline_start','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','tfd_baseline_end','');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','index_list','ALL');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','average_list','ALL');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','electrode_list','{''''}');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.generate_loaddata_loadvars','script_name','data_loadvars');


    set(handles.Load_File,'String',gui_parameters.generate_loaddata_loadvars.load_file)
    set(handles.Chunk_Variable,'String',gui_parameters.generate_loaddata_loadvars.chunk_variable)
    set(handles.Min_Valid_Trials,'String',gui_parameters.generate_loaddata_loadvars.min_valid_trials)
    set(handles.Plot_File_Format,'Value',gui_parameters.generate_loaddata_loadvars.plot_file_format)
    set(handles.Topomap_Style,'Value',gui_parameters.generate_loaddata_loadvars.topomap_style)
    set(handles.Electrode_To_Plot,'String',gui_parameters.generate_loaddata_loadvars.electrode_to_plot)
    set(handles.Scaling_Factor,'String',gui_parameters.generate_loaddata_loadvars.scaling_factor)
    set(handles.Default_Colormap,'Value',gui_parameters.generate_loaddata_loadvars.default_colormap)
    set(handles.Pca_Association,'Value',gui_parameters.generate_loaddata_loadvars.pca_association)
    set(handles.Cache_Erp,'Value',gui_parameters.generate_loaddata_loadvars.cache_erp)
    set(handles.Cache_Tfd,'Value',gui_parameters.generate_loaddata_loadvars.cache_tfd)
    set(handles.Tfd_Baseline_Start,'String',gui_parameters.generate_loaddata_loadvars.tfd_baseline_start)
    set(handles.Tfd_Baseline_End,'String',gui_parameters.generate_loaddata_loadvars.tfd_baseline_end)
    set(handles.Index_List,'String',gui_parameters.generate_loaddata_loadvars.index_list)
    set(handles.Average_List,'String',gui_parameters.generate_loaddata_loadvars.average_list)
    set(handles.Electrode_List,'String',gui_parameters.generate_loaddata_loadvars.electrode_list)
    set(handles.Verbosity,'String',gui_parameters.generate_loaddata_loadvars.verbosity)
    set(handles.Script_Name,'String',gui_parameters.generate_loaddata_loadvars.script_name)

assignin('base','gui_parameters',gui_parameters)


% UIWAIT makes pop_Generate_Loaddata_Loadvars wait for user response (see UIRESUME)
% uiwait(handles.pop_Generate_Loaddata_Loadvars);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Generate_Loaddata_Loadvars_OutputFcn(hObject, eventdata, handles)
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

gui_parameter_change('.generate_loaddata_loadvars','load_file',get(hObject,'String'));
file_name = get(hObject,'String');
fileseps = find(file_name == filesep);
dotpos = find(file_name == '.');
set(handles.Script_Name,'String',[file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1) '_loadvars'])
gui_parameter_change('.generate_loaddata_loadvars','script_name',get(handles.Script_Name,'String'));


% --- Executes on button press in Browse_Load_File.
function Browse_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.generate_loaddata_loadvars.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    file_name = gui_parameters.file_select.selected_file;
    set(handles.Load_File,'String',file_name);
    fileseps = find(file_name == filesep);
    dotpos = find(file_name == '.');
    set(handles.Script_Name,'String',[file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1) '_loadvars'])
    gui_parameter_change('.generate_loaddata_loadvars','load_file',get(handles.Script_Name,'String'));
    Load_File_Callback(handles.Load_File,eventdata,handles)
end

% --- Executes during object creation, after setting all properties.
function Chunk_Variable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Valid_Trials_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Chunk_Variable_Callback(hObject, eventdata, handles)
% hObject    handle to Chunk_Variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Chunk_Variable as text
%        str2double(get(hObject,'String')) returns contents of
%        Chunk_Variable as a double

gui_parameter_change('.generate_loaddata_loadvars','chunk_variable',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Min_Valid_Trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Valid_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Min_Valid_Trials_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Valid_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Valid_Trials as text
%        str2double(get(hObject,'String')) returns contents of Min_Valid_Trials as a double

gui_parameter_change('.generate_loaddata_loadvars','min_valid_trials',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Pca_Association_CreateFcn(hObject, eventdata, handles)


% --- Executes on selection change in Pca_Association.
function Pca_Association_Callback(hObject, eventdata, handles)
% hObject    handle to Pca_Association (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Pca_Association contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Pca_Association

% Assigns domain of analysis based on selection

gui_parameter_change('.generate_loaddata_loadvars','pca_association',get(hObject,'Value'));


% --- Executes on button press in Define_Stats.
function Define_Stats_Callback(hObject, eventdata, handles)
% hObject    handle to Define_Stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the define_stats dialog box
pop_Define_Stats;

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

% Updates Index_List and Average_List, if New_Index and New_Average boxes aren't empty
if isempty(get(handles.New_Index,'String')) ~= 1 & isempty(get(handles.New_Average,'String')) ~= 1 

    loadvars_index_list = get(handles.Index_List,'String');
    if iscell(loadvars_index_list) ~= 1 & isempty(loadvars_index_list) ~= 1; loadvars_index_list = cellstr(loadvars_index_list); end
    length_nl = length(loadvars_index_list);
    loadvars_index_list{length_nl+1} = get(handles.New_Index,'String');
    set(handles.Index_List,'String',loadvars_index_list)
    set(handles.New_Index,'String','')

    loadvars_average_list = get(handles.Average_List,'String');
    if iscell(loadvars_average_list) ~= 1 & isempty(loadvars_average_list) ~= 1; loadvars_average_list = cellstr(loadvars_average_list); end
    length_al = length(loadvars_average_list);
    loadvars_average_list{length_al+1} = get(handles.New_Average,'String');
    set(handles.Average_List,'String',loadvars_average_list)
    set(handles.New_Average,'String','')

    gui_parameter_change('.generate_loaddata_loadvars','index_list',get(handles.Index_List,'String'));
    gui_parameter_change('.generate_loaddata_loadvars','average_list',get(handles.Index_List,'String'));
    
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
loadvars_index_list = get(handles.Index_List,'String');
if iscell(loadvars_index_list) ~= 1; loadvars_index_list = cellstr(loadvars_index_list); end
if isempty(loadvars_index_list) ~= 1; loadvars_index_list(nlist_pos) = []; end
if length(loadvars_index_list) == 1; loadvars_index_list = char(loadvars_index_list); end
if nlist_pos > 1; set(handles.Index_List,'Value',nlist_pos-1); end
set(handles.Index_List,'String',loadvars_index_list)

alist_pos = get(handles.Average_List,'Value');
loadvars_average_list = get(handles.Average_List,'String');
if iscell(loadvars_average_list) ~= 1; loadvars_average_list = cellstr(loadvars_average_list); end
if isempty(loadvars_average_list) ~= 1; loadvars_average_list(alist_pos) = []; end
if length(loadvars_average_list) == 1; loadvars_average_list = char(loadvars_average_list); end
if alist_pos > 1; set(handles.Average_List,'Value',alist_pos-1); end
set(handles.Average_List,'String',loadvars_average_list)

gui_parameter_change('.generate_loaddata_loadvars','index_list',get(handles.Index_List,'String'));
gui_parameter_change('.generate_loaddata_loadvars','average_list',get(handles.Index_List,'String'));


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
gui_parameter_change('.generate_loaddata_loadvars','electrode_list',electrode_list);
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
    gui_parameter_change('.generate_loaddata_loadvars','electrode_list',electrode_list);
    set(handles.Electrode_List,'String',electrode_list)
    set(handles.New_Electrode,'String','')
end


% --- Executes on button press in loadvars_Data.
function Generate_Scripts_Callback(hObject, eventdata, handles)
% hObject    handle to loadvars_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.Load_File,'String')) ~= 1
% Writes lovely scripts in default_script_dir

    gui_parameters = evalin('base','gui_parameters');

    % Loaddata script
    loaddata_name = get(handles.Script_Name,'String');
    loaddata_name = [loaddata_name(1:length(loaddata_name)-9) '_loaddata'];
    
    fid = fopen([gui_parameters.default_script_dir filesep loaddata_name '.m'],'w+');
    script_header(fid);
    fprintf(fid,'load(''%s'');\n',get(handles.Load_File,'String'));
    fclose(fid);

    % Loadvars script
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
        fprintf(fid,'%% Defines electrode montage subfields of SETvars\n');
    
        electrode_list = get(handles.Electrode_List,'String');
        if iscell(electrode_list)
            electrode_array_string = '';
            for i = 1:length(electrode_list)
                electrode_array_string = [electrode_array_string char(electrode_list(i)) ';'];
            end
            fprintf(fid,'SETvars.electrode_montage = %s\n',electrode_array_string);
        else
            fprintf(fid,'SETvars.electrode_montage = %s;\n',char(electrode_list));
        end
    
        switch get(handles.Topomap_Style,'Value')
            case 1
                topomap_style = '''default''';
            case 2
                topomap_style = '''none''';
        end
    
        fprintf(fid,'SETvars.electrode_locations = ''%s'';\n',topomap_style);
        fprintf(fid,'SETvars.electrode_to_plot = ''%s'';\n',get(handles.Electrode_To_Plot,'String'));
        fprintf(fid,'\n%% Defines trials-to-average subfields of SETvars\n');
        fprintf(fid,'SETvars.trl2avg.var2chunk = ''%s'';\n',get(handles.Chunk_Variable,'String'));
        fprintf(fid,'SETvars.trl2avg.verbose = %s;\n',get(handles.Verbosity,'String'));
        fprintf(fid,'SETvars.trl2avg.min_trials_averaged = %s;\n',get(handles.Min_Valid_Trials,'String'));
    
        loadvars_index_list = cellstr(get(handles.Index_List,'String'));
        loadvars_average_list = cellstr(get(handles.Average_List,'String'));
        if strcmp(loadvars_index_list,'ALL') | strcmp(loadvars_index_list,'all')
            fprintf(fid,'SETvars.trl2avg='''';\n');
        else
            for i = 1:length(loadvars_index_list)
                fprintf(fid,'SETvars.trl2avg.catcodes(%s).name = ''%s'';\n', ...
	              num2str(i),['' char(loadvars_index_list(i)) '']);
            end
        end
        if strcmp(loadvars_average_list,'ALL') | strcmp(loadvars_average_list,'all')
            fprintf(fid,'SETvars.trl2avg='''';\n');
        else    
            for i = 1:length(loadvars_average_list)
                fprintf(fid,'SETvars.trl2avg.catcodes(%s:q).text = ''%s'';\n', ...
	              num2str(i),['' strrep(char(loadvars_average_list(i)),'''','''''') '']);
            end
        end
        
        fprintf(fid,'\n%% Defines PCA decomposition type subfield of SETvars\n');
        switch get(handles.Pca_Association,'Value')
            case 1
                decomp = 'association_Correlation';
            case 2
                decomp = 'association_Covariance';
            case 3
                decomp = 'association_SSCP';
            case 4
                decomp = 'data_Center';
            case 5
                decomp = 'data_CenterScale';
        end
        fprintf(fid,'SETvars.pca_decomptype = ''%s'';\n',decomp);
        fprintf(fid,'\n%% Defines TFD baseline subfields of SETvars\n');
        fprintf(fid,'SETvars.TFDbaseline.start = [%s];\n',get(handles.Tfd_Baseline_Start,'String'));
        fprintf(fid,'SETvars.TFDbaseline.end = [%s];\n',get(handles.Tfd_Baseline_End,'String'));
        fprintf(fid,'\n%% Defines cache settings subfields of SETvars\n');
        fprintf(fid,'SETvars.cache_erp = %s;\n',num2str(get(handles.Cache_Erp,'Value')));
        fprintf(fid,'SETvars.cache_tfd = %s;\n',num2str(get(handles.Cache_Tfd,'Value')));
        fprintf(fid,'\n%% Defines default plot subfields of SETvars\n');
        fprintf(fid,'SETvars.topomap_colormap_scale_factor = [%s];\n',char(get(handles.Scaling_Factor,'String')));
    
        default_colormap = get(handles.Default_Colormap,'String');
        default_colormap = char(default_colormap(get(handles.Default_Colormap,'Value')));
        fprintf(fid,'SETvars.topomap_colormap_name = ''%s'';\n',default_colormap);
    
        plot_file_format = get(handles.Plot_File_Format,'String');
        plot_file_format = char(plot_file_format(get(handles.Plot_File_Format,'Value')));
        spaces = find(plot_file_format == ' ');
        plot_file_format = plot_file_format(1:spaces(1));
        fprintf(fid,'SETvars.ptype = ''%s'';\n',plot_file_format);
    
        fprintf(fid,'\n%% Defines settings for group plots subfields of SETvars\n');
        colormaps = gui_parameters.generate_loaddata_loadvars.colormaps;
        fprintf(fid,'SETvars.differences_colormap = ''%s'';\n',char(colormaps.difference_colormap));
        fprintf(fid,'SETvars.differences_caxis = [%s %s];\n',colormaps.min_uv,colormaps.max_uv);
        fprintf(fid,'SETvars.statistics_colormap = ''%s'';\n',char(colormaps.statistical_colormap));
        fprintf(fid,'SETvars.statistics_caxis = [%s %s];\n',colormaps.max_p,colormaps.min_p);

        fprintf(fid,'\n%% Defines comparisons to be performed through SETvars subfields\n');
    
        comparisons = gui_parameters.generate_loaddata_loadvars.comparisons;
        for i = 1:length(comparisons)
            fprintf(fid,'SETvars.comparisons(%s).label = ''%s'';\n',num2str(i),char(comparisons(i).label));
            fprintf(fid,'SETvars.comparisons(%s).stats = ''%s'';\n',num2str(i),char(comparisons(i).stats));
            fprintf(fid,'SETvars.comparisons(%s).type = ''%s'';\n',num2str(i),char(comparisons(i).type));
            for j = 1:length(comparisons(i).set)
                fprintf(fid,'SETvars.comparisons(%s).set(%s).label = ''%s'';\n',num2str(i),num2str(j), ...
                    char(comparisons(i).set(j).label));
                fprintf(fid,'SETvars.comparisons(%s).set(%s).var.crit = ''%s'';\n',num2str(i),num2str(j), ...
                    strrep(char(comparisons(i).set(j).var.crit),'''',''''''));
            end
            fprintf(fid,'\n');
        end
    
        fclose(fid);
    
    end

    % Closes the dialog box
    close(pop_Generate_Loaddata_Loadvars)

end

% Function to generate a header for each script
function script_header(fid)
fprintf(fid,'%% Script generated on %s\n',datestr(date));
fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');


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

gui_parameter_change('.generate_loaddata_loadvars','script_file',get(hObject,'String'));


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
    gui_parameter_change('.generate_loaddata_loadvars','script_file',get(handles.Script_Name,'String'));
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

gui_parameter_change('.generate_loaddata_loadvars','verbosity',get(hObject,'String'));


% --- Executes on button press in Clear_All_Averages.
function Clear_All_Averages_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_All_Averages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadvars_index_list = get(handles.Index_List,'String');
loadvars_index_list(:) = [];
set(handles.Index_List,'String',loadvars_index_list)
gui_parameter_change('.generate_loaddata_loadvars','index_list',get(handles.Index_List,'String'));

loadvars_average_list = get(handles.Average_List,'String');
loadvars_average_list(:) = [];
set(handles.Average_List,'String',loadvars_average_list)
gui_parameter_change('.generate_loaddata_loadvars','average_list',get(handles.Index_List,'String'));


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
function Topomap_Style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Topomap_Style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Topomap_Style.
function Topomap_Style_Callback(hObject, eventdata, handles)
% hObject    handle to Topomap_Style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Topomap_Style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Topomap_Style

gui_parameter_change('.generate_loaddata_loadvars','topomap_style',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Electrode_To_Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Electrode_To_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Electrode_To_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Electrode_To_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Electrode_To_Plot as text
%        str2double(get(hObject,'String')) returns contents of Electrode_To_Plot as a double

gui_parameter_change('.generate_loaddata_loadvars','electrode_to_plot',get(handles.Electrode_To_Plot,'String'));


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
gui_parameter_change('.generate_loaddata_loadvars','electrode_list',electrode_list);


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
gui_parameter_change('.generate_loaddata_loadvars','electrode_list',electrode_list);
set(handles.Electrode_List,'String',electrode_list)
set(handles.Electrode_List,'Value',el_pos-1)


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadvars_pos = get(handles.Index_List,'Value');
loadvars_index = get(handles.Index_List,'String');

if loadvars_pos > 1 % If not at first or last row
    % Gets current lists
    loadvars_index = get(handles.Index_List,'String');
    loadvars_average = get(handles.Average_List,'String');
    
    % Extracts relevant lines
    index_old = loadvars_index{loadvars_pos}; index_new = loadvars_index{loadvars_pos-1};
    average_old = loadvars_average{loadvars_pos}; average_new = loadvars_average{loadvars_pos-1};
    
    % Switches lines
    loadvars_index{loadvars_pos-1} = index_old; loadvars_index{loadvars_pos} = index_new;
    loadvars_average{loadvars_pos-1} = average_old; loadvars_average{loadvars_pos} = average_new;
    
    % Sets new lists
    set(handles.Index_List,'String',loadvars_index)
    set(handles.Average_List,'String',loadvars_average)

    gui_parameter_change('.generate_loaddata_loadvars','index_list',get(handles.Index_List,'String'));
    gui_parameter_change('.generate_loaddata_loadvars','average_list',get(handles.Index_List,'String'));
    
    % Updates highlighted row
    set(handles.Index_List,'Value',loadvars_pos-1)
    highlighter(handles.Index_List,eventdata,handles);
end

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadvars_pos = get(handles.Index_List,'Value');
loadvars_index = get(handles.Index_List,'String');

if loadvars_pos < length(loadvars_index) % If not at last row
    % Gets current lists
    loadvars_index = get(handles.Index_List,'String');
    loadvars_average = get(handles.Average_List,'String');

    % Extracts relevant lines
    index_old = loadvars_index{loadvars_pos}; index_new = loadvars_index{loadvars_pos+1};
    average_old = loadvars_average{loadvars_pos}; average_new = loadvars_average{loadvars_pos+1};

    % Switches lines
    loadvars_index{loadvars_pos+1} = index_old; loadvars_index{loadvars_pos} = index_new;
    loadvars_average{loadvars_pos+1} = average_old; loadvars_average{loadvars_pos} = average_new;

    % Sets new lists
    set(handles.Index_List,'String',loadvars_index)
    set(handles.Average_List,'String',loadvars_average)

    gui_parameter_change('.generate_loaddata_loadvars','index_list',get(handles.Index_List,'String'));
    gui_parameter_change('.generate_loaddata_loadvars','average_list',get(handles.Index_List,'String'));

    % Updates highlighted row
    set(handles.Index_List,'Value',loadvars_pos+1)
    highlighter(handles.Index_List,eventdata,handles);
end


% --- Executes on button press in Cache_Erp.
function Cache_Erp_Callback(hObject, eventdata, handles)
% hObject    handle to Cache_Erp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Cache_Erp

gui_parameter_change('.generate_loaddata_loadvars','cache_erp',get(hObject,'Value'));


% --- Executes on button press in Cache_Tfd.
function Cache_Tfd_Callback(hObject, eventdata, handles)
% hObject    handle to Cache_Tfd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Cache_Tfd

gui_parameter_change('.generate_loaddata_loadvars','cache_tfd',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Scaling_Factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Scaling_Factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Scaling_Factor_Callback(hObject, eventdata, handles)
% hObject    handle to Scaling_Factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Scaling_Factor as text
%        str2double(get(hObject,'String')) returns contents of Scaling_Factor as a double

gui_parameter_change('.generate_loaddata_loadvars','scaling_factor',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Default_Colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Default_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Default_Colormap.
function Default_Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to Default_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Default_Colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Default_Colormap

gui_parameter_change('.generate_loaddata_loadvars','default_colormap',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Plot_File_Format_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plot_File_Format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Plot_File_Format.
function Plot_File_Format_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_File_Format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Plot_File_Format contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Plot_File_Format

gui_parameter_change('.generate_loaddata_loadvars','plot_file_format',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function Tfd_Baseline_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tfd_Baseline_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Tfd_Baseline_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Tfd_Baseline_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tfd_Baseline_Start as text
%        str2double(get(hObject,'String')) returns contents of Tfd_Baseline_Start as a double

gui_parameter_change('.generate_loaddata_loadvars','tfd_baseline_start',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Tfd_Baseline_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tfd_Baseline_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Tfd_Baseline_End_Callback(hObject, eventdata, handles)
% hObject    handle to Tfd_Baseline_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tfd_Baseline_End as text
%        str2double(get(hObject,'String')) returns contents of Tfd_Baseline_End as a double

gui_parameter_change('.generate_loaddata_loadvars','tfd_baseline_end',get(hObject,'String'));

