function[TP,FN,FP,TN]=New_index(origin_labels,predict_labels);
n=size(origin_labels,2);
single_o_labels=unique(origin_labels);
single_p_labels=unique(predict_labels);
a=numel(single_o_labels);
b=numel(single_p_labels);
confusion=zeros(a,b);%开辟一个行为原始数据类别个数，列为预测数据类别个数的confusion矩阵。
for i=1:n
    i1=find(single_o_labels==origin_labels(i));
    i2=find(single_p_labels==predict_labels(i));
    confusion(i1,i2)=confusion(i1,i2)+1;
end
TP=0;
FN=0;
FP=0;
TN=0;
%TP
for i=1:a
    for j=1:b
        TP=TP+confusion(i,j)*(confusion(i,j)-1)/2;
    end
end
%FP
for i=1:b
    for j=1:a
        for t=(j+1):a
            FP=FP+confusion(j,i)*confusion(t,i);
        end
    end
end
%FN
for i=1:a
    for j=1:b
        for t=(j+1):b
            FN=FN+confusion(i,j)*confusion(i,t);
        end
    end
end
%TN
pairs=(n*(n-1)/2);
TN=pairs-TP-FP-FN;
%percent
TP=TP/pairs;
FN=FN/pairs;
FP=FP/pairs;
TN=TN/pairs;
end