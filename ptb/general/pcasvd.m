function [pc,latent,explained] = pcasvd(data,dtype), 

% [pc,latent,explained] = pcasvd(data,dtype), 
% 
% Principle Components Analysis (PCA) using Singular Value Decomposition (SVD) 
% 
% Parameters:  
% 
%   data - raw data for decomposition 
% 
%   dtype - decomposition using: 
%      association_Correlation - Correlation Association Matrix
%      association_Covariance  - Covariance Association Matrix  
%      association_SSCP        - Sum of Squares Cros Product (SSCP) Association Matrix 
%      data_Center             - Centered Data Matrix  
%      data_CenterScale        - Centered and Scaled Data Matrix 
%  
% Edward Bernat & Steve Malone 01/27/2002 
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  
 
% pre decomposition vars 
  [m,n] = size(data);
  if exist('dtype','var')==0, dtype='association_Covariance'; end  
  disp(['PCASVD -- decomposition type: ' dtype ]);  

% decomposition 
  switch dtype 

    % Correlation Association Matrix decomposition

      case 'association_Correlation'  
        mdata         = mean(data);                           % mean
        stddata       = std(data);                            % std dev
        data          = (data - mdata(ones(m,1),:));          % center
        data          = data ./ stddata(ones(m,1),:);         % scale
        data          = (data' * data) / (m-1);               % SSCP
        [u,latent,pc] = svd(data,0);                          % decompose 

    % Covariance Association Matrix decomposition

      case 'association_Covariance'  
        mdata         = mean(data);                           % mean
        data          = (data - mdata(ones(m,1),:));          % center
        data          = (data' * data) / (m-1);               % SSCP 
        [u,latent,pc] = svd(data,0);                          % decompose 

    % Sum of Squares Cross Product (SSCP) Association Matrix decomposition 

      case 'association_SSCP' 
        data          = (data' * data) / (m-1);               % SSCP 
        [u,latent,pc] = svd(data,0);                          % decompose 

    % Centered Data Matrix decomposition

      case 'data_Center' 
        mdata         = mean(data);                           % mean
        data          = (data - mdata(ones(m,1),:));          % center
        [u,latent,pc] = svd(data,0);                          % decompose
 
    % Centered and Scaled Data Matrix decomposition (matlab: princomp)

      case 'data_CenterScale' 
        mdata         = mean(data);                           % mean
        data          = (data - mdata(ones(m,1),:));          % center
        data          = data ./ sqrt(m-1);                    % scale 
        [u,latent,pc] = svd(data,0);                          % decompose
        latent        = latent .^2;                

  end 

% post decomposition vars 
  latent = diag(latent); 
  explained = 100 * latent / sum(latent); 

