function putIntoSql()
javaaddpath('D:/mysql-connector-java-5.1.42-bin.jar');
javaaddpath('D:/jdbc4.jar');
con=database('elecnet','root','root','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/elecnet');
[a,sheet,b] = xlsfinfo('./data.xls');
sheetnumber = size(sheet,2);
for i = 1:sheetnumber
    data = xlsread('./data.xls',sheet{i}); 
    if(sheet{i}=='配电节点')
         sql = 'delete from node';
         exec(con,sql);
         data = data(:,[1,2,3,8,11,5]);
         sql = mysqlHand('insert','node',data);
         exec(con,sql);
    end
    if(sheet{i}=='配电线路')
         sql = 'delete from line';
         exec(con,sql);
          data = data(:,[1,2,3,11]);
         sql = mysqlHand('insert','line',data);
         exec(con,sql);
    end
    if(sheet{i}=='交通节点')
     sql = 'delete from ax';
     exec(con,sql);
     sql = mysqlHand('insert','ax',data);
     exec(con,sql);
    end
    if(sheet{i}=='交通道路')
     sql = 'delete from road';
     exec(con,sql);
     data = data(:,[1,2,3]);
     sql = mysqlHand('insert','road',data);
     exec(con,sql);
    end
end
end