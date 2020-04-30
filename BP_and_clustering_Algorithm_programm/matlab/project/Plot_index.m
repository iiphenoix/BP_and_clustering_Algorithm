% PM=load('D:\index\Kmeans_index.txt');
% PM=load('D:\index\Kmedoids_index.txt');
% PM=load('D:\index\Cure_index.txt');
% PM=load('D:\index\Optics_index.txt');
% PM=load('D:\index\DPC_index.txt');
%  PM=load('D:\index\Birch_index.txt');
PM=load('D:\index\Clique._index.txt');
% n =0;
% nmi = [];
% ARI = [];
% Purity =[];
% FMeasure = [];
% DB = [];
% DI = [];
% for i = [1,7,13,19,25,31]
% n = n+1;;
% nmi(n) = PM(i);
% ARI(n) = PM(i+1);
% Purity(n) = PM(i+2);
% FMeasure(n) = PM(i+3);
% DB(n) = PM(i+4);
% DI(n) = PM(i+5);
% end



nmi = PM(1:6,1:1);
ARI = PM(1:6,2:2);
Purity =PM(1:6,3:3);
FMeasure = PM(1:6,4:4);
DB = PM(1:6,5:5);
DI = PM(1:6,6:6);
aa = [nmi';ARI';Purity';FMeasure';DB';DI'];
barh(aa);

legend('Synthesis','Aggregation','Compound','Flame','R15','spiral');

set(gca,'YTickLabel',{'NMI','RandÖ¸Êý','Purity','FMeasure','DBI','DVI'});