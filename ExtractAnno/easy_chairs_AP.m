





clsname = 'chair';
assert(strcmp(clsname, 'chair'));
load('/orions3-zfs/projects/rqi/Dataset/PASCAL3D/PASCAL3D+_release1.1/ExtractAnno/voc12_val_easy_chair_ids.mat');

load('/orions3-zfs/projects/rqi/voc12_anno.mat');
annos = annotations{9}; % 9 for chair
image_ids = ids;

load(['/orions3-zfs/projects/rqi/' clsname '.mat']); % DETECTION RESULTS FROM RCNN MODEL..
boxes = BB';
% boxes = BB(:,tp==1)';
% tp_ids = ids(tp==1);
% sc_ids = sc(tp==1);

% labelfile = fopen([clsname '_label_v360.txt'],'w');
image_dir = '/orions3-zfs/projects/rqi/Dataset/VOC12/VOCdevkit/VOC2012/JPEGImages/';


% PR CURVE ON EASY CHAIRS

easy_cnt = 0;
for i = 1:length(tp)
    i
    
    if tp(i) == 1
        box = boxes(i,:);

        % find anno
        im_idx = strmatch(ids(i), image_ids);
        anno = annos{im_idx};
        anno_boxes = anno.bbox;
        anno_views = anno.view;
        anno_truncated = anno.truncated;
        anno_occluded = anno.occluded;
        anno_difficult = anno.difficult;

        o = box_overlap(anno_boxes, box);
        [maxo, index] = max(o);
        assert(maxo>0.5);
        
        if anno_truncated(index) == 0 && anno_occluded(index) == 0 && anno_difficult(index) == 0
            is_easy = 1;
        else
            continue; % not easy case, continue...
        end
    end
    
    
    
    in_easy = 0;
    for k = 1:length(easy_ids) % CONSIDER USING HASH FOR SPEEDUP!
        if strcmp(ids{i}, easy_ids{k})
            in_easy = 1;
        end
    end
    if in_easy
        easy_cnt = easy_cnt + 1;
        easy_tp(easy_cnt) = tp(i);
        easy_fp(easy_cnt) = fp(i);
    end
end
% compute precision/recall
easy_npos = length(easy_ids);
easy_fp=cumsum(easy_fp);
easy_tp=cumsum(easy_tp);
rec=easy_tp/easy_npos;
prec=easy_tp./(easy_fp+easy_tp);

ap=VOCap(rec',prec');

draw = 1;
if draw
    % plot precision/recall
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'
    title(sprintf('class: %s, subset: %s, AP = %.3f',cls,VOCopts.testset,ap));
end