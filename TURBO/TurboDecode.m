function xhat = TurboDecode(encode_msg, alpha, puncture, L_total, niter, L_c, dec_alg, g)

[n,K] = size(g);
m = K - 1; %m=2;


yk = demultiplex(encode_msg, alpha,puncture); % demultiplex to get input for decoder 1 and 2
      
rec_s = 0.5*L_c*yk; % Scale the received bits

% Initialize extrinsic information 初始化外信息     
L_e(1: L_total) = zeros(1, L_total);
 for iter = 1:niter
% Decoder one
         L_a(alpha) = L_e;  % a priori info. 
         if dec_alg == 0
            L_all = logmapo(rec_s(1,:), g, L_a, 1);  % complete info.
         else   
            L_all = sova0(rec_s(1,:), g, L_a, 1);  % complete info.
         end   
         L_e = L_all - 2*rec_s(1,1:2:2*L_total) - L_a;  % extrinsic info.

% Decoder two         
         L_a = L_e(alpha);  % a priori info.
         if dec_alg == 0
            L_all = logmapo(rec_s(2,:), g, L_a, 2);  % complete info.  
         
            L_all = sova0(rec_s(2,:), g, L_a, 2);  % complete info. 
         end
         L_e = L_all - 2*rec_s(2,1:2:2*L_total) - L_a;  % extrinsic info.
         
% Estimate the info. bits   
         xhat(alpha) =(sign(L_all)+1)/2;
         % Number of bit errors in current iteration
         % err(iter) = length(find(xhat(1:L_total-m)~=x));
 end
% ber=err/length(x);
         