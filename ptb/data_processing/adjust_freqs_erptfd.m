function [erptfd] = adjust_freq_erptfd(erptfd,fqamp01,SETvars,verbose), 

%  [erptfd] = adjust_freq_erptfd(erptfd,fqamp01,SETvars,verbose),

    % vars 
      if ~exist('verbose'), verbose = 0; end 

      % setup SETvars and TFtbin 
      SETvars.TFtbin = erptfd.tbin;  

    % transform to components erptfd format 
    erptfd_org = erptfd; 
    erptfd = erptfd_org.data;  
    erptfd = shiftdim(erptfd,1); 

    % TF bins 
    [tfqbins,ttmbins,trecords] = size(erptfd);
    if verbose > 0,
      disp(['      timebins: ' num2str(ttmbins) '   freqbins: ' num2str(tfqbins) '   Records: ' num2str(trecords) ]);
    end

    % adjust fq amplitude 
    for jj=1:length(fqamp01),
      cur_fqamp01 = fqamp01(jj);
      switch cur_fqamp01,
      case {'L','l'},
        % log TFD 
        if verbose > 0, disp(['FREQ: Log transform energy']); end
       %erptfd(erptfd==0) = .01;
       %erptfd = log(erptfd);
        erptfd_min = min(min(min(erptfd)));
        if erptfd_min <= 0,
          erptfd = erptfd + ((abs(erptfd_min)) + .001);
        end
        erptfd = log(erptfd);
        clear erptfd_min
      case {1,'1','F','f'},
        % raise freq by 1/f 
        if verbose > 0, disp(['FREQ: 1/F energy adjustment']); end
        for ii=1:length(erptfd(:,1,1)),
          erptfd(ii,:,:) = erptfd(ii,:,:).*(ii*(erptfd_org.samplerate/2)/tfqbins);
        end
      case {'S','s'},
        % standardize freq by whole epoch 
        if verbose > 0, disp(['FREQ: Standardize within band by whole epoch activity']); end
        for ii=1:length(erptfd(:,1,1)),
          mdata = mean(erptfd(ii,:,:));
          sdata =  std(erptfd(ii,:,:));
          cur_erptfd = erptfd(ii,:,:);
          cur_erptfd_m = mdata(1,ones(1,ttmbins),:);
          cur_erptfd(std(cur_erptfd(1,:,:))>3) = cur_erptfd_m(std(cur_erptfd(1,:,:))>3);
          mdata = mean(cur_erptfd(1,:,:));
          sdata =  std(cur_erptfd(1,:,:)); sdata(sdata==0) = .001;
          erptfd(ii,:,:) = erptfd(ii,:,:)  - mdata(1,ones(1,ttmbins),:);
          erptfd(ii,:,:) = erptfd(ii,:,:) ./ sdata(1,ones(1,ttmbins),:);
        end
        clear mdata sdata cur_erptfd
      case {'K','k'},
        if verbose > 0, disp(['FREQ: Standardize within band by baseline activity']); end
        % baseline definition 
        if isfield(SETvars,'TFDbaseline'),
          BL_start = SETvars.TFtbin + floor(SETvars.TFDbaseline.start * timebinss/1000);
          BL_end   = SETvars.TFtbin +  ceil(SETvars.TFDbaseline.end   * timebinss/1000);
        else,
          BL_start = 2;
          BL_end   = SETvars.TFtbin - 1;
        end
        % standardize freq by baseline 
        for ii=1:length(erptfd(:,1,1)),
          mdata = mean(erptfd(ii,BL_start:BL_end,:));
          sdata =  std(erptfd(ii,:,:));
          cur_erptfd = erptfd(ii,:,:);
          cur_erptfd_m = mdata(1,ones(1,ttmbins),:);
          cur_erptfd(std(cur_erptfd(1,:,:))>3) = cur_erptfd_m(std(cur_erptfd(1,:,:))>3);
          mdata = mean(cur_erptfd(1,BL_start:BL_end,:));
          sdata =  std(cur_erptfd(1,:,:)); sdata(sdata==0) = .001;
          erptfd(ii,:,:) = erptfd(ii,:,:)  - mdata(1,ones(1,ttmbins),:);
          erptfd(ii,:,:) = erptfd(ii,:,:) ./ sdata(1,ones(1,ttmbins),:);
        end
        clear mdata sdata cur_erptfd
      case {'B','b'},
        if verbose > 0, disp(['FREQ: Baseline Adjust within band']); end
        % baseline definition 
        if isfield(SETvars,'TFDbaseline'),
          BL_start = SETvars.TFtbin + floor(SETvars.TFDbaseline.start * timebinss/1000);
          BL_end   = SETvars.TFtbin +  ceil(SETvars.TFDbaseline.end   * timebinss/1000);
        else,
          BL_start = 2;
          BL_end   = SETvars.TFtbin - 1;
        end
        % baseline adjust  
        for ii=1:length(erptfd(:,1,1)),
          mdata = median(erptfd(ii,BL_start:BL_end,:));
          erptfd(ii,:,:) = erptfd(ii,:,:)  - mdata(1,ones(1,ttmbins),:);
        end
      end
    end

    erptfd = shiftdim(erptfd,2); 
    erptfd_org.data = erptfd; 
    erptfd = erptfd_org; 
    clear erptfd_org 
 
