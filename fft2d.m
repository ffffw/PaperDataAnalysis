clear all;
close all;
paths = getPaths('/home/ruiy/store/data/ruiy/alice/2019-04-01-*/calculated_csi.bin');
data = readData(paths);

Y = fft2(data);
imagesc(abs(fftshift(Y)));
