function y=rs_poly(f,x)
load alpha_to.mat alpha_to;
load index_of.mat index_of;
n=length(alpha_to)-1;
xx=index_of(x);
L=length(f)-1;
y1=f(1);
for i=1:L
    y1=rs_add(y1,rs_mul(f(i+1),alpha_to(mod(i*xx,n)+1)));
end
y=y1;
end