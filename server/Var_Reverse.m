function [ Pop_bin ] = Var_Reverse( Pop_bin,i,Gen_lenth )
%--------------- 此处采用倒序变异方式 ---------------
Var_position_1=1+round(rand*(Gen_lenth-1));    %选择变异位置1
Var_position_2=1+round(rand*(Gen_lenth-1));    %选择变异位置2
a=min(Var_position_1,Var_position_2);     %选择下限
b=max(Var_position_1,Var_position_2);     %选择上限
if Var_position_1~=Var_position_2         %两个变异点位置不相等时时才能产生新个体
     for j=a:b      %倒序交叉
          L= Pop_bin(i,j);
          Pop_bin(i,b-(j-a))=L;    %将序列倒序
     end
end
end

