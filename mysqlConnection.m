javaaddpath('D:/mysql-connector-java-5.1.42-bin.jar');
javasddpath('D:/jdbc4.jar');
%增加数据库驱动
con=database('mydb','root','root','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/mydb');
%建立连接对象con
% 第一个参数：数据库的名称，就是要操作的数据库的名称
% 第二个参数：用户名
% 第三个参数：密码
% 第四个参数：连接的驱动，这里就写这个，不用改
% 第五个参数：数据库的连接路径吧，jdbc:mysql://，前面这个是jdbc，用mysql数据库，后边是具体的路径，数据库的IP，端口，和数据库的名称，跟第一个参数一样
%注意 ，mysql的结构为数据库->表，相当于excle中的文件和sheet的关系。
sql ='select * from nux'%数据库查询指令
cursorA = exec(con,sql);%执行指令
cursorA=fetch(cursorA) ;
data=cursorA.data;%得到数据库中的数据,但是得到的是cell型数据。建议在建立表格的时候建立成合适的格式
A = [1 2 ;3 4;5 6;7 8];
sql = mysqlHand('insert','nux',A)%工具函数，表示将数组A中的数据插入到数据表mysite中
exec(con,sql);