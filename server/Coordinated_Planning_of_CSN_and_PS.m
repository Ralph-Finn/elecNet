%%%%%%%%%%%%%%%%%%% Coordinated Planning of CSN and PS %%%%%%%%%%%%%%%%%%%
function Coordinated_Planning_of_CSN_and_PS ( parm )
global TH_n TH_l Mile_dthre Mile_max n1 m1 Xx Yy perm weekday deta_t N_max ...
    T_down T_up T_record Ele_thre1 Ele_thre2 T f2 f4 K st en t add_t Power Mile Mile_left ...
    D1 D Char_candidate np DPS_n DPS_l n2 m2 Plan_Trans nk VB SR_min SR_max SC_min...
    SC_max tao radio1 radio2 mu_D  EVs            %定义全局变量
%% ================ 导入广州天河区交通网络 ================
n1=size(TH_n,1);                                             %交通节点数
m1=size(TH_l,1);                                             %道路数
Xx=TH_n(:,2);
Yy=TH_n(:,3);
np=max(Char_candidate(:,7));                                 %规划年限
radio1=0.04;                                                 %EV渗透率增长率
%% ================ 导入广州天河区配电系统 ================
n2=size(DPS_n,1);                                            %配电节点数
m2=size(DPS_l,1);                                            %线路数
nk=max(Plan_Trans(:,10));                                    %配电系统分区数      
VB=12.5;                                                     %标准电压
SR_min=5;                                                    %新建变电站容量下限/MW
SR_max=40;                                                   %新建变电站容量上限/MW
SC_min=0;                                                    %扩容变电站容量下限/MW
SC_max=40;                                                   %扩容变电站容量上限/MW
tao=2.34;                                                    %单位容量扩容成本/万元   
radio2=0.10;                                                 %负荷增长率 
mu_D=[0.6684,0.6711,0.6984,0.7751,0.8801,0.9400,0.9727,0.9586,1,0.9718,0.9612,0.9427,...
0.9118,0.82623,0.8219,0.8677,0.8915,0.8977,0.8845,0.80862,0.7778,0.7399,0.7116,0.6878]'; %日负荷变化率
tic;                                                       %开始计时 
%% ============= 电动汽车各项权重计算和初始化 =============
% ---------------------- 页面输入变量 ----------------------
perm=parm(1);                                              %电动汽车渗透率设为40%
weekday=parm(2);                                         %是否是工作日
% ---------------------- 各项参数整定 ----------------------
deta_t=60;                                             %设置时间尺度，60分钟更新一次路况信息
N_max=round(2153*(perm/0.4));                          %天河区电动汽车保有量;                           
T_down=0;                                              %记录时间下限
T_up=24;                                               %记录时间上限
T_record=T_up-T_down;
Mile_max=[130;140];                                    %各类电动汽车最大行驶里程
Ele_thre1=0.30;                                        %阈值电量1_30%
Ele_thre2=0.28;                                        %阈值电量2_28%
% --------------------- 计算各发车时刻权重 ---------------------
for i=1:T_record*60
    T(i,1)=T_down+floor(i/60);                         %记录小时
    T(i,2)=mod(i,60);                                  %记录分钟 
    X(i)=T_down+floor(i/60)+mod(i,60)/60;
    f2(i)=Fitting( X(i),2 );                           %工作日私家车返回时间拟合
    f4(i)=Fitting( X(i),4 );                           %出租车重发时间拟合
end
% --------------------- 导入EV初始数据 ---------------------   
K=EVs(:,2);   st=EVs(:,3);   en=EVs(:,4);
Power=EVs(:,7);   Mile=EVs(:,8);   Mile_left=EVs(:,9);
if weekday == 1
    t=EVs(:,5:6);                                      %工作日  
else
    t=EVs(:,10:11);                                    %节假日 
end
for i=1:length(Mile_max)
    Mile_thre(i)=-(Mile_max(i)/1.6)*log(Ele_thre1);    %阈值电量所对应的距离阈值
    Mile_dthre(i)=(-(Mile_max(i)/1.6)*log(Ele_thre2))-Mile_thre(i);    %电动汽车缺电行驶半径
end   
%% ================ MI-GA算法优化主体部分 ================
% --------------------- 定义各参数 ---------------------
N=60;                                                  %种群规模
Gen_max=5;                                             %最大迭代的代数
Pc=0.618;                                              %交叉概率
Pm=0.05;                                               %变异概率
D1=size(Char_candidate,1);                             %新建充电站数 
D=2*D1;                                                %解的维度数
Gen_lenth=D1+5*D1;                                     %染色体长度，充电站建桩数需要5位二进制表示
xmin=3;                                                %建桩数(容量)取值范围
xmax=20; 
% --------------------- 初始化种群 ---------------------
CP10=round(rand(N,D1)); 
Charg_post10=[CP10 , CP10.*(xmin+round(rand(N,D1)*(xmax-xmin)))]; 
% tic;
for i=1:N
    [fitness(i),op_x,num] = Fitness ( Charg_post10(i,:) ); %求解各个体的适应度
    OP_x(1:np,1:max(sum(num,2)),i)=op_x;
