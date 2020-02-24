clear all;
close all;

% paths = getPaths('/home/ruiy/store/data/experiment/indoor-no-move-600/alice/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/experiment/indoor-no-move/alice/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/experiment/indoor-people-move/alice/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/experiment/indoor-trolly-move/alice/*-*-*-*-*-*/calculated_csi.bin');

% paths = getPaths('/home/ruiy/store/data/experiment/corridor-short-distence-no-move/alice/*-*-*-*-*-*/calculated_csi.bin');
% % 数据不好，舍弃不用
% paths =getPaths('/home/ruiy/store/data/experiment/corridor-long-distence-no-move/alice/*-*-*-*-*-*/calculated_csi.bin'); % 可以当做no-move用
% paths = getPaths('/home/ruiy/store/data/experiment/corridor-people-move/alice/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/experiment/corridor-trolly-move/alice/*-*-*-*-*-*/calculated_csi.bin');

% paths = getPaths('/home/ruiy/store/data/experiment/outdoor-no-move/alice/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/experiment/outdoor-people-move/alice/*-*-*-*-*-*/calculated_csi.bin');
paths = getPaths('/home/ruiy/store/data/experiment/outdoor-trolly-move/alice/*-*-*-*-*-*/calculated_csi.bin');



% paths = getPaths('/home/ruiy/store/data/fdd-experiment/indoor-no-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/indoor-people-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/indoor-trolly-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/corridor-no-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/corridor-people-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/corridor-trolly-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/outdoor-no-move/bob/*-*-*-*-*-*/calculated_csi.bin');
% paths = getPaths('/home/ruiy/store/data/fdd-experiment/outdoor-people-move/bob/*-*-*-*-*-*/calculated_csi.bin');
paths = getPaths('/home/ruiy/store/data/fdd-experiment/outdoor-trolly-move/bob/*-*-*-*-*-*/calculated_csi.bin');

data = readData(paths); % 原始复数数据
data = data(:, 1:600);
data = abs(data);

% data = randn(511, 600); % 完全随机

% 均值化为0
avg = mean(data);
data = data - avg;

% 归一化 
energe = sum(data .* data);
% data = data ./ sqrt(energe);

% data = repmat(data(:, 1), 1, 600);
% data = repmat([1], 600, 511);

figure(1)
imagesc(data);

figure(2)
x= 1:size(data,2);
y= 1:size(data,1);
[meshX, meshY]=meshgrid(x,y);
mesh(meshX, meshY, data);
xlabel('测量次数');
ylabel('子载波数');
set(gca, 'FontSize', 20);

figure(3)
Z = mat2gray(data);
imshow(Z, []);
% h = entropy(Z)

figure(4)
Y = fft2(data);
% Y = Y(128: end-128, 2: end);
% Y = Y(64: end-64, 2: end);
Y = fftshift(Y);
% imagesc(angle(Y));
Z = log(abs(Y)+1);
Z = mat2gray(Z);
imshow(Z, []);

imwrite(Z, '/home/ruiy/store/paperlet/paperlet-tex/xml/outdoor-trolly-move.png')
% saveas(gcf, '/home/ruiy/store/paperlet/paperlet-tex/xml/indoor-no-move.png');
% img = imread('entropy.png');
h = entropy(Z)


figure(5)
x= 1:size(Y, 2);
y= 1:size(Y, 1);
[meshX, meshY]=meshgrid(x,y);
mesh(meshX, meshY, abs(Y))


