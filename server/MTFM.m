function [Dist,CP,flow,Fast_P,Slow_P] = MTFM ( CP_new )
%自定义微观交通配流模型定量计算充电服务网络优化指标
global TH_n TH_l PATH MILE ROAD weigth n1 m1 Xx Yy perm weekday ...
    deta_t N_max T_down T_record T f2 f4 K st en t Mile Mile_left                %定义全局变量
% ====================== 各项参数整定 ====================== 
IO=length(CP_new);
SC=zeros(N_max,1);
SLOW=zeros(N_max,1);                                   %慢充标记符
Home_time=zeros(N_max,2);                              %最后一次行程结束后的回家时刻，用于计算慢充负荷
FC=zeros(IO,1);
Post_mark=zeros(IO,1);
S_Char=zeros(N_max,1);
F_Char=zeros(IO,1);
T_max=round(length(T)/deta_t);
flow=zeros(m1,T_max);                                   %初始化按时分配流量矩阵，防止出现更新时刻未到达第一个节点的情况
v=39.80*ones(m1,T_max);                                 %初始化主干道路实时速度矩阵，假定设计时速为40km/h
ev_left=[];
Path_left=[];
WW=zeros(N_max,1);
R=zeros(N_max,1);
before=zeros(N_max,1);
then=zeros(N_max,1);
Charge_need=zeros(N_max,1);
Change_Mark=ones(N_max,1);
numda=0.25;                                            %充电需求与充电容量折算系数
et1(1,1)=20;         et1(1,2)=0;                       %私家车发车时间下限
et1(2,1)=24;         et1(2,2)=0;                       %出租车发车时间下限 
ratio=0.70;                                            %出租车直接重发比例下限
T_wait=0.25;                                           %出租车最长停车时间
t_wait=(T_wait*60)/deta_t;
Nn_car=0;
for i=1:N_max
    if K(i)==1
        Nn_car=Nn_car+1;
        n_car(Nn_car,1)=i;                             
        n_car(Nn_car,2)=2;                             %私家车平均跑2趟
    end
