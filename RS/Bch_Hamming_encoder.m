function code=Bch_Hamming_encoder(msg)
%% BCH(31,11,5)&& extend hamming
n1=31;k1=11;
n2=15;k2=5;
[msg1,block]=add_bits(msg,k1);
%% 
msg1=reshape(msg1,[k1,block])';
msg2=msg1(:,k1-k2+1:k1);
code1=zeros(block,n1);
code2=zeros(block,n2);
for i=1:block
    code1(i,:)=bch_encode(msg1(i,:),n1,k1);
    code2(i,:)=bch_encode(msg2(i,:),n2,k2);
end
%%
code=[code1,code2];
len=block*(n1+n2);
code=reshape(code',1,len);

end