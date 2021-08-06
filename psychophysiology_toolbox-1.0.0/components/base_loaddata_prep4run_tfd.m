
    % TF bins 
    [tfqbins,ttmbins,trecords] = size(erptfd);
    if verbose > 0,
      disp(['      timebins: ' num2str(ttmbins) '   freqbins: ' num2str(tfqbins) '   Records: ' num2str(trecords) ]);
    end

    % adjust fq amplitude 
    for jj=1:length(fqamp01), 
      cur_fqamp01 = fqamp01(jj);  
      switch cur_fqamp01, 
      case {'M','m'},  
        % negative numbers - add minimum plus .001 
        if verbose > 0, disp(['Minima: handle negative values by adding the min of the surface + .001']); end
        erptfd_min = min(min(min(erptfd)));
        if erptfd_min <= 0,
          erptfd = erptfd + ((abs(erptfd_min)) + .001);
        end
        clear erptfd_min
      case {'C','c'},
        % negative numbers - cut off negative numbers to .001 
        if verbose > 0, disp(['Negative values: handle negative values by making all <=.001 equal to .001']); end
        erptfd(erptfd==0) = .01;
      case {'L','l'}, 
        % log TFD 
        if verbose > 0, disp(['FREQ: Log transform energy']); end 
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
          erptfd(ii,:,:) = erptfd(ii,:,:).*(ii*(erp.samplerate/2)/fqbins);
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
          sdata =  std(erptfd(ii,BL_start:BL_end,:)); % edited by JH 08.08.19 - This incorrectly used the whole time window, instead of the baseline, to calculate the SD. Fixed
         %sdata =  std(erptfd(ii,:,:));
          cur_erptfd = erptfd(ii,:,:);
          cur_erptfd_m = mdata(1,ones(1,ttmbins),:);
          cur_erptfd(std(cur_erptfd(1,:,:))>3) = cur_erptfd_m(std(cur_erptfd(1,:,:))>3);
          mdata = mean(cur_erptfd(1,BL_start:BL_end,:));
          sdata =  std(cur_erptfd(1,BL_start:BL_end,:)); sdata(sdata==0) = .001; % edited by JH 08.08.19 - This incorrectly used the whole time window, instead of the baseline, to calculate the SD. Fixed
         %sdata =  std(cur_erptfd(1,:,:)); sdata(sdata==0) = .001;
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

    % reduce to requested size 
      erptfd = erptfd(fqstartbin:fqendbin,startbin+SETvars.TFtbin:endbin+SETvars.TFtbin,:);
      SETvars.TFtbin =  SETvars.TFtbin + (startbin+SETvars.TFtbin);

    % z-score TFDs if requested 
    % if ~isfield(SETvars,'normalize') || isempty(SETvars), SETvars.normalize = 0; end
    % if ~isequal(SETvars.normalize,0),
    %    if isfield(SETvars.normalize,'TFD') && SETvars.normalize.TFD == 1, 
    %      disp(['NORMALIZING TFD region to be analyzed']);  
    %      erptfd = erptfd ./ mean(mean( std(erptfd))); 
    %      erptfd = erptfd  - mean(mean(mean(erptfd))); 
    %    end 
    % end 

    % cleanup 
      clear tfqbins ttmbins trecords 

