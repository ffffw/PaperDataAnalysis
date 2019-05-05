close all;
clear all;

figure(1)
paths = getPaths('/home/ruiy/store/data/ruiy/alice/2019-04-01-*/calculated_csi.bin');
data = readData(paths);
% data = data(:, 1:100);

data = abs(data);

% 均值化为0
avg = mean(data);
data = data - avg;

% 能量归一化 
energe = sum(data .* data);
data = data ./ sqrt(energe);

sum = 0;
for i=1: size(data, 2)
    [a, b] = xcorr(data(:, i), 'coeff');
    sum = sum + a;
end

plot(b, sum / size(data, 2));
