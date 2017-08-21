%%%%%%%%%%%%%%%%%% Traffic Network and Dijsktra %%%%%%%%%%%%%%%%%% 
clear
clc
tic;                              %��ʼ��ʱ

%% ============== ���ƽ�ͨ����ͼ ============== 
GZ_n=xlsread('�������ͨ����.xls','��ͨ�ڵ�');
GZ_l=xlsread('�������ͨ����.xls','��ͨ��·');
n=size(GZ_n,1);                   %��ͨ�ڵ���
l=size(GZ_l,1);                   %��ͨ��·��

hold on
plot(GZ_n(:,2),GZ_n(:,3),'ko','MarkerFaceColor','w','MarkerSize',8)     %���ƽ�ͨ�ڵ�

for i=1:l
    st=GZ_l(i,2);
    en=GZ_l(i,3);
    plot([GZ_n(st,2);GZ_n(en,2)],[GZ_n(st,3);GZ_n(en,3)],'r','linewidth',2);  %���ƽ�ͨ��·
end

%% ============ ������ڵ����̾���·�� ============ 
% ---------------- ��·���ȼ��� ----------------
for i=1:l
    st=GZ_l(i,2);
    en=GZ_l(i,3);
    d(i,1)=distance(GZ_n(st,2),GZ_n(st,3),GZ_n(en,2),GZ_n(en,3))*111.1775;    %�����·����
end

% ---------------- �������Ӳ������� ----------------
for i=1:n
    for j=1:l
        A(i,j)=0;
        if GZ_l(j,2)==i                        
            A(i,j)=1;                          %���ɹ�������
        end
        if GZ_l(j,3)==i
            A(i,j)=-1;
        end
    end
end
Yn=A*diag(d)*A';

% ---------------- �ڵ����̾���·������ ----------------
W=abs(Yn);        
W(find(W==0))=Inf;
W=W-diag(diag(W));                            %��·����Ȩ����
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
% xlswrite('��·�ڵ����̾����·��',D,'��̾���')
% xlswrite('��·�ڵ����̾����·��',[PATH,H],'���·��')

toc;                              %ֹͣ��ʱ


