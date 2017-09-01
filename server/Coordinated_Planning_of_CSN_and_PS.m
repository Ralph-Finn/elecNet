%%%%%%%%%%%%%%%%%%% Coordinated Planning of CSN and PS %%%%%%%%%%%%%%%%%%%
function Coordinated_Planning_of_CSN_and_PS ( parm )
global TH_n TH_l Mile_dthre Mile_max n1 m1 Xx Yy perm weekday deta_t N_max ...
    T_down T_up T_record Ele_thre1 Ele_thre2 T f2 f4 K st en t add_t Power Mile Mile_left ...
    D1 D Char_candidate np DPS_n DPS_l n2 m2 Plan_Trans nk VB SR_min SR_max SC_min...
    SC_max tao radio1 radio2 mu_D  EVs            %����ȫ�ֱ���
%% ================ ��������������ͨ���� ================
n1=size(TH_n,1);                                             %��ͨ�ڵ���
m1=size(TH_l,1);                                             %��·��
Xx=TH_n(:,2);
Yy=TH_n(:,3);
np=max(Char_candidate(:,7));                                 %�滮����
radio1=0.04;                                                 %EV��͸��������
%% ================ ���������������ϵͳ ================
n2=size(DPS_n,1);                                            %���ڵ���
m2=size(DPS_l,1);                                            %��·��
nk=max(Plan_Trans(:,10));                                    %���ϵͳ������      
VB=12.5;                                                     %��׼��ѹ
SR_min=5;                                                    %�½����վ��������/MW
SR_max=40;                                                   %�½����վ��������/MW
SC_min=0;                                                    %���ݱ��վ��������/MW
SC_max=40;                                                   %���ݱ��վ��������/MW
tao=2.34;                                                    %��λ�������ݳɱ�/��Ԫ   
radio2=0.10;                                                 %���������� 
mu_D=[0.6684,0.6711,0.6984,0.7751,0.8801,0.9400,0.9727,0.9586,1,0.9718,0.9612,0.9427,...
0.9118,0.82623,0.8219,0.8677,0.8915,0.8977,0.8845,0.80862,0.7778,0.7399,0.7116,0.6878]'; %�ո��ɱ仯��
tic;                                                       %��ʼ��ʱ 
%% ============= �綯��������Ȩ�ؼ���ͳ�ʼ�� =============
% ---------------------- ҳ��������� ----------------------
perm=parm(1);                                              %�綯������͸����Ϊ40%
weekday=parm(2);                                         %�Ƿ��ǹ�����
% ---------------------- ����������� ----------------------
deta_t=60;                                             %����ʱ��߶ȣ�60���Ӹ���һ��·����Ϣ
N_max=round(2153*(perm/0.4));                          %������綯����������;                           
T_down=0;                                              %��¼ʱ������
T_up=24;                                               %��¼ʱ������
T_record=T_up-T_down;
Mile_max=[130;140];                                    %����綯���������ʻ���
Ele_thre1=0.30;                                        %��ֵ����1_30%
Ele_thre2=0.28;                                        %��ֵ����2_28%
% --------------------- ���������ʱ��Ȩ�� ---------------------
for i=1:T_record*60
    T(i,1)=T_down+floor(i/60);                         %��¼Сʱ
    T(i,2)=mod(i,60);                                  %��¼���� 
    X(i)=T_down+floor(i/60)+mod(i,60)/60;
    f2(i)=Fitting( X(i),2 );                           %������˽�ҳ�����ʱ�����
    f4(i)=Fitting( X(i),4 );                           %���⳵�ط�ʱ�����
end
% --------------------- ����EV��ʼ���� ---------------------   
K=EVs(:,2);   st=EVs(:,3);   en=EVs(:,4);
Power=EVs(:,7);   Mile=EVs(:,8);   Mile_left=EVs(:,9);
if weekday == 1
    t=EVs(:,5:6);                                      %������  
else
    t=EVs(:,10:11);                                    %�ڼ��� 
end
for i=1:length(Mile_max)
    Mile_thre(i)=-(Mile_max(i)/1.6)*log(Ele_thre1);    %��ֵ��������Ӧ�ľ�����ֵ
    Mile_dthre(i)=(-(Mile_max(i)/1.6)*log(Ele_thre2))-Mile_thre(i);    %�綯����ȱ����ʻ�뾶
end   
%% ================ MI-GA�㷨�Ż����岿�� ================
% --------------------- ��������� ---------------------
N=60;                                                  %��Ⱥ��ģ
Gen_max=5;                                             %�������Ĵ���
Pc=0.618;                                              %�������
Pm=0.05;                                               %�������
D1=size(Char_candidate,1);                             %�½����վ�� 
D=2*D1;                                                %���ά����
Gen_lenth=D1+5*D1;                                     %Ⱦɫ�峤�ȣ����վ��׮����Ҫ5λ�����Ʊ�ʾ
xmin=3;                                                %��׮��(����)ȡֵ��Χ
xmax=20; 
% --------------------- ��ʼ����Ⱥ ---------------------
CP10=round(rand(N,D1)); 
Charg_post10=[CP10 , CP10.*(xmin+round(rand(N,D1)*(xmax-xmin)))]; 
% tic;
for i=1:N
    [fitness(i),op_x,num] = Fitness ( Charg_post10(i,:) ); %�����������Ӧ��
    OP_x(1:np,1:max(sum(num,2)),i)=op_x;
