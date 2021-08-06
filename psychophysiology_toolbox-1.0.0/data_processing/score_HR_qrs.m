function [erp] = tt(erp,HRelecname,outtype); 

% [erp] = scoreHR(erp,HRelecname,outtype); 
% 
%    Scores HR 
% 
%     erp - input data 
%     HRelecname - elecname with HR data (default 'HR')   
%     outtype    - 'bpm', 'peaks' (default 'bpm')  
% 

  % vars 
    if ~exist('HRelecname','var'), HRelecname=   'HR'; end 
    if ~exist('outtype'   ,'var'), outtype   = 'bpm'; end 

    switch outtype
    case 'bpm',
    case 'peaks',
    otherwise,
      disp(['WARNING: output type (' outtype ') not recognized']);
    end

  % get trials to score 
    HRtrials = find(erp.elec==strmatch(HRelecname,erp.elecnames)); 

  % loop for trials 
    for cur_trl=1:length(HRtrials), 

      curECG = erp.data(HRtrials(cur_trl),:); 

      HB = qrsdetect(curECG,erp.samplerate); 

        % reject adjacent points
        HBd = diff(HB);
        HB = HB(HBd>1);

      % output type 
      switch outtype 
      case 'peaks', 
        peaks = zeros(size(curECG));
        peaks(HB) = 1; 
        erp.data(HRtrials(cur_trl),:) = peaks;

      case 'bpm', 

        % calculate HR bpm   
        bps = zeros(size(curECG));

        for j=1:length(HB)-1,  
          bpm =  (erp.samplerate / (HB(j+1)-HB(j)) ) * 60; 
          bps(HB(j):HB(j+1)) =  bpm;          
          if j==1, 
            bps(1:HB(j)) =  bpm;
          end 
        end  
          bps(HB(j+1):end) =  bpm;   
 
        bps_m = median(bps); 
        bps_s = std(bps);  
        bps(bps>(bps_m + bps_s*2)) = bps_m; 

        erp.data(HRtrials(cur_trl),:) = bps; 
     end 
  
   end 

