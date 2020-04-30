clear all;close all;clc;
% PM=load('Standard_DATA\Synthesis.txt');
%  PM=load('Standard_DATA\Aggregation.txt');
%  PM=load('Standard_DATA\Compound.txt');
% PM=load('Standard_DATA\Flame.txt');
% PM=load('Standard_DATA\R15.txt');
PM=load('Standard_DATA\spiral.txt');
data = PM(:,1:2);
labels = PM(:,3:3);

clusterNum = max(labels);
for i = min(labels):clusterNum
    subCluster = data(find(labels == i),:);
    scatter(subCluster(:, 1), subCluster(:, 2),'*');
    hold on  ;
    grid on;%œ‘ æ±Ì∏Ò
end