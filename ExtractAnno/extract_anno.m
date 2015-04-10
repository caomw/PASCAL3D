function extract_anno()
% viewpoint annotation path
path_ann_view = '../Annotations';
addpath('../VDPM');
% read ids of validation images
pascal_init;
ids = textread(sprintf(VOCopts.imgsetpath, 'val'), '%s');
M = numel(ids);

cls_names = {'aeroplane','bicycle','bird','boat','bottle','bus','car','cat','chair','cow','diningtable','dog','horse','motorbike','person','pottedplant','sheep','sofa','train','tvmonitor'};


% EXTRACT BBOX and VIEW for CLS
for cidx = 1:length(cls_names)
        cls = cls_names{cidx};
        cidx = 9;
        cls = 'chair';
for i = 1:M
    fprintf('%s,%d\n',cls,i);
    % read ground truth bounding box
    rec = PASreadrecord(sprintf(VOCopts.annopath, ids{i}));
        clsinds = strmatch(cls, {rec.objects(:).class}, 'exact');
        diff = [rec.objects(clsinds).difficult];
        clsinds(diff == 1) = [];
        n = numel(clsinds);
        bbox = zeros(n, 4);
        truncated = zeros(n,1);
        occluded = zeros(n,1);
        difficult = zeros(n,1);
        for j = 1:n
        bbox(j,:) = rec.objects(clsinds(j)).bbox;
        truncated(j,:) = rec.objects(clsinds(j)).truncated;
        occluded(j,:) = rec.objects(clsinds(j)).occluded;
        difficult(j,:) = rec.objects(clsinds(j)).difficult;
        end

        % read ground truth viewpoint
        filename = fullfile(path_ann_view, sprintf('%s_pascal/%s.mat', cls, ids{i}));
        if isempty(clsinds) == 1 || ~exist(filename,'file')
            view_gt = [];
        else
            object = load(filename);
            record = object.record;
            view_gt = zeros(n, 1);
            for j = 1:n
                if record.objects(clsinds(j)).viewpoint.distance == 0
                azimuth = record.objects(clsinds(j)).viewpoint.azimuth_coarse;
                else
                azimuth = record.objects(clsinds(j)).viewpoint.azimuth;
                end
                view_gt(j) = azimuth; %find_interval(azimuth, azimuth_interval);
            end
        end

        % packaging
        annotations{cidx}{i} = struct('bbox', bbox, 'view', view_gt, 'truncated', truncated, 'occluded', occluded, 'difficult', difficult);
end
    break;
end

save('/orions3-zfs/projects/rqi/voc12_anno');
end
