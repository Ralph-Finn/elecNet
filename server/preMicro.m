function [TH_n,TH,Charg_post,EVs,weigth,PATH,MILE,ROAD]= preMicro()
TH_n=xlsread('天河区交通网络.xls','交通节点');              %输入交通网络节点
TH=xlsread('天河区交通网络.xls','交通道路');              %输入交通网络道路
Charg_post=xlsread('初始充电站信息.xls');                   %输入初始充电桩位置
EVs=xlsread('EV初始数据.xls'); 
weigth=xlsread('天河区各类目的地坐标和权重.xls','各类目的地权重');     
PATH=xlsread('道路节点间最短距离和路径.xls','最短路径');  %输入各EV最短路径
ROAD=xlsread('道路节点间最短距离和路径.xls','各路径道路');  
MILE=xlsread('道路节点间最短距离和路径.xls','各节点里程');  
end