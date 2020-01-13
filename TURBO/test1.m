clc;clear;
% snr=0.5;
% alice=[1,-1,1,-1];
% len=length(alice);
% alice0=0.5.*alice+0.5*ones(1,len);
% modbit1 = pskmod(alice0,2); %相移键控调制
%  modbit2= awgn(modbit1,snr,'measured');%bob端收到信号
%  bob0=pskdemod(modbit2,2);
%  bob=2.*(bob0-0.5*ones(1,len));
%  ori_error=(alice0~=bob0);
%  Ber_ori=sum(ori_error)/length(alice0);
% 
% trellis=poly2trellis([5,4],[23,35,0;0,05,13])
%poly2trellis(4,[13 15 17],13)
clc;clear;

orilen=10;
alice0=randi([0,1],1,orilen);
index=randperm(orilen);