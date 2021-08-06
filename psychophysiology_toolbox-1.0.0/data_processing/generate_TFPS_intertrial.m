function [erptfd] = generate_TFPS_intertrial(erp,TFPSparms,verbose), 

% [erp] = generate_TFPS_intertrial(erp,TFPSparms),
% 
%  required parameters: 
%  
%    none 
% 

% error checks 
  usweep=unique(erp.sweep);
  uelec =unique( erp.elec);
  if ~exist('verbose'), verbose = 1; end 
  if length(usweep)<2, disp(['ERROR ' mfilename ': TFPS inter-trial (within elec) requires more than one sweep']);  
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
  if verbose >1, 
    disp(['Generating Phase-Synchrony from TFDs: within electrode ITPC ']); 
  end  

tic 
for ee=1:length(uelec),
  % --The below was modified by SJB on 6/29/2012 to make comparable to PLF and ITPC
  % Create mean (ref_surface; "preferred phase") surface, from the function circ_mean() CircStat toolbox.  
  % Note: really, this could be any complex surface; the point is to keep it constant across phase-difference 
  % computations so that: abs(sumphdif)/sumphdif_count = circular variance
  % Citation: Berens, P. (2009).  CircStat: a Matlab toolbox for circular statistics. J Stat Software, 31(10).
     alpha       = angle(erp.data(erp.elec==uelec(ee),:,:)); % get angles for all bins
     w           = ones(size(erp.data));  % normalize to unit magnitude
     ref_surface = sum(w.*exp(1i*alpha)); % compute weighted sum of cos and sin of angles ("averaged phase")

  sumphdif = zeros(size(squeeze(erptfd.data(1,:,:)))); 
  sumphdif_count = 0; 
  for ss=1:length(usweep), 

    x = ref_surface; 
    y = erp.data(erp.sweep==usweep(ss)&erp.elec==uelec(ee),:,:);

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

