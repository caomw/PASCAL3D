function [azimuths, elevations, distances] = get_voc12train_view_stats(cls)

% viewpoint annotation path
path_ann_view = '../Annotations';
addpath('../VDPM');
% read ids of training set images
pascal_init;
ids = textread(sprintf(VOCopts.imgsetpath, 'train'), '%s');
M = numel(ids);

cls_names = {'aeroplane','bicycle','bird','boat','bottle','bus','car','cat','chair','cow','diningtable','dog','horse','motorbike','person','pottedplant','sheep','sofa','train','tvmonitor'};
cls_rigid_names = {'aeroplane','bicycle','boat','bottle','bus','car','chair','diningtable','motorbike','sofa','train','tvmonitor'};

cnt = 1;

azimuths = [];
elevations = [];
distances = [];
thetas = [];

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
    if ~isempty(obj.viewpoint) && strcmp(obj.class,cls)
        try
            azimuths = [azimuths obj.viewpoint.azimuth];
            elevations = [elevations obj.viewpoint.elevation];
            thetas = [thetas obj.viewpoint.theta];
            distances = [distances obj.viewpoint.distance];
        catch
        end
    end
%     if obj.truncated==0 && obj.occluded==0 && obj.difficult==0 && strcmp(obj.class,cls)
%         azimuths = [azimuths obj.viewpoint.azimuth];
%         elevations = [elevations obj.viewpoint.elevation];
%         distances = [distances obj.viewpoint.distance];
%         %easy_chairs{cnt} = struct('idx',i,'img',ids{i},'object',objects(k));
%         cnt = cnt + 1;
%     end
end
end

save([cls,'_viewpoint_stats'], 'azimuths', 'elevations', 'thetas', 'distances');
figure, subplot(1,2,1), hist(azimuths);
subplot(1,2,2), hist(elevations);
