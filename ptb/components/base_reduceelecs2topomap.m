function [erp] = base_reduceelecs2topomap(IDvars,SETvars,erp),  
% [erp] = base_reduceelecs2topomap(IDvars,SETvars,erp),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

  % vars 
  retval = 1; 
  base_function_initvars;

  electrode_montage_row = SETvars.electrode_montage_row; 

  m_rows=length(electrode_montage_row);
  m_cols=length(electrode_montage_row(1).col);

  enums2keep    =[]; 

  % reduce to only elecs in montage (electrode_montage) 

   for r=1:m_rows,
     for c=1:m_cols,

      cur_ename = char(electrode_montage_row(r).col(c));

      if isequal(deblank(cur_ename),'NA'),
        % skip 
      else,

        enums(r,c) = strmatch(deblank(cur_ename),erp.elecnames,'exact');
        if isempty(enums(r,c)),
          disp(['electrode name ' cur_ename ' from electrode_montage is invalid']);
          retval = 0; erp = 0; return;
        else,
          enums2keep = [enums2keep; enums(r,c);];
        end

      end

     end 
   end 

   enums2keep_vect = zeros(size(erp.elec)); % erp.elec==-100; 
   for jj = 1:length(enums2keep), 
     enums2keep_vect(erp.elec==enums2keep(jj))  = 1; 
   end 

   % reduce variables 

    erp.data     = [     erp.data(enums2keep_vect~=0,:) ;];
    erp.elec     = [     erp.elec(enums2keep_vect~=0,:) ;];
    erp.sweep    = [    erp.sweep(enums2keep_vect~=0,:) ;];
    erp.subnum   = [   erp.subnum(enums2keep_vect~=0,:) ;];
    erp.ttype    = [    erp.ttype(enums2keep_vect~=0,:) ;];
    erp.correct  = [  erp.correct(enums2keep_vect~=0,:) ;];
    erp.accept   = [   erp.accept(enums2keep_vect~=0,:) ;];
    erp.rt       = [       erp.rt(enums2keep_vect~=0,:) ;];
    erp.response = [ erp.response(enums2keep_vect~=0,:) ;];

    if isfield(erp,'stim'),
      stimnames = fieldnames(erp.stim);
      for sn = 1:length(stimnames),
        cur_stimname = char(stimnames(sn,:));
        eval(['erp.stim.' cur_stimname '=[erp.stim.' cur_stimname '(enums2keep_vect~=0,:);];' ]);
      end
    end

% if verbose > 0,   
%   disp(['Reduce to Electrodes in Topomap -- New Data Matrix Size (rows/bins): ' num2str(size(erp.data)) ]);
% end 
 
