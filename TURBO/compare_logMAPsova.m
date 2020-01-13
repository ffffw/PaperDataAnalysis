%logMAP sova¶Ô±È
EbN0db=0.5:0.5:3;
semilogy(EbN0db,(log(:,1)),'-.xk');
hold on;
semilogy(EbN0db,(sova(:,1)),'--*k');
hold on;

%legend('not coded','(15,5)BCH coded','(15,7)BCH coded'); %,'(15,11)BCH coded'
legend('logMAP','sova');
xlabel('EbN0/dB');
ylabel('BER');
title('Decoding performance comparison of logMAP and sova');