function [ Time,Path ] = Dijkstra ( W,N,st,en )
%自定义基于Dijkstra算法的最短路径寻优子函数
st=find(N==st);                         %节点编号变换
en=find(N==en);

n=length(W);                            %节点数  
D=W(st,:);  
Visit=ones(1,n); 
Visit(st)=0;  
Parent=zeros(1,n);                      %记录每个节点的上一个节点  
  
path =[];  
  
for i=1:n-1  
    temp = [];  
    
    %从起点出发，找最短距离的下一个点，每次不会重复原来的轨迹，设置Visit判断节点是否访问  
    for j=1:n  
       if Visit(j)                     %若j点未被访问
           temp =[temp D(j)];  
       else  
           temp =[temp Inf];  
       end     
    end  
      
    [~,index] = min(temp);   
    Visit(index)=0;                    %将已选中的点置0
      
    %更新 如果经过index节点，从起点到每个节点的路径长度更小，则更新，记录前趋节点，方便后面回溯循迹  
    for k=1:n  
        if D(k)>D(index)+W(index,k)  
           D(k) = D(index)+W(index,k);  
           Parent(k)=index;  
        end  
    end         
end

Time=D(en);%最短距离

%回溯法  从尾部往前寻找搜索路径  
t=en;  
while t~=st && t>0  
    path=[t,path];  
    p=Parent(t);
    t=p;   
end  
path =[st,path];                       %最短路径  

for i=1:length(path)                   %节点编号反变换
    Path(i)=N(path(i));
end

end  

