function [msg,m1]=Bch_Hamming_decoder(code,msg_len)
%% 
n1=31;k1=11;
n2=15;k2=5;
block=length(code)/(n1+n2);
code=reshape(code,(n1+n2),block)';
%% BCH && extend hamming
code1=code(:,1:n1);msg1=zeros(block,k1);
code2=code(:,n1+1:n1+n2);msg2=zeros(block,k2);
for i=1:block
    msg1(i,:)=bch_decode(code1(i,:),n1,k1);
    msg2(i,:)=bch_decode(code2(i,:),n2,k2);
end
%%
msg=[msg1(:,1:k1-k2),msg2];
msg=reshape(msg',1,k1*block);
msg=msg(1:msg_len);

m1=reshape(msg1',1,k1*block);
m1=m1(1:msg_len);
end