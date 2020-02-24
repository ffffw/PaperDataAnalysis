clear all;
close all;

% load keys8b10b.mat
% load keys.mat
load fdd_keys_avg8.mat
addpath('NIST-methods');

N = size(keys, 1);

ratios = zeros(8, N);
for k = 1: N

    keyGroupNum = size(keys{k, 1}, 1);
    % keyGroupNum = 600;
    
    for i = 1: keyGroupNum
        
        key = keys{k, 1}{i, 1};
        keyLength = length(key);
        
        if keyLength == 0
            continue;
        end
        
        % 频率检验
        [p, judge] = Frequency(key);
        if strcmp(judge, 'YES')
            ratios(1, k) = ratios(1, k) + 1;
        end
        
        % 块内频数检验
        [p, judge] = BlockFrequency(key, ceil(keyLength/100));
        if strcmp(judge, 'YES')
            ratios(2, k) = ratios(2, k) + 1;
        end
        
        % 游程检验
        [p, judge] = Runs(key);
        if strcmp(judge, 'YES')
            ratios(3, k) = ratios(3, k) + 1;
        end
        
        % 块内最长游程检验
        [p, judge] = LongestRunOfOnes(key);
        if strcmp(judge, 'YES')
            ratios(4, k) = ratios(4, k) + 1;
        end
        
        % 二元矩阵秩检验
        [p, judge] = Ranking(key, 16);
        if strcmp(judge, 'YES')
            ratios(5, k) = ratios(5, k) + 1;
        end
        
        % 序列检验
        [p1, p2, judge] = Serial(key, 2);
        if strcmp(judge, 'YES')
            ratios(6, k) = ratios(6, k) + 1;
        end
        
        % 近似熵检验
        [p, judge] = ApproximateEntropy(key, 1);
        if strcmp(judge, 'YES')
            ratios(7, k) = ratios(7, k) + 1;
        end
        
        % 累加和检验
        [p, judge] = CumulativeSums(key, 0);
        if strcmp(judge, 'YES')
            ratios(8, k) = ratios(8, k) + 1;
        end
        
    end
    
    ratios(:, k) = ratios(:, k) ./ keyGroupNum;
   
end


% [P_Runs,Judge_Runs] = Runs(Collect_Keys);
% [P1_Serial,P2_Serial,Judge_Serial] = Serial(Collect_Keys,2);
% [P_Ranking,Judge_Ranking] = Ranking(Collect_Keys,16);
% [P_LongestRunOfOnes,Judge_LongestRunOfOnes] = LongestRunOfOnes(Collect_Keys);
% [P_Frequency,Judge_Frequency] = Frequency(Collect_Keys);
% [P_DiscreteFourierTransform,Judge_DiscreteFourierTransform] = DiscreteFourierTransform(Collect_Keys');
% [P_CumulativeSums,Judge_CumulativeSums] = CumulativeSums(Collect_Keys,0);
% [P_BlockFrequency,Judge_BlockFrequency] = BlockFrequency(Collect_Keys,ceil(Key_Length/100));
% [P_ApproximateEntropy,Judge_ApproximateEntropy] = ApproximateEntropy(Collect_Keys,1);