end
N_car=ones(Nn_car,1);
End_time=zeros(N_max,2);
Char_time=zeros(N_max,1);
CP=zeros(length(CP_new),T_max+1)./(CP_new(:,4)*ones(1,T_max+1));  %初始化车装比
Dist=zeros(N_max,1);
% ====================== 迭代配流并记录电量变化 ======================       
for i=1:T_max         
    ut(i,:)=T(deta_t*i,:);                             %记录路况更信息新时刻
    % --------------------- 记录各时段内的发车量 ---------------------   
    ev=[];
    I=0;
    
    for j=1:N_max
        if i<2
            if t(j,1)==ut(i,1) && t(j,2)<ut(i,2)
                I=I+1;
                ev(I,1)=j;
                ev(I,2:3)=t(j,:);
            end 
        else
            if ut(i,2)==0
                if t(j,1)+1==ut(i,1) && t(j,2)>=ut(i-1,2) 
                    I=I+1;
                    ev(I,1)=j;
                    ev(I,2:3)=t(j,:);
                end
            else if t(j,1)==ut(i,1) && t(j,2)>=ut(i-1,2) && t(j,2)<ut(i,2)
                     I=I+1;
                     ev(I,1)=j;
                     ev(I,2:3)=t(j,:);
                 end
            end
        end
    end
    % ---------------------- Dijkstra法计算最短用时路径 ----------------------
    Path=[];
    for j=1:I
        YU=sort([st(ev(j,1)),en(ev(j,1))]);
        IU=find(PATH(:,1)==YU(1));
        U=IU(find(PATH(IU,2)==YU(2)));
        R(ev(j,1))=PATH(U,end);
        Path(j,1:R(ev(j,1)))=PATH(U,3:2+R(ev(j,1)));                       %记录各路径节点
        
        %计算到达各节点所对应的时刻和里程
        for r=1:R(ev(j,1))-1
            q=ROAD(U,r);
            ev(j,3*r+1)=q;                                                       %标记路径上的各条道路             
            ev(j,3*r+2)=ev(j,3*r-1)+floor((ev(j,3*r)+(TH_l(q,5)/v(q,i))*60)/60); %更新小时      
            ev(j,3*(r+1))=round(mod((ev(j,3*r)+(TH_l(q,5)/v(q,i))*60),60));      %更新分钟      
        end 
        Home_time(ev(j,1),:)=ev(j,3*R(ev(j,1))-1:3*R(ev(j,1)));                  %更新反回时刻
        Mile(ev(j,1),1:R(ev(j,1)))=Mile(ev(j,1),1)+MILE(U,1:R(ev(j,1)));         %记录路径上各节点对应的已行驶里程
    end
    
    % ------------------- 新出发电动车并上仍在路上的和重发的电动车 ------------------- 
    [Ew1,Ev1]=size(Path_left);
    [Ew2,Ev2]=size(Path);
    
    if Ev1>Ev2
        ev=[ev_left;ev,zeros(Ew2,3*(Ev1-Ev2))];        
        Path=[Path_left;Path,zeros(Ew2,Ev1-Ev2)];
    end
    if Ev1<Ev2
        ev=[ev_left,zeros(Ew1,3*(Ev2-Ev1));ev]; 
        Path=[Path_left,zeros(Ew1,Ev2-Ev1);Path];
    end
    if Ev1==Ev2
        ev=[ev_left;ev];  
        Path=[Path_left;Path];
    end
    [I,~]=size(ev); 
    % ------------------------------ 充电需求位置确定 ------------------------------
    Rr=zeros(I,1);
    for j=1:I
        for r=1:R(ev(j,1))-1
            if Mile(ev(j,1),r)<Mile_left(ev(j,1)) && Mile(ev(j,1),r+1)>=Mile_left(ev(j,1)) && Change_Mark(ev(j,1))==1             
                WW(ev(j,1),1)=WW(ev(j,1),1)+1;
                Mile_deta(ev(j,1))=Mile_left(ev(j,1))-Mile(ev(j,1),r);
                before(ev(j,1),WW(ev(j,1),1))=find(TH_n(:,1)==Path(j,r));
                then(ev(j,1),WW(ev(j,1),1))=find(TH_n(:,1)==Path(j,r+1));
                
                deta=Mile_deta(ev(j,1))/TH_l(ev(j,3*r+1),5);
                Charge_need(ev(j,1),2*WW(ev(j,1),1)-1)=Xx(before(ev(j,1),WW(ev(j,1),1)))+(Xx(then(ev(j,1),WW(ev(j,1),1)))...
                        -Xx(before(ev(j,1),WW(ev(j,1),1))))*deta;        %记录需求地横坐标
                Charge_need(ev(j,1),2*WW(ev(j,1),1))=Yy(before(ev(j,1),WW(ev(j,1),1)))+(Yy(then(ev(j,1),WW(ev(j,1),1)))...
                        -Yy(before(ev(j,1),WW(ev(j,1),1))))*deta;        %记录需求地纵坐标
                Rr(j,1)=r;   
                % ^^^^^^^^^^^^^^^^^^^^^^^^ 充电桩对车流量反馈影响子函数 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                path=[];
                [ Selected,path,EV,mile,RR,arrive_time,leave_time,wait,slow,distance ] = Charge_effect1( before(ev(j,1),WW(ev(j,1),1)),CP(:,i),...
                    Path(j,:),Rr(j,1),R(ev(j,1)),Mile(ev(j,1),:),ev(j,:),K(ev(j,1)),v(:,i),CP_new);  
                R(ev(j,1))=RR;
                Path(j,1:R(ev(j,1)))=path(1:R(ev(j,1)));
                ev(j,2:end)=0;
                ev(j,1:3*R(ev(j,1)))=EV(1:3*R(ev(j,1)));
                Home_time(ev(j,1),:)=ev(j,3*R(ev(j,1))-1:3*R(ev(j,1)));                 
                Mile(ev(j,1),1:R(ev(j,1)))=mile(1:R(ev(j,1)));
                Dist(ev(j,1),WW(ev(j,1),1))=distance;                                     %记录因充电增加距离
                % ^^^^^^^^^^^^^^^^^^^^^^^^ 记录EV充电时间 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                SLOW(ev(j,1))=slow;
                if SLOW(ev(j,1))>0 && K(ev(j,1))==1
                    SC(ev(j,1),1)=SC(ev(j,1),1)+1;
                    S_Char(ev(j,1),4*SC(ev(j,1),1)-3:4*SC(ev(j,1)))=[arrive_time+wait,leave_time];     %记录慢速充电时间
                end
                if SLOW(ev(j,1))==0
                    FC(Selected,1)=FC(Selected,1)+1;
                    F_Char(Selected,5*FC(Selected,1)-4:5*FC(Selected))=[K(ev(j,1)),arrive_time+wait,leave_time];  %记录快速充电时间
                    CP(Selected,i+1)=CP(Selected,i+1)+1/CP_new(Selected,4);                       %修正车桩比指标
                end 
                Change_Mark(ev(j,1))=0;
                break; 
            end
        end
    end
    ev=[ev zeros(I,1)];                                %增加一个全0列，便于后续编程   
    % -------------------- 各道路实时交通流量计算 --------------------
    II=0;
    Location=[];
    
    if i<2
        for j=1:I
            for r=1:R(ev(j,1))
                if ev(j,3*r-1)==ut(i,1) && ev(j,3*r)<=ut(i,2) && ev(j,3*r+1)>0
                    flow(ev(j,3*r+1),i)=flow(ev(j,3*r+1),i)+1;
                end
                
                if ev(j,3*r+1)==0 && (ev(j,3*r-1)*60+ev(j,3*r))<=(ut(i,1)*60+ut(i,2)) && ev(j,3*r)+ev(j,3*r-1)>0
                    II=II+1;
                    Location(II)=j;                    %若在更新时刻前到达终点，则记录该电动汽车位置
                    break;
                end
            end
        end
    else  
        for j=1:I
            for r=1:R(ev(j,1))
                if ut(i,2)==0
                    if ev(j,3*r-1)+1==ut(i,1) && ev(j,3*r)>=ut(i-1,2) && ev(j,3*r+1)>0
                        flow(ev(j,3*r+1),i)=flow(ev(j,3*r+1),i)+1;
                    end
                else if ev(j,3*r-1)==ut(i,1) && ev(j,3*r)>=ut(i-1,2) && ev(j,3*r)<=ut(i,2) && ev(j,3*r+1)>0
                         flow(ev(j,3*r+1),i)=flow(ev(j,3*r+1),i)+1;
                    end
                end
                
                if ev(j,3*r+1)==0 && (ev(j,3*r-1)*60+ev(j,3*r))<=(ut(i,1)*60+ut(i,2)) && ev(j,3*r)+ev(j,3*r-1)>0
                    II=II+1;
                    Location(II)=j;
                    break;    
                end
            end
        end
    end
    
    % --------------------- 更新主干道路实时速度 ---------------------
    Flow=flow(:,i)/perm;                               %车流量折算
    v(:,i+1)=BPR( Flow );                              %调用流量-车速变换子函数     
    % ----------------- 根据不同类别重发已到站电动汽车 -----------------
    %已到站私家车选择和重发
    Location1=[];
    CC=0;
    if i<=((et1(1,1)-T_down)*60+et1(1,2))/deta_t
        for j=1:II
            if K(ev(Location(j),1))==1 
                C_car=find(n_car(:,1)==ev(Location(j),1));
                if N_car(C_car,1)<n_car(C_car,2)
                    CC=CC+1;
                    N_car(C_car,1)=N_car(C_car,1)+1;
                    Location1(CC)=ev(Location(j),1);
                end
            end
        end
        for j=1:CC
            TR=t(Location1(j),:);
            if weekday
                t(Location1(j),:)= Origin_Time( f2(deta_t*i:T_record*60),T(deta_t*i:T_record*60,:) );  %筛选私家车重发时间
            else
                if rand<=0.45
                    tt1=t(Location1(j),1)+t(Location1(j),2)/60;
                    tt2=min(tt1+normrnd(6,1.2,1,1),21);
                    t(Location1(j),:)=[floor(tt2),round(60*mod(tt2,1))];
                else
                    t(Location1(j),:)= Origin_Time( f2(deta_t*i:T_record*60),T(deta_t*i:T_record*60,:) );
                end
            end 
            if SLOW(Location1(j))==1                                 
                S_Char(Location1(j),4*SC(Location1(j),1)-1:4*SC(Location1(j),1))=[TR(1)+min(6,t(Location1(j),1)-TR(1)),t(Location1(j),2)]; %确定慢充结束时刻
                SLOW(Location1(j))=0;
            end
        end
        PP=st(Location1(j));
        st(Location1(j))=en(Location1(j));             %调换起止点
        en(Location1(j))=PP;       
        Mile(Location1(j),1)=Mile(Location1(j),R(Location1(j)));                     
        Mile(Location1(j),2:R(Location1(j)))=0;
        Change_Mark(Location1(j))=1;
    end
    %已到站出租车选择和重发
    Location2=[];
    TT=0;  
    if i<=((et1(2,1)-T_down)*60+et1(2,2))/deta_t-t_wait
        for j=1:II
            End_time(ev(Location(j),1),:)=ev(Location(j),3*R(ev(Location(j),1))-1:3*R(ev(Location(j),1))); %记录终止时刻 
            if K(ev(Location(j),1))==2
                TT=TT+1;
                Location2(TT)=ev(Location(j),1);
            end
        end
        for j=1:TT
            t(Location2(j),:)= Origin_Time( f4(deta_t*i:deta_t*(i+t_wait)),T(deta_t*i:deta_t*(i+t_wait),:) ); %筛选剩余出租车重发时间
            point=TH_n(:,1);
            ww=weigth(:,9);
            st(Location2(j))=en(Location2(j));       
            mm=find(point==st(Location2(j)));
            point(mm)=[];    
            if mod(i,2)==0
                en(Location2(j))=point(1+round(rand*(n1-2)),1);      %重新选择终点
            else
                ww(mm,:)=[];
                en(Location2(j))=Select(ww,point);
            end       
            Mile(Location2(j),1)=Mile(Location2(j),R(Location2(j)));                     
            Mile(Location2(j),2:R(Location2(j)))=0;
            Change_Mark(Location2(j))=1;
        end
    end 
    % --------- 剔除到站电动车，将途中电动车和重发出租车代入下轮迭代 ---------
    ev(Location,:)=[];                                 %剔除已到站电动车
    Path(Location,:)=[]; 
    ev_left=[];
    Path_left=[];    
    ev_left=ev(:,1:end-1);                             %记入途中电动车和重发出租车,消除最后全0列
    Path_left=Path;  
