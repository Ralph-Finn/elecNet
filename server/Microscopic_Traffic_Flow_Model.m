%%%%%%%%%%%%%%%%%%%% Microscopic Traffic Flow Model %%%%%%%%%%%%%%%%%%%%
function Microscopic_Traffic_Flow_Model ( parm )
global TH_n TH_l Charg_post PATH MILE  ROAD  EVs weigth Mile_dthre Mile_max  %����ȫ�ֱ���
%% ================ ��������������ͨ���� ================
n=length(TH_n);                                            %�ڵ���
m=length(TH_l);                                            %��·��
Xx=TH_n(:,2);
Yy=TH_n(:,3);

%% ============= �綯��������Ȩ�ؼ���ͳ�ʼ�� =============
% ---------------------- ҳ��������� ----------------------
perm=parm(1);                                                 %�綯������͸����Ϊ20%
weekday=parm(2);                                           %�Ƿ��ǹ�����
deta_t=parm(3);                                               %����ʱ��߶ȣ�60���Ӹ���һ��·����Ϣ
T_d=parm(4);                                                   %��¼ʱ������
T_u=parm(5);                                                   %��¼ʱ������
% ---------------------- ����������� ----------------------
N_max=round(2153*(perm/0.4));            %������綯����������
T_down=0;                                             %����ʱ������
T_up=24;                                                %����ʱ������
T_record=T_up-T_down;
S1=0.783;                                              %˽�ҳ�ռ��
S2=0.217;                                              %���⳵ռ��
Mile_max=[130;140];                                    %����綯���������ʻ���
Ele_thre1=0.30;                                        %��ֵ����1_30%
Ele_thre2=0.28;                                        %��ֵ����2_28%

% --------------------- ���������ʱ��Ȩ�� ---------------------
for i=1:1440
    T(i,1)=T_down+floor(i/60);                   %��¼Сʱ
    T(i,2)=mod(i,60);                                  %��¼���� 
    X(i)=T_down+floor(i/60)+mod(i,60)/60;
    f1(i)=Fitting( X(i),1 );                           %������˽�ҳ�����ʱ�亯��
    f2(i)=Fitting( X(i),2 );                           %������˽�ҳ�����ʱ�����
    f3(i)=Fitting( X(i),3 );                           %���⳵����ʱ�亯��
    f4(i)=Fitting( X(i),4 );                           %���⳵�ط�ʱ�����
end

% --------------------- ����EV��ʼ���� ---------------------
 
K=EVs(:,2);   st=EVs(:,3);   en=EVs(:,4);
Power=EVs(:,7);   Mile=EVs(:,8);   Mile_left=EVs(:,9);
for i=1:N_max
    point=TH_n(:,1);
    ww=weigth;
    if K(i)==1
        if weekday
            t(i,:)= Origin_Time ( f1(1+T_down*60:T_up*60),T(1+T_down*60:end,:) );                  %ɸѡ�綯������ʱ��
        else
            if rand<=0.45
                tt = normrnd(10,1.5,1,1);
                t(i,:)=[floor(tt),round(60*mod(tt,1))];
            else
                t(i,:)= Origin_Time ( f1(1+T_down*60:T_up*60),T(1+T_down*60:end,:) );
            end
        end    
    end
    
    if K(i)==2
        t(i,:)= Origin_Time ( f3(1+T_down*60:T_up*60),T(1+T_down*60:end,:) );              
    end
end
for i=1:length(Mile_max)
    Mile_thre(i)=-(Mile_max(i)/1.6)*log(Ele_thre1);    %��ֵ��������Ӧ�ľ�����ֵ
    Mile_dthre(i)=(-(Mile_max(i)/1.6)*log(Ele_thre2))-Mile_thre(i);    %�綯����ȱ����ʻ�뾶
end   

