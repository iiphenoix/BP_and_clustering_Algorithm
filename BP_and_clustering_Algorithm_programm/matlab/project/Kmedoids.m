clc;  
clear;  
%读取数据文件,生成点矩阵  
% fileID = fopen('Standard_DATA\Synthesis.txt');  
%  fileID = fopen('Standard_DATA\Aggregation.txt');  
%  fileID = fopen('Standard_DATA\Compound.txt');  
%  fileID = fopen('Standard_DATA\Flame.txt');  
%  fileID = fopen('Standard_DATA\R15.txt');  
 fileID = fopen('Standard_DATA\spiral.txt');  

 C=textscan(fileID,'%f %f %f'); %textscan函数读取数据
 fclose(fileID); %关闭一个打开的fileID的文件
 %显示数组结果  
 %celldisp(C);  
 %将cell类型转换为矩阵类型,这里只假设原数据为二维属性，且是二维的坐标点  
 CC_init=cat(2,C{1},C{2});%用来保存初始加载的值  
 CC=CC_init;  %cat函数用于连接两个矩阵或数组
  %获得对象的数量  
 num=length(C{1});  
 %显示初始分布图  
 grid on;%显示表格
 %scatter(C{1},C{2},'filled');  %filled为实心圆，该函数可以把C中所有坐标的点都画出来。
 %%设置任意k个簇  
% k=5;  
% k = 7;
% k =6;
% k = 2;
% k = 15;
k = 3;
%临时存放k个中心点的数组  
C_temp=zeros(k,2);  
%判断所设置的k值是否小于对象的数量  
  
    %产生随机的k个整数  
   randC=randperm(num);  
   randC=randC(1:k);  
   %从原数组中提出这三个点     
   for i=1:k  
       C_temp(i,:)=CC(randC(1,i),:);  
   end  
   %将原数组中的这三个点清空  
    for j=1:k  
       CC(randC(1,j),:)=zeros(1,2);  
    end    
    idZero=find(CC(:,1)==0);  
    %删除为零的行  
    [i1,j1]=find(CC==0);  
    row=unique(i1);  
    CC(row,:)=[];  
   %分配k个二维数组，用来存放聚类点  
   %分配行为k的存储单元  
   cluster=cell(k,1,1);   
    %将剔除的三个点加入到对应的三个存储单元,每个单元的第一行置为0，为了存储相对应的簇中心  
   for m=1:k  
       cluster{m}=C_temp(m,:);  
   end    
   %计算其他点到这k个点的距离，然后分配这些点，第一次遍历  
   for i=1:num-k  
       %分别计算到三个点的距离         
       minValue=1000000;%最小值，要根据实际情况设定该值  
       minNum=-1;%最小值序号  
       for j=1:k  
           if minValue>sqrt((CC(i,1)-C_temp(j,1))*(CC(i,1)-C_temp(j,1))+(CC(i,2)-C_temp(j,2))*(CC(i,2)-C_temp(j,2)))  
               minValue=sqrt((CC(i,1)-C_temp(j,1))*(CC(i,1)-C_temp(j,1))+(CC(i,2)-C_temp(j,2))*(CC(i,2)-C_temp(j,2)));  
               minNum=j;  
           end  
       end  
       cluster{minNum}=cat(1,cluster{minNum},CC(i,:));         
   end  
   %随机选择p点  
   flag=1;  
   count=0;  
   %%
   while flag==1  
       randC=randperm(num-k);  
       randC=randC(1:1);    
       o_random=CC(randC,:);  
       %找出该随机点所在的簇  
       recordN=0;  
       for i=1:k        
           for j=1:size(cluster{i},1)        
               cc=cluster{i}(j,:);  
               cc=cc-o_random;  
               if cc==0  
                   recordN=i;  
                   break;  
               end  
           end  
       end  
       %将选择的随机点从点集中删除  
       CC(randC,:)=[];  
       %计算替换代价  
       o=cluster{recordN}(1,:);  
       o_rand_sum=0;  
       o_sum=0;  
       for i=1:length(CC)  
           o_rand_sum=o_rand_sum+sqrt((CC(i,1)-o_random(1,1))*(CC(i,1)-o_random(1,1))+(CC(i,2)-o_random(1,2))*(CC(i,2)-o_random(1,2)));  
           o_sum=o_sum+sqrt((CC(i,1)-o(1,1))*(CC(i,1)-o(1,1))+(CC(i,2)-o(1,2))*(CC(i,2)-o(1,2)));  
       end  
       %如果随机选择的点的代价小于原始代表点的代价，则替换该代表点，然后重新聚类  
       if o_rand_sum<o_sum  
           cluster{recordN}(1,:)=o_random;  
           %将代表点放入对象集  
           CC=cat(1,CC,o);  
           %对所有对象重新进行聚类  
           %将cluster除第一行之外的数据全部清空  
           for i=1:k  
               c=cluster{i}(1,:);  
               cluster{i}=[];  
               cluster{i}=c;  
           end   
           %重新聚类  
           for i=1:num-k  
               %分别计算到三个点的距离         
               minValue=1000000;%最小值，要根据实际情况设定该值  
               minNum=-1;%最小值序号  
               for j=1:k  
                   if minValue>sqrt((CC(i,1)-C_temp(j,1))*(CC(i,1)-C_temp(j,1))+(CC(i,2)-C_temp(j,2))*(CC(i,2)-C_temp(j,2)))  
                       minValue=sqrt((CC(i,1)-C_temp(j,1))*(CC(i,1)-C_temp(j,1))+(CC(i,2)-C_temp(j,2))*(CC(i,2)-C_temp(j,2)));  
                       minNum=j;  
                   end  
               end  
               cluster{minNum}=cat(1,cluster{minNum},CC(i,:));         
           end             
       else  
           %将随机点重新放入对象集  
           CC=cat(1,CC,o_random);  
           %终止循环  
           flag=0;  
       end  
       count=count+1;  
   end
   %绘制聚类结果
   %%
   n = 0;
   
   for i=1:k  
     
       scatter(cluster{i}(:,1),cluster{i}(:,2),'filled');  
       for j = 1:size(cluster{i},1)
           n = n+1;
           labels(n) = i;
       end
       hold on  
       grid on;%显示表格
   end     
   
   %%               Index
classLabelvector = C{3};

z = Nmi(classLabelvector, labels);
ARI=RandIndex(labels,classLabelvector);
[Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(classLabelvector',labels);
Re = strcmp('euclidean', 'euclidean');

[DB,CH,KL,Han,st] = Valid_internal_deviation(CC_init,labels,Re);
distM=squareform(pdist(CC_init));
DI=Dunns(3,distM,labels);
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
tic
toc

%%
lis = [z,ARI,Purity,FMeasure,DB,DI];
fid = fopen('D:\\index\Kmedoids_index.txt', 'a');
for i=1:length(lis)
   fprintf(fid, '%f\n ', lis(i));
end
   fprintf(fid,'\r\n');
    fclose(fid);