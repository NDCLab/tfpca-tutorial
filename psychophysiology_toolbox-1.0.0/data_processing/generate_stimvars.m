function [erp] = generate_stimvars(erp,stimvars)
% [erp] =  generate_stimvars(erp,stimvars)
% 
% Arguments: 
% 
% erp                 erp data structure to process. 
% stimvars            Structured variable containing the names of the stim subfields
%                          to write out and the catcodes defining the values in each
%                          stim subfield.
%    .name            Name of the subfield of erp.stim to write (e.g., 'valence').
%    .catcodes        Structure containing names, logical expressions, and human-
%                          readable descriptions of each value of this stim subfield.
%        .name        The single-character OR numerical value to put in for this value
%                          of the current stim subfield (e.g., 'v').  Within a given
%                          stimvars.name, all of these must be EITHER numerical OR
%                          single-character strings.
%        .text        The logical expression defining this value of the current stim
%                          subfield (e.g., 'erp.accept==1&(erp.ttype==131|erp.ttype==181)').
%        .description The human-readable description of this value of the current stim
%                          subfield (e.g., 'Pleasant').
% 
% Psychophysiology Toolbox - Data Processing 0.9.4, Stephen D. Benning, University of Minnesota  

disp('erp.stim subfield additions: START')

% Iterates through each erp.stim subfield to be generated
for i = 1:length(stimvars)

    disp(['Adding erp.stim.' stimvars(i).name '...'])

    % Initializes current .stim subfield
%    if ischar(stimvars(i).catcodes(j).text)
        eval(['erp.stim.' stimvars(i).name '(:,1) = blanks(length(erp.elec));']);
%    else
%        eval(['erp.stim.' stimvars(i).name '(:,1) = zeros(length(erp.elec));']);
%    end

    % Generates each value for the current erp.stim subfield
    for j = 1:length(stimvars(i).catcodes)

        if ischar(stimvars(i).catcodes(j).text)
            eval(['erp.stim.' stimvars(i).name '(' stimvars(i).catcodes(j).text ',:) = ''' stimvars(i).catcodes(j).name ''';']);
        else
            eval(['erp.stim.' stimvars(i).name '(' stimvars(i).catcodes(j).text ',:) = ' stimvars(i).catcodes(j).name ';']);
        end

        eval(['erp.stimkeys.' stimvars(i).name '(' num2str(j) ').name = ''' stimvars(i).catcodes(j).name ''';']);
        eval(['erp.stimkeys.' stimvars(i).name '(' num2str(j) ').text = ''' stimvars(i).catcodes(j).text ''';']);
        eval(['erp.stimkeys.' stimvars(i).name '(' num2str(j) ').description = ''' stimvars(i).catcodes(j).description ''';']);

    end

end

disp('erp.stim subfield additions: END')