%% =============== �������ʱ�����͵���ͳ��΢��ģ�� ===============
% ====================== ����������� ====================== 
IO=length(Charg_post);
SC=zeros(N_max,1);
SLOW=zeros(N_max,1);                                   %�����Ƿ�
Home_time=zeros(N_max,2);                              %���һ���г̽�����Ļؼ�ʱ�̣����ڼ������为��
FC=zeros(IO,1);
Post_mark=zeros(IO,1);
S_Char=zeros(N_max,1);
F_Char=zeros(IO,1);
T_max=round(length(T)/deta_t);
flow=zeros(m,T_max);                                   %��ʼ����ʱ�����������󣬷�ֹ���ָ���ʱ��δ�����һ���ڵ�����
v=39.80*ones(m,T_max);                                 %��ʼ�����ɵ�·ʵʱ�ٶȾ��󣬼ٶ����ʱ��Ϊ40km/h
ev_left=[];
Path_left=[];
WW=zeros(N_max,1);
R=zeros(N_max,1);
before=zeros(N_max,1);
then=zeros(N_max,1);
Charge_need=zeros(N_max,1);
Change_Mark=ones(N_max,1);
numda=0.25;                                            %�������������������ϵ��
et1(1,1)=20;         et1(1,2)=0;                       %˽�ҳ�����ʱ������
et1(2,1)=24;         et1(2,2)=0;                       %���⳵����ʱ������ 
ratio=0.70;                                            %���⳵ֱ���ط���������
T_wait=0.25;                                           %���⳵�ͣ��ʱ��
t_wait=(T_wait*60)/deta_t;
Nn_car=0;
for i=1:N_max
    if K(i)==1
        Nn_car=Nn_car+1;
        n_car(Nn_car,1)=i;                             
        n_car(Nn_car,2)=2;                             %˽�ҳ�ƽ����2��
    end
end
N_car=ones(Nn_car,1);
End_time=zeros(N_max,2);
Char_time=zeros(N_max,1);
CP=zeros(length(Charg_post),T_max+1)./(Charg_post(:,4)*ones(1,T_max+1));  %��ʼ����װ��

