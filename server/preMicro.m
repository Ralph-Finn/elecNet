function [TH_n,TH,Charg_post,EVs,weigth,PATH,MILE,ROAD]= preMicro()
TH_n=xlsread('�������ͨ����.xls','��ͨ�ڵ�');              %���뽻ͨ����ڵ�
TH=xlsread('�������ͨ����.xls','��ͨ��·');              %���뽻ͨ�����·
Charg_post=xlsread('��ʼ���վ��Ϣ.xls');                   %�����ʼ���׮λ��
EVs=xlsread('EV��ʼ����.xls'); 
weigth=xlsread('���������Ŀ�ĵ������Ȩ��.xls','����Ŀ�ĵ�Ȩ��');     
PATH=xlsread('��·�ڵ����̾����·��.xls','���·��');  %�����EV���·��
ROAD=xlsread('��·�ڵ����̾����·��.xls','��·����·');  
MILE=xlsread('��·�ڵ����̾����·��.xls','���ڵ����');  
end