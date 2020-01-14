function [msg] = BCHDecode(encode_msg, n, k, msg_len)

bch_block = length(encode_msg) / n;
bch_n = reshape(encode_msg, [n, bch_block])';
bch_k = zeros(bch_block, k);
for i = 1:bch_block
    bch_k(i,:) = bch_decode(bch_n(i,:), n, k);
end
bch_k = reshape(bch_k', 1, bch_block*k);
msg = bch_k(1: msg_len);

% m2_str = num2str(m2')'
