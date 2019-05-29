function y = normlize(x)

y = abs(x);

% 均值化为0
avg = mean(y);
y = y - avg;

% 能量归一化 
energe = sum(y .* y);
y = y ./ sqrt(energe);

end