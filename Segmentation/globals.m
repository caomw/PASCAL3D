function opt = globals()

path_pascal3d = '../../PASCAL3D+_release1.1'; 
opt.path_pascal3d = path_pascal3d;
opt.path_img_pascal = [opt.path_pascal3d '/Images/%s_pascal'];
opt.path_ann_pascal = [opt.path_pascal3d '/Annotations/%s_pascal'];
opt.path_img_imagenet = [opt.path_pascal3d '/Images/%s_imagenet'];
opt.path_ann_imagenet = [opt.path_pascal3d '/Annotations/%s_imagenet'];
opt.path_set_imagenet_train = [opt.path_pascal3d '/Image_sets/%s_imagenet_train.txt'];
opt.path_set_imagenet_val = [opt.path_pascal3d '/Image_sets/%s_imagenet_val.txt'];
opt.path_pascal = [opt.path_pascal3d '/PASCAL/VOCdevkit'];
opt.path_cad = [opt.path_pascal3d '/CAD/%s.mat'];