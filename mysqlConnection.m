javaaddpath('D:/mysql-connector-java-5.1.42-bin.jar');
javasddpath('D:/jdbc4.jar');
%�������ݿ�����
con=database('mydb','root','root','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/mydb');
%�������Ӷ���con
% ��һ�����������ݿ�����ƣ�����Ҫ���������ݿ������
% �ڶ����������û���
% ����������������
% ���ĸ����������ӵ������������д��������ø�
% ��������������ݿ������·���ɣ�jdbc:mysql://��ǰ�������jdbc����mysql���ݿ⣬����Ǿ����·�������ݿ��IP���˿ڣ������ݿ�����ƣ�����һ������һ��
%ע�� ��mysql�ĽṹΪ���ݿ�->���൱��excle�е��ļ���sheet�Ĺ�ϵ��
sql ='select * from nux'%���ݿ��ѯָ��
cursorA = exec(con,sql);%ִ��ָ��
cursorA=fetch(cursorA) ;
data=cursorA.data;%�õ����ݿ��е�����,���ǵõ�����cell�����ݡ������ڽ�������ʱ�����ɺ��ʵĸ�ʽ
A = [1 2 ;3 4;5 6;7 8];
sql = mysqlHand('insert','nux',A)%���ߺ�������ʾ������A�е����ݲ��뵽���ݱ�mysite��
exec(con,sql);