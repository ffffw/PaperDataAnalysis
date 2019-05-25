function [ P,judge ] = BlockFrequency( input,M )
%  块内频数检验
%  M位的子块中“1”码的比例,n>100,M>0.01n
%  
n = length(input);
N = floor(n/M);
for i = 1:N
    S(i) = sum(input((i-1)*M+1:(i*M)))/M;
end
V = 4*M*sum((S-0.5*ones(size(S))).^2);
P = 1-gammainc(V/2,N/2);
if P > 0.01
    judge = 'YES';
else
    judge = 'NO';
end

end

