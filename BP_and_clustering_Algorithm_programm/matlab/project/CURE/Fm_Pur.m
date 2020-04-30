function [Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(P,C)
% P为人工标记簇
% C为聚类算法计算结果
N = length(C);% 样本总数
p = unique(P);
c = unique(C);
P_size = length(p);% 人工标记的簇的个数
C_size = length(c);% 算法计算的簇的个数
% Pid,Rid：非零数据：第i行非零数据代表的样本属于第i个簇
Pid = double(ones(P_size,1)*P == p'*ones(1,N) );
Cid = double(ones(C_size,1)*C == c'*ones(1,N) );
CP = Cid*Pid';%P和C的交集,C*P
Pj = sum(CP,1);% 行向量，P在C各个簇中的个数
Ci = sum(CP,2);% 列向量，C在P各个簇中的个数

precision = CP./( Ci*ones(1,P_size) );
recall = CP./( ones(C_size,1)*Pj );
F = 2*precision.*recall./(precision+recall);
% 得到一个总的F值
FMeasure = sum( (Pj./sum(Pj)).*max(F) );
Accuracy = sum(max(CP,[],2))/N;
%得到聚类效果 Entropy和Purity
C_i=Ci';
[e1 p1]=EnAndPur(CP ,C_i);
Entropy=e1;
Purity=p1;
end


%% 计算聚类效果熵与纯度 输入的矩阵为 CP：算法聚类与实际类别得到的数据的交集
%Ci 算法聚类得到的每个类别的总数
function [Entropy Purity]=EnAndPur(CP,Ci)
%得到行列值
[rn cn]=size(CP);
%% 计算熵
%计算概率 precision
for i=1:rn
    for j=1:cn
     precision(i,j)=CP(i,j)/Ci(1,i);    
    end
end
%计算ei(i,j)
for i=1:rn
    for j=1:cn
     ei(i,j)=precision(i,j)*log2(precision(i,j));    
    end
end
%
%计算ei_sum
for i=1:rn
    ei_sum(i)=-nansum(ei(i,:));
end
%计算mi*ei_sum(i)
for j=1:cn
    mmi(j)=Ci(1,j)*ei_sum(j);
end
%计算entropy
Entropy=nansum(mmi)/nansum(Ci);
%% 计算纯度Purity
%找出最大的一类
for i=1:rn
     pr_max(i)=max(precision(i,:));    
end
%计算类别数量
for j=1:cn
    nni(j)=Ci(1,j)*pr_max(j);
end
Purity=nansum(nni)/nansum(Ci);
end
