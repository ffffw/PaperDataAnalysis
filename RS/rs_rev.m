function y=rs_rev(a)
load alpha_to.mat alpha_to;
load index_of.mat index_of;
n=length(alpha_to)-1;
if a==0
    y=0;
else
    a1=index_of(a);
    c=mod(n-a1,n);
    y=alpha_to(c+1);
end
end