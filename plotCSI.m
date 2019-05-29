clear all;
close all;

paths = {
     '/home/ruiy/store/data/experiment/indoor-no-move', 
     '/home/ruiy/store/data/experiment/indoor-people-move',
     '/home/ruiy/store/data/experiment/indoor-trolly-move',
      %'/home/ruiy/store/data/experiment/corridor-short-distance-no-move',
     '/home/ruiy/store/data/experiment/corridor-long-distance-no-move',
     '/home/ruiy/store/data/experiment/corridor-people-move',
     '/home/ruiy/store/data/experiment/corridor-trolly-move',
     '/home/ruiy/store/data/experiment/outdoor-no-move',
     '/home/ruiy/store/data/experiment/outdoor-people-move',
     '/home/ruiy/store/data/experiment/outdoor-trolly-move'
};

sceneNum = size(paths, 1);

for k = 1: sceneNum
    
    path = char(paths(k));
    
    data = readData(getPaths([path, '/alice/*-*-*-*-*-*/calculated_csi.bin']));
    data = data(:, 1:600);
   
    data = normlize(data);

    
    figure;
    x= 1:size(data,2);
    y= 1:size(data,1);
    [meshX, meshY]=meshgrid(x,y);
    mesh(meshX, meshY, data);
    set(gca,'ZLim',[-0.2 0.2]); % z轴的数据显示范围
    set(gca, 'ZTick', [-0.2:0.2:0.2])
    set(gca, 'XLim', [0 600]); % x轴 
    set(gca, 'XTick', [0:600:600]);
    set(gca, 'YLim', [0 600]); % Y轴 
    set(gca, 'YTick', [0:600:600]);
    set(gca, 'FontSize', 20);
    
end