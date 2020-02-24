clear;

addpath('RS');

n=31;k=11;
msg=randi([0 1], 765, 1)';

[encode_msg, hamming_encode_msg] = BCHEncode(msg, n, k);

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

barData = [];
for i = 1: length(paths)
    
    path = char(paths(i));
    
    alicePaths = getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']);
    bobPaths = getPaths([path, '/bob/*-*-*-*-*-*/calculated_csi.bin']);

    aliceData = abs(readData(alicePaths));
    bobData = abs(readData(bobPaths));

    aliceData = aliceData(:, 11: 610);
    bobData = bobData(:, 11: 610);

    ber = 0;
    key_inconsistent_rate = 0;
    for j = 1: size(aliceData, 2)
        key1 = GenKey(aliceData(:, j));
        key2 = GenKey(bobData(:, j));
        
        key_inconsistent_rate = key_inconsistent_rate + length(find(key1 ~= key2)) / length(key1);

        rx_encode_msg = XorTwoKey(encode_msg, key1, key2);

        decode_msg = BCHDecode(rx_encode_msg, n, k, length(msg));

        ber = ber + length(find(decode_msg ~= msg)) / length(msg);
    end
    
    ber = ber / size(aliceData, 2);
    key_inconsistent_rate = key_inconsistent_rate / size(aliceData, 2);

    barData = [barData; 1 - key_inconsistent_rate ber];
end

save('fdd_test_bch.mat', 'barData');

figure;
b = bar(barData, 'FaceColor', 'flat');
b(1).CData = [0 0 0];
b(2).CData = [1 1 1];

% set(ch,'FaceVertexCData',[0 0 1;0 1 1]);
grid on;
set(gca, 'FontSize', 28);
set(gca, 'XTickLabel', {'室内-方式1','室内-方式2','室内-方式3','走廊-方式1','走廊-方式2','走廊-方式3','室外-方式1', '室外-方式2', '室外-方式3'});
% legend('alice和bob','alice和eve');
legend('\fontsize {22} 密钥一致率','\fontsize {22} 纠错之后的误比特率');