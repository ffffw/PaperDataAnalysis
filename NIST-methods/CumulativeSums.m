function [ P,judge ] = CumulativeSums( input,mode )
%  累加和检验
%  看随机游动的最大偏移,m=0 正向；m=0 反向
%  n>100
    
    n = length(input);
    data = 2*input-1;
    if mode == 0
        for i = 1:n
            s(i) = sum(data(1:i));
        end
    else
        for i = 1:n
            s(i) = sum(data(n-i+1:n));
        end
    end
    z = max(abs(s));%/(n/10)
    p1 = 0;
    p2 = 0;
    for j = ((-(n/z)+1)/4):1:(((n/z)-1)/4)%??????????????????????
        p1 = p1+(normcdf((4*j+1)*z/sqrt(n))-normcdf((4*j-1)*z/sqrt(n)));
    end
    for k = ((-(n/z)-3)/4):1:(((n/z)-1)/4)%??????????????????????
        p2 = p2+(normcdf((4*j+3)*z/sqrt(n))-normcdf((4*j+1)*z/sqrt(n)));
    end
    P = 1-p1+p2;
    if P > 0.01
        judge = 'YES';
    else
        judge = 'NO';
    end

end

