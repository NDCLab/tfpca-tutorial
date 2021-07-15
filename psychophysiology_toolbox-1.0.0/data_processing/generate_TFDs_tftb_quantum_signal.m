

    % vars 
      if isequal(domainparms.method,'bintfd') & ~isfield(domainparms,'options'),
         domainparms.options = ['''PosOnly'',''Analytic'',0,''Hanning''']; 
      end

    % check requested times 
      if domainparms.samplerateTF > erp.samplerate;                disp('ERROR: attempt to upsample TFD surface from raw samplerate'); erptfd = 0; retval = 0; return; end  
      if mod(erp.samplerate/domainparms.samplerateTF,1)~=0,        disp('ERROR: TFD subsampling must be an integer');                  erptfd = 0; retval = 0; return; end 

      if     domainparms.samplerateTF==erp.samplerate,  
       [bins4tfd,f,t]  =eval([ domainparms.method '(erp.data(1,:),domainparms.freqbins*2,' domainparms.options ');']);
      elseif domainparms.samplerateTF~=erp.samplerate, 
       [bins4tfd,f,t]  =eval([ domainparms.method '(erp.data(1,:),domainparms.freqbins*2,' domainparms.options ',''Reduce'',erp.samplerate/domainparms.samplerateTF);']);
      end 

      erptfd = erp; 
      erptfd.data  = zeros(trials,size(bins4tfd,1),size(bins4tfd,2));

      if verbose > 0,   
        trial_counter = [round(trials/10):floor(trials/10):trials-round(trials/10)]; trial_counter(end+1) = trials;  
        trial_count   = 1; 
        tic  
      end 

      for ii=1:trials,

        if     domainparms.samplerateTF==erp.samplerate,
         [erptfd.data(ii,:,:),f,t]  =eval([ domainparms.method '(erp.data(ii,:),domainparms.freqbins*2,' domainparms.options ');']);
        elseif domainparms.samplerateTF~=erp.samplerate, 
         [erptfd.data(ii,:,:),f,t]  =eval([ domainparms.method '(erp.data(ii,:),domainparms.freqbins*2,'  domainparms.options ',''Reduce'',erp.samplerate/domainparms.samplerateTF);']);
        end

        if verbose > 0, if trial_count<=numel(trial_counter) && ii==trial_counter(trial_count),
           disp(['     ' num2str(trial_count*10) '% completed, ' num2str(ii) ' of ' num2str(trials) ' trials, ' num2str(toc) ' seconds elapsed']);
           trial_count = trial_count + 1;
        end, end

      end

