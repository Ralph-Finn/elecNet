function soc = SOC ( f,XX )
%�Զ���SOCɸѡ����
%����GA�㷨�����̶�����
F=f/sum(f);               %��һ��
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


