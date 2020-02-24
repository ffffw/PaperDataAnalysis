function [code, ratio] = Reconcile(key1, key2, L, crc_no)
    
     block_code1 = reshape(key1(1: L*floor(numel(key1) / L)), L, floor(numel(key1) / L));
     block_code2 = reshape(key2(1: L*floor(numel(key2) / L)), L, floor(numel(key2) / L));
    
     code = [];ratio = 0;
     for j = 1: size(block_code1, 2)
         crc_code1 = crcAdd(str2num(block_code1(:, j))', crc_no);
         [output, indicate] = crcCheck([str2num(block_code2(:, j))' crc_code1(L+1:end)], crc_no);
         if indicate == 0
             code = [code block_code1(:, j)];
         end
     end
     
     ratio = size(code, 2) / size(block_code1, 2);
    
end