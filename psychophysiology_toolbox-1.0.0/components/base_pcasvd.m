function [P,LATENT,EXPLAINED,cnum,retval] = pca_pcasvd(IDvars,SETvars,erp)
%[P,PC,LATENT,EXPLAINED,cnum] = pca_pcasvd(IDvars,SETvars,erp)
% 
% PCA decomposition script  
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

retval = 1;
base_function_initvars;

dtypet = IDvars.dmx; 
switch dtypet 
case 'acov' , pca_func = 'pcasvd'; dtype = 'association_Covariance'; 
case 'acor' , pca_func = 'pcasvd'; dtype = 'association_Correlation'; 
case 'aSSCP', pca_func = 'pcasvd'; dtype = 'association_SSCP'; 
case 'dctr' , pca_func = 'pcasvd'; dtype = 'data_Center'; 
case 'dctrs', pca_func = 'pcasvd'; dtype = 'data_CenterScale'; 
case 'COV',   pca_func = 'doPCA'; dtype = 'COV';
case 'COR',   pca_func = 'doPCA'; dtype = 'COR';
case 'SCP',   pca_func = 'doPCA'; dtype = 'SCP';
end 
 
if isnumeric(rot) ==1, 
  disp('ERROR: rotation must be text (none/vmx)');
  retval = 0; P=0; PC=0; LATENT=0; cnum=0; 
  return;
end

%timer  
  tic

%PCA  
switch pca_func, 

case 'pcasvd', 

  %PCA 
    if verbose > 0,
               [PC, LATENT, EXPLAINED] = pcasvd(erp,dtype);
    else,
      evalc([' [PC, LATENT, EXPLAINED] = pcasvd(erp,dtype); ']);
    end

    %choose components
       if fa==0,
         %plot Scree, and ask for number of components 
            whos
         LATENT(1:floor(length(LATENT)/4))
         plot(LATENT,'o')
         cnum=input('How many components? ');
       else,
         %if number of components already defined, don't ask
         cnum=fa;
       end
       if verbose > 0,
         Unrotated_VarianceExplained = EXPLAINED(1:cnum),
       end

  switch lower(rot)  

   case 'none'    %no rotation 

      P=PC(:,1:cnum)'; 
 
   case 'vmx'     %varimax rotation 

       if verbose > 0, 
                   [V,P] = varimax(PC(:,1:cnum)');
       else, 
          evalc([ '[V,P] = varimax(PC(:,1:cnum)'');' ]);
       end 

   case 'vmxso'     %varimax rotation 

       if verbose > 0,
                   [V,P] = varimax(PC(:,1:cnum)' ,1e-4,'noreorder');          % unrotated PC order 
       else,
          evalc([ '[V,P] = varimax(PC(:,1:cnum)'',1e-4,''noreorder'');' ]);   % unrotated PC order 
       end

    case 'qmx'    %quartimax rotation - operation not verified  

       if verbose > 0,
                   [V,P] = qrtimax(PC(:,1:cnum)');
       else,
          evalc([ '[V,P] = qrtimax(PC(:,1:cnum)'');' ]);
       end

    case 'pmx'    %promax rotatioin - not working correctly  

       if verbose > 0,
                   [P] = promax(PC',cnum);
       else,
          evalc([ '[P] = promax(PC'',cnum);' ]);
       end
 
  end  


% do PCA 
case 'doPCA', 

  if ~isempty(findstr('-K',rot)),  
    KAISER = rot(findstr('-K',rot)+2); 
  else, 
    KAISER = 'K'; 
  end 

  rot = rot(1:4); % shorten to just the rotation parameter for doPCA  
  cnum = fa;  
  [FacPat, FacStr, FacScr, FacRef, FacCor, scree, facVar, facVarQ, varSD] = doPCA('asis',rot, dtype, cnum, erp, KAISER);
  LATENT = scree; 
  EXPLAINED = facVar; 
  P = FacPat';  
 %P = FacStr';

% varimax from EEGLAB 
% [FacPat, FacStr, FacScr, FacRef, FacCor, scree, facVar, facVarQ, varSD] = doPCA('asis','UNRT', dtype, cnum, erp, KAISER); 
% LATENT = scree;
% EXPLAINED = facVar;
% P = FacPat';  
%%[V,P] = varimax(P); 

% varimax from EEGLAB 
% [FacPat, FacStr, FacScr, FacRef, FacCor, scree, facVar, facVarQ, varSD] = doPCA('asis','UNRT', dtype, cnum, erp, KAISER);
% LATENT = scree;
% EXPLAINED = facVar;
%%P = FacPat';
% P=zeros(length(FacScr(:,1) * FacPat(:,1)'),cnum)'; 
% for n=1:cnum, 
%     P(n,:) = mean(FacScr(:,n) * FacPat(:,n)'); 
%    %eval(['PCA_p.PC' num2str(n) ' = FacScr_p(:,' num2str(n) ') * FacPat_p(:,' num2str(n) ')'';']);
% end
%%[V,P] = varimax(P); 

end 

 %orient all components positive 
% for j=1:length(P(:,1)) 
%  PCmean = mean(P(j,:)); 
%  p_mean2peak=abs(max(P(j,:)) - PCmean); 
%  n_mean2peak=abs(min(P(j,:)) - PCmean); 
%  if PCmean < 0 | p_mean2peak < n_mean2peak,  
%   P(j,:)=P(j,:) .* -1; 
%  end 
% end 

  % individual surface BEST 
  for j=1:length(P(:,1))
    PCmedian = median(P(j,:));
    below_median=abs(mean(P(j,find(P(j,:)<PCmedian))) - PCmedian);
    above_median=abs(mean(P(j,find(P(j,:)>PCmedian))) - PCmedian);
    if above_median < below_median,
      P(j,:)=P(j,:) .* -1;
    end
  end 

% for j=1:length(P(:,1)) 
%  PCmedian = median(P(j,:)); 
%  p_median2peak=abs(max(P(j,:)) - PCmedian); 
%  n_median2peak=abs(min(P(j,:)) - PCmedian); 
%  if PCmedian < 0 | p_median2peak < n_median2peak,  
%   P(j,:)=P(j,:) .* -1; 
%  end 
% end 
  
% % Median of all PCs criterion 
% for j=1:length(P(:,1))
%   PCsmedian = median(median(P)); 
%   t = P; 
%   t(j,:) = t(j,:)*-1; 
%   tsmedian = median(median(t));  
%   if tsmedian > PCsmedian, P = t; end 
%  end 

  % Bottom percentile of Mean of all PCs criterion 
  for m=1:10, 
  for j=1:length(P(:,1))
    PCsmin = prctile(mean(P), 1);
    t = P;
    t(j,:) = t(j,:)*-1;
    tsmin  = prctile(mean(t), 1);
    if tsmin> PCsmin, P = t; end
   end
   end 

  % time 
  disp([' ']);
  disp(['PCASVD -- decomposition and rotation processing time: ' num2str(toc) ' seconds ']);
  disp([' ']);

  % end 

