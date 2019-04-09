function [data] = readData(filepaths)

if isstr(filepaths)
    filepaths = [filepaths];
end

data = [];

for i = 1: length(filepaths)
    
file = fopen(filepaths(i));
floatData = fread(file, 'float32');
complexData = floatData(1:2:end) + 1j * floatData(2:2:end);

data = [data complexData];

end

end