function [ output, indicate] = crcCheck( input, crc_no )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  written by Wang Meifang on 24th April, 2008
%   Email: mflltt@126.com
%  the function is proposed for deleting crc bits from the input sequence

%  input:     the input information+crc bits, a column vector
%  crc_no:    the number of the adding crc bits, such as 8,12,16,24
%  output:    the output information bits, a column vector
%  indicate:  indicate = 0 transmission is correct, otherwise transmission is wrong 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the length of input
n = size(input,2); 
generator = zeros(1,crc_no+1);
output = zeros(1,n-crc_no);

switch  crc_no
case   3
    generator = [1 0 1 1];
case   8
    generator = [1 1 0 0 1 1 0 1 1]; %D^8+D^7+D^4+D^3+D+1
case   12
    generator = [1 1 0 0 0 0 0 0 0 1 1 1 1]; %D^12+D^11+D^3+D^2+D+1
case   16
    generator = [1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1]; %D^16+D^12+D^5+1
case   24
    generator = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1]; %D^24+D^23+d^6+D^5+D+1
otherwise
    fprintf('\nPlease the number of crc bits should be 8 12 16 24\n');
end

output = input(1:n-crc_no);
for ii = 1:n-crc_no
    if(input(1) == 1)
        input(1:crc_no+1) = mod((input(1:crc_no+1)+generator),2);
    end
    input = [input(2:end) input(1)];
end
if sum(input) == 0
    indicate = 0;
else
    indicate = 1;
end
    