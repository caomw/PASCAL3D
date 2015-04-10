% cls: class name
% n: view number
% function pose_test_given_bbox(cls, n)

% matlabpool open

model_name = sprintf('data/%s_%d_view_flip.mat', cls, n);
object = load(model_name);
model = object.model;
model.thresh = min(-1.1, model.thresh);
index_pose = model.index_pose;

% read ids of validation images
pascal_init;

[status, res] = system('find /orions3-zfs/projects/rqi/voc_det/chair -name ''*.jpg''');
ids = strsplit(res(1:(end-1)), '\n');

N = numel(ids);
dets = cell(N, 1);
% parfor gets confused if we use VOCopts
opts = VOCopts;

for i = 1:N
    fprintf('%s view %d: %d/%d\n', cls, n, i, N);
    file_img = fullfile('/orions3-zfs/projects/rqi/voc_det/chair', [num2str(i) '.jpg']);
    I = imread(file_img);
    det = process(I, model, model.thresh);
    num = size(det, 1);
    for j = 1:num
        det(j,5) = index_pose(det(j,5));
    end
    dets{i} = det;
end

filename = sprintf('data/%s_%d_test.mat', cls, n);
save(filename, 'dets');

% matlabpool close