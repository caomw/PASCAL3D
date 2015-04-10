function prepare_all_val_chair_imgs()

image_dir = '/orions3-zfs/projects/rqi/Dataset/VOC12/VOCdevkit/VOC2012/JPEGImages/';
load('all_val_chairs');

vnum = 360;
azimuth_interval = [0 (360/(vnum*2)):(360/vnum):360-(360/(vnum*2))];
labelfile = fopen(['all_val_chair_labels_v' num2str(vnum) '.txt'],'w');

for i = 1:length(all_val_chairs)
    i
im = imread([image_dir all_val_chairs{i}.img '.jpg']);
box = all_val_chairs{i}.object.bbox;
w = box(3)-box(1)+1;
h = box(4)-box(2)+1;
im = imcrop(im, [box(1),box(2), w, h]);
% write cropped img
cropped_img = [num2str(i) '_' all_val_chairs{i}.img '.jpg'];
imwrite(im, ['all_val_chairs_set/' cropped_img]); % gt

% write view annotation
azimuth = all_val_chairs{i}.object.viewpoint.azimuth;
view = find_interval(azimuth, azimuth_interval);
% fprintf(labelfile, '%s %d\n', cropped_img, view-1);
fprintf(labelfile, '%s %d\n', cropped_img, mod(view-1,360));

% fprintf('azimuth: %f,view: %d\n',azimuth,view-1);
% imshow(im);
% pause;

end

fclose(labelfile);

function ind = find_interval(azimuth, a)

for i = 1:numel(a)
    if azimuth < a(i)
        break;
    end
end
ind = i - 1;
if azimuth > a(end)
    ind = 1;
end
% ---- END ----