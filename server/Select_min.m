function [ Char_post ] = Select_min( fitness,Char_Post,N )
% ---------------- ���̶�ɸѡ���� ----------------
ffitness=1./fitness;                              %ȡ��������Сֵ
Fitness=ffitness/sum(ffitness);                   %��һ��
Sum(1)=0;
for j=1:N
    Sum(j+1)=Sum(j)+Fitness(j);
end
for i=1:N
    for j=1:N
        p=rand;
       
        if p>Sum(j) && p<=Sum(j+1)
            break;
        end
    end
    Char_post(i,:)=Char_Post(j,:);
end

end
