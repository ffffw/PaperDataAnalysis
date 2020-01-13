clear;
% msg=[1,0,1,0,1,1,1,0,0,0,1,1,1,0,1,1,0,1,1,1,0];
% len=length(msg);
% code1=Bch_RS_encoder(msg);
% code2=code1;
% loc=randperm(105,5*7);
% for i=1:35
%     code2(loc(i))=xor(code1(loc(i)),1);
% end
% m1=Bch_RS_decoder(code2,len);
% a=length(find(m1==msg))/len

% msg=[1,0,1,0,1,1,1,0,0,0,1];
% len=length(msg);
% 
% code1=Bch_Hamming_encoder(msg);
% code2=code1;
% loc=randperm(46,7);
% for i=1:7
%     code2(loc(i))=xor(code1(loc(i)),1);
% end
% 
% m1=Bch_Hamming_decoder(code2,len);
% a=length(find(m1==msg))/len
n=31;k=11;
msg=randi([0 1],100,1)';

[bch_k,bch_block]=add_bits(msg,k);
bch_k=reshape(bch_k,[k,bch_block])';
bch_n=zeros(bch_block,n);
for i=1:bch_block
    bch_n(i,:)=bch_encode(bch_k(i,:),n,k);
end
code1=reshape(bch_n',1,bch_block*n);
code2=Bch_Hamming_encoder(msg);

code3=gen_key(code1,1);
code4=gen_key(code2,1);

b1=length(find(code3~=code1))/length(code1);
b2=length(find(code4~=code2))/length(code2);

bch_block=length(code1)/n;
bch_n=reshape(code3,[n,bch_block])';
bch_k=zeros(bch_block,k);
for i=1:bch_block
    bch_k(i,:)=bch_decode(bch_n(i,:),n,k);
end
bch_k=reshape(bch_k',1,bch_block*k);
m2=bch_k(1:length(msg));
[m3,m4]=Bch_Hamming_decoder(code4,length(msg));


j=1;
a1(j)=length(find(m2~=msg))/length(msg);
a2(j)=length(find(m3~=msg))/length(msg);
a3(j)=length(find(m4~=msg))/length(msg);

x=[sum(a1),sum(a2),sum(a3)]/j






