function [ P,judge ] = LongestRunOfOnes( input )
%  块内最长游程检验，块内最大“1”游程检测
%  看长度为M-bits的子块中的最长“1”游程,判定待检验序列的最长“1”游程的长度是否同随机序列的相同。
%  n>=128且n<6272

n = length(input);
if n < 128
    P = 0;
    judge = 'NO test';
else
    M = 8;
    K = 3;
    N = floor(n/M);
    v = zeros(1,K+1);
    for i = 1:N
        if input((i-1)*M+1) == 1
            max_run(i) = 1;
        else
            max_run(i) = 0;
        end
        max_temp = max_run(i);
        for j = 2:M
            if (input((i-1)*M+j)==1) && (input((i-1)*M+j-1)==0)
                max_temp = 1;
            else if (input((i-1)*M+j)==1) && (input((i-1)*M+j-1)==1)
                    max_temp = max_temp+1;
                else if input((i-1)*M+j)==0
                        if max_temp > max_run(i)
                            max_run(i) = max_temp;
                            max_temp = 0;
                        end
                    end
                end
            end
            
        end
        if max_temp > max_run(i)
        	max_run(i) = max_temp;
        	max_temp = 0;
        end
        if (max_run(i)>=1) && (max_run(i)<=4)
            v(max_run(i)) = v(max_run(i))+1;
        end
    end
    
%     max_run
%     v
    
    pai = [0.2148,0.3672,0.2305,0.1875];
    V = sum((v-N*pai).^2./(N*pai));
    P = 1-gammainc(V/2,K/2);
    if P > 0.01
        judge = 'YES';
    else
        judge = 'NO';
    end
end
    
end

