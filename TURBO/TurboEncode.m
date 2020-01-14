function [encoded_msg, alpha] = TurboEncode(msg, g, puncture)

[n,K] = size(g);
m = K - 1; %m=2;
L_total = m + length(msg);

[temp, alpha] = sort(rand(1, L_total)); % random interleaver mapping

encoded_msg = encoderm(msg, g, alpha, puncture);
