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
%    '/home/ruiy/store/data/experiment/indoor-people-move'
% };

crcNo = 12;

keys = cell(length(paths), 1);
for k = 1: length(paths)
    
    path = char(paths(k));
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = abs(readData(alicePaths));
    bobData = abs(readData(bobPaths));
    
    N = size(aliceData, 2);
    aliceData(256, :) = [];
    bobData(256, :) = [];
    
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
    
    ratios = [];
    
    keys{k, 1} = cell(N, 1);
    
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
        
%        ratios = [ratios size(rightCode, 2)/size(aliceBlockCode, 2)];
        
        keys{k, 1}{i, 1} = str2num(rightCode(:))';
        
    end
    
end

save("key.mat", "keys")
