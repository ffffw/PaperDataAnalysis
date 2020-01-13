function code=Bch_RS_encoder(msg)
%% BCH(15,7,2)
n=15;k=7;
[bch_k,bch_block]=add_bits(msg,k);
bch_k=reshape(bch_k,[k,bch_block])';
bch_n=zeros(bch_block,n);
for i=1:bch_block
    bch_n(i,:)=bch_encode(bch_k(i,:),n,k);
end
bch_n=reshape(bch_n',1,bch_block*n);
%% RS(31,25,3)
m=5;n=31;k=25;
%m=3;n=7;k=3;
[rs_k1,rs_b1]=add_bits(bch_n,m);
rs_k2=bch_to_rs(rs_k1,m);
[rs_k,rs_block]=add_bits(rs_k2,k);
rs_k=reshape(rs_k,[k,rs_block])';
rs_n=zeros(rs_block,n);
for i=1:rs_block
    rs_n(i,:)=rs_encode(rs_k(i,:),n,k);
end
rs_n=reshape(rs_n',1,rs_block*n);
%% rs to bch
code=rs_to_bch(rs_n,m);
end