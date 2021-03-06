% draw_ctable(ctable, 1, {'front', 'right-front', 'right', 'right-back', 'back', 'left-back', 'left', 'left-front'});
% draw_ctable(ctable, 1, {'Frontal', 'Left', 'Rear', 'Right'});
function CTableProb = draw_ctable(CTable, flag, classNames)

if nargin < 3
    classNames = 1:size(CTable,1);
end

CTableProb = zeros(size(CTable));
for i = 1:size(CTable, 1)
    if sum(CTable(i, :)) ~= 0
        CTableProb(i, :) = 100 * CTable(i, :) / sum(CTable(i, :));
    end
end

figure;
imagesc(CTableProb, [0 120]);
title({['Average Accuracy: ', num2str(sum(sum(diag(CTableProb))) / sum(sum(CTableProb)) * 100, '%.1f'),'%']});
% title({extraTitle;['Total Accuracy: ', num2str(sum(sum(diag(CTable))) / sum(sum(CTable)) * 100, '%.1f'),'%']});
set(gca, 'FontWeight', 'bold');

xlabel('estimated viewpoint');
ylabel('ground truth');
set(gca, 'YTick', 1:size(CTable, 1));
set(gca, 'XTick', 1:size(CTable, 2));
set(gca, 'YTickLabel', classNames);
set(gca, 'XTickLabel', classNames);
set(gca, 'FontWeight', 'bold');

if flag == 1
    for i=1:size(CTable, 1)
        for j=1:size(CTable, 2)
            dispStr = num2str(CTableProb(i, j)/100,'%.2f');
            text(j, i, dispStr, 'HorizontalAlignment','center','color','w', 'FontSize', 15, 'FontWeight', 'bold');
        end
    end
end