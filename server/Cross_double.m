function [ Pop_bin ] = Cross_double( Pop_bin,i,N,Gen_lenth )
%--------------- 此处采用截段均匀交叉方式 ---------------
Cross_position_1=1+round(rand*(Gen_lenth-1));    %选择交点叉位置
Cross_position_2=1+round(rand*(Gen_lenth-1));    %选择交点叉位置
a=min(Cross_position_1,Cross_position_2);     %选择下限
b=max(Cross_position_1,Cross_position_2);     %选择上限
if Cross_position_1~=Cross_position_2         %两个交叉点位置不相等时时才能产生新个体
    if rand<=0.5    
        for j=a:b      %正序交叉
             L= Pop_bin(i+1,j);
             Pop_bin(i+1,j)=Pop_bin(N-i,j);    %将种群的首尾进行配对
             Pop_bin(N-i,j)=L;
        end
    else
        for j=a:b      %倒序交叉
             L= Pop_bin(i+1,j);
             Pop_bin(i+1,b-(j-a))=Pop_bin(N-i,j);    %将种群的首尾进行配对
             Pop_bin(N-i,b-(j-a))=L;
        end
    end
end
end