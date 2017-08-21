function [ Selected,Path,EV,mile,R,arrive_time,leave_time,Wait,SLOW ] = Charge_effect( Before,CP,Path,Rr,R,mile,EV,K,v )
%自定义充电桩对车流量影响的子函数，以体现反馈机制
% Before=before(ev(j,1));
% CP=CP(:,i);
% Path=Path(j,:);
% Rr=Rr(j,1);
% R=R(ev(j,1));
% mile=Mile(ev(j,1),:);
% EV=ev(j,:);
% K=K(ev(j,1));
% v=v(:,i);

global TH_l Charg_post PATH MILE Mile_dthre ROAD Mile_max 
Dmile=0;
for j=Rr:R-1
    Dmile=Dmile+TH_l(EV(3*j+1),5);
end

if Dmile<=Mile_dthre(K)       %在电量允许范围内能够到达目的地则不修改路径
    Selected=0;
    arrive_time=EV(3*R-1:3*R);
    leave_time=[0,0];
    Wait=[0,0];
    Path=Path;
    EV=EV;
    mile=mile;
    R=R;
    SLOW=1;                  %标记是否进行慢速充电
else
    [n,~]=size(Charg_post);
    m=length(TH_l);
    path1=[];
    mile1=[];
    road1=[];
    for i=1:n
        YU=sort([Before,Charg_post(i,3)]);
        IU=find(PATH(:,1)==YU(1));
        U=IU(find(PATH(IU,2)==YU(2)));
        
        if isempty(U)
            Distance(i)=0;
            path1(i,1)=0;
            mile1(i,1:end)=0;
            road1(i,1:end)=0;
        else
            Distance(i)=MILE(U,PATH(U,end));
            path1(i,1:1+PATH(U,end))=[PATH(U,end),PATH(U,3:2+PATH(U,end))];
            mile1(i,1:PATH(U,end))=MILE(U,1:PATH(U,end));
            road1(i,1:PATH(U,end)-1)=ROAD(U,1:PATH(U,end)-1);
        end
    end
    Fit=0.5*Distance'+0.5*CP;
    Selected=find(Fit==min(Fit));
    
    YU=sort([Path(R),Charg_post(Selected,3)]);
    IU=find(PATH(:,1)==YU(1));
    U=IU(find(PATH(IU,2)==YU(2))); 
    if isempty(U)
        path2=[];
        mile2=[];
        road2=[];
    else
        path2=PATH(U,3:2+PATH(U,end));
        mile2=MILE(U,1:PATH(U,end));
        road2=ROAD(U,1:PATH(U,end)-1);
    end
    
    R1=Rr+path1(Selected,1);
    Path(Rr+1:R1)=path1(Selected,2:1+path1(Selected,1));                  %修改后路径
    mile(Rr:R1-1)=mile(Rr)+mile1(Selected,1:path1(Selected,1));           %修改后行驶里程
    road=road1(Selected,1:path1(Selected,1)-1);
    
    EV(3*Rr+4:end)=0;
    for r=Rr+1:R1-1
        q=road(r-Rr);
        EV(3*r+1)=q;                                                     %标记路径上的各条道路             
        EV(3*r+2)=EV(3*r-1)+floor((EV(3*r)+(TH_l(q,5)/v(q))*60)/60);     %更新小时      
        EV(3*(r+1))=round(mod((EV(3*r)+(TH_l(q,5)/v(q))*60),60));        %更新分钟     
    end
    arrive_time=EV(3*R1-1:3*R1);                                           %记录到站时间
    CT=round(normrnd(30,4.5,1,1));    Charge_time=[floor(CT/60),mod(CT,60)];  %生成随机充电时间 
    Wait=[floor(round(5*CP(Selected))/60),mod(round(5*CP(Selected)),60)];  %根据车桩比计算等待时间
    
    PC=0.045*(Charge_time(1)+Charge_time(2)/60)/0.055;                   %充电电量，充电功率40kW/h,电池容量55kW*h
    mile(R1)=mile(R1)+(Mile_max(K)/1.6)*log(PC);                         %更新充电后行驶里程
    T=arrive_time+Charge_time+Wait;
    leave_time=[T(1)+floor(T(2)/60),mod(T(2),60)];                       %计算离站时间
    
    R=R1+length(path2)-1;
    Path(R1:R)=path2;                                                    %修改后路径
    mile(R1:R)=mile(R1)+mile2;                                           %修改后行驶里程
    road=road2;
    
    TT=Charge_time+Wait;
    delay_time=[TT(1)+floor(TT(2)/60),mod(TT(2),60)];                       %计算离站时间 
    
    EV(3*R1-1:3*R1)=leave_time;
    for r=R1:R-1
        q=road(r-R1+1);
        EV(3*r+1)=q;                                                     %标记路径上的各条道路             
        EV(3*r+2)=EV(3*r-1)+floor((EV(3*r)+(TH_l(q,5)/v(q))*60)/60);     %更新小时      
        EV(3*(r+1))=round(mod((EV(3*r)+(TH_l(q,5)/v(q))*60),60));        %更新分钟     
    end
    SLOW=0;
    
end