end
%% ==================== 输出变量整理 ====================
% ------------------  充电需求位置信息整理 ------------------ 
Cha=0;
for i=1:N_max
    if WW(i,1)>0 
        for j=1:WW(i,1)
            Cha=Cha+1;
            Charge_EV(Cha,1)=Charge_need(i,2*j-1);     %记录充电需求位置
            Charge_EV(Cha,2)=Charge_need(i,2*j);
        end
    end
end
% ------------------  私家车快速充电负荷整理 ------------------ 
Fast_PC=zeros(IO,T_max+10);
for i=1:IO
    for j=1:FC(i)
        if F_Char(i,5*j-4)==1
            DT1=F_Char(i,5*j-1)*60+F_Char(i,5*j);
            DT2=F_Char(i,5*j-3)*60+F_Char(i,5*j-2);
            DT=DT1-DT2;
            for k=1:ceil(DT/deta_t)
                Fast_PC(i,ceil(DT2/deta_t))=Fast_PC(i,ceil(DT2/deta_t))+(0.045/60)*min(deta_t,(DT1-DT2));
                DT2=DT2+deta_t;
            end
        end
    end
end
% ------------------  出租车快速充电负荷整理 ------------------ 
Fast_PT=zeros(IO,T_max+10);
for i=1:IO
    for j=1:FC(i)
        if F_Char(i,5*j-4)==2
            DT1=F_Char(i,5*j-1)*60+F_Char(i,5*j);
            DT2=F_Char(i,5*j-3)*60+F_Char(i,5*j-2);
            DT=DT1-DT2;
            for k=1:ceil(DT/deta_t)
                Fast_PT(i,ceil(DT2/deta_t))=Fast_PT(i,ceil(DT2/deta_t))+(0.045/60)*min(deta_t,(DT1-DT2));
                DT2=DT2+deta_t;
            end
        end
    end
