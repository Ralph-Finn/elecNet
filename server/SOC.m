function soc = SOC ( f,XX )
%自定义SOC筛选函数
%利用GA算法的轮盘赌算子
F=f/sum(f);               %归一化
p=rand;
Sum(1)=0;

for i=1:length(F)
    Sum(i+1)=Sum(i)+F(i);
    if p>Sum(i) && p<Sum(i+1)
        break;
    end
end

soc=XX(i);
 
end


