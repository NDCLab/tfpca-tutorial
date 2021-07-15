function [erptfd] = generate_TFPS_interelec(erp,TFPSparms,verbose),  

% [erp] = generate_TFPS_interelec(erp,TFPSparms),
% 
%  required parameters: 
%  
%    TFPSparms.refelec  - TFPS values are conputed relative to this reference  
% 

% error checks 
  usweep=unique(erp.sweep);
  uelec =unique( erp.elec);
  if ~exist('verbose'), verbose = 1; end
  if ~isfield(TFPSparms,'refelec'),
      disp(['ERROR:' mfilename ': reference electrode not defined']);
      return
  elseif ~strmatch(TFPSparms.refelec,erp.elecnames,'exact'),
      disp(['ERROR:' mfilename ': reference electrode ' TFPSparms.refelec ' not valid']);
      return
  end

% prepare erptfd stucture  
  if isfield(erp,'stim') && isfield(erp.stim,'catcodes'),
    erp.stim.catcodes_hold = erp.stim.catcodes;
    catcodes(1).name = 1; catcodes(1).text = 'erp.ttype~=-999'; erp.domain='time';
    erptfd = aggregate_erp(erp,catcodes);
    erptfd.stim.catcodes = erptfd.stim.catcodes_hold;
    erptfd.stim = rmfield(erptfd.stim,'catcodes_hold');
  else,
    catcodes(1).name = 1; catcodes(1).text = 'erp.ttype~=-999'; erp.domain='time';
    erptfd = aggregate_erp(erp,catcodes);
  end
  erptfd.data(:,:,:) = 0; % complex(0);

% main loop  
  if verbose > 1, 
    disp(['Generating Phase-Synchrony from TFDs: ITPC in reference to electrode ' TFPSparms.refelec ]); 
  end  

tic 
for ee=1:length(uelec),
  sumphdif = zeros(size(squeeze(erptfd.data(1,:,:)))); 
  sumphdif_count = 0; 
  for ss=1:length(usweep),

    x = erp.data(erp.sweep==usweep(ss)&erp.elec==uelec(ee)                        ,:,:);
    y = erp.data(erp.sweep==usweep(ss)&erp.elec==strmatch(TFPSparms.refelec,erp.elecnames,'exact')  ,:,:);

   %if ~isequal(mean(find(erp.sweep==usweep(ss  )&erp.elec==uelec(ee))),0),
    if size(x,1)~=0 && size(y,1)~=0, 

     [phdif]=generate_TFPS_base_phase_diff(squeeze(x), squeeze(y)); 
      sumphdif = sumphdif + phdif; 
      sumphdif_count = sumphdif_count + 1; 
 
    end 
 
  end
  if verbose > 2, 
    disp(sprintf('     %d %% completed elec: %s; sweeps: %d; time elapsed: %g \r',round((ee/length(uelec)*100)),char(erp.elecnames(uelec(ee),:)),length(usweep),toc));
   end 

   if sumphdif_count==0, 
      disp(['ERROR: ' mfilename ': insufficient valid trials for TFPS']);  
      erptfd=[]; 
      return 
   end 

   plv = abs(sumphdif)/sumphdif_count; 
   erptfd.data(erptfd.elec==uelec(ee) ,:,:) = plv; 
   erptfd.sweep(erptfd.elec==uelec(ee)) = sumphdif_count; 

end   

