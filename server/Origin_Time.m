function t = Origin_Time ( f,T )
%自定义出发时间筛选函数
%利用GA算法的轮盘赌算子筛选电动汽车出发时刻
F=f/sum(f);               %归一化
p=rand;
Sum(1)=F(1);
for i=2:length(F)
    Sum(i)=Sum(i-1)+F(i);
    if p>Sum(i-1) && p<Sum(i)
        break;
    end
end

t(1,1)=T(i,1);
t(1,2)=T(i,2);
 
end

