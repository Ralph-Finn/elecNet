function [ Pop_bin ] = Var_Defect( Pop_bin,i,Gen_lenth )
%--------------- �˴�����ȱʧ���췽ʽ ---------------
Var_position=1+round(rand*(Gen_lenth-1));    %ѡ�����λ��
Var_lenth=1+round(rand*(Gen_lenth-1));             %ѡ��ȱʧ���г���
if rand<=0.5                                 %���ȱʧ����
    if Var_position+Var_lenth<=Gen_lenth  
        for j=1:Var_lenth
            if rand<=0.5
                Pop_bin(i,Var_position+j)=0;     %��������ȫΪ0
            else
                Pop_bin(i,Var_position+j)=1;     %��������ȫΪ1
            end
        end 
    else
        for j=1:Gen_lenth-Var_position
            if rand<=0.5 
                Pop_bin(i,Var_position+j)=0;     %��������ȫΪ0
            else
                Pop_bin(i,Var_position+j)=1;     %��������ȫΪ1
            end
        end
    end

else                                             %��ǰȱʧ����
    if Var_position-Var_lenth>=1
        for j=1:Var_lenth
            if rand<=0.5
                Pop_bin(i,Var_position-j)=0;     %��������ȫΪ0
            else
                Pop_bin(i,Var_position-j)=1;     %��������ȫΪ1
            end
        end  
    else
        for j=1:Var_position-1
            if rand<=0.5
                Pop_bin(i,Var_position-j)=0;     %��������ȫΪ0
            else
                Pop_bin(i,Var_position-j)=1;     %��������ȫΪ1
            end
        end 
    end
end

end
