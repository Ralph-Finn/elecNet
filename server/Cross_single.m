function [ Pop_bin ] = Cross_single( Pop_bin,i,N,Gen_lenth )
%--------------- �˴����õ�����Ƚ��淽ʽ ---------------
Cross_position=1+round(rand*(Gen_lenth-1));    %ѡ�񽻵��λ��
if rand<=0.5    
    for j=Cross_position:Gen_lenth             %��󽻲�
         L= Pop_bin(i+1,j);
         Pop_bin(i+1,j)=Pop_bin(N-i,j);        %����Ⱥ����β�������
         Pop_bin(N-i,j)=L;
    end
else
    for j=1:Cross_position                      %��ǰ����
         L= Pop_bin(i+1,j);
         Pop_bin(i+1,j)=Pop_bin(N-i,j);        %����Ⱥ����β�������
         Pop_bin(N-i,j)=L;
    end
end
end
