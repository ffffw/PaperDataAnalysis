function  m_x=extend_hamming_decode(t_x)
%% parity bits
s(1,:)=[t_x(1),t_x(3),t_x(5),t_x(7),t_x(9)];
s(2,:)=[t_x(2),t_x(3),t_x(6),t_x(7),0];
s(3,:)=[t_x(4),t_x(5),t_x(6),t_x(7),0];
s(4,:)=[t_x(8),t_x(9),0,0,0];
a=zeros(1,4);
for j=1:4
    for i=1:5
        a(1,j)=xor(a(1,j),s(j,i));
    end
end
b=a(4)*2^3+a(3)*2^2+a(2)*2+a(1);
%% m_x
m_x=zeros(1,5);
if b==0||b>9 
    m_x(1)=t_x(3);
    m_x(2)=t_x(5);
    m_x(3)=t_x(6);
    m_x(4)=t_x(7);
    m_x(5)=t_x(9);
else
    t_x(b)=xor(t_x(b),1);
    m_x(1)=t_x(3);
    m_x(2)=t_x(5);
    m_x(3)=t_x(6);
    m_x(4)=t_x(7);
    m_x(5)=t_x(9); 
end
end