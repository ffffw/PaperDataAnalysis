function [code] = GenKey(data)

N = length(data);
data((N + 1) / 2, :) = [];
    
N = length(data);
% 每4个取平均
i = 1;
j = 1;
avgNum = 2;
tmp = [];
while i+avgNum-1 <= N
    tmp = [tmp; mean(data(i:i+avgNum-1))];
    i = i + avgNum;
    j = j + 1;
end
data = tmp;

normScale = 127;
L = 7;
delta = 4;

N = length(data);

data = data * normScale / mean(data);
data = round(data);


for i = 1: N
    data(i) = floor(data(i) / pow2(delta));    
end

code = [];

for i = 1: N
    grayCode = num2gray_vector(data(i), L - delta)';
    grayCode= grayCode(:)';
    code = [code grayCode];
end