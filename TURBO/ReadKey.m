function keys = ReadKey(filepaths)

if isstr(filepaths)
    filepaths = [filepaths];
end

keys = [];

for i = 1: length(filepaths)
    
file = fopen(filepaths(i));
key = fread(file, '*char');

keys = [keys key'];

fclose(file);

end