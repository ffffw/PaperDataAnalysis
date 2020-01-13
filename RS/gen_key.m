function bob0=gen_key(alice0,snr)
modbit1 = pskmod(alice0,2); %相移键控调制
modbit2= awgn(modbit1,snr,'measured');%bob端收到信号
bob0=pskdemod(modbit2,2);
end