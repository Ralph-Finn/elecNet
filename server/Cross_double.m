function [ Pop_bin ] = Cross_double( Pop_bin,i,N,Gen_lenth )
%--------------- �˴����ýضξ��Ƚ��淽ʽ ---------------
Cross_position_1=1+round(rand*(Gen_lenth-1));    %ѡ�񽻵��λ��
Cross_position_2=1+round(rand*(Gen_lenth-1));    %ѡ�񽻵��λ��
a=min(Cross_position_1,Cross_position_2);     %ѡ������
b=max(Cross_position_1,Cross_position_2);     %ѡ������
if Cross_position_1~=Cross_position_2         %���������λ�ò����ʱʱ���ܲ����¸���
    if rand<=0.5    
        for j=a:b      %���򽻲�
             L= Pop_bin(i+1,j);
             Pop_bin(i+1,j)=Pop_bin(N-i,j);    %����Ⱥ����β�������
             Pop_bin(N-i,j)=L;
        end
    else
        for j=a:b      %���򽻲�
             L= Pop_bin(i+1,j);
             Pop_bin(i+1,b-(j-a))=Pop_bin(N-i,j);    %����Ⱥ����β�������
             Pop_bin(N-i,b-(j-a))=L;
        end
    end
end
end