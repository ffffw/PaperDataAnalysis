function p=generate_primpoly(m)
for m=3:20
poly=dec2bin(primpoly(m));
p=str2num(poly(:))';
p=flip(p);
disp(p);
end
end