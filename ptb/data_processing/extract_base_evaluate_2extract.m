function [create_2e] = extract_base_parse_2extract(var2e,text2e), 

% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

  % assess whether var2e is defined or needs to be 
    if     isempty(var2e),
      create_2e = 1;
    elseif isstruct(var2e) == 0,
      switch var2e  
        case {'ALL','all'}, 
          create_2e = 1;
        otherwise
          create_2e = 0;
       end
    elseif isstruct(var2e) ==1,
      create_2e = -1;
    end

    if create_2e == 0,
          disp(['WARNING: ' text2e ' not correctly defined -- all processed']);
          create_2e = 1;
    end

