close all;
clear all;

paths = getPaths('/home/ruiy/store/data/ruiy/alice/2019-04-01-*/calculated_csi.bin');
data = readData(paths);

figure(1)
for i=1: size(data, 2)
    [a, b] = xcorr(data(:, i), 'unbiased');
    hold on
    plot(b, abs(a));
end