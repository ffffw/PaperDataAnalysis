function lamda_x=bch_decode_BM(syn,t)
t2=2*t;
lamda=zeros(t2+2,t2+1); %错误位置多项式
lamda(1,1)=1;
lamda(2,1)=1;%错位位置多项式初始值
D=zeros(1,t2+2);    % D:错误位置多项式lamda的次数
D(1)=0;  %D(-1)
D(2)=0;  %D(0)
d=zeros(1,t2+2); %d:j步和j+1步的差值
d(1)=1;   %d(-1)
d(2)=syn(1); %d(0)=S(1)
flag=-1;   %recode the last non-zero d
for j=0:t2-1
    if d(j+2)==0   
        lamda(j+2+1,:)=lamda(j+2,:);
        D(j+2+1)=D(j+2);
    else
        %to find the 'flag' for the iterate
        temp=circshift(lamda(flag+2,:),[0 j-flag]);
        %iteration to calculate locator polynomial
        for i=1:t2+1
            rev_flag=rs_rev(d(flag+2));
            mul_temp=rs_mul(d(j+2),rev_flag);
            lamda(j+2+1,i)=bitxor(lamda(j+2,i),rs_mul(mul_temp,temp(i)));
        end
        %to get the D(j)
        for i=1:t2+1
            if lamda(j+2+1,i)~=0
                D(j+2+1)=i-1;
            end
        end
        flag=j;   
    end
    if j~=t2-1
        r=j+1;
        d(r+2)=syn(r+1);
        for z=1:D(r+2)
            d(r+2)=bitxor(d(r+2),rs_mul(lamda(r+2,z+1),syn(r+1-z)));
        end
    end
end
lamda_x=lamda(t2+2,1:(D(t2+2)+1));
end