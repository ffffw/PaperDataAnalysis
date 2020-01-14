%test demo
clc;clear;
addpath('TURBO');
L_total=1024;
g = [1 1 1; 1 0 1];
[n,K] = size(g); % n = 2, K = 3;

m = K - 1; % m = 2
nstates = 2 ^ m; % nstates = 4

puncture = 0; % puncture=0,1



msg = round(rand(1, L_total-m)); % message bits

[en_output, alpha] = TurboEncode(msg, g, puncture)


% channel: encode(x) xor key1 xor key2

en_output = (en_output + 1) / 2; % {-1, 1} => {0, 1}
key1 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/alice/2019-04-01-10-14-41/calculated_csi.bin")))
key2 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/bob/2019-04-01-10-14-41/calculated_csi.bin")))

r = XorTwoKey(en_output, key1, key2);
r = 2 * r - 1; % {0, 1} => {-1, 1}

niter = 8; % iteration number
dec_alg =0; % (0:Log-MAP, 1:SOVA) 
rate = 1/(2+puncture); % code rate
a = 1; % Fading amplitude; a=1 in AWGN channel 
snr = 2;
en = snr;
L_c = 4 * a * en * rate; 	% reliability value of the channel a=1，channel fadding

decode_msg = TurboDecode(r, alpha, puncture, L_total, niter, L_c, dec_alg, g);

ber = length(find(decode_msg(1: L_total - m) ~= msg)) / length(msg)