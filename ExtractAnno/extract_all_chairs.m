clear all; close all; clc;

% viewpoint annotation path
path_ann_view = '../Annotations';
addpath('../VDPM');
% read ids of validation images
pascal_init;
% ids = textread(sprintf(VOCopts.imgsetpath, 'val'), '%s');
ids = textread(sprintf(VOCopts.imgsetpath, 'train'), '%s');
M = numel(ids);

cls_names = {'aeroplane','bicycle','bird','boat','bottle','bus','car','cat','chair','cow','diningtable','dog','horse','motorbike','person','pottedplant','sheep','sofa','train','tvmonitor'};
cls = 'chair';
cnt = 1;
cnt_all = 1;
for i = 1:M
    i
filename = fullfile(path_ann_view, sprintf('%s_pascal/%s.mat', cls, ids{i}));
if ~exist(filename,'file')
    continue;
end
anno = load(filename);
objects = anno.record.objects;
for k = 1:length(objects)
    obj = objects(k);
    
%     if obj.truncated==0 && obj.occluded==0 && obj.difficult==0 && strcmp(obj.class,cls)
%         easy_chairs{cnt} = struct('idx',i,'img',ids{i},'object',objects(k));
%         cnt = cnt + 1;
%     end
% 
%     if strcmp(obj.class,cls)
%             if obj.viewpoint.distance == 0
%                 azimuth = obj.viewpoint.azimuth_coarse;
%             else
%                 azimuth = obj.viewpoint.azimuth;
%             end
%             all_chairs{cnt_all} = struct('idx',i,'img',ids{i},'object',objects(k),'azimuth',azimuth);
%             cnt_all = cnt_all + 1;
%     end
    
    if ~isempty(obj.viewpoint) && strcmp(obj.class,cls)
        try
            az=obj.viewpoint.azimuth;
            ele=obj.viewpoint.elevation;
            dist=obj.viewpoint.distance;
            % all chairs with annotations!
            all_chairs{cnt_all} = struct('idx',i,'img',ids{i},'object',objects(k));
            cnt_all = cnt_all + 1;
        catch
        end
    end
end
end

% save('easy_chairs','easy_chairs');
save('all_chairs', 'all_chairs');