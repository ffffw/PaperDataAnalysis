close all;
clear all;

paths = {
     '/home/ruiy/store/data/experiment/indoor-no-move', 
     '/home/ruiy/store/data/experiment/indoor-people-move', 
     '/home/ruiy/store/data/experiment/indoor-trolly-move',
     '/home/ruiy/store/data/experiment/corridor-short-distance-no-move',
     '/home/ruiy/store/data/experiment/corridor-long-distance-no-move',
     %  '/home/ruiy/store/data/experiment/corridor-people-move',
     '/home/ruiy/store/data/experiment/corridor-trolly-move',
     '/home/ruiy/store/data/experiment/outdoor-no-move',
     '/home/ruiy/store/data/experiment/outdoor-people-move',
     '/home/ruiy/store/data/experiment/outdoor-trolly-move'
};

% paths = {
%   '/home/ruiy/store/data/experiment/indoor-trolly-move'
% };

crcNo = 12;

barData = [];

for k = 1: length(paths)
    
    path = char(paths(k));
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);
    evePaths = getPaths([path, '/eve/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = abs(readData(alicePaths));
    bobData = abs(readData(bobPaths));
    eveData = abs(readData(evePaths));
    
    aliceData = aliceData(:, 1:600);
    bobData = bobData(:, 1:600);
    eveData = eveData(:, 1:600);
    
    N = size(aliceData, 2);
    aliceData(256, :) = [];
    bobData(256, :) = [];
    eveData(256, :) = [];
    
   
    normScale = 127;
    L = 7;
    delta = 4;
    
    for i = 1: N
        aliceData(:, i) = normScale * aliceData(:, i) / mean(aliceData(:, i));
        bobData(:, i) = normScale * bobData(:, i) / mean(bobData(:, i));
        eveData(:, i) = normScale * eveData(:, i) / mean(eveData(:, i));
    end
    
    aliceData = round(aliceData);
    bobData = round(bobData);
    eveData = round(eveData);
    
    for i = 1: N
        aliceData(:, i) = floor(aliceData(:, i) / pow2(delta));        
        bobData(:, i) = floor(bobData(:, i) / pow2(delta));
        eveData(:, i) = floor(eveData(:, i) / pow2(delta));
    end
    
    abRatios = [];
    aeRatios = [];
    
    
    for i = 1: N
        aliceGrayCode = num2gray_vector(aliceData(:, i), L - delta)';
        aliceGrayCode = aliceGrayCode(:)';
        aliceBlockCode = reshape(aliceGrayCode(1: L*floor(numel(aliceGrayCode) / L)), L, floor(numel(aliceGrayCode) / L));
        
        bobGrayCode = num2gray_vector(bobData(:, i), L - delta)';
        bobGrayCode = bobGrayCode(:)';
        bobBlockCode = reshape(bobGrayCode(1: L*floor(numel(bobGrayCode) / L)), L, floor(numel(bobGrayCode) / L));
        
        eveGrayCode = num2gray_vector(eveData(:, i), L - delta)';
        eveGrayCode = eveGrayCode(:)';
        eveBlockCode = reshape(eveGrayCode(1: L*floor(numel(eveGrayCode) / L)), L, floor(numel(eveGrayCode) / L));
        
        abRightCode = [];
        aeRightCode = [];
        for j = 1: size(aliceBlockCode, 2)
            aliceCrcCode = crcAdd(str2num(aliceBlockCode(:, j))', crcNo);
            [output, indicate] = crcCheck([str2num(bobBlockCode(:, j))' aliceCrcCode(L+1:end)], crcNo);
            if indicate == 0
                abRightCode = [abRightCode aliceBlockCode(:, j)];
            end
            
            [output, indicate] = crcCheck([str2num(eveBlockCode(:, j))' aliceCrcCode(L+1:end)], crcNo);
            if indicate == 0
                aeRightCode = [aeRightCode aliceBlockCode(:, j)];
            end
        end
       
        abRatios = [abRatios size(abRightCode, 2)/size(aliceBlockCode, 2)];
        aeRatios = [aeRatios size(aeRightCode, 2)/size(aliceBlockCode, 2)];
                   
    end

    barData = [barData; mean(abRatios) mean(aeRatios)];

end

figure;
save('disAccord.mat', 'barData');
b = bar(barData);
ch = get(b,'children');
% set(ch{1},'facecolor',[0 0 0])
% set(ch{2},'facecolor',[1 1 1])
grid on;
set(gca, 'XTickLabel', {'室内-方式1','室内-方式2','室内-方式3','走廊-方式1','走廊-方式2','走廊-方式3','室外-方式1', '室外-方式2', '室外-方式3'});
set(gca, 'FontSize', 28);
% set(gca, 'FontSize', 18);
legend('\fontsize {28} alice和bob', '\fontsize {28} alice和eve');
