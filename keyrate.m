close all;
clear all;

paths = {
     '/home/ruiy/store/data/experiment/indoor-no-move-600', 
%     '/home/ruiy/store/data/experiment/indoor-people-move', 
%     '/home/ruiy/store/data/experiment/indoor-trolly-move',
%      '/home/ruiy/store/data/experiment/corridor-short-distance-no-move',
%     '/home/ruiy/store/data/experiment/corridor-long-distance-no-move',
%       '/home/ruiy/store/data/experiment/corridor-people-move',
%     '/home/ruiy/store/data/experiment/corridor-trolly-move',
%     '/home/ruiy/store/data/experiment/outdoor-no-move',
%     '/home/ruiy/store/data/experiment/outdoor-people-move',
%     '/home/ruiy/store/data/experiment/outdoor-trolly-move'
};

% paths = {
%   '/home/ruiy/store/data/experiment/indoor-trolly-move'
% };

crcNo = 12;

k = 1;
period = 32;

rates = [];

 path = char(paths(k));
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);

    aliceDataOrg = abs(readData(alicePaths));
    bobDataOrg = abs(readData(bobPaths));
    
    aliceDataOrg = aliceDataOrg(:, 1:10);
    bobDataOrg = bobDataOrg(:, 1:10);
    
    N = size(aliceDataOrg, 2);
    aliceDataOrg(256, :) = [];
    bobDataOrg(256, :) = [];
    
    
    
for avgNum = 1:20
    
    if avgNum ~= 1
    
        % 每4个取平均
        i = 1;
        j = 1;

        tmp = [];
        while i+avgNum-1 <= size(aliceDataOrg, 1)
            tmp = [tmp; mean(aliceDataOrg(i:i+avgNum-1, :))];
            i = i + avgNum;
            j = j + 1;
        end
        aliceData = tmp;

        i = 1;
        j = 1;
        tmp = [];
        while i+avgNum-1 <= size(bobDataOrg, 1)
            tmp = [tmp; mean(bobDataOrg(i:i+avgNum-1, :))];
            i = i + avgNum;
            j = j + 1;
        end
        bobData = tmp;
    else
        aliceData = aliceDataOrg;
        bobData = bobDataOrg;
    end
   
    normScale = 127;
    L = 7;
    delta = 4;
    
    for i = 1: N
        aliceData(:, i) = normScale * aliceData(:, i) / mean(aliceData(:, i));
        bobData(:, i) = normScale * bobData(:, i) / mean(bobData(:, i));
    end
    
    aliceData = round(aliceData);
    bobData = round(bobData);
    
    for i = 1: N
        aliceData(:, i) = floor(aliceData(:, i) / pow2(delta));        
        bobData(:, i) = floor(bobData(:, i) / pow2(delta));
    end
           
    cnt = 0;
    for i = 1: N
        aliceGrayCode = num2gray_vector(aliceData(:, i), L - delta)';
        aliceGrayCode = aliceGrayCode(:)';
        aliceBlockCode = reshape(aliceGrayCode(1: L*floor(numel(aliceGrayCode) / L)), L, floor(numel(aliceGrayCode) / L));
        
        bobGrayCode = num2gray_vector(bobData(:, i), L - delta)';
        bobGrayCode = bobGrayCode(:)';
        bobBlockCode = reshape(bobGrayCode(1: L*floor(numel(bobGrayCode) / L)), L, floor(numel(bobGrayCode) / L));
        
        rightCode = [];
        for j = 1: size(aliceBlockCode, 2)
            aliceCrcCode = crcAdd(str2num(aliceBlockCode(:, j))', crcNo);
            [output, indicate] = crcCheck([str2num(bobBlockCode(:, j))' aliceCrcCode(L+1:end)], crcNo);
            if indicate == 0
                rightCode = [rightCode aliceBlockCode(:, j)];
            end
        end
        
        % ratios = [ratios size(rightCode, 2)/size(aliceBlockCode, 2)];
        cnt = cnt + numel(rightCode);
    end
    
    rates = [rates cnt / period];
    
end

plot(4:20 , rates(4:20));
set(gca, 'FontSize', 28);
