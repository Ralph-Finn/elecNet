%%%%%%%%%%%%%%%%%% Traffic Network and Dijsktra %%%%%%%%%%%%%%%%%% 
clear
clc
tic;                              %开始计时

%% ============== 绘制交通网络图 ============== 
GZ_n=xlsread('天河区交通网络.xls','交通节点');
GZ_l=xlsread('天河区交通网络.xls','交通道路');
n=size(GZ_n,1);                   %交通节点数
l=size(GZ_l,1);                   %交通道路数

hold on
plot(GZ_n(:,2),GZ_n(:,3),'ko','MarkerFaceColor','w','MarkerSize',8)     %绘制交通节点

for i=1:l
    st=GZ_l(i,2);
    en=GZ_l(i,3);
    plot([GZ_n(st,2);GZ_n(en,2)],[GZ_n(st,3);GZ_n(en,3)],'r','linewidth',2);  %绘制交通道路
end

%% ============ 计算各节点间最短距离路径 ============ 
% ---------------- 道路长度计算 ----------------
for i=1:l
    st=GZ_l(i,2);
    en=GZ_l(i,3);
    d(i,1)=distance(GZ_n(st,2),GZ_n(st,3),GZ_n(en,2),GZ_n(en,3))*111.1775;    %计算道路长度
end

% ---------------- 网络连接参数计算 ----------------
for i=1:n
    for j=1:l
        A(i,j)=0;
        if GZ_l(j,2)==i                        
            A(i,j)=1;                          %生成关联矩阵
        end
        if GZ_l(j,3)==i
            A(i,j)=-1;
        end
    end
end
Yn=A*diag(d)*A';

% ---------------- 节点间最短距离路径计算 ----------------
W=abs(Yn);        
W(find(W==0))=Inf;
W=W-diag(diag(W));                            %道路连接权矩阵
D=zeros(n);
PATH=[];
H=[];
for i=1:n
    for j=i+1:n
        path=[];
        [ D(i,j),path] = Dijkstra( W,GZ_n(:,1),i,j );
        PATH(end+1,1:2+length(path))=[i,j,path];
        H(end+1,1)=length(path);
        D(j,i)=D(i,j);
    end
end

% warning off
% xlswrite('道路节点间最短距离和路径',D,'最短距离')
% xlswrite('道路节点间最短距离和路径',[PATH,H],'最短路径')

toc;                              %停止计时


