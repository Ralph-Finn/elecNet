function [TH_n,TH_l,Charg_post,EVs,weigth,PATH,MILE,ROAD,Char_candidate,DPS_n,DPS_l,Plan_Trans]= preMicro()
TH_n=xlsread('data.xls','��ͨ�ڵ�');              %���뽻ͨ����ڵ�
TH_l=xlsread('data.xls','��ͨ��·');              %���뽻ͨ�����·
Charg_post=xlsread('��ʼ���վ��Ϣ.xls');                   %�����ʼ���׮λ��
EVs=xlsread('EV��ʼ����.xls'); 
weigth=xlsread('���������Ŀ�ĵ������Ȩ��.xls','����Ŀ�ĵ�Ȩ��');     
PATH=xlsread('��·�ڵ����̾����·��.xls','���·��');  %�����EV���·��
ROAD=xlsread('��·�ڵ����̾����·��.xls','��·����·');  
MILE=xlsread('��·�ڵ����̾����·��.xls','���ڵ����');  
Char_candidate=xlsread('���վ��ѡ��λ��.xls');
DPS_n=xlsread('data.xls','���ڵ�');                %���뽻ͨ����ڵ�
DPS_l=xlsread('data.xls','�����·');                %���뽻ͨ�����·
Plan_Trans=xlsread('���ϵͳ�����ڹ滮����.xls');           %�������ϵͳ�����ڹ滮����
end