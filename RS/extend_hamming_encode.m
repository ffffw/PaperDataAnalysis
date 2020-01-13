function  t_x=extend_hamming_encode(m_x)
%% (10,5,1)  t=1 e=2 d=4
t_x=zeros(1,10);
%% information bits
t_x(3)=m_x(1);
t_x(5)=m_x(2);
t_x(6)=m_x(3);
t_x(7)=m_x(4);
t_x(9)=m_x(5);
%% parity bits
s(1,:)=[t_x(1),t_x(3),t_x(5),t_x(7),t_x(9)];
s(2,:)=[t_x(2),t_x(3),t_x(6),t_x(7),0];
s(3,:)=[t_x(4),t_x(5),t_x(6),t_x(7),0];
s(4,:)=[t_x(8),t_x(9),0,0,0];
for j=1:4
    for i=1:4
        t_x(2^(j-1))=xor(t_x(2^(j-1)),s(j,i+1));
    end
end
%% even parity
for i=1:9
    t_x(10)=xor(t_x(10),t_x(i));
end
end