%test demo
clc;clear;
addpath('TURBO');
L_total=1024;
g = [ 1 1 1;
      1 0 1 ];
 [n,K] = size(g); %n=2,K=3;
m = K - 1;%m=2;
nstates = 2^m;% nstates =4;
%puncture=0,1
puncture = 0;
% EbN0db=1;
rate = 1/(2+puncture); % code rate
% Fading amplitude; a=1 in AWGN channel
a = 1; 
% nEN=1;
% en = 10^(EbN0db(nEN)/10);  % convert Eb/N0 from unit db to normal numbers db→w
snr=2;en=snr; 
L_c = 4*a*en*rate; 	% reliability value of the channel a=1，channel fadding
%sigma = 1/sqrt(2*rate*en);	% standard deviation of AWGN noise
niter=8;%反馈循环次数
dec_alg =0;% (0:Log-MAP, 1:SOVA) 
%dec_alg =1;

x = round(rand(1, L_total-m)); % message bits
input = num2str(x')'
[temp, alpha] = sort(rand(1,L_total)); % random interleaver mapping


en_output=encoderm( x, g, alpha, puncture );

% r = en_output+sigma*randn(1,L_total*(2+puncture)); % received bits
% ber_ori=sum(xor(en_output,r))/L_total;
% [r,ber_ori] = genkey( en_output,snr );

% 1. encode(x) xor key1 xor key2

en_output = (en_output + 1) / 2;
encode_res = num2str(en_output')'
key1 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/alice/2019-04-01-10-14-41/calculated_csi.bin")))
key2 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/bob/2019-04-01-10-14-41/calculated_csi.bin")))
L = str2num(key1') - str2num(key2');
s = sum(~L(:)); %算逻辑矩阵中非零个数
key_consistent_rate = s / length(key1)
n_key = length(key1);
for i = 1: length(en_output)
    tx = xor(en_output(i), str2num(key1(mod(i - 1, n_key) + 1)));
    en_output(i) = xor(tx, str2num(key2(mod(i - 1, n_key) + 1)));
end
r = en_output;
encode_res = num2str(r')'
r = 2 * r - 1;


yk = demultiplex(r,alpha,puncture); % demultiplex to get input for decoder 1 and 2
decoce_res = num2str(yk')'
% Scale the received bits      
rec_s = 0.5*L_c*yk;

% f4=fopen('x.bin','w');
% fwrite(f4,x,'double');
% f1=fopen('rsc1.bin','w');
% fwrite(f1,rec_s(1,:),'double');
% f2=fopen('rsc2.bin','w');
% fwrite(f2,rec_s(2,:),'double');
% f3=fopen('alpha.bin','w');
% fwrite(f3,alpha,'double');
% fclose(f1);
% fclose(f2);
% fclose(f3);
% fclose(f4);


% Initialize extrinsic information 初始化外信息     
L_e(1:L_total) = zeros(1,L_total);
 for iter = 1:niter
% Decoder one
         L_a(alpha) = L_e;  % a priori info. 
         if dec_alg == 0
            L_all = logmapo(rec_s(1,:), g, L_a, 1);  % complete info.
         else   
            L_all = sova0(rec_s(1,:), g, L_a, 1);  % complete info.
         end   
         L_e = L_all - 2*rec_s(1,1:2:2*L_total) - L_a;  % extrinsic info.

% Decoder two         
         L_a = L_e(alpha);  % a priori info.
         if dec_alg == 0
            L_all = logmapo(rec_s(2,:), g, L_a, 2);  % complete info.  
         else
            L_all = sova0(rec_s(2,:), g, L_a, 2);  % complete info. 
         end
         L_e = L_all - 2*rec_s(2,1:2:2*L_total) - L_a;  % extrinsic info.
         
% Estimate the info. bits   
         xhat(alpha) =(sign(L_all)+1)/2;
         % Number of bit errors in current iteration
         err(iter) = length(find(xhat(1:L_total-m)~=x));
 end
ber=err/length(x);
         
input
xhat_res = num2str(xhat')'
         
L = str2num(input')' - str2num(xhat_res(1:L_total - m)')';
s = sum(~L(:)); %算逻辑矩阵中非零个数
consistent_rate = s / length(input)