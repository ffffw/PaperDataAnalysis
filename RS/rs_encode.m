function code=rs_encode(data,n,k)
m=log2(n+1);
[index_of,alpha_to]=generate_gf(m);
%%g(x)
g=rsgenpoly(n,k);
g=double(g.x);
g=flip(g);
%%r(x)
rr=zeros(1,n-k);
for i=k:-1:1
    feedback=rs_add(data(i),rr(n-k));
    if(feedback~=0)
        for j=n-k-1:-1:1
            if(g(j)~=0)
                rr(j+1)=rs_add(rr(j),rs_mul(g(j+1),feedback));
            else
                rr(j+1)=rr(j);
            end
        end
            rr(1)=rs_mul(g(1),feedback);
    else
        for j=n-k-1:-1:1
            rr(j+1)=rr(j);
        end
        rr(1)=0;
    end
end
%%c(x)
code=[rr,data];
end
