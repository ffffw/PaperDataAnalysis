clear all;
close all;

paths = getPaths('/home/ruiy/store/data/ruiy/eve/2019-04-01-*/calculated_csi.bin');
data = readData(paths); % 原始复数数据
% data(255:257, :) = [];
% data = data(:, 128: 256);
% data([1:10 500:511], :) = [];

data = abs(data);

% 均值化为0
avg = mean(data);
data = data - avg;

% 归一化 
energe = sum(data .* data);
data = data ./ sqrt(energe);

figure(1)
imagesc(data);

figure(2)
x= 1:size(data,2);
y= 1:size(data,1);
[meshX, meshY]=meshgrid(x,y);
mesh(meshX, meshY, data);

figure(3)
Y = fft2(data(:, :));
Y = Y(128: end-128, 2: end);
% Y = Y(64: end-64, 2: end);
% Y = fftshift(Y);
imagesc(abs(Y));

figure(4)
x= 1:size(Y, 2);
y= 1:size(Y, 1);
[meshX, meshY]=meshgrid(x,y);
mesh(meshX, meshY, abs(Y))

