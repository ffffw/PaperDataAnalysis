function h = myentropy(data, n)

p = hist(data(:),8);%该直方图将会有8列，如果是灰度图像，则使用hist(f(:),256)，因为灰度图有256个灰度级
p = p/sum(p);
i = find(p);
h = -sum(p(i).*log2(p(i)));%计算信源熵

end