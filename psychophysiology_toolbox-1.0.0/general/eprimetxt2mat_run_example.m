function [stim] = eprimetxt2mat_run(infile,outfile),

% import_NS_files(rsrate),

fieldtext=[
 'num FixationDur              '
 'num T1Word                   '
 'txt T2Word                   '
 'txt CurrentContextWord       '
 'num StimLag                  '
 'num OddEven.ACC              '
 'num OddEven.RT               '
 'txt OddEven.RESP             '
 'txt OddEven.CRESP            '
 'num XO.ACC                   '
 'num XO.RT                    '
 'txt XO.RESP                  '
 'txt XO.CRESP                 '
          ];

infile 
stim=eprimetxt2mat_base(infile,fieldtext); 

if exist('outfile')==1 & isempty(outfile)==0, 
  save(outfile,'stim');
end 

