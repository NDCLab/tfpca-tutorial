function varargout = Main(varargin)
% MAIN M-file for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 04-Jan-2005 16:53:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.Main);

% Initializes gui_parameters
if exist('default_gui_parameters.mat')
	load default_gui_parameters
else
	gui_parameters = '';
end

gui_parameters = gui_parameter_default(gui_parameters,'','default_load_dir',pwd);
gui_parameters = gui_parameter_default(gui_parameters,'','default_save_dir',pwd);
gui_parameters = gui_parameter_default(gui_parameters,'','default_script_dir',pwd);

gui_parameters = gui_parameter_default(gui_parameters,'','add_stim',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','advanced_components',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','create_master_script',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','create_startup',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','define_stats',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','directory_select',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','epoch_data',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','extract_averages',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','extract_trials',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','file_select',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','filter_builder',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','generate_loaddata_loadvars',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','get_components',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','import_data',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','plot_erpdata',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','rereference_data',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','tag_artifacts',[]);
gui_parameters = gui_parameter_default(gui_parameters,'','update_data',[]);

assignin('base','gui_parameters',gui_parameters)


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles)
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


% --------------------------------------------------------------------
function BasicMenu_Callback(hObject, eventdata, handles)
% hObject    handle to BasicMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Tools_Callback(hObject, eventdata, handles)
% hObject    handle to Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Set_Default_Load_Data_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Default_Load_Data_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
gui_parameter_change('','default_load_dir',gui_parameters.directory_select.selected_dir);


% --------------------------------------------------------------------
function Import_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Import_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Import_Data;

% --------------------------------------------------------------------
function Extract_Trials_from_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Extract_Trials_from_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Extract_Trials;

% --------------------------------------------------------------------
function Set_Default_Save_Data_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Default_Save_Data_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
gui_parameter_change('','default_save_dir',gui_parameters.directory_select.selected_dir);


% --- Executes on button press in Start_Wizard.
function Start_Wizard_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Wizard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Closes active window
close(Main)


% --------------------------------------------------------------------
function Extract_Averages_Callback(hObject, eventdata, handles)
% hObject    handle to Extract_Averages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Extract_Averages;

% --------------------------------------------------------------------
function Epoch_Callback(hObject, eventdata, handles)
% hObject    handle to Epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Epoch_Data;

% --------------------------------------------------------------------
function Rereference_Callback(hObject, eventdata, handles)
% hObject    handle to Rereference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Rereference_Data;

% --------------------------------------------------------------------
function Tag_Artifacts_Callback(hObject, eventdata, handles)
% hObject    handle to Tag_Artifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Tag_Artifacts;

% --------------------------------------------------------------------
function Plot_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Plot_Erpdata;

% --------------------------------------------------------------------
function Get_Components_Callback(hObject, eventdata, handles)
% hObject    handle to Get_Components (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
gui_parameter_change('.get_components','review_components',0);
pop_Get_Components;


% --------------------------------------------------------------------
function Review_Components_Callback(hObject, eventdata, handles)
% hObject    handle to Review_Components (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
gui_parameter_change('.get_components','review_components',1);
pop_Get_Components;


% --------------------------------------------------------------------
function Generate_Loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Generate_Loaddata_Loadvars;

% --------------------------------------------------------------------
function Modify_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Modify_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Update_File_Callback(hObject, eventdata, handles)
% hObject    handle to Update_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Update_Data;

% --------------------------------------------------------------------
function Add_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Add_Stim;

% --------------------------------------------------------------------
function Advanced_Component_Extraction_Callback(hObject, eventdata, handles)
% hObject    handle to Advanced_Component_Extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Extract_Components_Callback(hObject, eventdata, handles)
% hObject    handle to Extract_Components (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Advanced_Components;

% --------------------------------------------------------------------
function Filter_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Filter_Builder;

% --------------------------------------------------------------------
function Script_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Script_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
gui_parameter_change('','default_script_dir',gui_parameters.directory_select.selected_dir);


% --------------------------------------------------------------------
function Set_Default_Dirs_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Create_Preprocessing_Scripts_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Preprocessing_Scripts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Create_Dirs_Startups_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Dirs_Startups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Create_Components_Directories_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Components_Directories (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    if ~exist([selected_dir filesep 'data_cache'],'dir'), mkdir(selected_dir,'data_cache'); end
    if ~exist([selected_dir filesep 'output_data'],'dir'), mkdir(selected_dir,'output_data'); end
    if ~exist([selected_dir filesep 'output_plots'],'dir'), mkdir(selected_dir,'output_plots'); end
    if ~exist([selected_dir filesep 'scripts'],'dir'), mkdir(selected_dir,'scripts'); end
end

% --------------------------------------------------------------------
function Create_Startup_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Startup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Create_Startup;


% --------------------------------------------------------------------
function View_File_Contents_Callback(hObject, eventdata, handles)
% hObject    handle to View_File_Contents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function No_Help_Callback(hObject, eventdata, handles)
% hObject    handle to No_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Create_Master_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Master_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pop_Create_Master_Script;
