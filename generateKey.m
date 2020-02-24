close all;
clear all;

paths = {
     '/home/ruiy/store/data/fdd-experiment/indoor-no-move', 
     '/home/ruiy/store/data/fdd-experiment/indoor-people-move', 
     '/home/ruiy/store/data/fdd-experiment/indoor-trolly-move',
     '/home/ruiy/store/data/fdd-experiment/corridor-no-move',
     '/home/ruiy/store/data/fdd-experiment/corridor-people-move',
     '/home/ruiy/store/data/fdd-experiment/corridor-trolly-move',
     '/home/ruiy/store/data/fdd-experiment/outdoor-no-move',
     '/home/ruiy/store/data/fdd-experiment/outdoor-people-move',
     '/home/ruiy/store/data/fdd-experiment/outdoor-trolly-move'
};

% paths = {
%   '/home/ruiy/store/data/experiment/indoor-trolly-move'
% };

crcNo = 12;

keys = cell(length(paths), 1);
for k = 1: length(paths)
    
    path = char(paths(k));
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = abs(readData(alicePaths));
    bobData = abs(readData(bobPaths));
    
    aliceData = aliceData(:, 1:600);
    bobData = bobData(:, 1:600);
    
    N = size(aliceData, 2);
    aliceData(256, :) = [];
    bobData(256, :) = [];
    
    avgNum = 1; % 每avgNum个取平均
    if avgNum ~= 1
        i = 1;
        j = 1;
        tmp = [];
        while i+avgNum-1 <= size(aliceData, 1)
            tmp = [tmp; mean(aliceData(i:i+avgNum-1, :))];
            i = i + avgNum;
            j = j + 1;
        end
        aliceData = tmp;
    end
    
    if avgNum ~= 1
        i = 1;
        j = 1;
        tmp = [];
        while i+avgNum-1 <= size(bobData, 1)
            tmp = [tmp; mean(bobData(i:i+avgNum-1, :))];
            i = i + avgNum;
            j = j + 1;
        end
        bobData = tmp;
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
        
        % ratios = [ratios size(rightCode, 2)/size(aliceBlockCode, 2)];
        
        if size(rightCode, 2) ~= 0
            rightCode = str2num(rightCode(:))';
            % keys{k, 1}{i, 1} = enc8b10b(rightCode(1:floor(size(rightCode, 2) / 8) * 8));
            keys{k, 1}{i, 1} = rightCode;
        end
            
    end
    
end

save("fdd_keys_avg1.mat", "keys")
