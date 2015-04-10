% show pascal3d annotations
function show_annotations

cls = 'car';
opt = globals();
pascal_init;
pad_size = 100;

% load PASCAL3D+ cad models
fprintf('load CAD models from file\n');
filename = sprintf(opt.path_cad, cls);
object = load(filename);
cads = object.(cls);

% annotations
filename = fullfile(sprintf(opt.path_ann_pascal, cls), '*.mat');
files = dir(filename);

% get number of images
nimages = length(files);

% main loop
figure(1);
cmap = colormap(jet);
for img_idx = 1:nimages
  filename = files(img_idx).name;
  [pathstr, name, ext] = fileparts(filename);
  
  fprintf('%d %s\n', img_idx, filename);
    
  % show image
  subplot(1, 2, 1);
  filename = fullfile(sprintf(opt.path_img_pascal, cls), [name '.jpg']);
  I = imread(filename);
  [h, w, ~] = size(I);
  mask = ones(h, w, 3);
  mask = padarray(mask, [pad_size pad_size 0]);
  imshow(I);
  hold on;
  
  % load annotations
  filename = fullfile(sprintf(opt.path_ann_pascal, cls), files(img_idx).name);
  object = load(filename);
  objects = object.record.objects;
 
  % for all annotated objects do
  for i = 1:numel(objects)
    object = objects(i);
    if strcmp(object.class, cls) == 0
        continue;
    end      
      
    % plot 2D bounding box
    bbox = object.bbox;
    bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
    rectangle('Position', bbox_draw, 'EdgeColor', 'g');
    
    % vertices and faces
    cad_index = object.cad_index;
    x3d = cads(cad_index).vertices;
    x2d = project_3d(x3d, object);
    if isempty(x2d)
        continue;
    end
    face = cads(cad_index).faces;

    % draw the cad overlap
    index_color = 1 + floor((i-1) * size(cmap,1) / numel(objects));
    patch('vertices', x2d, 'faces', face, ...
        'FaceColor', cmap(index_color,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none');

    x2d = x2d + pad_size;
    vertices = [x2d(face(:,1),2) x2d(face(:,1),1) ...
                x2d(face(:,2),2) x2d(face(:,2),1) ...
                x2d(face(:,3),2) x2d(face(:,3),1)];
    % BW is the mask
    BW = mesh_test(vertices, h+2*pad_size, w+2*pad_size);

    % create a colorful mask
    for j = 1:3
        tmp = mask(:,:,j);
        tmp(BW) = cmap(index_color,j);
        mask(:,:,j) = tmp;
    end
  end
  hold off;
  
  % show the mask
  subplot(1,2,2);
  mask = mask(pad_size+1:h+pad_size, pad_size+1:w+pad_size,:);
  imshow(uint8(255*mask));
  axis off;  
  axis equal;
  
  pause;
end