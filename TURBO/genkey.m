function [bob,Ber_ori] = genkey( alice,snr )
len=length(alice);
alice0=0.5.*alice+0.5*ones(1,len);%0/1
modbit1 = pskmod(alice0,2); %相移键控调制
 modbit2= awgn(modbit1,snr,'measured');%bob端收到信号
 bob0=pskdemod(modbit2,2);
 bob=2.*(bob0-0.5*ones(1,len));
 ori_error=(alice0~=bob0);
 Ber_ori=sum(ori_error)/length(alice0);

end
