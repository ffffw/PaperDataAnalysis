close all;
clear all;

figure(1)
paths = getPaths('/home/ruiy/store/data/ruiy/bob/2019-04-01-*/calculated_csi.bin');
data = readData(paths);

data = abs(data);

% 均值化为0
avg = mean(data);
data = data - avg;

% 能量归一化 
energe = sum(data .* data);
data = data ./ sqrt(energe);

for i=1: size(data, 2)
    [a, b] = xcorr(data(:, i), 'coeff');
    hold on
    plot(b(length(b)/2: end), a(length(a)/2: end));
end
