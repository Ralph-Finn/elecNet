function t = Origin_Time ( f,T )
%�Զ������ʱ��ɸѡ����
%����GA�㷨�����̶�����ɸѡ�綯��������ʱ��
F=f/sum(f);               %��һ��
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

