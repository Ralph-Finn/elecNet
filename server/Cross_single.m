function [ Pop_bin ] = Cross_single( Pop_bin,i,N,Gen_lenth )
%--------------- 此处采用单点均匀交叉方式 ---------------
Cross_position=1+round(rand*(Gen_lenth-1));    %选择交点叉位置
if rand<=0.5    
    for j=Cross_position:Gen_lenth             %向后交叉
         L= Pop_bin(i+1,j);
         Pop_bin(i+1,j)=Pop_bin(N-i,j);        %将种群的首尾进行配对
         Pop_bin(N-i,j)=L;
    end
else
    for j=1:Cross_position                      %向前交叉
         L= Pop_bin(i+1,j);
         Pop_bin(i+1,j)=Pop_bin(N-i,j);        %将种群的首尾进行配对
         Pop_bin(N-i,j)=L;
    end
end
end
