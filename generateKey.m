close all;
clear all;

paths = {
     '/home/ruiy/store/data/tdd-experiment/indoor-no-move', 
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

crc_no = 12;
avg_num = 1;
  
norm_scale = 127;
L = 7;
delta = 4;

keys = cell(length(paths), 1);

for k = 1: length(paths)
    
    path = char(paths(k));
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = abs(readData(alicePaths));
    bobData = abs(readData(bobPaths));
    
    aliceData = aliceData(:, 1:10);
    bobData = bobData(:, 1:10); 
    
    N = size(aliceData, 2);

    
    keys{k, 1} = cell(N, 1);
    
    for i = 1: N
        key1 = GenKey(aliceData(:, i), avg_num, norm_scale, L, delta);
        key2 = GenKey(bobData(:, i), avg_num, norm_scale, L, delta);
        
        [code, ratio] = Reconcile(key1, key2, L, crc_no);
        
        
        if size(code, 2) ~= 0
            code = str2num(code(:))';
            % keys{k, 1}{i, 1} = enc8b10b(rightCode(1:floor(size(rightCode, 2) / 8) * 8));
            keys{k, 1}{i, 1} = code;
        end
        
    end
    
end

save("fdd_keys_avg1.mat", "keys")
