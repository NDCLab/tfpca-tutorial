function varargout = pop_Import_Data(varargin)
% POP_SCRIPT_NAME M-file for pop_Import_Data.fig
%      POP_SCRIPT_NAME, by itself, creates a new POP_SCRIPT_NAME or raises the existing
%      singleton*.
%
%      H = POP_SCRIPT_NAME returns the handle to a new POP_SCRIPT_NAME or the handle to
%      the existing singleton*.
%
%      POP_SCRIPT_NAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_SCRIPT_NAME.M with the given input arguments.
%
%      POP_SCRIPT_NAME('Property','Value',...) creates a new POP_SCRIPT_NAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pop_Import_Data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pop_Import_Data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pop_Import_Data

% Last Modified by GUIDE v2.5 13-Mar-2005 16:22:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pop_Import_Data_OpeningFcn, ...
                   'gui_OutputFcn',  @pop_Import_Data_OutputFcn, ...
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


% --- Executes just before pop_Import_Data is made visible.
function pop_Import_Data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pop_Import_Data (see VARARGIN)

% Choose default command line output for pop_Import_Data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initializes gui_parameters
blank_gui_parameters = [];
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');

assignin('base','gui_parameters',gui_parameters)

gui_parameters = gui_parameter_default(gui_parameters,'.import_data','load_dir',gui_parameters.default_load_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','load_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','save_dir',gui_parameters.default_save_dir);
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','save_append_text','');
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','save_file','');
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','data_format','.cnt');
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','scale2uv',0);
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','verbosity','1');
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','data_bit_length','int16');
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','generate_script',0);
gui_parameters = gui_parameter_default(gui_parameters,'.import_data','script_file','import_data_script');
gui_parameters = gui_parameter_default(gui_parameters,'.add_stim','called_from_import_data',0);
gui_parameters = gui_parameter_default(gui_parameters,'.epoch_data','called_from_import_data',0);
gui_parameters = gui_parameter_default(gui_parameters,'.filter_builder','called_from_import_data',0);
gui_parameters = gui_parameter_default(gui_parameters,'.rereference_data','called_from_import_data',0);


    set(handles.Select_Load_Data_Dir,'String',gui_parameters.import_data.load_dir)
    set(handles.Select_Data_Load_File,'String',gui_parameters.import_data.load_file)
    set(handles.Select_Save_Data_Dir,'String',gui_parameters.import_data.save_dir)
    set(handles.Save_Append_Text,'String',gui_parameters.import_data.save_append_text)
    set(handles.Select_Data_Save_File,'String',gui_parameters.import_data.save_file)
    switch gui_parameters.import_data.data_format
        case '.cnt'
            set(handles.Select_Data_Format,'Value',1)
        case '.eeg'
            set(handles.Select_Data_Format,'Value',2)
        case '.avg'
            set(handles.Select_Data_Format,'Value',3)
        case '.bdf'
            set(handles.Select_Data_Format,'Value',4)
        case '.edf'
            set(handles.Select_Data_Format,'Value',5)
    end
    set(handles.Scale2uV,'Value',gui_parameters.import_data.scale2uv)
    switch gui_parameters.import_data.data_bit_length
        case 'int16'
            set(handles.Select_Data_Bits,'Value',1)
        case 'int32'
            set(handles.Select_Data_Bits,'Value',2)
    end
    set(handles.Verbosity,'String',gui_parameters.import_data.verbosity)
    set(handles.Generate_Script,'Value',gui_parameters.import_data.generate_script)
    set(handles.Script_Name,'String',gui_parameters.import_data.script_file)
    set(handles.Add_Stim,'Value',gui_parameters.add_stim.called_from_import_data)
    set(handles.Epoch_Data,'Value',gui_parameters.epoch_data.called_from_import_data)
    set(handles.Filter_Data,'Value',gui_parameters.filter_builder.called_from_import_data)
    set(handles.Rereference_Data,'Value',gui_parameters.rereference_data.called_from_import_data)

assignin('base','gui_parameters',gui_parameters)

% UIWAIT makes pop_Import_Data wait for user response (see UIRESUME)
% uiwait(handles.pop_Import_Data);


% --- Outputs from this function are returned to the command line.
function varargout = pop_Import_Data_OutputFcn(hObject, eventdata, handles)
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


% --- Executes during object creation, after setting all properties.
function Select_Data_Format_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Select_Data_Format.
function Select_Data_Format_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Data_Format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Data_Format contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Data_Format

% Selects data format
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
data_selection = get(hObject,'Value');
switch data_selection
    case 1
        gui_parameter_change('.import_data','data_format','.cnt');
    case 2
        gui_parameter_change('.import_data','data_format','.eeg');
    case 3
        gui_parameter_change('.import_data','data_format','.avg');
    case 4
        gui_parameter_change('.import_data','data_format','.bdf');
    case 5
        gui_parameter_change('.import_data','data_format','.edf');
end


% --- Executes during object creation, after setting all properties.
function Select_Load_Data_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Load_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Select_Load_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Load_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Load_Data_Dir as text
%        str2double(get(hObject,'String')) returns contents of Select_Load_Data_Dir as a double

gui_parameter_change('.import_data','load_dir',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Select_Save_Data_Dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Select_Save_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Save_Data_Dir as text
%        str2double(get(hObject,'String')) returns contents of Select_Save_Data_Dir as a double

gui_parameter_change('.import_data','save_dir',get(hObject,'String'));


% --- Executes on button press in Import_Data_Directory_Button.
function Import_Data_Directory_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Import_Data_Directory_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sets the parameters for each file's extraction
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
data_format = gui_parameters.import_data.data_format;
data_format = data_format(2:4);
load_data_dir = get(handles.Select_Load_Data_Dir,'String');
save_data_dir = get(handles.Select_Save_Data_Dir,'String');
save_append_text = get(handles.Save_Append_Text,'String');
scale2uv = num2str(gui_parameters.import_data.scale2uv);
verbosity = gui_parameters.import_data.verbosity;
data_bit_length = gui_parameters.import_data.data_bit_length;

% Makes a list of all files with the appropriate extension
% and imports data from each file
file_list = dir([load_data_dir filesep '*.' data_format]);

for i = 1:length(file_list)
    base_name = file_list(i).name;
    dotpos = find(base_name == '.');
    base_name = base_name(1:dotpos(length(dotpos))-1);

    no_functions_called = gui_parameters.epoch_data.called_from_import_data ~= 1 & ...
          gui_parameters.rereference_data.called_from_import_data ~= 1 & ...
          gui_parameters.filter_builder.called_from_import_data ~= 1 & ...
          gui_parameters.add_stim.called_from_import_data ~= 1;

    if no_functions_called
        params = [data_format '2mat(''' load_data_dir filesep char(file_list(i).name) ...
              ''',''' save_data_dir filesep base_name save_append_text ...
	      ''',' scale2uv ',' verbosity ',''' data_bit_length ''');'];
	erp = eval(params);
    else
        params = [data_format '2mat(''' load_data_dir filesep char(file_list(i).name) ...
              ''','''',' scale2uv ',' verbosity ',''' data_bit_length ''');'];
        erp = eval(params);
        if gui_parameters.epoch_data.called_from_import_data == 1, erp = epoch_data(gui_parameters,erp); end
        if gui_parameters.rereference_data.called_from_import_data == 1, erp = rereference_data(gui_parameters,erp); end
        if gui_parameters.filter_builder.called_from_import_data == 1, erp = filter_data(gui_parameters,erp); end
        if gui_parameters.add_stim.called_from_import_data == 1, erp = add_stim(gui_parameters,erp); end
        eval(['save ' [save_data_dir filesep base_name save_append_text] ' erp;']);
    end
    clear erp
end

% Writes out a lovely script in default_script_dir, if desired
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
        script_header(fid);
        fprintf(fid,'%% Sets the parameters for each file extraction\n');
        fprintf(fid,'data_format = ''%s'';\n',data_format);
        fprintf(fid,'load_data_dir = ''%s'';\n',get(handles.Select_Load_Data_Dir,'String'));
        fprintf(fid,'save_data_dir = ''%s'';\n',get(handles.Select_Save_Data_Dir,'String'));
        fprintf(fid,'save_append_text = ''%s'';\n',get(handles.Save_Append_Text,'String'));
        fprintf(fid,'scale2uv = [%s];\n',scale2uv);
        fprintf(fid,'verbosity = [%s];\n',verbosity);
        fprintf(fid,'data_bit_length = ''%s'';\n\n',data_bit_length);
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'%% Makes a list of all files with the appropriate extension\n');
        fprintf(fid,'%% and imports data from each file\n');
        fprintf(fid,'file_list = dir([load_data_dir filesep ''*.'' data_format]);\n');
        fprintf(fid,'for i = 1:length(file_list)\n');
        fprintf(fid,'    base_name = file_list(i).name;\n');
        fprintf(fid,'    dotpos = find(base_name == ''.'');\n');
        fprintf(fid,'    base_name = base_name(1:dotpos(length(dotpos))-1);\n');
        if no_functions_called
            fprintf(fid,'    params = [data_format ''2mat('''''' load_data_dir filesep char(file_list(i).name) ...\n');
            fprintf(fid,'            '''''','''' save_data_dir filesep file_list(i).name save_append_text ...\n');
	    fprintf(fid,'            '''''','' num2str(scale2uv) '','' num2str(verbosity) '','''''' data_bit_length '''''');''];\n');
            fprintf(fid,'erp = eval(params);\n');
        else
            fprintf(fid,'    params = [data_format ''2mat('''''' load_data_dir filesep char(file_list(i).name) ...\n');
            fprintf(fid,'            '''''','''''''','' num2str(scale2uv) '','' num2str(verbosity) '','''''' data_bit_length '''''');''];\n');
            fprintf(fid,'    erp = eval(params);\n');
            if gui_parameters.epoch_data.called_from_import_data == 1, print_epoch_data(gui_parameters,fid); end
            if gui_parameters.rereference_data.called_from_import_data == 1, print_rereference_data(gui_parameters,fid); end
            if gui_parameters.filter_builder.called_from_import_data == 1, print_filter_data(gui_parameters,fid); end
            if gui_parameters.add_stim.called_from_import_data == 1, print_add_stim(gui_parameters,fid); end
            fprintf(fid,'    eval([''save '' [save_data_dir filesep base_name save_append_text] '' erp;'']);\n');
        end
        fprintf(fid,'    clear erp; pack\n');
        fprintf(fid,'end\n');

        fclose(fid);
    end
end

% Resets called_from_import_data parameters
gui_parameter_change('.epoch_data','called_from_import_data',0);
gui_parameter_change('.rereference_data','called_from_import_data',0);
gui_parameter_change('.filter_builder','called_from_import_data',0);
gui_parameter_change('.add_stim','called_from_import_data',0);
    
% Closes active window
close(pop_Import_Data)


% Function to generate a header for each script
function script_header(fid)
fprintf(fid,'%% Script generated on %s\n',datestr(date));
fprintf(fid,'%% by the Psychophysiology Toolbox GUI written by\n');
fprintf(fid,'%% Stephen D. Benning, University of Minnesota.\n');
fprintf(fid,'%% The Psychophysiology Toolbox is written by\n');
fprintf(fid,'%% Edward M. Bernat, University of Minnesota.\n\n');


function erp = add_stim(gui_parameters,erp)
stim_list = fieldnames(gui_parameters.add_stim.definitions);
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

if ~isempty(stimvars), erp = generate_stimvars(erp,stimvars); end

% Generates trialnums variables, if defined
trialnums = gui_parameters.add_stim.trialnums;
if ~isempty(trialnums), erp = generate_trialcounts(erp,trialnums); end % If trial number list specified to be written out


function erp = epoch_data(gui_parameters,erp)
% Sets parameters to execute data epoching
data_format = gui_parameters.epoch_data.data_format;
data_format = data_format(2:4);
trigger_numbers = str2num(['[' gui_parameters.epoch_data.trigger_numbers ']']);
epoch_start = str2num(gui_parameters.epoch_data.epoch_start);
epoch_end = str2num(gui_parameters.epoch_data.epoch_end);
verbosity = str2num(gui_parameters.epoch_data.verbosity);

% Combines parameters, then executes the epoch routine
erp = epoch(erp,trigger_numbers,epoch_start,epoch_end,verbosity);


function erp = filter_data(gui_parameters,erp)
% Creates filtervars variable
filtervars = [];
filtervars.electrodes = gui_parameters.filter_builder.filter_electrode_list;
filtervars.subjects = gui_parameters.filter_builder.filter_subject_list;
filtervars.filter = gui_parameters.filter_builder.filter_type_list;
filtervars.frequencies = gui_parameters.filter_builder.filter_freqs_list;
filtervars.order = gui_parameters.filter_builder.filter_order_list;
filtervars.highlowpass = gui_parameters.filter_builder.filter_highlowpass_list;
filtervars.time_constant = gui_parameters.filter_builder.filter_time_constant_list;

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
verbosity = gui_parameters.import_data.verbosity;

% DO NOT ALTER ANYTHING BELOW THIS LINE!
% Applies filters sequentially to data file
erp = build_filters(erp,filtervars,verbosity);


function erp = rereference_data(gui_parameters,erp)
% Sets the parameters for each file's rereferencing
data_format = gui_parameters.rereference_data.data_format;
data_format = data_format(2:4);
ldr_file = gui_parameters.rereference_data.ldr_file;
verbosity = str2num(gui_parameters.rereference_data.verbosity);

% Rereferences data from each file
erp = rereference(erp,ldr_file,verbosity);


function print_add_stim(gui_parameters,fid)

stim_list = fieldnames(gui_parameters.add_stim.definitions);
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

if ~isempty(stim_list), fprintf(fid,'\nerp = generate_stimvars(erp,stimvars);\n\n'); end

trialnums = gui_parameters.add_stim.trialnums;
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
		
    if ~isempty(trialnums), fprintf(fid,'\nerp = generate_trialcounts(erp,trialnums);\n'); end; % If trial number list specified to be written out

end


function print_epoch_data(gui_parameters,fid)

fprintf(fid,'%% Sets the parameters for each file extraction\n');
fprintf(fid,'data_format = ''%s'';\n',gui_parameters.epoch_data.data_format(2:4));
fprintf(fid,'trigger_numbers = [%s];\n',gui_parameters.epoch_data.trigger_numbers);
fprintf(fid,'epoch_start = [%s];\n',gui_parameters.epoch_data.epoch_start);
fprintf(fid,'epoch_end = [%s];\n',gui_parameters.epoch_data.epoch_end);
fprintf(fid,'verbosity = [%s];\n',gui_parameters.epoch_data.verbosity);
fprintf(fid,'%% Epochs data from the specified file\n');
fprintf(fid,'erp = epoch(erp,trigger_numbers,epoch_start,epoch_end,verbosity)\n');


function print_filter_data(gui_parameters,fid)
% Creates filtervars variable
filtervars = [];
filtervars.electrodes = gui_parameters.filter_builder.filter_electrode_list;
filtervars.subjects = gui_parameters.filter_builder.filter_subject_list;
filtervars.filter = gui_parameters.filter_builder.filter_type_list;
filtervars.frequencies = gui_parameters.filter_builder.filter_freqs_list;
filtervars.order = gui_parameters.filter_builder.filter_order_list;
filtervars.highlowpass = gui_parameters.filter_builder.filter_highlowpass_list;
filtervars.time_constant = gui_parameters.filter_builder.filter_time_constant_list;

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


function print_rereference_data(gui_parameters,fid)

fprintf(fid,'%% Sets the parameters for each file extraction\n');
fprintf(fid,'ldr_file = ''%s'';\n',gui_parameters.rereference_data.ldr_file);
fprintf(fid,'verbosity = [%s];\n',gui_parameters.rereference_data.verbosity);
fprintf(fid,'%% Rereferences data in each file\n');
fprintf(fid,'erp = rereference(erp,ldr_file,verbosity);\n');


% --- Executes on button press in Browse_Load_Data_Dir.
function Browse_Load_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Load_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the directory selection dialog box
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Select_Load_Data_Dir,'String',selected_dir)
    set(handles.Select_Save_Data_Dir,'String',selected_dir)
    gui_parameter_change('.import_data','load_dir',selected_dir);
end
    
% --- Executes on button press in Browse_Save_Data_Dir.
function Browse_Save_Data_Dir_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Save_Data_Dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls the directory selection dialog box
pop_Directory_Select;
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
selected_dir = gui_parameters.directory_select.selected_dir;
if ~strcmp(selected_dir,'No directory selected.')
    set(handles.Select_Save_Data_Dir,'String',selected_dir)
    gui_parameter_change('.import_data','save_dir',selected_dir);
end
    
% --- Executes during object creation, after setting all properties.
function Select_Data_Load_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Select_Data_Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Data_Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Data_Load_File as text
%        str2double(get(hObject,'String')) returns contents of Select_Data_Load_File as a double

gui_parameter_change('.import_data','load_file',get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Select_Data_Save_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Select_Data_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Select_Data_Save_File as text
%        str2double(get(hObject,'String')) returns contents of
%        Select_Data_Save_File as a double

gui_parameter_change('.import_data','save_file',get(hObject,'String'));


% --- Executes on button press in Import_Data_File_Button.
function Import_Data_File_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Import_Data_File_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Sets parameters to execute data importing
gui_parameters = evalin('base','gui_parameters','blank_gui_parameters');
data_format = gui_parameters.import_data.data_format;
data_format = data_format(2:4);
load_data_file = get(handles.Select_Data_Load_File,'String');
save_data_file = get(handles.Select_Data_Save_File,'String');
scale2uv = gui_parameters.import_data.scale2uv;
verbosity = gui_parameters.import_data.verbosity;
data_bit_length = gui_parameters.import_data.data_bit_length;

% Combines parameters, then executes the import routine
no_functions_called = gui_parameters.epoch_data.called_from_import_data ~= 1 & ...
      gui_parameters.rereference_data.called_from_import_data ~= 1 & ...
      gui_parameters.filter_builder.called_from_import_data ~= 1 & ...
      gui_parameters.add_stim.called_from_import_data ~= 1;
if no_functions_called
    params = [data_format '2mat(''' load_data_file ''',''' save_data_file ''',' ...
            scale2uv ',' verbosity ',''' data_bit_length ''');'];
    erp = eval(params);
else
    params = [data_format '2mat(''' load_data_file ''','''',' ...
            scale2uv ',' verbosity ',''' data_bit_length ''');'];
    erp = eval(params);
    if gui_parameters.epoch_data.called_from_import_data == 1, erp = epoch_data(gui_parameters,erp); end
    if gui_parameters.rereference_data.called_from_import_data == 1, erp = rereference_data(gui_parameters,erp); end
    if gui_parameters.filter_builder.called_from_import_data == 1, erp = filter_data(gui_parameters,erp); end
    if gui_parameters.add_stim.called_from_import_data == 1, erp = add_stim(gui_parameters,erp); end
    save(save_data_file,'erp');
end
clear erp


% Writes out a lovely script in save_data_dir, if desired
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
        script_header(fid);
        fprintf(fid,'%% Sets the parameters for each file extraction\n');
        fprintf(fid,'data_format = ''%s'';\n',data_format);
        fprintf(fid,'load_data_file = ''%s'';\n',get(handles.Select_Data_Load_File,'String'));
        fprintf(fid,'save_data_file = ''%s'';\n',get(handles.Select_Data_Save_File,'String'));
        fprintf(fid,'scale2uv = %s;\n',scale2uv);
        fprintf(fid,'verbosity = %s;\n',verbosity);
        fprintf(fid,'data_bit_length = ''%s'';\n\n',data_bit_length);
        fprintf(fid,'%% DO NOT ALTER ANYTHING BELOW THIS LINE!\n');
        fprintf(fid,'%% Imports data from the specified file\n');
        if no_functions_called
            fprintf(fid,'params = [data_format ''2mat('''''' load_data_file ...\n');
            fprintf(fid,'        '''''','''''' save_data_file '''''','' scale2uv ...\n');
            fprintf(fid,'        '','' verbosity '','''''' data_bit_length '''''');''];\n');
            fprintf(fid,'erp = eval(params);\n');
        else
            fprintf(fid,'params = [data_format ''2mat('''''' load_data_file ...\n');
            fprintf(fid,'        '''''','''','' scale2uv '','' verbosity '','''''' data_bit_length '''''');''];\n');
            fprintf(fid,'erp = eval(params);\n');
            if gui_parameters.epoch_data.called_from_import_data == 1, print_epoch_data(gui_parameters,fid); end
            if gui_parameters.rereference_data.called_from_import_data == 1, print_rereference_data(gui_parameters,fid); end
            if gui_parameters.filter_builder.called_from_import_data == 1, print_filter_data(gui_parameters,fid); end
            if gui_parameters.add_stim.called_from_import_data == 1, print_add_stim(gui_parameters,fid); end
            fprintf(fid,'save(save_data_file),''erp'')\n');
        end
        fprintf(fid,'clear erp\n');
        fclose(fid);
    end
end

% Resets called_from_import_data parameters
gui_parameter_change('.epoch_data','called_from_import_data',0);
gui_parameter_change('.rereference_data','called_from_import_data',0);
gui_parameter_change('.filter_builder','called_from_import_data',0);
gui_parameter_change('.add_stim','called_from_import_data',0);

% Closes active window
close(pop_Import_Data)

% --- Executes on button press in Browse_Data_File_Load.
function Browse_Data_File_Load_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_File_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = gui_parameters.import_data.data_format;
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    selected_file = gui_parameters.file_select.selected_file;
    set(handles.Select_Data_Load_File,'String',selected_file)
    dotpos = find(selected_file == '.');
    base_name = selected_file(1:dotpos(length(dotpos))-1);
    data_format = gui_parameters.import_data.data_format;
    if strcmp(data_format,'.cnt') | strcmp(data_format,'.bdf') | strcmp(data_format,'.edf')
        load_file_name = [base_name data_format '.mat'];
    else
        load_file_name = [base_name '.mat'];
    end
    set(handles.Select_Data_Save_File,'String',load_file_name)
    gui_parameter_change('.import_data','save_file',load_file_name);
end
    
% --- Executes on button press in Browse_Data_Save_File.
function Browse_Data_Save_File_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Data_Save_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes to correct file format
gui_parameters = evalin('base','gui_parameters');
gui_parameters.file_select.data_format = '.mat';
assignin('base','gui_parameters',gui_parameters)

% Calls file selector and sets text box value
pop_File_Select;
gui_parameters = evalin('base','gui_parameters');
if ~strcmp('No file selected.',gui_parameters.file_select.selected_file)
    selected_file = gui_parameters.file_select.selected_file;
    dotpos = find(selected_file == '.');
    base_name = selected_file(1:dotpos(length(dotpos))-1);
    data_format = evalin('base','data_format');
    if strcmp(data_format,'.cnt') | strcmp(data_format,'.bdf') | strcmp(data_format,'.edf')
        save_file_name = [base_name data_format '.mat'];
    else
        save_file_name = [base_name '.mat'];
    end
    set(handles.Select_Data_Save_File,'String',save_file_name)
    gui_parameter_change('.import_data','save_file',save_file_name);
end
    
% --- Executes during object creation, after setting all properties.
function Select_Data_Bits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Data_Bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in Select_Data_Bits.
function Select_Data_Bits_Callback(hObject, eventdata, handles)
select_data_bits = get(hObject,'Value');
switch select_data_bits
    case 1
        gui_parameter_change('.import_data','data_bit_length','int16');
    case 2
        gui_parameter_change('.import_data','data_bit_length','int32');
end


% --- Executes on button press in Scale2uV.
function Scale2uV_Callback(hObject, eventdata, handles)
% hObject    handle to Scale2uV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Scale2uV

gui_parameter_change('.import_data','scale2uv',get(hObject,'Value'));


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

gui_parameter_change('.import_data','verbosity',get(hObject,'String'));


% --- Executes on button press in Generate_Script.
function Generate_Script_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Generate_Script

gui_parameter_change('.import_data','generate_script',get(hObject,'Value'));


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
%        str2double(get(hObject,'String')) returns contents of Script_Name as a double

gui_parameter_change('.import_data','script_file',get(hObject,'String'));


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
    file_name = file_name(fileseps(length(fileseps))+1:dotpos(length(dotpos))-1);
    set(handles.Script_Name,'String',file_name)
    gui_parameter_change('.import_data','script_file',get(handles.Script_File,'String'));
end


% --- Executes on button press in Epoch_Data.
function Epoch_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Epoch_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Epoch_Data

gui_parameter_change('.epoch_data','called_from_import_data',get(hObject,'Value'));
if get(hObject,'Value') == 1, pop_Epoch_Data; end

% --- Executes on button press in Rereference_Data.
function Rereference_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Rereference_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rereference_Data

gui_parameter_change('.rereference_data','called_from_import_data',get(hObject,'Value'));
if get(hObject,'Value') == 1, pop_Rereference_Data; end


% --- Executes on button press in Filter_Data.
function Filter_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Filter_Data

gui_parameter_change('.filter_builder','called_from_import_data',get(hObject,'Value'));
if get(hObject,'Value') == 1, pop_Filter_Builder; end


% --- Executes on button press in Add_Stim.
function Add_Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Add_Stim

gui_parameter_change('.add_stim','called_from_import_data',get(hObject,'Value'));
if get(hObject,'Value') == 1, pop_Add_Stim; end


% --- Executes during object creation, after setting all properties.
function Save_Append_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_Append_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Save_Append_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Append_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Save_Append_Text as text
%        str2double(get(hObject,'String')) returns contents of Save_Append_Text as a double

gui_parameter_change('.import_data','save_append_text',get(hObject,'String'));

