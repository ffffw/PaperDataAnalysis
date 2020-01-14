function [code1, code2] = BCHEncode(msg, n, k)

% msg_str = num2str(msg')';

[bch_k,bch_block]=add_bits(msg,k);
bch_k=reshape(bch_k,[k,bch_block])';
bch_n=zeros(bch_block,n);
for i=1:bch_block
    bch_n(i,:)=bch_encode(bch_k(i,:),n,k);
end
code1=reshape(bch_n',1,bch_block*n);
code2=Bch_Hamming_encoder(msg);


