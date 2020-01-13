function y=rs_mul(a,b)
load alpha_to.mat alpha_to;
load index_of.mat index_of;
n=length(alpha_to)-1;
if a*b==0
    y=0;
else
    a1=index_of(a);
    b1=index_of(b);
    c=mod((a1+b1),n);
    y=alpha_to(c+1);
end
end

    
    