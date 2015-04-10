clear all; close all; clc;

% viewpoint annotation path
path_ann_view = '../Annotations';
addpath('../VDPM');
% read ids of validation images
pascal_init;
ids = textread(sprintf(VOCopts.imgsetpath, 'val'), '%s');
M = numel(ids);

cls_names = {'aeroplane','bicycle','bird','boat','bottle','bus','car','cat','chair','cow','diningtable','dog','horse','motorbike','person','pottedplant','sheep','sofa','train','tvmonitor'};
cls = 'chair';
cnt = 1;
for i = 1:M
filename = fullfile(path_ann_view, sprintf('%s_pascal/%s.mat', cls, ids{i}));
if ~exist(filename,'file')
    continue;
end
anno = load(filename);
objects = anno.record.objects;
for k = 1:length(objects)
    obj = objects(k);
    if obj.truncated==0 && obj.occluded==0 && obj.difficult==0 && strcmp(obj.class,cls)
        easy_chairs{cnt} = struct('idx',i,'img',ids{i},'object',objects(k));
        easy_ids{cnt} = ids{i};
        cnt = cnt + 1;
    end
end
end

% save('easy_chairs','easy_chairs');
