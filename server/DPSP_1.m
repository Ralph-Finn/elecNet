function [ op_x,op_sr,op_sc,op_obj ] = DPSP_1( r1,x1,r2,x2,PT,ll,npt,ny,e,PL,QL,SL,seta,A,ll1,S0,F_P1,F_Q1,F_P2,F_Q2,mu )
%自定义配电系统规划模型的求解子函数1，直接利用YALMIP求解器求解
global VB SR_min SR_max SC_min SC_max tao T_up
% ----------------------- 变量定义  -----------------------
x=binvar(1,npt);                                     %新建变电站是否采用线路a连接的0-1变量                                
SR=intvar(1,ny);                                     %新增变电站的建设容量，整数型变量/MW
SC=intvar(1,ll1);                                    %已有变电站的扩容容量，整数型变量/MW
P=sdpvar(T_up,ll);                                   %新建变电站是否采用线路a连接对应的线路有功
Q=sdpvar(T_up,ll);                                   %新建变电站是否采用线路a连接对应的线路无功
% ----------------------- 目标函数  -----------------------
obj1=x*(PT(:,4).*PT(:,8));                           %新建线路成本
obj2=SR*seta+SC*(tao*ones(ll1,1));                   %新增/扩容变电站成本
obj3=sum((P(:,1:ll1)*r1+Q(:,1:ll1)*x1)/VB+(P(:,ll1+1:end)*(e*(r2.*x'))+Q(:,ll1+1:end)*(e*(x2.*x')))/VB);   %电压偏移成本，配电系统无环流，总是能假设有P/Q为正
w2=[30 0.1 0.05];
obj=w2*[obj1;obj2;obj3];
% ----------------------- 约束条件  -----------------------
cst=[x*e'==1];
cst=[cst,-P*A-PL==0];                                %DistFlow功率平衡方程的正方向定义刚好和A相反
cst=[cst,-Q*A-QL==0];
cst=[cst,ones(T_up,1)*((S0+SC).*mu(1:ll1))>=SL(:,1:ll1)];
cst=[cst,ones(T_up,1)*(SR.*mu(ll1+1:end))>=SL(:,ll1+1:end)];
cst=[cst,P(:,1:ll1)<=ones(T_up,1)*F_P1,Q(:,1:ll1)<=ones(T_up,1)*F_Q1];
cst=[cst,P(:,ll1+1:end)<=ones(T_up,1)*(x.*F_P2*e'),Q(:,ll1+1:end)<=ones(T_up,1)*(x.*F_Q2*e')];
cst=[cst,SR_min<=SR<=SR_max,SC_min<=SC<=SC_max];
% ----------------------- 求解器求解  -----------------------
ops=sdpsettings('solver','cplex');     %选用cplex求解器求解
optimize(cst,obj,ops);
op_x=round(value(x));
op_sr=value(SR);
op_sc=value(SC);
op_obj=value(obj);
end

