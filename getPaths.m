function [paths] = getPaths(wildchar)

dirOutput = dir(fullfile('', wildchar));
names = {dirOutput.name};
folders = {dirOutput.folder};

paths = [];
for i=1: length(names)
    path = string(fullfile(folders(i), names(i)));
    paths = [paths path];
end

end