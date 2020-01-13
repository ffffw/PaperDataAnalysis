function [index_of,alpha_to]=generate_gf(m)
primpoly=[1     1     0     1     0     0     0     0     0     0     0;
   1     1     0     0     1     0     0     0     0     0     0;
   1     0     1     0     0     1     0     0     0     0     0;
   1     1     0     0     0     0     1     0     0     0     0;
   1     0     0     1     0     0     0     1     0     0     0;
   1     0     1     1     1     0     0     0     1     0     0;
   1     0     0     0     1     0     0     0     0     1     0;
   1     0     0     1     0     0     0     0     0     0     1];
p=primpoly(m-2,1:m+1);
n=2^m-1;
alpha_to=zeros(1,2^m);
mask=1;
alpha_to(m+1)=0;
for i=1:m
    alpha_to(i)=mask;
    if(p(i)~=0)
        alpha_to(m+1)=bitxor(alpha_to(m+1),mask);
    end
    mask=mask*2;     
end
mask=alpha_to(m);
for i=m+2:n
    if(alpha_to(i-1)>=mask)
        alpha_to(i)=bitxor(alpha_to(m+1),bitxor(alpha_to(i-1),mask)*2);
    else
        alpha_to(i)=alpha_to(i-1)*2;
    end
end
alpha_to(2^m)=0;
save 'alpha_to.mat' alpha_to;
index_of=zeros(1,2^m);
for i=1:2^m-1
    index_of(alpha_to(i))=i-1;
end
save 'index_of.mat' index_of;
end