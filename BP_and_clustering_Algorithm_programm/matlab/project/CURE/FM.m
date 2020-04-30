function [FMeasure,Accuracy] = Fmeasure(P,C)
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
end
