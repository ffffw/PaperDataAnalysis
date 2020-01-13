function [a1,block]=add_bits(a0,msg_len)
%msg_len 每组消息长度  block 分组数
len=length(a0);
if rem(len,msg_len)
    block=ceil(len/msg_len);
    a1=[a0,zeros(1,block*msg_len-len)];
else
    block=len/msg_len;
    a1=a0;
end
end