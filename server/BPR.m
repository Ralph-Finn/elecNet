function v = BPR( Flow )
%�Զ�������-���ٱ任�Ӻ���
global TH_l
for i=1:length(Flow)
    b=0.218+0.135*(Flow(i)/TH_l(i,6))^3;        
    v(i)=39.800/(1+(Flow(i)/TH_l(i,6))^b);         %���ʽ�ο��������еĻ��ھ���BPRģ�͵ĸĽ�S����ģ��
    
end

