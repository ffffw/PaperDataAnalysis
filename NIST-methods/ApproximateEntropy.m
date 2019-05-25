function [ P,judge ] = ApproximateEntropy( input,m )

%  近似熵检验
%  将两相邻长度（m和m-1）的重叠子块的频数与随机情况下比较
%  m<log2(n)-2

    n = length(input);
    if m > floor(log2(n))-2
        P = 0;
        judge = 'NO. m is too big';
    else
        data0 = reshape(input,1,[]);
        data = [data0,data0(1:m)];
        vm_0 = zeros(1,2^m);
        vm_1 = zeros(1,2^(m+1));
        for  i = 1:n
            s = 0;
            for j = 1:m
                s = s*2+data(i+j-1);
            end
            vm_0(s+1) = vm_0(s+1)+1;
            s = 0;
            for j = 1:m+1
                s = s*2+data(i+j-1);
            end
            vm_1(s+1) = vm_1(s+1)+1;
        end
        vm_0 = vm_0/n;
        vm_1 = vm_1/n;
        dm_0 = 0;
        dm_1 = 0;
        for i = 1:length(vm_0)
            if vm_0(i) > 0
                dm_0 = dm_0+vm_0(i)*log(vm_0(i));
            end
        end
        for i = 1:length(vm_1)
            if vm_1(i) > 0
                dm_1 = dm_1+vm_1(i)*log(vm_1(i));
            end
        end
        V = 2*n*(log(2)-(dm_0-dm_1));
        P = 1-gammainc(V/2,2^(m-1));
        if P > 0.01
            judge = 'YES';
        else
            judge = 'NO';
        end
    end

end

