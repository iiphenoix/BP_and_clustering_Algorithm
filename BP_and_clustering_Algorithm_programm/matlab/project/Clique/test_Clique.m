clear all;close all;clc;
% PM=load('Standard_DATA\Synthesis.txt');
%  PM=load('Standard_DATA\Aggregation.txt');
%  PM=load('Standard_DATA\Compound.txt');
% PM=load('Standard_DATA\Flame.txt');
PM=load('Standard_DATA\R15.txt')
% PM=load('Standard_DATA\spiral.txt');
original_data = PM(:,1:2);
data = normalize_features(original_data);
xsi = 10;
tau = 0.01;
[clusters1,clusters2,dense_units,dense_units2] = run_clique(data,xsi,tau);

data(:,3) = 0;
k =0 ;
J = [];
for i = 1:size(clusters2,1)
    lis = [];
    if(length(clusters2{i,4})>0)
           k = k+1;
            
           lis = clusters2{i,4};
           scatter(data(lis,1:1),data(lis,2:2),'*'); 
           data(lis,3:3) = k;
           J = [J lis];
    end
      hold on  
%        grid on;%œ‘ æ±Ì∏Ò
end
labels =[];
labels = data(:,3:3);
data1=vpa(data(:,1:2),4);

data = double(data);
Xi=data1(labels==0,:);
plot(Xi(:,1),Xi(:,2),'o','MarkerSize',4,'Color','black');   
fprintf('\n');
%%
labels = data(J,3:3);
labels=double(labels);
classLabelvector = PM(:,3:3);
classLabelvector = classLabelvector(J);

z = Nmi(labels,classLabelvector);
ARI=RandIndex(labels,classLabelvector);
[FMeasure,Accuracy] = FM(classLabelvector',labels');

Re = strcmp('euclidean', 'euclidean');
[DB,CH,KL,Han,st] = Valid_internal_deviation(data,labels,Re);
distM=squareform(pdist(data));
DI=Dunns(3,distM,labels)   ;
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,FMeasure,DB,DI);


% [Entropy,Purity] = EnAndPur(classLabelvector,labels);
% fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
tic
toc