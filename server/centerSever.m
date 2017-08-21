clear
clc
global TH_n TH_l Charg_post PATH MILE  ROAD  EVs weigth 
[TH_n,TH_l,Charg_post,EVs,weigth,PATH,MILE,ROAD]= preMicro();%读入参数进行初始化
radio=15;  
MILE=MILE*radio;                                                     %地图里程缩放比例
TH_l(:,5)=TH_l(:,5)*radio;
message = 'init complete'

while(1)
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
    fprintf(tong,cmd); %表示程序运行结束，返回给client端数据
end
cmd = '0';
%pause(1);
end