% ====================== ������������¼�����仯 ======================       
for i=1:T_max         
    ut(i,:)=T(deta_t*i,:);                             %��¼·������Ϣ��ʱ��
    % --------------------- ��¼��ʱ���ڵķ����� ---------------------   
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
    
    % ---------------------- Dijkstra�����������ʱ·�� ----------------------
    Path=[];
    for j=1:I
        YU=sort([st(ev(j,1)),en(ev(j,1))]);
        IU=find(PATH(:,1)==YU(1));
        U=IU(find(PATH(IU,2)==YU(2)));
        R(ev(j,1))=PATH(U,end);
        Path(j,1:R(ev(j,1)))=PATH(U,3:2+R(ev(j,1)));                       %��¼��·���ڵ�
        
        %���㵽����ڵ�����Ӧ��ʱ�̺����
        for r=1:R(ev(j,1))-1
            q=ROAD(U,r);
            ev(j,3*r+1)=q;                                                       %���·���ϵĸ�����·             
            ev(j,3*r+2)=ev(j,3*r-1)+floor((ev(j,3*r)+(TH_l(q,5)/v(q,i))*60)/60); %����Сʱ      
            ev(j,3*(r+1))=round(mod((ev(j,3*r)+(TH_l(q,5)/v(q,i))*60),60));      %���·���      
        end 
        Home_time(ev(j,1),:)=ev(j,3*R(ev(j,1))-1:3*R(ev(j,1)));                  %���·���ʱ��
        Mile(ev(j,1),1:R(ev(j,1)))=Mile(ev(j,1),1)+MILE(U,1:R(ev(j,1)));         %��¼·���ϸ��ڵ��Ӧ������ʻ���
    end
    
    % ------------------- �³����綯����������·�ϵĺ��ط��ĵ綯�� ------------------- 
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

    % ------------------------------ �������λ��ȷ�� ------------------------------
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
                        -Xx(before(ev(j,1),WW(ev(j,1),1))))*deta;        %��¼����غ�����
                Charge_need(ev(j,1),2*WW(ev(j,1),1))=Yy(before(ev(j,1),WW(ev(j,1),1)))+(Yy(then(ev(j,1),WW(ev(j,1),1)))...
                        -Yy(before(ev(j,1),WW(ev(j,1),1))))*deta;        %��¼�����������
                Rr(j,1)=r;   
                
                % ^^^^^^^^^^^^^^^^^^^^^^^^ ���׮�Գ���������Ӱ���Ӻ��� ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                path=[];
                [ Selected,path,EV,mile,RR,arrive_time,leave_time,wait,slow ] = Charge_effect( before(ev(j,1),WW(ev(j,1),1)),CP(:,i),...
                    Path(j,:),Rr(j,1),R(ev(j,1)),Mile(ev(j,1),:),ev(j,:),K(ev(j,1)),v(:,i));  
                R(ev(j,1))=RR;
                Path(j,1:R(ev(j,1)))=path(1:R(ev(j,1)));
                ev(j,2:end)=0;
                ev(j,1:3*R(ev(j,1)))=EV(1:3*R(ev(j,1)));
                Home_time(ev(j,1),:)=ev(j,3*R(ev(j,1))-1:3*R(ev(j,1)));                 
                Mile(ev(j,1),1:R(ev(j,1)))=mile(1:R(ev(j,1)));

                % ^^^^^^^^^^^^^^^^^^^^^^^^ ��¼EV���ʱ�� ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                SLOW(ev(j,1))=slow;
                if SLOW(ev(j,1))>0 && K(ev(j,1))==1
                    SC(ev(j,1),1)=SC(ev(j,1),1)+1;
                    S_Char(ev(j,1),4*SC(ev(j,1),1)-3:4*SC(ev(j,1)))=[arrive_time+wait,leave_time];     %��¼���ٳ��ʱ��
                end
                if SLOW(ev(j,1))==0
                    FC(Selected,1)=FC(Selected,1)+1;
                    F_Char(Selected,5*FC(Selected,1)-4:5*FC(Selected))=[K(ev(j,1)),arrive_time+wait,leave_time];  %��¼���ٳ��ʱ��
                    CP(Selected,i+1)=CP(Selected,i+1)+1/Charg_post(Selected,4);                       %������׮��ָ��
                end 
                Change_Mark(ev(j,1))=0;
                break; 
            end
        end
    end
    ev=[ev zeros(I,1)];                                %����һ��ȫ0�У����ں������
    
    % -------------------- ����·ʵʱ��ͨ�������� --------------------
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
                    Location(II)=j;                    %���ڸ���ʱ��ǰ�����յ㣬���¼�õ綯����λ��
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
    
    % --------------------- �������ɵ�·ʵʱ�ٶ� ---------------------
    Flow=flow(:,i)/perm;                               %����������
    v(:,i+1)=BPR( Flow );                              %��������-���ٱ任�Ӻ��� 
    
    % ----------------- ���ݲ�ͬ����ط��ѵ�վ�綯���� -----------------
    %�ѵ�վ˽�ҳ�ѡ����ط�
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
                t(Location1(j),:)= Origin_Time( f2(deta_t*i:T_record*60),T(deta_t*i:T_record*60,:) );  %ɸѡ˽�ҳ��ط�ʱ��
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
                S_Char(Location1(j),4*SC(Location1(j),1)-1:4*SC(Location1(j),1))=[TR(1)+min(6,t(Location1(j),1)-TR(1)),t(Location1(j),2)]; %ȷ���������ʱ��
                SLOW(Location1(j))=0;
            end
        end
        PP=st(Location1(j));
        st(Location1(j))=en(Location1(j));             %������ֹ��
        en(Location1(j))=PP;       
        Mile(Location1(j),1)=Mile(Location1(j),R(Location1(j)));                     
        Mile(Location1(j),2:R(Location1(j)))=0;
        Change_Mark(Location1(j))=1;
    end

    %�ѵ�վ���⳵ѡ����ط�
    Location2=[];
    TT=0;  
    if i<=((et1(2,1)-T_down)*60+et1(2,2))/deta_t-t_wait
        for j=1:II
            End_time(ev(Location(j),1),:)=ev(Location(j),3*R(ev(Location(j),1))-1:3*R(ev(Location(j),1))); %��¼��ֹʱ�� 
            if K(ev(Location(j),1))==2
                TT=TT+1;
                Location2(TT)=ev(Location(j),1);
            end
        end
        for j=1:TT
            t(Location2(j),:)= Origin_Time( f4(deta_t*i:deta_t*(i+t_wait)),T(deta_t*i:deta_t*(i+t_wait),:) ); %ɸѡʣ����⳵�ط�ʱ��
            point=TH_n(:,1);
            ww=weigth(:,9);
            st(Location2(j))=en(Location2(j));       
            mm=find(point==st(Location2(j)));
            point(mm)=[];    
            if mod(i,2)==0
                en(Location2(j))=point(1+round(rand*(n-2)),1);      %����ѡ���յ�
            else
                ww(mm,:)=[];
                en(Location2(j))=Select(ww,point);
            end       
            Mile(Location2(j),1)=Mile(Location2(j),R(Location2(j)));                     
            Mile(Location2(j),2:R(Location2(j)))=0;
            Change_Mark(Location2(j))=1;
        end
    end
    
    % --------- �޳���վ�綯������;�е綯�����ط����⳵�������ֵ��� ---------
    ev(Location,:)=[];                                 %�޳��ѵ�վ�綯��
    Path(Location,:)=[]; 
    ev_left=[];
    Path_left=[];    
    ev_left=ev(:,1:end-1);                             %����;�е綯�����ط����⳵,�������ȫ0��
    Path_left=Path;
    
