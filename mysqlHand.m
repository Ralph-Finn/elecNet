function  sql = mysqlHand(cmd , table, A)
col = size(A,2);
sql = [cmd,' ',table,' ','values'];
for i=1:size(A,1)
    data = '(';
    for j = 1:col 
        data = [data,num2str(A(i,j)),','];
    end
    data = [data(1:end-1), '),'];
    sql = [sql,' ',data];
end
sql = sql(1:end-1)
end