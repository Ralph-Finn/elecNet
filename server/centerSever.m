clear
clc
addpath(genpath('./YALMIP-master'))
global TH_n TH_l Charg_post EVs weigth PATH MILE ROAD Char_candidate DPS_n DPS_l Plan_Trans
while(1)%����ѭ��
[TH_n,TH_l,Charg_post,EVs,weigth,PATH,MILE,ROAD,Char_candidate,DPS_n,DPS_l,Plan_Trans]= preMicro();%����������г�ʼ��
radio=15;  
MILE=MILE*radio;                                                     %��ͼ������ű���
TH_l(:,5)=TH_l(:,5)*radio;
message = 'init complete'
while(1)%�ڲ��ѭ��
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
    parm = csvread('./inputData.csv');
   % try
        %parm = [0.28,1,15,3,20];
        Microscopic_Traffic_Flow_Model( parm ); 
        message =  ['Success at' ,datestr(now,0)] 
        fprintf(tong,cmd);
%     catch
%         message = ['Failed at',datestr(now,0)]
%         cmd = '0';
%         fprintf(tong,cmd);
%     end
end
if cmd == '2'
     parm = csvread('./inputDatax.csv');
   % try
        %parm = [0.40,1];
        Coordinated_Planning_of_CSN_and_PS ( parm ); 
        message =  ['Success at' ,datestr(now,0)] 
        fprintf(tong,cmd);
%     catch
%         message = ['Failed at',datestr(now,0)]
%         cmd = '0';
%         fprintf(tong,cmd);
%     end
end
if cmd == '3'
     parm = csvread('./inputDatay.csv');
   % try
        %parm = [0.40,1,0.50];
        UE_Macroscopic_Traffic_Flow_Model ( parm ); 
        message =  ['Success at' ,datestr(now,0)] 
        fprintf(tong,cmd);
%     catch
%         message = ['Failed at',datestr(now,0)]
%         cmd = '0';
%         fprintf(tong,cmd);
%     end
end
if cmd == 'x'
    
    message = ['reload files at',datestr(now,0)]
    putIntoSql();%���ϴ��������ļ���������ݱ��浽���ݿ���
    fprintf(tong,cmd);
    break;
end
if cmd == '0'
    fprintf(tong,cmd); %��ʾ�������н��������ظ�client������
end
cmd = '0';
%pause(1);
end
end