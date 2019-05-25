function [ P,judge ] = Frequency( input )
%  频数(一位)检测、单比特频数检测
%  0和1在整个序列中所占的比例，输入>100bit0bit

data = 2*input-1;
S = sum(data);
V = abs(S)/sqrt(length(input));  % 统计值
P = erfc(V/sqrt(2));

if P > 0.01
    judge = 'YES';
else
    judge = 'NO';
end

end

