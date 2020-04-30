% PM=load('Standard_DATA\Synthesis.txt');
%  PM=load('Standard_DATA\Aggregation.txt');
%  PM=load('Standard_DATA\Compound.txt');
% PM=load('Standard_DATA\Flame.txt');
% PM=load('Standard_DATA\R15.txt');
PM=load('Standard_DATA\spiral.txt');
x = PM(:,1:2);
data =x;
[RD,CD,order,labels]=optics(x,2);
 labels(find(labels == -1)) = 0;
 labels = labels+1;


figure;
PlotClusterinResult(x, labels);

%%               FM-Index
classLabelvector = PM(:,3:3);
[TP,FN,FP,TN]=New_index(classLabelvector',labels');
fprintf('\n');
FM=sqrt((TP/(TP+FP))*(TP/(TP+FN))); 
z = Nmi(labels,classLabelvector);
ARI=RandIndex(classLabelvector',labels');

[Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(classLabelvector',labels);
Re = strcmp('euclidean', 'euclidean');
[DB,CH,KL,Han,st] = Valid_internal_deviation(data,labels,Re);
distM=squareform(pdist(data));
DI=Dunns(3,distM,labels);
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
tic
toc

%%
% lis = [z,ARI,Purity,FMeasure,DB,DI];
% fid = fopen('D:\\index\Optics_index.txt', 'a');
% for i=1:length(lis)
%    fprintf(fid, '%f\n ', lis(i));
% end
%    fprintf(fid,'\r\n');
%    
%     fclose(fid);