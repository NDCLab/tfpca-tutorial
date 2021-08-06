
   % args 
    %if ~isfield(domainparms,'scales'),  domainparms.scales  = 1:.25:domainparms.fqbins; end 
     if ~isfield(domainparms,'method'),        domainparms.method        =  'cwt'; end
    %if ~isfield(domainparms,'scale_factor'),  domainparms.scale_factor  =    .25; end
    %if ~isfield(domainparms,'scale_number'),  domainparms.scale_number  =     32; end
     if ~isfield(domainparms,'scale_number'),  domainparms.scale_number  = erp.samplerate; end
     if ~isfield(domainparms,'scale_factor'),  domainparms.scale_factor  =      1; end
     if ~isfield(domainparms,'wavelet'),       domainparms.wavelet       = 'morl'; end
     if ~isfield(domainparms,'freqbins'),      domainparms.freqbins      =  floor(erp.samplerate/2); end
     if ~isfield(domainparms,'abs'),           domainparms.abs           =      1; end % absolute value 

   % vars 
     delta = 1/erp.samplerate;
     scales= [1:domainparms.scale_factor:domainparms.scale_number];

     times = [1:length(erp.data(1,:))] .* 1000/erp.samplerate;

       times_skip = erp.samplerate/domainparms.samplerateTF;
       timesr = times(1:times_skip:end);

     freqs = scal2frq(scales,domainparms.wavelet,delta);

       freqs_diff_from_samplerate = abs(freqs-(erp.samplerate/2));
       freqHzbinval = min(freqs_diff_from_samplerate);
       freqHzbin = find(freqs_diff_from_samplerate<=freqHzbinval);
       freqsvalid    = freqs(freqHzbin:end);

       freqbinsr_factor = (erp.samplerate/2)/domainparms.freqbins;
       freqbinsr = freqbinsr_factor:freqbinsr_factor:erp.samplerate/2;

   % generate wavelet 
      erptfd=erp;
      erptfd = rmfield(erp,'data');

     switch domainparms.method
     case 'cwt',
       if ~isfield(domainparms,'waveletparms'),
       wt = cwt(erp.data(jj,:),scales,domainparms.wavelet);
       else,
       wt = cwt(erp.data(jj,:),scales,domainparms.wavelet,domainparms.waveletparms);
       end
     end
subplot(3,1,1); 
imagesc(real(abs(wt)))
    %wt = griddata(times,freqsvalid,abs(wt(freqHzbin:end,:)).^2,timesr,freqbinsr');
     wt = griddata(times,freqsvalid,wt(freqHzbin:end,:).^2,timesr,freqbinsr');
subplot(3,1,2); 
imagesc(flipud(real(abs(wt(1:end,:))))) 
     wt = [zeros(size(wt(1,:))); wt;];
subplot(3,1,3); 
imagesc(flipud(real(abs(wt(1:end,:)))))
      erptfd.data = zeros(length(erp.elec),length(wt(:,1)),length(wt(1,:)));

     tic
     for jj=1:length(erp.elec),
       if verbose > 1,
       disp(['total: ' num2str(length(erp.elec)) ' current: ' num2str(jj) ' time: ' num2str(toc) ]); tic
       end

      %wt = cwt(erp.data(jj,:),domainparms.scales,domainparms.wavelet);
      %wt = griddata(times,freqs,abs(wt).^2,times,[1:erp.samplerate/2]');

       if ~isfield(domainparms,'waveletparms'),
       wt = cwt(erp.data(jj,:),scales,domainparms.wavelet);
       else,
       wt = cwt(erp.data(jj,:),scales,domainparms.wavelet,domainparms.waveletparms);
       end

       wt = griddata(times,freqsvalid,wt(freqHzbin:end,:).^2,timesr,freqbinsr');
       wt = [zeros(size(wt(1,:))); wt;];
       erptfd.data(jj,:,:) = wt;
     end

   % drop NaNs 
     erptfd.data(isnan(erptfd.data)~=0) = 0;

   % take absolute value (abs), if requested 
   if domainparms.abs == 1,
     erptfd.data = abs(erptfd.data);
   end

   % clean up 
     clear times times_skip timesr freq freqs_diff_from_samplerate freqHzbinval freqHzbin freqsvalid freqbinsr_factor  freqbinsr wt bins4tfd jj

