clear all;close all;clc;
% PM=load('Standard_DATA\Synthesis.txt');
%  PM=load('Standard_DATA\Aggregation.txt');
%  PM=load('Standard_DATA\Compound.txt');
% PM=load('Standard_DATA\Flame.txt');
% PM=load('Standard_DATA\R15.txt');
PM=load('Standard_DATA\spiral.txt');
data = PM(:,1:2);

N=3;
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N,n);
pattern(:,1:n)=data(:,:);
for x=1:N
    center(x,:)=data( randi(m,1),:);
end

%%
while 1
distence=zeros(1,N);
num=zeros(1,N);
new_center=zeros(N,n);
 
for x=1:m
    for y=1:N
    distence(y)=norm(data(x,:)-center(y,:));
    end
    [~, temp]=min(distence);%temp返回的是矩阵每列向量中最小值的位置
    pattern(x,n+1)=temp;         
end

%重新选聚类中心点
k=0;
for y=1:N
    for x=1:m
        if pattern(x,n+1)==y
            
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1   %各元素平方和开根号(距离)
        k=k+1;
    end
end
if k==N
     break;
else
     center=new_center;
     end
end

%%
[m, n]=size(pattern);


labels = pattern(:,3:3);
clusterNum = max(labels);
for i = min(labels):clusterNum
    subCluster = data(find(labels == i),:);
    scatter(subCluster(:, 1), subCluster(:, 2),'fill');
    hold on  ;
    grid on;%显示表格
end

%%               Index
classLabelvector = PM(:,3:3);
 
z = Nmi(labels,classLabelvector);
ARI=RandIndex(labels,classLabelvector);
[Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(classLabelvector',labels');

Re = strcmp('euclidean', 'euclidean');

[DB,CH,KL,Han,st] = Valid_internal_deviation(data,labels,Re);
distM=squareform(pdist(data));
DI=Dunns(3,distM,labels);
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
tic
toc

%%
lis = [z,ARI,Purity,FMeasure,DB,DI];
fid = fopen('D:\\index\Kmeans_index.txt', 'a');
for i=1:length(lis)
   fprintf(fid, '%f\n ', lis(i));
end
   fprintf(fid,'\r\n');
   
    fclose(fid);