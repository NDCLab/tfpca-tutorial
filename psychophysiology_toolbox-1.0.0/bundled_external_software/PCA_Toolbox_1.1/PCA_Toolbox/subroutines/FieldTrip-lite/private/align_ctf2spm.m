function [mri] = align_ctf2spm(mri);

% ALIGN_CTF2SPM performs an approximate alignment of the anatomical volume
% from CTF towards SPM coordinates. Only the homogenous transformation matrix
% is modified.

spmvox2spmhead = [
     2     0     0   -92
     0     2     0  -128
     0     0     2   -74
     0     0     0     1
];

% these are the voxel indices of some points in the SPM canonical T1 
spmvox_Ac           = [46 64  37  1]';     % the anterior commissure
spmvox_Ori          = [46 48  10  1]';     % approximately between the ears in T1.mnc
spmvox_Nas          = [46 106 13  1]';     % approximately the nasion in T1.mnc
spmvox_Lpa_canal    = [ 5 48  10  1]';     % Left ear canal
spmvox_Rpa_canal    = [87 48  10  1]';     % Right ear canal

spmhead_Ac           = spmvox2spmhead * spmvox_Ac  ;
spmhead_Ori          = spmvox2spmhead * spmvox_Ori ;
spmhead_Nas          = spmvox2spmhead * spmvox_Nas ;
spmhead_Lpa_canal    = spmvox2spmhead * spmvox_Lpa_canal ;
spmhead_Rpa_canal    = spmvox2spmhead * spmvox_Rpa_canal ;

ctfvox2ctfhead  = mri.transform;
spmhead2ctfhead = headcoordinates(spmhead_Nas(1:3), spmhead_Lpa_canal(1:3), spmhead_Rpa_canal(1:3), 0);

ctfvox2spmhead =  inv(spmhead2ctfhead) *  ctfvox2ctfhead;

% change the transformation matrix, such that it returns SPM head coordinates
mri.transform = ctfvox2spmhead;
