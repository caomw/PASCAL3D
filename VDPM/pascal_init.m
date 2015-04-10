
% initialize the PASCAL development kit 
tmp = pwd;
cd('../PASCAL/VOCdevkit');
addpath([cd '/VOCcode']);
VOCinit;
cd(tmp);
