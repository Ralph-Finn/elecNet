function [ point ] = Select ( weigth,N )
% ---------------- ���̶�ɸѡ���� ----------------
Fitness=weigth/sum(weigth);                   %��һ��
n=size(N,1);
Sum(1)=0;
for i=1:n
    Sum(i+1)=Sum(i)+Fitness(i);
end

for i=1:n
    p=rand;
    if p>Sum(i) && p<=Sum(i+1)
        break;
    end
end
point=N(i);

end

