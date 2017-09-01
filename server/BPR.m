function v = BPR( Flow )
%自定义流量-车速变换子函数
global TH_l
for i=1:length(Flow)
    b=0.218+0.135*(Flow(i)/TH_l(i,6))^3;        
    v(i)=39.800/(1+(Flow(i)/TH_l(i,6))^b);         %表达式参考自文献中的基于经典BPR模型的改进S曲线模型
    
end

