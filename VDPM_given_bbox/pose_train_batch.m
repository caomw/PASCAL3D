views = [4, 8, 16];

tcls = {'bicycle', 'bus', 'table', 'sofa'};

for tt = 1:length(tcls)
    cls = tcls{tt};
    for i = 1:length(views)
        model = pose_train(cls, views(i), [cls '_' num2str(views(i))]);        
        save(['data/' cls '_' num2str(views(i)) '_view.mat'], 'model');
        system('rm -rf data/2012');
    end
end