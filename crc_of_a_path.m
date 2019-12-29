close all;
clear all;

path = "/home/ruiy/store/data/experiment/indoor-no-move-600/alice/2019-04-01-10-48-09/calculated_csi.bin";

data = readData(path);
data = abs(data);

keys = GenKey(data);

group_size = 7;
groups = reshape(keys(1: group_size*floor(numel(keys) / group_size)), group_size, floor(numel(keys) / group_size));

crc_no = 12;
crc_groups = [];
for i = 1: size(groups, 2)
    crc_code = crcAdd(str2num(groups(:, i))', crc_no);
    crc_groups = [crc_groups;crc_code];
end

crc_groups =  crc_groups';
% crc_groups_r = crc_groups;
crc_groups_r = crc_groups(group_size + 1: group_size + crc_no, :);
crc_groups_r_str = [];
for i = 1: size(crc_groups_r, 2)
    t = crc_groups_r(:, i);
    crc_groups_r_str = [crc_groups_r_str num2str(t(:))];
end


path2 = "/home/ruiy/store/data/experiment/indoor-no-move-600/bob/2019-04-01-10-48-09/calculated_csi.bin";
data2 = readData(path2);
data2 = abs(data2);

keys2 = GenKey(data2);
groups2 = reshape(keys2(1: group_size*floor(numel(keys2) / group_size)), group_size, floor(numel(keys2) / group_size));

check_res = [];
for i = 1: size(crc_groups_r, 2)
    [output, indicate] = crcCheck([str2num(groups2(:, i))' str2num(crc_groups_r_str(:, i))'], crc_no);
    check_res = [check_res 1 - indicate];
end

check_res_str = num2str(check_res')';