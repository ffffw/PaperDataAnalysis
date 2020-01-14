function res = XorTwoKey (code, key1, key2)

n_key = min(length(key1), length(key2));

res = code;
for i = 1: length(code)
    tx = xor(code(i), str2num(key1(mod(i - 1, n_key) + 1)));
    res(i) = xor(tx, str2num(key2(mod(i - 1, n_key) + 1)));
end

