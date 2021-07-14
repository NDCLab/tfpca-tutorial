
    % interpolation parameters 
      if domainparms.samplerateTF ~= erp.samplerate, 
        times = [1:length(erp.data(1,:))] .* 1000/erp.samplerate;
          times_skip = erp.samplerate/domainparms.samplerateTF;
          timesr = times(1:times_skip:end);
        freqs = [0:domainparms.freqbins] .* ((erp.samplerate/2)/domainparms.freqbins); 
      end 

    % setup erptfd structure 
      [ttfd,t,f] = eval([ domainparms.method '(erp.data(1,:),erp.samplerate,domainparms.freqbins*2,domainparms.freqbins*2);']);      
       ttfd = ttfd(length(ttfd(:,1))-ceil(length(ttfd(:,1))/2):length(ttfd(:,1)),:);
       if domainparms.samplerateTF ~= erp.samplerate, 
         ttfd = griddata(times,freqs,ttfd,timesr,freqs');
       end 

       bins4tfd  = ttfd; 

      erptfd = erp;
      erptfd.data  = zeros(trials,size(bins4tfd,1),size(bins4tfd,2));

    % run TFD 
      for ii=1:trials,
           
          [ttfd,t,f] = eval([ domainparms.method '(erp.data(ii,:),erp.samplerate,domainparms.freqbins*2,domainparms.freqbins*2);']);
          %ttfd = ttfd(length(ttfd(:,1))-ceil(length(ttfd(:,1))/2):length(ttfd(:,1)),:); % old missed DC bin 
           ttfd = flipud(ttfd(1:ceil(length(ttfd(:,1))/2)+1,:));
           if domainparms.samplerateTF ~= erp.samplerate,
             ttfd = griddata(times,freqs,ttfd,timesr,freqs'); 
           end 
  
           erptfd.data(ii,:,:) = ttfd; 
          
      end 

    % clean up 
      clear times times_skip timesr freq ttfd t f bins4tfd ii 

