function [ op_x,op_sr,op_sc,op_obj ] = DPSP_1( r1,x1,r2,x2,PT,ll,npt,ny,e,PL,QL,SL,seta,A,ll1,S0,F_P1,F_Q1,F_P2,F_Q2,mu )
%�Զ������ϵͳ�滮ģ�͵�����Ӻ���1��ֱ������YALMIP��������
global VB SR_min SR_max SC_min SC_max tao T_up
% ----------------------- ��������  -----------------------
x=binvar(1,npt);                                     %�½����վ�Ƿ������·a���ӵ�0-1����                                
SR=intvar(1,ny);                                     %�������վ�Ľ��������������ͱ���/MW
SC=intvar(1,ll1);                                    %���б��վ�����������������ͱ���/MW
P=sdpvar(T_up,ll);                                   %�½����վ�Ƿ������·a���Ӷ�Ӧ����·�й�
Q=sdpvar(T_up,ll);                                   %�½����վ�Ƿ������·a���Ӷ�Ӧ����·�޹�
% ----------------------- Ŀ�꺯��  -----------------------
obj1=x*(PT(:,4).*PT(:,8));                           %�½���·�ɱ�
obj2=SR*seta+SC*(tao*ones(ll1,1));                   %����/���ݱ��վ�ɱ�
obj3=sum((P(:,1:ll1)*r1+Q(:,1:ll1)*x1)/VB+(P(:,ll1+1:end)*(e*(r2.*x'))+Q(:,ll1+1:end)*(e*(x2.*x')))/VB);   %��ѹƫ�Ƴɱ������ϵͳ�޻����������ܼ�����P/QΪ��
w2=[30 0.1 0.05];
obj=w2*[obj1;obj2;obj3];
% ----------------------- Լ������  -----------------------
cst=[x*e'==1];
cst=[cst,-P*A-PL==0];                                %DistFlow����ƽ�ⷽ�̵���������պú�A�෴
cst=[cst,-Q*A-QL==0];
cst=[cst,ones(T_up,1)*((S0+SC).*mu(1:ll1))>=SL(:,1:ll1)];
cst=[cst,ones(T_up,1)*(SR.*mu(ll1+1:end))>=SL(:,ll1+1:end)];
cst=[cst,P(:,1:ll1)<=ones(T_up,1)*F_P1,Q(:,1:ll1)<=ones(T_up,1)*F_Q1];
cst=[cst,P(:,ll1+1:end)<=ones(T_up,1)*(x.*F_P2*e'),Q(:,ll1+1:end)<=ones(T_up,1)*(x.*F_Q2*e')];
cst=[cst,SR_min<=SR<=SR_max,SC_min<=SC<=SC_max];
% ----------------------- ��������  -----------------------
ops=sdpsettings('solver','cplex');     %ѡ��cplex��������
optimize(cst,obj,ops);
op_x=round(value(x));
op_sr=value(SR);
op_sc=value(SC);
op_obj=value(obj);
end

