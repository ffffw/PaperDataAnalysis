function t_x=rs_to_bch(m_x,m)
n=length(m_x);
t_x=zeros(1,n*m);
for i=1:n
    a=dec2bin(m_x(i),m);
    t_x(1,(i-1)*m+1:i*m)=str2num(a(:))';
end
end