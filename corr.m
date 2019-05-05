close all;
clear all;

figure(1)
paths = getPaths('/home/ruiy/store/data/ruiy/bob/2019-04-01-*/calculated_csi.bin');
data = readData(paths);
% data = data(:, 1:100);

data = abs(data);

% 均值化为0
avg = mean(data);
data = data - avg;

% 能量归一化 
energe = sum(data .* data);
data = data ./ sqrt(energe);

figure(1);
sum = 0;
for i=1: size(data, 2)
    [a, b] = xcorr(data(:, i), 'coeff');
    sum = sum + a;
    hold on
    plot(b, a);
end
figure(2);
plot(b, sum / size(data, 2));
