clear
clc
global TH_n TH_l Charg_post PATH MILE  ROAD  EVs weigth 
[TH_n,TH_l,Charg_post,EVs,weigth,PATH,MILE,ROAD]= preMicro();%����������г�ʼ��
radio=15;  
MILE=MILE*radio;                                                     %��ͼ������ű���
TH_l(:,5)=TH_l(:,5)*radio;
message = 'init complete'

while(1)
tong=tcpip('localhost', 4004, 'NetworkRole', 'server');% ����tcp����,��������4004�˿�
fopen(tong);  % ��tcpͨ������û����ҳ���󣬸�ģ�齫��������
message = ['start connection at ',datestr(now,0)] 
try
    data = fread(tong,10);%����buff�е���Ϣ,ʹ�ý�С��buffer���ܻ����������ٶ�
    cmd = data(1);
catch
    cmd = '0';
end
command = cmd -48
%data =fread(t,50);
if cmd == '1'
    parm = [0.2,1,60];
    try
    %parm = csvread('inputData.csv');
        Microscopic_Traffic_Flow_Model( parm ); 
        message =  ['Success at' ,datestr(now,0)] 
        fprintf(tong,cmd);
    catch
        message = ['Failed at',datestr(now,0)]
        cmd = '0';
        fprintf(tong,cmd);
    end
end
if cmd == '0'
    fprintf(tong,cmd); %��ʾ�������н��������ظ�client������
end
cmd = '0';
%pause(1);
end