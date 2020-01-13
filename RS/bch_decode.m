function m_x=bch_decode(rec,n,k)
m=log2(n+1);
t=(n-k)/m;
[index_of,alpha_to]=generate_gf(m);
%% syndrome generation 
s=zeros(1, 2*t); 
for j=1:2*t
    s(j)=rs_poly(rec,alpha_to(j+1));
end
%% Berlekamp Massey Algorithm--erro location polynomial
lamda_x=bch_decode_BM(s,t);
%% Chien search: find roots of the error location polynomial
root=[];
j=1;
for i=1:n
    result=rs_poly(lamda_x,alpha_to(i));
    if result==0
        root(j)=alpha_to(i);
        j=j+1;
    end
end
site=[];
for i=1:length(root)
    site(i)=mod(n-index_of(root(i)),n);
end
%% r(x)+e(x)
 t_x=rec;
 for i=1:length(site)
      t_x(site(i)+1)=bitxor(rec(site(i)+1),1);
 end
%% m_x
m_x=t_x(n-k+1:n);   
end