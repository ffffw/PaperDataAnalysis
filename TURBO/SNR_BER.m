
semilogy(snr,(ber(:,1)),'b-*');
hold on;
semilogy(snr,(ber(:,2)),'g-*');
hold on;
semilogy(snr,(ber(:,3)),'r-*');
hold on;
%legend('not coded','(15,5)BCH coded','(15,7)BCH coded'); %,'(15,11)BCH coded'
legend('1 iteration','2 iteration','3 iteration');
xlabel('SNR/dB');
ylabel('BER');
title('SOVAÒëÂëĞÔÄÜ');