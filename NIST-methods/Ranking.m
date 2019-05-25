function [ P,judge ] = Ranking( input,m )
%  二元矩阵秩检验，矩阵秩检测
%  看整个序列的分离子矩阵的秩。目的是核对源序列中固定长度子链间的线性依赖关系。
%  M=32，Q=32,n>=MQ=1024,  q=m,n>=38mq

    n = length(input);
    if n >=1024
        M = 32;
        Q = 32;
    else
        M = m;
        Q = m;
    end
    N = floor(n/(M*Q));
    F = zeros(1,3);
    for i = 1:N
        data = zeros(M,Q);
        for j = 1:M
            data(j,:) = input((i-1)*M*Q+(j-1)*Q+1:(i-1)*M*Q+(j-1)*Q+Q);
        end
        r(i) = rank(data);
        if r(i) == M
            F(1) = F(1)+1;
        else if r(i) == M-1
                F(2) = F(2)+1;
            else
                F(3) = F(3)+1;
            end
        end
    end
    
    pai = [0.2888,0.5776,0.1336];
    V = sum((F-N*pai).^2./(N*pai));
    P = exp(-V/2);
%     P = 1-gammainc(V/2,1);
    if P > 0.01
        judge = 'YES';
    else
        judge = 'NO';
    end
    
end

