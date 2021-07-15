function [erp] = extract_averages_update(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose),

% extract_averages_update 
% 
% runs:  [erp] = extract_update(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose,'averages'); 

   [erp] = extract_update(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose,'averages'); 

