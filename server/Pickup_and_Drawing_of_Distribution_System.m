%%%%%%%%%%%%%% Pickup and Drawing of Distribution System %%%%%%%%%%%%%% 
clear
clc
tic;                              %开始计时

%% ============== 配电系统节点坐标拾取 ============== 
% % ------------------- 坐标拾取 ------------------- 
% TH=imread('天河某区中压配电网.png');                  
% imshow(TH);                                    
% L=ginput;
% xlswrite('广州市天河区10kV主变节点坐标',L);
% 
% % ------------------- 坐标变换 ------------------- 
% xx=[245.720820189274;1278.41798107256];
% yy=[885.275236593060;192.522870662460];
% 
% for i=1:length(L)
%     X(i)=113.327615+(L(i,1)-xx(1))*((113.344993-113.327615)/(xx(2)-xx(1)));       %变换为实际地理坐标
%     Y(i)=23.121839+(L(i,2)-yy(1))*((23.131681-23.121839)/(yy(2)-yy(1)));
% end

%% ============== 绘制电网-交通耦合网络图 ============== 
% ------------------- 绘制交通网络 ------------------- 
GZ_n=xlsread('天河区交通网络.xls','交通节点');
GZ_l=xlsread('天河区交通网络.xls','交通道路');
n=size(GZ_n,1);                   %交通节点数
l=size(GZ_l,1);                   %交通道路数

hold on
plot(GZ_n(:,2),GZ_n(:,3),'ko','MarkerFaceColor','w','MarkerSize',5)     %绘制交通节点

for i=1:l
    st=GZ_l(i,2);
    en=GZ_l(i,3);
    plot([GZ_n(st,2);GZ_n(en,2)],[GZ_n(st,3);GZ_n(en,3)],'r:','linewidth',2);  %绘制交通道路
end

% ------------------- 绘制配电系统 ------------------- 
DS_n=xlsread('天河区配电系统','配电节点');
DS_l=xlsread('天河区配电系统','配电线路');
n=size(DS_n,1);                   %配电节点数
l=size(DS_l,1);                   %配电线路数

L_110=[find(DS_n(:,8)==1);l];         %标记110kV主变节点位置    

color={'r','b','g','m','c','k','y'};

for i=1:length(L_110)-1;            %配电系统个数 
    l_c=DS_l(find(DS_l(:,end)==i),:);    %读取分区i的线路信息  
    for j=1:size(l_c,1)
        st=l_c(j,2);
        en=l_c(j,3);
        plot([DS_n(st,2);DS_n(en,2)],[DS_n(st,3);DS_n(en,3)],color{i},'linewidth',1);
    end
    
    plot(DS_n(L_110(i):L_110(i+1),2),DS_n(L_110(i):L_110(i+1),3),'ks','MarkerFaceColor',color{i},'MarkerSize',4)     %配电系统节点
end

toc;                              %停止计时    
