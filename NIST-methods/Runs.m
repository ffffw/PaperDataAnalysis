function [ P,judge ] = Runs( input )
%  游程（总数）检验
%  判定不同长度的“1”游程的数目以及“0”游程的数目是否跟理想的随机序列的期望值相一致
%  n>100

n = length(input);
s = sum(input)/n;
if abs(s-0.5) >= (2/sqrt(n))
    P = 0;
    judge = 'NO test';
else
    for i = 1:n-1
        if input(i) == input(i+1) 
            r(i) = 0;
        else
            r(i) = 1;
        end
    end
    V = sum(r)+1;
    P = erfc(abs(V-2*n*s*(1-s))/(2*sqrt(2*n)*s*(1-s)));
    if P > 0.01
        judge = 'YES';
    else
        judge = 'NO';
    end
end

end

