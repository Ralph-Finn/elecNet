clear
clc
addpath(genpath('./YALMIP-master'))
global TH_n TH_l Charg_post EVs weigth PATH MILE ROAD Char_candidate DPS_n DPS_l Plan_Trans
while(1)%外层的循环
[TH_n,TH_l,Charg_post,EVs,weigth,PATH,MILE,ROAD,Char_candidate,DPS_n,DPS_l,Plan_Trans]= preMicro();%读入参数进行初始化
radio=15;  
MILE=MILE*radio;                                                     %地图里程缩放比例
TH_l(:,5)=TH_l(:,5)*radio;
message = 'init complete'
while(1)%内层的循环
tong=tcpip('localhost', 4004, 'NetworkRole', 'server');% 建立tcp连接,开启本地4004端口
fopen(tong);  % 打开tcp通道，若没有网页请求，该模块将会阻塞。
message = ['start connection at ',datestr(now,0)] 
try
    data = fread(tong,10);%读入buff中的信息,使用较小的buffer可能会带来更快的速度
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
    putIntoSql();%将上传的数据文件里面的数据保存到数据库中
    fprintf(tong,cmd);
    break;
end
if cmd == '0'
    fprintf(tong,cmd); %表示程序运行结束，返回给client端数据
end
cmd = '0';
%pause(1);
end
end