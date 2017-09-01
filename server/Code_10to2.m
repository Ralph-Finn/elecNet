function [ Pop_bin ] = Code_10to2( Pop_dec,N,Gen_lenth,D )
%==================== 二进制编码程序 ======================
Pop_bin=zeros(N,Gen_lenth);  
H=Gen_lenth/D;
for i=1:N
    for j=1:D
        change=Pop_dec(i,j);
        for k=0:H-1         
            Pop_bin(i,H*j-k)=mod(change,2);         %mod表示取余
            change=fix(change/2);                   %fix表示截尾取整
        end    
    end
end


