function [code] = GenKey(data, avgNum, norm_scale, L, delta) % data为csi，avgNum为降采样率（不降采样，则填入为1）


N = length(data);
data((N + 1) / 2, :) = [];


N = length(data);
 
% 每avgNum个取平均
if avgNum ~= 1
    i = 1;
    j = 1;
    tmp = [];
    while i+avgNum-1 <= N
        tmp = [tmp; mean(data(i:i+avgNum-1))];
        i = i + avgNum;
        j = j + 1;
    end
    data = tmp;
end

data = MyNormlize(data, norm_scale, delta);

code = [];

for i = 1: N
    grayCode = num2gray_vector(data(i), L - delta)';
    grayCode= grayCode(:)';
    code = [code grayCode];
end