end
Fast_P=Fast_PC+Fast_PT;                               %快速充电负荷
% ------------------  私家车慢速充电负荷整理 ------------------ 
Slow_PC=zeros(1,T_max+10*(60/deta_t));
SPC=S_Char(find(SC~=0),:);
for i=1:size(SPC,1)
    DT1=SPC(i,3)*60+SPC(i,4);
    DT2=SPC(i,1)*60+SPC(i,2);
    DT=DT1-DT2;
    for j=1:ceil(DT/deta_t)
        Slow_PC(1,ceil(DT2/deta_t))=Slow_PC(1,ceil(DT2/deta_t))+(0.007/60)*min(deta_t,(DT1-DT2));
        DT2=DT2+deta_t;
    end
end
for i=1:N_max
    if Home_time(i,1)>0 && K(i)==1 && Mile(i,R(i))/130>=0.55  %当SOC小于50%时进行慢充
        for j=1:5*(60/deta_t)                               %慢充5个小时
            Tt=floor(Home_time(i,1)*60/deta_t);
            Slow_PC(1,Tt+j)=Slow_PC(1,Tt+j)+(0.007/60)*deta_t;
        end
    end
end
% ------------------  出租车慢速充电负荷整理 ------------------ 
Slow_PT=zeros(1,T_max+10*(60/deta_t));
for i=1:N_max
    if Home_time(i,1)>0 && K(i)==2 && Mile(i,R(i))/140>=0.65           
        for j=1:5*(60/deta_t) 
            Tt=floor(Home_time(i,1)*60/deta_t);
            Slow_PT(1,Tt+j)=Slow_PT(1,Tt+j)+(0.007/60)*deta_t;
        end
    end
end
Slow_P=Slow_PC+Slow_PT;                               %快速充电负荷
end
