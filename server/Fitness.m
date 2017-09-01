function [fitness,OP_x,Num] = Fitness ( X )
%�Զ�����Ӧ�ȼ����Ӻ���������΢�۽�ͨ�����ֺ����ϵͳ����
% i=1;
% X=Charg_post10(i,:);
global TH_l Charg_post D1 Char_candidate np N_max T_up m1 Plan_Trans DPS_n DPS_l radio1 radio2 VB mu_D
LO=0;
CP_new=Charg_post;
L_CP=[];     
dps_n=DPS_n;       dps_l=DPS_l;
for i=1:np
    % =============== ����������滮���� ===============
    % ---------- ����������վ����������MTFM�����Ż�ָ�� ----------
    nL=length(find(Char_candidate(:,7)==i));
    l_cp=LO+find(X(LO+1:LO+nL)==1);
    L_CP=[L_CP,l_cp];
    CP_new=[CP_new;[Char_candidate(l_cp,1:3),X(D1+l_cp)',Char_candidate(l_cp,8:9)]]; %�����������վλ����Ϣ
    [dist,cp,flow,fast_P,slow_P] = MTFM ( CP_new );                                %����΢�۽�ͨ����ģ�Ͷ�����������������Ż�ָ��
    Dist(1:N_max,1:size(dist,2),i)=dist;
    n_CP=size(CP_new,1);
    CP(1:n_CP,1:T_up+1,i)=cp;
    Flow(1:m1,1:T_up,i)=flow;
    Fast_P=[fast_P(:,1:10)+fast_P(:,T_up+1:T_up+10),fast_P(:,11:T_up)];
    Slow_P=[slow_P(1:10)+slow_P(T_up+1:T_up+10),slow_P(11:T_up)];
    LO=LO+nL;
    % =============== ���ϵͳ�滮���� ===============
    PT=Plan_Trans(find(Plan_Trans(:,1)==i),:);                     %��i��������������ϵͳ�滮����
    npt=size(PT,1);
    r2=PT(:,5).*PT(:,8);                                           %�½���·����
    x2=PT(:,6).*PT(:,8);                                           %�½���·���
    ny=1;     l_pt=[];     l_pt(ny)=1;
    for j=2:npt
        if PT(j,2)~=PT(j-1,2)
            ny=ny+1;
            l_pt(ny)=j;
        end
    end
    L1=PT(l_pt,11);
    seta=PT(l_pt,15)+PT(l_pt,16);
    F_P2=1.7321*VB*(PT(:,9).*PT(:,17))';
    F_Q2=1.7321*VB*(PT(:,9).*sqrt(1-PT(:,17).^2))';
    nn1=size(dps_n,1);          ll1=size(dps_l,1);   
    S0=dps_n(dps_l(:,3),5)';
    F_P1=1.7321*VB*(dps_l(:,10).*dps_n(dps_l(:,3),6))';
    F_Q1=1.7321*VB*(dps_l(:,10).*sqrt(1-dps_n(dps_l(:,3),6).^2))';
    n_add=[nn1+[1:ny]',PT(l_pt,19:20),zeros(ny,2),PT(l_pt,17:18),zeros(ny,1),PT(l_pt,13:14),PT(l_pt,10)];     
    l_add=[ll1+[1:ny]',PT(l_pt,3),nn1+[1:ny]',zeros(ny,1),PT(l_pt,21),PT(l_pt,5:11)];
    dps_n=[dps_n;n_add];                                           %������i������ϵͳ�ڵ���
    dps_l=[dps_l;l_add];                                           %������i������ϵͳ��·��
    nn=nn1+ny;          ll=ll1+ny;                                 %������i��Ľڵ�������·��
    r1=dps_l(1:ll1,6).*dps_l(1:ll1,9).*dps_l(1:ll1,5);             %������·����
    x1=dps_l(1:ll1,7).*dps_l(1:ll1,9).*dps_l(1:ll1,5);             %������·���   
    P_FCS=zeros(T_up,nn);
    P_FCS(:,CP_new(:,5))=1.5*T_up*Fast_P';                         %��为��
    P_CP=1.5*T_up*Slow_P'*dps_n(:,9)'/(sum(dps_n(:,9))/2);         %���为��
    A=[];
    for j=1:nn
        for k=1:ll
            if dps_l(k,2)==j                                       %�������ϵͳ�Ĺ�������
                A(j,k)=1;
            end
            if dps_l(k,3)==j 
                A(j,k)=-1;
            end
        end
    end
    A(find(dps_n(:,8)==1),:)=[];                                   %����nk�����ϵͳ��ƽ��ڵ�
    l_pt=[l_pt,npt+1];
    e=[];
    for j=1:ny
        for k=l_pt(j):l_pt(j+1)-1
            e(j,k)=1;
        end
    end
    PL=(1+radio1)^(i-1)*(P_FCS(:,dps_l(:,3))+P_CP(:,dps_l(:,3)))+(1+radio2)^(i-1)*mu_D*dps_n(dps_l(:,3),9)'; %ˮƽ�滮����EV��͸�ʰ�radio1����������������Ϊradio2
    QL=mu_D*dps_n(dps_l(:,3),10)';
    SL=sqrt(PL.^2+QL.^2);
    mu=dps_n(dps_l(:,3),7)';
    [ op_x,op_sr,op_sc,op_obj(i) ] = DPSP_1( r1,x1,r2,x2,PT,ll,npt,ny,e,PL,QL,SL,seta,A,ll1,S0,F_P1,F_Q1,F_P2,F_Q2,mu ); %�����Ӻ�������Ż�ģ��
    Lx=find(op_x==1);
    dps_l(ll1+1:end,5:10)=[PT(Lx,21),PT(Lx,5:9)];                  %������ѡ��·���跽������
    Lsc=find(op_sc~=0);
    dps_n(dps_l(Lsc,3),5)=dps_n(dps_l(Lsc,3),5)+op_sc(Lsc)';       %�����б��վ����
    dps_n(nn1+1:end,5)=op_sr';                                     %��¼�½����վ���Ž�������
    OP_x(i,1:npt+ll)=[op_x,op_sr,op_sc];                           %��¼��������Ż�ֵ 
    Num(i,1:3)=[npt,ny,ll1];                                       %��¼�����Ż������� 
end
    % ------------ ���������������Ż�Ŀ�� ------------
    fitness1=sum(sum(sum(Dist)));                                  %EV���������Ӿ���֮����С
    fitness2=var(sum(sum(CP,2),3));                                %���վ����ʱ�γ�׮�ȵķ�����С
    BPR=(TH_l(:,5)/39.8).*(1+0.15*(sum(sum(Flow,2),3)./TH_l(:,6)).^4);
    fitness3=var(BPR);                                             %BPR·�躯���ķ�����С
    % ------------ ���������罨���Ż�Ŀ�� ------------
    fitness4=2.3*sum(X(D1+L_CP));                                  %�������׮������ú�����ά������Ϊ2.3��Ԫ
    fitness5=sum(Char_candidate(L_CP,6).*X(D1+L_CP)');             %���׮���ؽ���ɱ�
    % ------------ �������������Ż�Ŀ�� ------------
    w1=[0.0667 8 40000 0.5 0.25];
    fitness=w1*[fitness1;fitness2;fitness3;fitness4;fitness5];     %���������������Ż�Ŀ��
    fitness=fitness+sum(op_obj);
end

