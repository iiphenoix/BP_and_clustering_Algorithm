clear;
clc;
tic;

PM=load('Standard_DATA\Synthesis.txt');%10 5 1.5
% PM=load('Standard_DATA\Aggregation.txt');%10 7 1.5
% PM=load('Standard_DATA\Compound.txt');%10 6 0.9
% PM=load('Standard_DATA\Flame.txt');%10 2 0.9
% PM=load('Standard_DATA\R15.txt'); %20 15 0.1
% PM=load('Standard_DATA\spiral.txt');%10 3 1

data = PM(:,1:2);
classLabelvector = PM(:,3:3);

branching_factor=10;
n_clusters= 5;
threshold=1.5;
brc = Birch( threshold,branching_factor, n_clusters);
brc=brc.fit(data);
labels=brc.predict(data);
labels=labels;

PlotClusterinResult(data, labels);
%%               
[TP,FN,FP,TN]=New_index(classLabelvector',labels');

FM=sqrt((TP/(TP+FP))*(TP/(TP+FN))); 
z = Nmi(labels',classLabelvector');

ARI=RandIndex(classLabelvector',labels');

[Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(classLabelvector',labels');
Re = strcmp('euclidean', 'euclidean');
[DB,CH,KL,Han,st] = Valid_internal_deviation(data,labels,Re);
distM=squareform(pdist(data));
DI=Dunns(3,distM,labels);
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
toc

%%
% lis = [z,ARI,Purity,FMeasure,DB,DI];
% fid = fopen('D:\\index\Birch_index.txt', 'a');
% for i=1:length(lis)
%    fprintf(fid, '%f\n ', lis(i));
% end
%    fprintf(fid,'\r\n');
%    
%     fclose(fid);