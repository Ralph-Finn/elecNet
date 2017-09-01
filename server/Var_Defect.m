function [ Pop_bin ] = Var_Defect( Pop_bin,i,Gen_lenth )
%--------------- 此处采用缺失变异方式 ---------------
Var_position=1+round(rand*(Gen_lenth-1));    %选择变异位置
Var_lenth=1+round(rand*(Gen_lenth-1));             %选择缺失序列长度
if rand<=0.5                                 %向后缺失序列
    if Var_position+Var_lenth<=Gen_lenth  
        for j=1:Var_lenth
            if rand<=0.5
                Pop_bin(i,Var_position+j)=0;     %变异序列全为0
            else
                Pop_bin(i,Var_position+j)=1;     %变异序列全为1
            end
        end 
    else
        for j=1:Gen_lenth-Var_position
            if rand<=0.5 
                Pop_bin(i,Var_position+j)=0;     %变异序列全为0
            else
                Pop_bin(i,Var_position+j)=1;     %变异序列全为1
            end
        end
    end

else                                             %向前缺失序列
    if Var_position-Var_lenth>=1
        for j=1:Var_lenth
            if rand<=0.5
                Pop_bin(i,Var_position-j)=0;     %变异序列全为0
            else
                Pop_bin(i,Var_position-j)=1;     %变异序列全为1
            end
        end  
    else
        for j=1:Var_position-1
            if rand<=0.5
                Pop_bin(i,Var_position-j)=0;     %变异序列全为0
            else
                Pop_bin(i,Var_position-j)=1;     %变异序列全为1
            end
        end 
    end
end

end
