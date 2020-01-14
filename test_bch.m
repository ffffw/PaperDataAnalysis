clear;

addpath('RS');

n=31;k=11;
msg=randi([0 1],100,1)';

[encode_msg, hamming_encode_msg] = BCHEncode(msg, n, k);

key1 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/alice/2019-04-01-10-14-41/calculated_csi.bin")))
key2 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/bob/2019-04-01-10-14-41/calculated_csi.bin")))

key_inconsistent_rate = length(find(key1 ~= key2)) / length(key1)

rx_encode_msg = XorTwoKey(encode_msg, key1, key2);

rx_encode_msg_str = num2str(rx_encode_msg')'

decode_msg = BCHDecode(rx_encode_msg, n, k, length(msg));

ber = length(find(decode_msg ~= msg)) / length(msg)