end

if weekday 
    csvwrite('./output/weekday_flow.csv',flow)
    csvwrite('./output/weekday_v.csv',v)
else
    csvwrite('./output/weekday_flow.csv',flow)
    csvwrite('./output/weekday_v.csv',v)
end

%% ==================== ����������� ====================
% ------------------  �������λ����Ϣ���� ------------------ 
Cha=0;
for i=1:N_max
    if WW(i,1)>0 
        for j=1:WW(i,1)
            Cha=Cha+1;
            Charge_EV(Cha,1)=Charge_need(i,2*j-1);     %��¼�������λ��
            Charge_EV(Cha,2)=Charge_need(i,2*j);
        end
    end
end
%csvwrite('./output/Charge_EV.csv',Charge_EV)
dlmwrite('./output/Charge_EV.csv',Charge_EV,'delimiter',',','precision',8) 
% ------------------  ˽�ҳ����ٳ�縺������ ------------------ 
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
ffast_PC=[Fast_PC(:,1:10)+Fast_PC(:,T_max+1:end),Fast_PC(:,11:T_max)];
fast_PC=ffast_PC(:,(T_d*60/deta_t)+1:T_u*60/deta_t);
csvwrite('./output/Fast_PC.csv',sum(fast_PC))
% ------------------  ���⳵���ٳ�縺������ ------------------ 
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
ffast_PT=[Fast_PT(:,1:10)+Fast_PT(:,T_max+1:end),Fast_PT(:,11:T_max)];
fast_PT=ffast_PT(:,(T_d*60/deta_t)+1:T_u*60/deta_t);
csvwrite('./output/Fast_PT.csv',sum(fast_PT))
csvwrite('./output/Fast_Station.csv',[FC,sum(fast_PC+fast_PT,2)])
% ------------------  ˽�ҳ����ٳ�縺������ ------------------ 
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
    if Home_time(i,1)>0 && K(i)==1 && Mile(i,R(i))/130>=0.55  %��SOCС��50%ʱ��������
        for j=1:5*(60/deta_t)                               %����5��Сʱ
            Tt=floor(Home_time(i,1)*60/deta_t);
            Slow_PC(1,Tt+j)=Slow_PC(1,Tt+j)+(0.007/60)*deta_t;
        end
    end
end
sslow_PC=[Slow_PC(:,1:10*(60/deta_t))+Slow_PC(:,T_max+1:end),Slow_PC(:,11:T_max)];
slow_PC=sslow_PC((T_d*60/deta_t)+1:T_u*60/deta_t);
csvwrite('./output/Slow_PC.csv',slow_PC)
% ------------------  ���⳵���ٳ�縺������ ------------------ 
Slow_PT=zeros(1,T_max+10*(60/deta_t));
for i=1:N_max
    if Home_time(i,1)>0 && K(i)==2 && Mile(i,R(i))/140>=0.65           
        for j=1:5*(60/deta_t) 
            Tt=floor(Home_time(i,1)*60/deta_t);
            Slow_PT(1,Tt+j)=Slow_PT(1,Tt+j)+(0.007/60)*deta_t;
        end
    end
end
sslow_PT=[Slow_PT(:,1:10*(60/deta_t))+Slow_PT(:,T_max+1:end),Slow_PT(:,11:T_max)];
slow_PT=sslow_PT((T_d*60/deta_t)+1:T_u*60/deta_t);
csvwrite('./output/Slow_PT.csv',slow_PT) 
