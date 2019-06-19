clear all;
close all;


paths = {
    '/home/ruiy/store/data/experiment/indoor-no-move-600', 
    '/home/ruiy/store/data/experiment/indoor-people-move', 
    '/home/ruiy/store/data/experiment/indoor-trolly-move',
    '/home/ruiy/store/data/experiment/corridor-short-distance-no-move',
    '/home/ruiy/store/data/experiment/corridor-people-move',
    '/home/ruiy/store/data/experiment/corridor-trolly-move',
    '/home/ruiy/store/data/experiment/outdoor-no-move',
    '/home/ruiy/store/data/experiment/outdoor-people-move',
    '/home/ruiy/store/data/experiment/outdoor-trolly-move'
};

% paths = {'/home/ruiy/store/data/experiment/corridor-trolly-move'};

barData = [];
for k = 1: length(paths)

    path = char(paths(k));
    
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);
    evePaths = getPaths([path, '/eve/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = abs(readData(alicePaths));
    bobData = abs(readData(bobPaths));
    eveData = abs(readData(evePaths));

    % aliceData = aliceData(:, 11: 610);
    % bobData = bobData(:, 11: 610);
    % eveData = eveData(:, 11: 610);

    aliceData = mapstd(aliceData')';
    bobData = mapstd(bobData')';
    eveData = mapstd(eveData')';

    A = aliceData(:, 1);
    B = bobData(:, 1);

    ratios = [];
    cnt = 0;
    i = 1;
    if k == 5
        i = 301;
    end
    N = size(aliceData, 2);
    
    while cnt < 600 && i <= N

        Ik = log2(cov(aliceData(:, i)) * cov(bobData(:, i)) / det(cov(aliceData(:, i), bobData(:, i))));
        Isk = log2(det(cov([aliceData(:, i) eveData(:, i)])) * det(cov([bobData(:, i) eveData(:, i)])) / (cov(eveData(:, i)) * det(cov([aliceData(:, i) bobData(:, i) eveData(:, i)]))));    
        ratio = Isk / Ik;
        if ratio <= 1 && ratio >= 0
            cnt = cnt + 1;
            ratios = [ratios ratio];
        end

        i = i + 1;
    end
    
    barData = [barData mean(ratios)];

    figure;
    plot(ratios);

end

save('leak.mat', 'barData');

figure;
b = bar(barData, 'FaceColor', 'flat');
b.CData = [1 1 1];
% ch = get(b,'children');
% set(ch{1},'facecolor',[0 0 0])
% set(ch{2},'facecolor',[1 1 1])
grid on;
set(gca, 'FontSize', 18);
set(gca, 'XTickLabel', {'室内-方式1','室内-方式2','室内-方式3','走廊-方式1','走廊-方式2','走廊-方式3','室外-方式1', '室外-方式2', '室外-方式3'});
legend('\fontsize {18} 安全信息比率');