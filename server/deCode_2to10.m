function [ Pop_dec ] = deCode_2to10( Pop_bin,N,Gen_lenth,D )
%==================== ʮ���ƽ������ ======================
H=Gen_lenth/D;
Weight=2.^(H-1:-1:0);    %�������������Ȩ��
for i=1:N
    for j=0:D-1
        Pop_dec(i,j+1)=Pop_bin(i,1+H*j:H+H*j)*Weight';
    end
end
end

