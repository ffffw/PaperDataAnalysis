function [ P1,P2,judge ] = Serial( input,m )

%  序列检验,重叠子序列检测
%  判定2^m个m-bit重叠模式的数目是否与随机情况下相似
%  2<=m<log2(n)-2

    n = length(input);
    if m > floor(log2(n))-2
        P1 = 0;
        P2 = 0;
        judge = 'NO. m is too big';
    else
        data0 = reshape(input,1,[]);
        data = [data0,data0(1:m-1)];
        vm_0 = zeros(1,2^m);
        vm_1 = zeros(1,2^(m-1));
        vm_2 = zeros(1,2^(m-2));
        for  i = 1:n
            s = 0;
            for j = 1:m
                s = s*2+data(i+j-1);
            end
            vm_0(s+1) = vm_0(s+1)+1;
            s = 0;
            for j = 1:m-1
                s = s*2+data(i+j-1);
            end
            vm_1(s+1) = vm_1(s+1)+1;
            s = 0;
            for j = 1:m-2
                s = s*2+data(i+j-1);
            end
            vm_2(s+1) = vm_2(s+1)+1;
        end

        dm_0 = (2^m/n)*sum(vm_0.^2)-n;
        dm_1 = (2^(m-1)/n)*sum(vm_1.^2)-n;
        dm_2 = (2^(m-2)/n)*sum(vm_2.^2)-n;
        V_1 = dm_0-dm_1;
        V_2 = dm_0-2*dm_1+dm_2;
        P1 = 1-gammainc(V_1/2,2^(m-2));
        P2 = 1-gammainc(V_2/2,2^(m-3));
        if P1 > 0.01 && P2 > 0.01
            judge = 'YES';
        else
            judge = 'NO';
        end
    end
        
end

