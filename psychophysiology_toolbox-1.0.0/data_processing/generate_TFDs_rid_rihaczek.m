% main program 

    % args 
      if ~isfield(domainparms,'abs'),           domainparms.abs           =      0; end % absolute value 

    % prep erp 
      erptfd=erp; 
      erptfd = rmfield(erp,'data'); 

    % check requested parameters 
      if domainparms.samplerateTF ~= erp.samplerate;         
         disp('ERROR: upsampling/downsampling of TFD surface not currently supported in this function'); 
         erptfd = 0; 
      end  
      if mod(length(erp.data(1,:)),2)==1, 
         disp(['ERROR ' mfilename ': input signal must have an even number of time bins']); 
         erptfd = 0; 
      end  
     %if ~isequal(domainparms.freqbins*2,size(erp.data,2)), 
     %   disp(['ERROR ' mfilename ': number of time bins must equal frequency bins (freq. resolution)']); 
     %   erptfd = 0; 
     %end

      if isequal(erptfd,0), 
        return 
      end 

    % prep data matrix 
      bins4tfd              = eval([ domainparms.method  '(erp.data(1,:),domainparms.freqbins*2);']);
      erptfd.data  = zeros(trials,size(bins4tfd,1),size(bins4tfd,2));


    % run TFD 

      % counter 
      if verbose > 0,
        trial_counter = [round(trials/10):floor(trials/10):trials-round(trials/10)]; trial_counter(end+1) = trials;
        trial_count   = 1;
        tic
      end

      % TFD loop 
      for ii=1:trials,

        % run TFDs  
        erptfd.data(ii,:,:) = eval([ domainparms.method '(erp.data(ii,:),domainparms.freqbins*2);']);

        % counter 
        if verbose > 0, if trial_count<=numel(trial_counter) && ii==trial_counter(trial_count),
           disp(['     ' num2str(trial_count*10) '% completed, ' num2str(ii) ' of ' num2str(trials) ' trials, ' num2str(toc) ' seconds elapsed']);
           trial_count = trial_count + 1;
        end, end

      end

   % only one half the surface 
   erptfd.data = erptfd.data(:,1:domainparms.freqbins+1,:); 

   % take absolute value (abs), if requested 
   if domainparms.abs == 1,
     erptfd.data = abs(erptfd.data);
   end


