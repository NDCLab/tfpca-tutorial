function [erp] = tt(erp,HRelecname,outtype,sdcrit); 

% [erp] = scoreHR(erp,HRelecname,outtype,sdcrit); 
% 
%    Scores HR 
% 
%     erp - input data 
%     HRelecname - elecname with HR data (default 'HR')   
%     outtype    - 'bpm', 'peaks' (default 'bpm')  
%     sdcrit     - standard deviation for correcting peaks 
% 

  % vars 
    if ~exist('HRelecname','var'), HRelecname=   'HR'; end 
    if ~exist('outtype'   ,'var'), outtype   =  'bpm'; end 
    if ~exist('sdcrit'    ,'var'), sdcrit    =      3; end 

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
      threshold = std(curECG)*3.0;  
      HB = find(curECG>threshold);  

        HBd = diff(HB); 

        % reject adjacent points 
        HB = HB(HBd>1); 
        HBd = diff(HB); 

        % reject too fast HBs  
        HB  = HB(HBd >= (median(HBd) - std(HBd)*sdcrit) ); 
        HBd = diff(HB);
%       HBnew = HB;
%       while 1,
%         t  = find(HBd <= (median(HBd) - std(HBd)*sdcrit) );
%         if ~isempty(t),
%         HBnew = [HBnew(1:t(1)-1) ...
%                  HBnew(t(1)+1:end)];
%         HBd = diff(HBnew);
%         else,
%           break
%         end
%       end
%       HB = HBnew;
%       HBd = diff(HB);


        % insert beats when HR too slow 
        HBnew = HB; 
        while 1, 
          t  = find(HBd >= (median(HBd) + std(HBd)*sdcrit) ); 
          if ~isempty(t),  
          HBnew = [HBnew(1:t(1)) ... 
                  HBnew(t(1)) + round((HBnew(t(1)+1) - HBnew(t(1)) )/2)  ... 
                   HBnew(t(1)+1:end)]; 
          HBd = diff(HBnew);  
          else, 
            break 
          end  
        end 
        HB = HBnew; 
        HBd = diff(HB); 

%       tm  = find(HBd <= (median(HBd) - std(HBd)*sdcrit) );
%       tp  = find(HBd >= (median(HBd) + std(HBd)*sdcrit) );
%       if ~isempty(tm), HB(tm) = HB(tm-1); end  
%       if ~isempty(tm), HB(tp) = HB(tp-1); end 

        HBd = diff(HB);

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

