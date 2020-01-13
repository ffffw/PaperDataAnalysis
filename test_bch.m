clear;

addpath('RS');
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

msg_str = num2str(msg')'

[bch_k,bch_block]=add_bits(msg,k);
bch_k=reshape(bch_k,[k,bch_block])';
bch_n=zeros(bch_block,n);
for i=1:bch_block
    bch_n(i,:)=bch_encode(bch_k(i,:),n,k);
end
code1=reshape(bch_n',1,bch_block*n);
code2=Bch_Hamming_encoder(msg);

code3 = code1;
key1 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/alice/2019-04-01-10-14-41/calculated_csi.bin")))
key2 = GenKey(abs(readData("/home/ruiy/store/data/experiment/indoor-no-move-600/bob/2019-04-01-10-14-41/calculated_csi.bin")))
L = str2num(key1') - str2num(key2');
s = sum(~L(:)); %算逻辑矩阵中非零个数
key_consistent_rate = s / length(key1)
n_key = length(key1);
for i = 1: length(code1)
    tx = xor(code1(i), str2num(key1(mod(i - 1, n_key) + 1)));
    code3(i) = xor(tx, str2num(key2(mod(i - 1, n_key) + 1)));
end
code3_str = num2str(code3')'

% code3=gen_key(code1,1);
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

m2_str = num2str(m2')'
msg_str

j=1;
a1(j)=length(find(m2~=msg))/length(msg);
a2(j)=length(find(m3~=msg))/length(msg);
a3(j)=length(find(m4~=msg))/length(msg);

x=[sum(a1),sum(a2),sum(a3)]/j


L = str2num(msg_str')' - str2num(m2_str')';
s = sum(~L(:)); %算逻辑矩阵中非零个数
consistent_rate = s / length(msg_str)