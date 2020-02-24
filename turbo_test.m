%test demo
close all;
clear all;
addpath('TURBO');
L_total=1024;
% L_total = 765 + 2;
g = [1 1 1; 1 0 1];
[n,K] = size(g); % n = 2, K = 3;

m = K - 1; % m = 2
nstates = 2 ^ m; % nstates = 4


puncture = 0; % puncture=0,1

% input message 
msg = round(rand(1, L_total-m)); % message bits

% encoded message
[en_output, alpha] = TurboEncode(msg, g, puncture);
en_output = (en_output + 1) / 2; % {-1, 1} => {0, 1}


% decode args
niter = 8; % iteration number
dec_alg =0; % (0:Log-MAP, 1:SOVA) 
rate = 1/(2+puncture); % code rate
a = 1; % Fading amplitude; a=1 in AWGN channel 
snr = 2;
en = snr;
L_c = 4 * a * en * rate; 	% reliability value of the channel a=1，channel fadding


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

    % channel: encode(x) xor key1 xor key2
    
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
        
        r = XorTwoKey(en_output, key1, key2);
        
        r = 2 * r - 1; % {0, 1} => {-1, 1}

        decode_msg = TurboDecode(r, alpha, puncture, L_total, niter, L_c, dec_alg, g);

        ber = ber + length(find(decode_msg(1: L_total - m) ~= msg)) / length(msg);
    
        key_inconsistent_rate = key_inconsistent_rate + length(find(key1 ~= key2)) / length(key1);
       
        [i, j]
    end
    
    key_inconsistent_rate = key_inconsistent_rate / size(aliceData, 2);
    ber = ber / size(aliceData, 2);

    barData = [barData; 1 - key_inconsistent_rate ber];
end
    

save('test_turbo.mat', 'barData');

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