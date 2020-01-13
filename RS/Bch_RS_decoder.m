function msg=Bch_RS_decoder(code,msg_len)
%% RS(31,25,3)
m=5;n=31;k=25;
%m=3;n=7;k=3;
rs_n1=bch_to_rs(code,m);
rs_block=length(rs_n1)/n;
rs_n=reshape(rs_n1,[n,rs_block])';
rs_k=zeros(rs_block,k);
for i=1:rs_block
    rs_k(i,:)=rs_decode(rs_n(i,:),n,k);
end
rs_k=reshape(rs_k',1,rs_block*k);
%%
bch_n=rs_to_bch(rs_k,m);
%% BCH(15,7,2)
n=15;k=7;
bch_block=length(bch_n)/n;
bch_n=reshape(bch_n,[n,bch_block])';
bch_k=zeros(bch_block,k);
for i=1:bch_block
    bch_k(i,:)=bch_decode(bch_n(i,:),n,k);
end
bch_k=reshape(bch_k',1,bch_block*k);
%% 
msg=bch_k(1:msg_len);
end