function [ Pop_bin ] = Var_Reverse( Pop_bin,i,Gen_lenth )
%--------------- �˴����õ�����췽ʽ ---------------
Var_position_1=1+round(rand*(Gen_lenth-1));    %ѡ�����λ��1
Var_position_2=1+round(rand*(Gen_lenth-1));    %ѡ�����λ��2
a=min(Var_position_1,Var_position_2);     %ѡ������
b=max(Var_position_1,Var_position_2);     %ѡ������
if Var_position_1~=Var_position_2         %���������λ�ò����ʱʱ���ܲ����¸���
     for j=a:b      %���򽻲�
          L= Pop_bin(i,j);
          Pop_bin(i,b-(j-a))=L;    %�����е���
     end
end
end

