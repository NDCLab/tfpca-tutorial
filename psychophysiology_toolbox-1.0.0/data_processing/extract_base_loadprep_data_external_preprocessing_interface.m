
  % external processing interface 1 
    if P1~=0,
      if exist(P1,'file'),
        disp(['Executing external preprocessing1 script: ' P1 ]);
        try,   run(P1);
        catch, disp('ERROR: preprocessing1 file failed -- NO preprocessing1 script executed');
               disp('ERROR text: ');
               disp(lasterr);
        end
      else,
        disp(['     ' mfilename ':Executing inline preprocessing1 script: ' P1 ]);
        try,   eval(P1);
        catch, disp('ERROR: preprocessing1 inline script failed -- NO preprocessing1 script executed');
               disp('ERROR text: ');
               disp(lasterr);
        end
      end
    end

  % external processing interface 2 
    if P2~=0,
      if exist(P2,'file'),
        disp(['Executing external preprocessing2 script: ' P2 ]);
        try,   run(P2);
        catch, disp('ERROR: preprocessing2 file failed -- NO preprocessing2 script executed');
               disp('ERROR text: ');
               disp(lasterr);
        end
      else,
        disp(['Executing inline preprocessing2 script: ' P2 ]);
        try,   eval(P2);
        catch, disp('ERROR: preprocessing2 inline script failed -- NO preprocessing2 script executed');
               disp('ERROR text: ');
               disp(lasterr);
        end
      end
    end