end
% toc;
[MIN,J]=min(fitness);                                      %��¼��һ����С��Ӧ��
Best_fit(1)=MIN;                                           %��һ����С��Ӧ�ȼ�Ϊ��һ����������Ӧ��
Beat_CP1=Charg_post10(J,D1+1:D);                           %��ʼ����������ʷ���ų���������滮���
Beat_CP2=OP_x(:,:,J);                                      %��ʼ����������ʷ�������ϵͳ�滮���
% --------------------- �Ŵ��������� ---------------------
for g=2:Gen_max
    %step_1 ѡ����� 
    Charg_post10=Select_min( fitness,Charg_post10,N );     %�����Զ����Select_min������ȷ���Ŵ�����һ���ĸ���
    Charg_post2=[Charg_post10(:,1:D1),Code_10to2( Charg_post10(:,D1+1:D),N,Gen_lenth-D1,D1 )];
    %step_2 �����Ŵ����� 
    %----------------- �˴����û�Ͻ��淽ʽ -----------------
    for i=0:N/2-1
         if rand<Pc                                    
             P=rand;
             if P<0.25
                 Charg_post2 = Cross_double( Charg_post2,i,N,Gen_lenth );  %���ýض�����/���򽻲��㷨
             else if P<0.75
                     Charg_post2 = Cross_single( Charg_post2,i,N,Gen_lenth );  %���õ�����Ƚ����㷨
                 else
                     for k=1:3                                             %ѡ��3������н���
                         Charg_post2 = Cross_single( Charg_post2,i,N,Gen_lenth );  %���ö����Ƚ����㷨
                     end
                 end
             end
         end
    end
    %step_3 Ⱦɫ�������� 
    %----------------- �˴����û�ϱ��췽ʽ -----------------
    for i=1:N
        if rand<Pm     
            P=rand;
            if P<0.2
                Charg_post2 = Var_Reverse( Charg_post2,i,Gen_lenth );  %����Ⱦɫ�嵹������㷨
            else if P<0.35
                     Charg_post2 = Var_Defect( Charg_post2,i,Gen_lenth );  %����Ⱦɫ��ȱʧ�����㷨
                 else if P<0.65
                          Charg_post2 = Var_Single( Charg_post2,i,Gen_lenth );  %����Ⱦɫ�嵥�㰴λȡ���㷨
                      else if P<0.85
                               Charg_post2 = Var_Multi( Charg_post2,i,Gen_lenth );  %����Ⱦɫ�嵥�㰴λȡ���㷨
                           else
                               for k=1:3                     %ѡ��3������а�λȡ������
                                   Charg_post2 = Var_Single( Charg_post2,i,Gen_lenth );  %����Ⱦɫ���㰴λȡ���㷨
                               end
                          end
                     end
                end
            end
        end
    end
    %step_4 Ⱦɫ����벢����������Ӧ�� 
    Charg_post10=[Charg_post2(:,1:D1),deCode_2to10( Charg_post2(:,D1+1:end),N,Gen_lenth-D1,D1 )];
    Charg_post10(:,D1+1:D)=min(Charg_post10(:,D1+1:D),Charg_post10(:,1:D1).*(xmax*ones(N,D1)));     %���Ƴ��׮�����߽�       
    Charg_post10(:,D1+1:D)=max(Charg_post10(:,D1+1:D),Charg_post10(:,1:D1).*(xmin*ones(N,D1)));
    for i=1:N
        [fitness(i),op_x,num] = Fitness ( Charg_post10(i,:) ); %�����������Ӧ��
        OP_x(1:np,1:max(sum(num,2)),i)=op_x;
    end
    [MIN,J]=min(fitness);                                   %��¼��һ��������Ӧ��
    [~,Kk]=max(fitness);                                    %��¼��һ�������Ӧ��
    %--------------------- ��Ӣ���� ---------------------
    if MIN<Best_fit(g-1)
        Best_fit(g)=MIN;
        Beat_CP1=Charg_post10(J,D1+1:D);                         
        Beat_CP2=OP_x(:,:,J);                                                                        
    else
        Best_fit(g)=Best_fit(g-1);
        Charg_post10(Kk,:)=[ceil(Beat_CP1/xmax),Beat_CP1];  %����ʷ���Ÿ���ֱ�ӵ�����һ��
        OP_x(:,:,Kk)=Beat_CP2;                              %�Ա�֤ÿ���ﶼ����ʷ���Ÿ���                                      
    end
end
toc;                                                       %ֹͣ��ʱ 
%--------------------- ����滮��� ---------------------
CP1=Beat_CP1';
X_c=find(Beat_CP1~=0);
CP1=[CP1,Char_candidate(:,[1:2,7:8])];
X_l=[];
CP2=[];
for i=1:np
    X_l=[X_l,Beat_CP2(i,1:num(i,1))];                      %��ѡ������·�������
    CP2=[CP2,Beat_CP2(i,num(i,1)+1:num(i,1)+num(i,2))];    %��ѡ�½����վ����
end
F_l=find(X_l==1);
P_n=[[zeros(n2,1),DPS_n(:,[1,2:3,11,5])];[Plan_Trans(F_l,[1:2,19:20,10]),CP2']];
for i=1:np
    P_n(1:num(i,3),end+1)=Beat_CP2(i,num(i,1)+num(i,2)+1:sum(num(i,:)));
end
A_l=Plan_Trans(F_l,1:10);
P_l=[[[zeros(m2,1),DPS_l(:,1:3)];[A_l(:,1),(A_l(:,2)-n2)+m2,A_l(:,[3,2])]],[DPS_l(:,11);Plan_Trans(F_l,10)]];
warning off
xlswrite('result',CP1,'�����ʩ')
xlswrite('result',P_n,'���ڵ�')
xlswrite('result',P_l,'�����·')
xlswrite('result',A_l,'������·����')
csvwrite('./output/addEqu.csv',CP1)
csvwrite('./output/addNode.csv',P_n)
csvwrite('./output/addLine.csv',P_l)
csvwrite('./output/addInfo.csv',A_l)





