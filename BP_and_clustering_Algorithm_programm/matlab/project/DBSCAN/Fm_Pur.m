function [Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(P,C)
% PΪ�˹���Ǵ�
% CΪ�����㷨������
N = length(C);% ��������
p = unique(P);
c = unique(C);
P_size = length(p);% �˹���ǵĴصĸ���
C_size = length(c);% �㷨����Ĵصĸ���
% Pid,Rid���������ݣ���i�з������ݴ�����������ڵ�i����
Pid = double(ones(P_size,1)*P == p'*ones(1,N) );
Cid = double(ones(C_size,1)*C == c'*ones(1,N) );
CP = Cid*Pid';%P��C�Ľ���,C*P
Pj = sum(CP,1);% ��������P��C�������еĸ���
Ci = sum(CP,2);% ��������C��P�������еĸ���

precision = CP./( Ci*ones(1,P_size) );
recall = CP./( ones(C_size,1)*Pj );
F = 2*precision.*recall./(precision+recall);
% �õ�һ���ܵ�Fֵ
FMeasure = sum( (Pj./sum(Pj)).*max(F) );
Accuracy = sum(max(CP,[],2))/N;
%�õ�����Ч�� Entropy��Purity
C_i=Ci';
[e1 p1]=EnAndPur(CP ,C_i);
Entropy=e1;
Purity=p1;
end


%% �������Ч�����봿�� ����ľ���Ϊ CP���㷨������ʵ�����õ������ݵĽ���
%Ci �㷨����õ���ÿ����������
function [Entropy Purity]=EnAndPur(CP,Ci)
%�õ�����ֵ
[rn cn]=size(CP);
%% ������
%������� precision
for i=1:rn
    for j=1:cn
     precision(i,j)=CP(i,j)/Ci(1,i);    
    end
end
%����ei(i,j)
for i=1:rn
    for j=1:cn
     ei(i,j)=precision(i,j)*log2(precision(i,j));    
    end
end
%
%����ei_sum
for i=1:rn
    ei_sum(i)=-nansum(ei(i,:));
end
%����mi*ei_sum(i)
for j=1:cn
    mmi(j)=Ci(1,j)*ei_sum(j);
end
%����entropy
Entropy=nansum(mmi)/nansum(Ci);
%% ���㴿��Purity
%�ҳ�����һ��
for i=1:rn
     pr_max(i)=max(precision(i,:));    
end
%�����������
for j=1:cn
    nni(j)=Ci(1,j)*pr_max(j);
end
Purity=nansum(nni)/nansum(Ci);
end
