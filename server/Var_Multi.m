function [ Pop_bin ] = Var_Multi( Pop_bin,i,Gen_lenth )
%--------------- �˴����ö�㰴λȡ�����췽ʽ ---------------
Var_position_1=1+round(rand*(Gen_lenth-1));    %ѡ�����λ��1
Var_position_2=1+round(rand*(Gen_lenth-1));    %ѡ�����λ��2
a=min(Var_position_1,Var_position_2);          %ѡ������
b=max(Var_position_1,Var_position_2);          %ѡ������
if Var_position_1~=Var_position_2              %���������λ�ò����ʱ��Ϊ��㰴λȡ��
    for j=a:b
         Pop_bin(i,j)=~Pop_bin(i,j);
    end  
end

end