end
% toc;
[MIN,J]=min(fitness);                                      %记录第一代最小适应度
Best_fit(1)=MIN;                                           %第一代最小适应度即为第一代的最优适应度
Beat_CP1=Charg_post10(J,D1+1:D);                           %初始化多年期历史最优充电服务网络规划结果
Beat_CP2=OP_x(:,:,J);                                      %初始化多年期历史最优配电系统规划结果
% --------------------- 遗传迭代操作 ---------------------
for g=2:Gen_max
    %step_1 选择操作 
    Charg_post10=Select_min( fitness,Charg_post10,N );     %利用自定义的Select_min函数，确定遗传到下一代的个体
    Charg_post2=[Charg_post10(:,1:D1),Code_10to2( Charg_post10(:,D1+1:D),N,Gen_lenth-D1,D1 )];
    %step_2 交叉遗传操作 
    %----------------- 此处采用混合交叉方式 -----------------
    for i=0:N/2-1
         if rand<Pc                                    
             P=rand;
             if P<0.25
                 Charg_post2 = Cross_double( Charg_post2,i,N,Gen_lenth );  %采用截段正序/倒序交叉算法
             else if P<0.75
                     Charg_post2 = Cross_single( Charg_post2,i,N,Gen_lenth );  %采用单点均匀交叉算法
                 else
                     for k=1:3                                             %选择3个点进行交叉
                         Charg_post2 = Cross_single( Charg_post2,i,N,Gen_lenth );  %采用多点均匀交叉算法
                     end
                 end
             end
         end
    end
    %step_3 染色体变异操作 
    %----------------- 此处采用混合变异方式 -----------------
    for i=1:N
        if rand<Pm     
            P=rand;
            if P<0.2
                Charg_post2 = Var_Reverse( Charg_post2,i,Gen_lenth );  %采用染色体倒序变异算法
            else if P<0.35
                     Charg_post2 = Var_Defect( Charg_post2,i,Gen_lenth );  %采用染色体缺失变异算法
                 else if P<0.65
                          Charg_post2 = Var_Single( Charg_post2,i,Gen_lenth );  %采用染色体单点按位取反算法
                      else if P<0.85
                               Charg_post2 = Var_Multi( Charg_post2,i,Gen_lenth );  %采用染色体单点按位取反算法
                           else
                               for k=1:3                     %选择3个点进行按位取反变异
                                   Charg_post2 = Var_Single( Charg_post2,i,Gen_lenth );  %采用染色体多点按位取反算法
                               end
                          end
                     end
                end
            end
        end
    end
    %step_4 染色体解码并重新评估适应度 
    Charg_post10=[Charg_post2(:,1:D1),deCode_2to10( Charg_post2(:,D1+1:end),N,Gen_lenth-D1,D1 )];
    Charg_post10(:,D1+1:D)=min(Charg_post10(:,D1+1:D),Charg_post10(:,1:D1).*(xmax*ones(N,D1)));     %限制充电桩数量边界       
    Charg_post10(:,D1+1:D)=max(Charg_post10(:,D1+1:D),Charg_post10(:,1:D1).*(xmin*ones(N,D1)));
    for i=1:N
        [fitness(i),op_x,num] = Fitness ( Charg_post10(i,:) ); %求解各个体的适应度
        OP_x(1:np,1:max(sum(num,2)),i)=op_x;
    end
    [MIN,J]=min(fitness);                                   %记录下一代最优适应度
    [~,Kk]=max(fitness);                                    %记录下一代最差适应度
    %--------------------- 精英策略 ---------------------
    if MIN<Best_fit(g-1)
        Best_fit(g)=MIN;
        Beat_CP1=Charg_post10(J,D1+1:D);                         
        Beat_CP2=OP_x(:,:,J);                                                                        
    else
        Best_fit(g)=Best_fit(g-1);
        Charg_post10(Kk,:)=[ceil(Beat_CP1/xmax),Beat_CP1];  %将历史最优个体直接导入下一代
        OP_x(:,:,Kk)=Beat_CP2;                              %以保证每代里都有历史最优个体                                      
    end
end
toc;                                                       %停止计时 
%--------------------- 输出规划结果 ---------------------
CP1=Beat_CP1';
X_c=find(Beat_CP1~=0);
CP1=[CP1,Char_candidate(:,[1:2,7:8])];
X_l=[];
CP2=[];
for i=1:np
    X_l=[X_l,Beat_CP2(i,1:num(i,1))];                      %获选新增线路方案标记
    CP2=[CP2,Beat_CP2(i,num(i,1)+1:num(i,1)+num(i,2))];    %获选新建变电站方案
end
F_l=find(X_l==1);
P_n=[[zeros(n2,1),DPS_n(:,[1,2:3,11,5])];[Plan_Trans(F_l,[1:2,19:20,10]),CP2']];
for i=1:np
    P_n(1:num(i,3),end+1)=Beat_CP2(i,num(i,1)+num(i,2)+1:sum(num(i,:)));
end
A_l=Plan_Trans(F_l,1:10);
P_l=[[[zeros(m2,1),DPS_l(:,1:3)];[A_l(:,1),(A_l(:,2)-n2)+m2,A_l(:,[3,2])]],[DPS_l(:,11);Plan_Trans(F_l,10)]];
warning off
xlswrite('result',CP1,'充电设施')
xlswrite('result',P_n,'配电节点')
xlswrite('result',P_l,'配电线路')
xlswrite('result',A_l,'新增线路方案')
csvwrite('./output/addEqu.csv',CP1)
csvwrite('./output/addNode.csv',P_n)
csvwrite('./output/addLine.csv',P_l)
csvwrite('./output/addInfo.csv',A_l)





