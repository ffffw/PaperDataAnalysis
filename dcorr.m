close all;
clear all;

paths = {
    '/home/ruiy/store/data/experiment/indoor-no-move-600', 
    '/home/ruiy/store/data/experiment/indoor-people-move', 
    '/home/ruiy/store/data/experiment/indoor-trolly-move',
    '/home/ruiy/store/data/experiment/corridor-long-distance-no-move',
    '/home/ruiy/store/data/experiment/corridor-people-move',
    '/home/ruiy/store/data/experiment/corridor-trolly-move',
    '/home/ruiy/store/data/experiment/outdoor-no-move',
    '/home/ruiy/store/data/experiment/outdoor-people-move',
    '/home/ruiy/store/data/experiment/outdoor-trolly-move'
};

% paths = {
%     '/home/ruiy/store/data/experiment/corridor-trolly-move'
% };

barData = [];

for k = 1: length(paths)
    
    path = char(paths(k));
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);
    evePaths = getPaths([path, '/eve/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = readData(alicePaths);
    bobData = readData(bobPaths);
    eveData = readData(evePaths);

    aliceData = normlize(aliceData);
    bobData = normlize(bobData);
    eveData = normlize(eveData);
    
    aliceData = aliceData(:, 11: 610);
    bobData = bobData(:, 11: 610);
    eveData = eveData(:, 11: 610);

    coeffAB = [];
    for i=1: size(aliceData, 2)
        a = corrcoef(aliceData(:, i), bobData(:, i));
        coeffAB = [coeffAB abs(a(1, 2))];
    end

    coeffAE = [];
    for i=1: size(aliceData, 2)
        a = corrcoef(aliceData(:, i), eveData(:, i));
        coeffAE= [coeffAE abs(a(1, 2))];
    end

    figure;
    plot(coeffAB);
    hold on;
    plot(coeffAE);

    mAB = mean(coeffAB);
    mAE = mean(coeffAE);
    
    fprintf("%s coeff between a and b: %f\n", path, mAB);
    fprintf("%s coeff between a and e: %f\n", path, mAE);
    
    barData = [barData; mAB mAE];
    
end

figure;
b = bar(barData);
ch = get(b,'children');
% set(ch{1},'facecolor',[0 0 0])
% set(ch{2},'facecolor',[1 1 1])
grid on;
set(gca, 'XTickLabel', {'室内-方式1','室内-方式2','室内-方式3','走廊-方式1','走廊-方式2','走廊-方式3','室外-方式1', '室外-方式2', '室外-方式3'});
legend('alice和bob','alice和eve');
