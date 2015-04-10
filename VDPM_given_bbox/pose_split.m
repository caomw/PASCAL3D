% split positive training samples according to viewpoints
function [spos, index_pose] = pose_split(pos, n)

N = numel(pos);
view = zeros(N, 1);
for i = 1:N
    view(i) = find_interval(pos(i).azimuth, n);
end

spos = cell(n,1);
index_pose = [];
for i = 1:n
    spos{i} = pos(view == i);
    if numel(spos{i}) < 3   % too few positive samples
        spos{i} = [];
    end
    if isempty(spos{i}) == 0
        index_pose = [index_pose i];
    end
end

function ind = find_interval(azimuth, num)

a = (360/(num*2)):(360/num):360-(360/(num*2));

for i = 1:numel(a)
    if azimuth < a(i)
        break;
    end
end
ind = i;
if azimuth > a(end)
    ind = 1;
end