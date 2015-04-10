cls_rigid_names = {'aeroplane','bicycle','boat','bottle','bus','car','chair','diningtable','motorbike','sofa','train','tvmonitor'};
for i = 1:12
    cls = cls_rigid_names{i}
    load([cls '_viewpoint_stats']);
    figure, subplot(1,3,1), hist(azimuths); title('azimuth');
    subplot(1,3,2), hist(elevations); title('elevations');
    subplot(1,3,3), hist(thetas); title('thetas');
    pause();
    close;
end