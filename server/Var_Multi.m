function [ Pop_bin ] = Var_Multi( Pop_bin,i,Gen_lenth )
%--------------- 此处采用多点按位取反变异方式 ---------------
Var_position_1=1+round(rand*(Gen_lenth-1));    %选择变异位置1
Var_position_2=1+round(rand*(Gen_lenth-1));    %选择变异位置2
a=min(Var_position_1,Var_position_2);          %选择下限
b=max(Var_position_1,Var_position_2);          %选择上限
if Var_position_1~=Var_position_2              %两个变异点位置不相等时才为多点按位取反
    for j=a:b
         Pop_bin(i,j)=~Pop_bin(i,j);
    end  
end

end
