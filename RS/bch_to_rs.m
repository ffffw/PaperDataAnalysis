function t_x=bch_to_rs(m_x,m)
len=length(m_x)/m;
t_x=zeros(1,len);
m1=reshape(m_x,[m,len])';
for i=1:len
    a=num2str(m1(i,:));
    t_x(1,i)=bin2dec(a);
end
end