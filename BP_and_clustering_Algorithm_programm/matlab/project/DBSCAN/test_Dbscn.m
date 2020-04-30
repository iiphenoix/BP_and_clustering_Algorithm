
clc;
clear;
close all;
 
%% test Data
%数据下载网站：http://archive.ics.uci.edu/ml/machine-learning-databases/iris/
%这里使用的iris数据的一部分，由于第3维和第4为数据数据区分度好，因此用3、4维数据测试
% PM=load('Standard_DATA\Synthesis.txt'); %2 3
% PM=load('Standard_DATA\Aggregation.txt');%
% PM=load('Standard_DATA\Compound.txt'); %2 3
% PM=load('Standard_DATA\Flame.txt');%1 6
% PM=load('Standard_DATA\R15.txt'); %0.4 6
PM=load('Standard_DATA\spiral.txt');
X = PM(:,1:2);
 data = X;

%% Run DBSCAN Clustering Algorithm
epsilon= 3 ;
MinPts=   4 ;  %epsilon和MinPts不停地调参
IDX1=DBSCAN(X,epsilon,MinPts);
IDX1 = IDX1+1;
labels = IDX1;
%% Plot Results
figure;
PlotClusterinResult(X, IDX1);

%%               FM-Index
classLabelvector = PM(:,3:3);
[TP,FN,FP,TN]=New_index(classLabelvector',IDX1');
fprintf('\n')
FM=sqrt((TP/(TP+FP))*(TP/(TP+FN))); 
z = Nmi(IDX1,classLabelvector);
ARI=RandIndex(IDX1,classLabelvector);
[Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(classLabelvector',labels');
Re = strcmp('euclidean', 'euclidean');
[DB,CH,KL,Han,st] = Valid_internal_deviation(data,labels,Re);
distM=squareform(pdist(data));
DI=Dunns(3,distM,labels);
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
tic
toc

%%
% lis = [z,ARI,Purity,FMeasure,DB,DI];
% fid = fopen('D:\\index\Dbscn_index.txt', 'a');
% for i=1:length(lis)
%    fprintf(fid, '%f\n ', lis(i));
% end
%    fprintf(fid,'\r\n');
%    
%     fclose(fid);