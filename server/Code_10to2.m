function [ Pop_bin ] = Code_10to2( Pop_dec,N,Gen_lenth,D )
%==================== �����Ʊ������ ======================
Pop_bin=zeros(N,Gen_lenth);  
H=Gen_lenth/D;
for i=1:N
    for j=1:D
        change=Pop_dec(i,j);
        for k=0:H-1         
            Pop_bin(i,H*j-k)=mod(change,2);         %mod��ʾȡ��
            change=fix(change/2);                   %fix��ʾ��βȡ��
        end    
    end
end


