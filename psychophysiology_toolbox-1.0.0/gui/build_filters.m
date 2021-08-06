function erp = build_filters(erp,filtervars,verbosity)

% erp = build_filters(erp,filtervars[,verbosity])
% Builds various filters that are defined by filtervars fields.
% Parameters:
%  erp              = data structure to be modified
%  filtervars       = structure containing cell arrays of filter parameters
%
%    .electrodes    = cell arrays of electrodes to which each filter should be applied
%    .subjects      = cell arrays of subject names (erp.subs.name) to which each filter should be applied
%    .filter        = filters to apply
%    .frequencies   = frequencies to use in filtering, if applicable
%    .order         = order to use for sprIIR filter
%    .highlowpass   = whether each sprIIR filter should operate as a high or low pass filter
%    .time_constant = time constants to use in sprIIR filters
%
%  verbosity        = level of output (0 = no output, >0 = basic output)
%
% Psychophysiology Toolbox - Data Processing 0.9.5, Stephen D. Benning, University of Minnesota

% Applies filters sequentially to data file
if verbosity > 0, disp('Multifilter processing: START'), end

for i = 1:length(filtervars); % Iterates through each filter definition

    if verbosity > 0, disp(['Applying ' char(filtervars(i).filter) ' filter...']), end
    logic = zeros(size(erp.elec));
    
    % Creates electrodes logic vector
    current_electrode_list = filtervars(i).electrodes;
    if ~strcmp(char(current_electrode_list),'ALL') & ~strcmp(char(current_electrode_list),'all')
        logic_elec = zeros(size(erp.elec));
        for j = 1:length(current_electrode_list)
            current_electrode = char(current_electrode_list{j});
            logic_elec = logic_elec==1|erp.elec==erp.elec(strmatch(current_electrode,erp.elecnames));
        end
    else
        logic_elec = logical(ones(size(erp.elec)));
    end
    
    % Creates subjects logic vector
    current_subject_list = filtervars(i).subjects;
    if ~strcmp(char(current_subject_list),'ALL') & ~strcmp(char(current_subject_list),'all')
        logic_subject = zeros(size(erp.elec));
        for j = 1:length(current_subject_list)
            current_subject = char(current_subject_list{j});
            logic_subject = logic_subject==1|erp.subnum==erp.subnum(strmatch(current_subject,erp.subs.name));
        end
    else
        logic_subject = logical(ones(size(erp.elec)));
    end
    
    % Creates master logic vector and specifies rows to filter
    logic = logic_elec==1&logic_subject==1; 
    filtered_rows = find(logic==1);
  
    % Sets filter parameters
    switch char(filtervars(i).filter)
        case {'highpass','lowpass','bandpass','stopband'}
            filter_def = ['filts_' char(filtervars(i).filter) '_butter(erp.data(filtered_rows,:),[' num2str(filtervars(i).frequencies) ...
                    ']/(erp.samplerate/2),' num2str(filtervars(i).order) ');'];
        case {'sprIIR'}
            filter_def = ['filts_' char(filtervars(i).filter) '(erp.data(filtered_rows,:),' num2str(filtervars(i).time_constant) ...
                    '*(erp.samplerate/1000),''' num2str(filtervars(i).highlowpass) ''');'];
        case {'rectify'}
            filter_def = 'abs(erp.data(filtered_rows,:));';
        case {'invert'}
            filter_def = '-1*erp.data(filtered_rows,:);';
        case {'delete'}
            filter_def = '[];';
    end

    % Filters data
    eval(['erp.data(filtered_rows,:) = ' filter_def])
    
end

if verbosity > 0, disp('Multifilter processing: END'), end
