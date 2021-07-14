
        if isstruct(OPTIONS) && isfield(OPTIONS,'loaddata'),
          if exist(OPTIONS.loaddata)==2,
             if verbose > 0, disp(['          trying to run loaddata as an external script: ' OPTIONS.loaddata ]); end
              try, 
                run(OPTIONS.loaddata); 
              catch, 
                  disp(['          failed to execute loaddata as an external script: ' OPTIONS.loaddata ]);
                  disp(lasterr); 
              end
             if verbose > 0, disp(['          done running loaddata as an external script: ' OPTIONS.loaddata ]); end
          else,
              try,
                if verbose > 0, disp(['          trying to run loaddata string as passed: ' OPTIONS.loaddata ]); end
                eval(OPTIONS.loaddata);
              catch,
                  disp(['          failed to execute loaddata string as passed: ' OPTIONS.loaddata ]);
                  disp(lasterr);
              end
              if verbose > 0, disp(['          done running loaddata string as passed: ' OPTIONS.loaddata ]); end
          end
        end

