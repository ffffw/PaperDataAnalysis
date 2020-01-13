function [Ber_ori ] =b_gen_key(orilen,snr )
alice0=randi([0,1],1,orilen);
modbit1 = pskmod(alice0,2); %相移键控调制
modbit2= awgn(modbit1,snr,'measured');%bob端收到信号
bob0=pskdemod(modbit2,2);
ori_error=(alice0~=bob0);
Ber_ori=sum(ori_error)/length(alice0);
end
