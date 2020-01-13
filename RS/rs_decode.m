function m_x=rs_decode(rec,n,k)
m=log2(n+1);
[index_of,alpha_to]=generate_gf(m);
%% s(x)
s=zeros(1,n-k);
for j=1:n-k
    s(j)=rs_poly(rec,alpha_to(j+1));
end
%% Berlekamp Massey Algorithm--erro location polynomial
lamda_x=rs_decode_BM(s,n,k);
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
%% forney-e(X)
if isempty(root)
    m_x=rec(n-k+1:n);
else
    site=[];  % erro location
    t=floor((n-k)/2);
    value=zeros(1,t);
    w=zeros(1,length(s)+length(lamda_x));
    for i=1:length(s)
        for j=1:length(lamda_x)
            w(i+j-1)=rs_add(w(i+j-1),rs_mul(s(i),lamda_x(j)));
        end
    end
    omega=w(1:2*t);
    lamda_dx=zeros(1,length(lamda_x));
    for h=1:length(lamda_x)
        if mod(h,2)==0
            lamda_dx(h-1)=lamda_x(h);
        end
    end
    lamda_dx(length(lamda_x))=0;
    for i=1:length(root)
        omega_final=rs_poly(omega,root(i));
        lamda_final=rs_poly(lamda_dx,root(i));
        %erro value
        value(i)=rs_mul(omega_final,rs_rev(lamda_final));
        site(i)=mod(n-index_of(root(i)),n);
    end
    %% r(x)+e(x)
    t_x=rec;
    for i=1:length(site)
        t_x(site(i)+1)=rs_add(rec(site(i)+1),value(i));
    end  
    %% m_x
    m_x=t_x(n-k+1:n);    
end
end
