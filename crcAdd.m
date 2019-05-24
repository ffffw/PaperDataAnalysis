function [ output ] = crcAdd( input, crc_no )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  written by Wang Meifang on 24th April, 2008
%   Email: mflltt@126.com
%  the function is proposed for adding crc bits to the input sequence

%  input:     the input information bits, a column vector
%  crc_no:    the number of the adding crc bits, such as 3,8,12,16,24
%  output:    the output information+crc bits, a column vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the length of input
k = size(input,2); 
generator = zeros(1,crc_no+1);
output = zeros(1,k+crc_no);

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

output(1:k)=input;
for ii = 1:k
    if(output(1) == 1)
        output(1:crc_no+1) = mod((output(1:crc_no+1)+generator),2);
    end
    output = [output(2:end) output(1)];
end

output = [input output(1:crc_no)];

