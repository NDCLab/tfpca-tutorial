function [erp] = generate_trialcounts(erp,trialnums)
% [erp] =  generate_trialnums(erp,trialnums)
%
% Arguments:
%
% erp                 erp data structure to process.
% trialnums           Structure containing names, erp subfields to chunk, and human-
%                          readable descriptions of each trial number vector.
%        .name        The name to use for this trialnum vector (e.g, 'trialnumC').
%        .text        A cell array of the names of the erp subfields by which to chunk
%                          trial numbers (e.g., {'erp.subnum'; 'erp.elec'; 'erp.stim.content'}).
%        .description The human-readable description of the current trialnum subfield
%                          (e.g., 'Content trial numbers').
%
% Psychophysiology Toolbox - Data Processing 0.9.4, Stephen D. Benning, University of Minnesota

% Creates trialnum subfield
for i = 1:length(trialnums)

    disp(['Adding erp.stim.' trialnums(i).name ' trial numbers...'])
    trials_list = trialnums(i).text;
    eval(['erp.stim.' trialnums(i).name '(:,1) = zeros(size(erp.elec));']);
            
    % Declares variables for trialnum creation loop
    for j = 1:length(trials_list)
        eval(['u' num2str(j) ' = unique(' char(trials_list(j)) ');']);
        eval(['length_u' num2str(j) ' = length(u' num2str(j) ');']);
        eval(['counter_u' num2str(j) ' = 1;']);
    end
            
    % Main loop
    while counter_u1 < length_u1 + 1
                
        % Creates logic strings
        logic_string = [];
        for j = 1:length(trials_list)
            if j == 1
                eval(['current_logic_string = ''' char(trials_list(j)) ...
                      '==u' num2str(j) '(counter_u' num2str(j) ')'';']);
            else
                eval(['current_logic_string = ''&' char(trials_list(j)) ...
                      '==u' num2str(j) '(counter_u' num2str(j) ')'';']);
            end
            logic_string = [logic_string current_logic_string];
        end
        eval(['logic = ' logic_string ';']);
        logic = find(logic==1);
            
        % Creates trialnums
        for j = 1:length(logic)
            eval(['erp.stim.' char(trialnums(i).name) '(logic(' ...
                  num2str(j) ')) = ' num2str(j) ';']);
        end
        
        % Increments counters
        variable_num = length(trials_list);
        eval(['counter_u' num2str(variable_num) ' = counter_u' num2str(variable_num) ' + 1;'])
        limit = eval(['length_u' num2str(variable_num)]);
        counter = eval(['counter_u' num2str(variable_num)]);
        while counter > limit & variable_num > 1 % While current counter doesn't exceed number of unique values
            eval(['counter_u' num2str(variable_num) ' = 1;'])
            variable_num = variable_num-1;
            eval(['counter_u' num2str(variable_num) ' = counter_u' num2str(variable_num) ' + 1;'])
            limit = eval(['length_u' num2str(variable_num)]);
            counter = eval(['counter_u' num2str(variable_num)]);
        end
    end

    % Writes out stimkeys for this trialnum subfield
    eval(['erp.stimkeys.' trialnums(i).name '(' num2str(i) ').name = ''' char(trialnums(i).name) ''';']);
    text_string = '{';
    for j = 1:length(cellstr(trialnums(i).text))
        text_string = [text_string '''' char(trialnums(i).text(j)) ''';'];
    end
    text_string = [text_string(1:length(text_string)-1) '}'];
    eval(['erp.stimkeys.' trialnums(i).name '(' num2str(i) ').text = ' text_string ';']);

end
