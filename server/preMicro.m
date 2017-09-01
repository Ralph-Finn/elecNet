function [TH_n,TH_l,Charg_post,EVs,weigth,PATH,MILE,ROAD,Char_candidate,DPS_n,DPS_l,Plan_Trans]= preMicro()
TH_n=xlsread('data.xls','交通节点');              %输入交通网络节点
TH_l=xlsread('data.xls','交通道路');              %输入交通网络道路
Charg_post=xlsread('初始充电站信息.xls');                   %输入初始充电桩位置
EVs=xlsread('EV初始数据.xls'); 
weigth=xlsread('天河区各类目的地坐标和权重.xls','各类目的地权重');     
PATH=xlsread('道路节点间最短距离和路径.xls','最短路径');  %输入各EV最短路径
ROAD=xlsread('道路节点间最短距离和路径.xls','各路径道路');  
MILE=xlsread('道路节点间最短距离和路径.xls','各节点里程');  
Char_candidate=xlsread('充电站候选点位置.xls');
DPS_n=xlsread('data.xls','配电节点');                %输入交通网络节点
DPS_l=xlsread('data.xls','配电线路');                %输入交通网络道路
Plan_Trans=xlsread('配电系统多年期规划方案.xls');           %输入配电系统多年期规划方案
end