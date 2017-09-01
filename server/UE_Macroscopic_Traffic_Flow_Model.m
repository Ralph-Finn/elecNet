%%%%%%%%%%%%%%%%%%%% UE Macroscopic Traffic Flow Model %%%%%%%%%%%%%%%%%%%%
function UE_Macroscopic_Traffic_Flow_Model ( parm )
global TH_n TH_l Charg_post PATH ROAD  EVs 
%% ================ 导入广州天河区交通网络 ================
n=length(TH_n);                                            %节点数
m=length(TH_l);                                            %道路数
Xx=TH_n(:,2);
Yy=TH_n(:,3);
%% ================ EV各项参数计算和初始化 ================
% ---------------------- 页面输入变量 ----------------------
perm= parm(1);                                              %电动汽车渗透率设为40%
weekday= parm(2);                                         %是否是工作日
k_FCS= parm(3);                                             %充电站对车流量的吸引系数
% ---------------------- 各项参数整定 ----------------------
T_down=0;                                              %仿真时间下限
T_up=24;                                               %仿真时间上限
N_max=round(2153*(perm/0.4));                          %天河区电动汽车保有量
T_record=T_up-T_down;
K=EVs(:,2);   st=EVs(:,3);   en=EVs(:,4);
if weekday == 1
    t=EVs(:,5:6);                                      %工作日  
else
    t=EVs(:,10:11);                                    %节假日 
end
I=0;
for i=1:N_max
    if t(i,1)>=T_down && (t(i,1)*60+t(i,2))<=T_up*60
        I=I+1;
        ev_od(I,1:2)=[st(i),en(i)];                          %记录所有出发EV的OD对
    end
end
OD1=zeros(sum([1:n-1]),3);
for i=1:I
    for j=1:n-1
        for k=j+1:n
            if ev_od(i,1)==j && ev_od(i,2)==k
                OD1(sum([n-j+1:n-1])+(k-j),:)=[j,k,OD1(sum([n-j+1:n-1])+(k-j),3)+1];
            end
            if ev_od(i,1)==k && ev_od(i,2)==j
                OD1(sum([n-j+1:n-1])+(k-j),:)=[j,k,OD1(sum([n-j+1:n-1])+(k-j),3)+1];
            end
        end
    end
end
OD=OD1(find(OD1(:,3)~=0),:); 
OD(:,3)=round(OD(:,3)/perm);                        %各OD对某一时段内的总流量
n_OD=size(OD,1);                                    %OD对数
path=[];
seta=zeros(1,m);
for i=1:n_OD
    IU=find(PATH(:,1)==OD(i,1));
    U=IU(find(PATH(IU,2)==OD(i,2)));
    r(i)=length(U);
    for j=1:r(i)
        path(end+1,1:PATH(U(j),end))=PATH(U(j),3:2+PATH(U(j),end));
        e(i,sum(r(1:i-1))+j)=1;
        seta(end+1,ROAD(U(j),1:PATH(U(j),end)-1))=1;
    end
end
seta(1,:)=[];
a=zeros(1,m);
a_k=zeros(1,m);
n_CP=size(Charg_post,1);
for i=1:n_CP
    a(Charg_post(i,6))=a(Charg_post(i,6))+1;
    a_k(Charg_post(i,6))=a_k(Charg_post(i,6))+Charg_post(i,4);
end
MTFM=[14,20,32,11,8,49,263,270,82,26,41,92,32,94,74,58,178,32,77,3,35,88,110,163,451,47,...
    93,193,245,91,115,81,104,81,433,391,74,196,104,207,228,382,385,577,1176,0,505,1196,295,...
    468,1376,87,539,1300,1486,1722,274,1226,2584,50,16,1571,79,103,296,243,507,377,131,508,...
    226,72,1391,1545,95,191,148,185,501,440,1681,268,369,211,238,67,408,333,349,77,1330,1443,...
    656,254,359,30,10,163,140,26,186,208,407,189,346,133,39,1544,189,1386,744,216,169,209,2019,...
    1959,1724,36,212,238,3,66,78,16,59,30,162,280,250,830,742,1623,234,139,129,97,191,130,145,...
    182,82,21,954,1498,509,1005,15,62,33,41,2648,435,305,1563];        %微观交通配流模型渗透率40%时的24h总流量
%% ============== 基于用户均衡理论的宏观交通配流模型 ==============
x=intvar(1,m);                                      %各条道路流量
f=intvar(1,sum(r));                                 %某一OD对不同路径的流量
% ----------------------- 目标函数 -----------------------
UJ=TH_l(:,5)/39.8;
k_fcs=(k_FCS/15)*a_k.*TH_l(:,6)';                   %吸引流量与充电站容量有关
obj=x*UJ+(x+k_fcs).^5*(0.03*UJ./TH_l(:,6).^5);
% ----------------------- 约束条件 -----------------------
cst=[f*e'==OD(:,3)'];
cst=[cst,f>=0];
cst=[cst,x+k_fcs-f*seta==0];
cst=[cst,sum(a)==n_CP,x>=0];
% ----------------------- 求解器求解 -----------------------
optimize(cst,obj);
op_x=value(x+k_fcs);
csvwrite('./output/MTFM.csv',MTFM);
csvwrite('./output/op_x.csv',op_x);
