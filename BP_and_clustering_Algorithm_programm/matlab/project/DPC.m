clear all;close all;clc;
% PM=load('Standard_DATA\Synthesis.txt');
%  PM=load('Standard_DATA\Aggregation.txt');
 PM=load('Standard_DATA\Compound.txt');
% PM=load('Standard_DATA\Flame.txt');
% PM=load('Standard_DATA\R15.txt');
% PM=load('Standard_DATA\spiral.txt');


data = PM(:,1:2);
[m,n] = size(data);
xx = cell(1,3,1);
num =0;
for i = 1:size(data,1)
    for j = i+1:size(data,1)
        distance = sqrt( (data(i,1) - data(j,1))*(data(i,1) - data(j,1))+(data(i,2) - data(j,2))*(data(i,2) - data(j,2))) ;
        num = num+1;
        xx{1}(num) = i;
        xx{2}(num) = j;
        xx{3}(num) = distance;
    end
end
ND = max(xx{1});
NL = max(xx{2});
if(NL>ND)
   ND = NL; 
end
N = num;
%% 这里不考虑对角线元素  
for i=1:N  
  ii=xx{1}(i);
  jj=xx{2}(i);
  dist(ii,jj)=xx{3}(i);
  dist(jj,ii)=xx{3}(i);
end  
  
%% 确定 dc  
  
percent=3.0;  

% 
%  PREFORMATTED
%  TEXT
% 

  
position=round(N*percent/100); %% round 是一个四舍五入函数  
sda = sort(xx{3});  %% 对所有距离值作升序排列  
dc=sda(position);  
%  2.3162
  dc = 1.7444
%% 计算局部密度 rho (利用 Gaussian 核)  

  
%% 将每个数据点的 rho 值初始化为零  
for i=1:ND  
  rho(i)=0.;  
end  
  
% Gaussian kernel  
for i=1:ND-1  
  for j=i+1:ND  
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));  
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));  
  end  
end  
  
  
%% 先求矩阵列最大值，再求最大值，最后得到所有距离值中的最大值  
maxd=max(max(dist));   
  
%% 将 rho 按降序排列，ordrho 保持序  
[rho_sorted,ordrho]=sort(rho,'descend');  
   
%% 处理 rho 值最大的数据点  
delta(ordrho(1))=-1.;  
nneigh(ordrho(1))=0;  
  
%% 生成 delta 和 nneigh 数组  
for ii=2:ND  
   delta(ordrho(ii))=maxd;  
   for jj=1:ii-1  
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))  
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));  
        nneigh(ordrho(ii))=ordrho(jj);   
        %% 记录 rho 值更大的数据点中与 ordrho(ii) 距离最近的点的编号 ordrho(jj)  
     end  
   end  
end  
  
%% 生成 rho 值最大数据点的 delta 值  
delta(ordrho(1))=max(delta(:));  
  
%% 决策图  
  


  
%% 选择一个围住类中心的矩形  

  
%% 每台计算机，句柄的根对象只有一个，就是屏幕，它的句柄总是 0  
%% >> scrsz = get(0,'ScreenSize')  
%% scrsz =  
%%            1           1        1280         800  
%% 1280 和 800 就是你设置的计算机的分辨率，scrsz(4) 就是 800，scrsz(3) 就是 1280  
scrsz = get(0,'ScreenSize');  
  
%% 人为指定一个位置，感觉就没有那么 auto 了 :-)  
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);  
  
%% ind 和 gamma 在后面并没有用到  
for i=1:ND  
  ind(i)=i;   
  gamma(i)=rho(i)*delta(i);  
end  
  
%% 利用 rho 和 delta 画出一个所谓的“决策图”  
  
subplot(2,1,1)  
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');  
title ('Decision Graph','FontSize',15.0)  
xlabel ('\rho')  
ylabel ('\delta')  
  
subplot(2,1,1)  
rect = getrect(1);   
%% getrect 从图中用鼠标截取一个矩形区域， rect 中存放的是  
%% 矩形左下角的坐标 (x,y) 以及所截矩形的宽度和高度  
rhomin=rect(1);  
deltamin=rect(2); %% 作者承认这是个 error，已由 4 改为 2 了!  
  
%% 初始化 cluster 个数  
NCLUST=0;  
  
%% cl 为归属标志数组，cl(i)=j 表示第 i 号数据点归属于第 j 个 cluster  
%% 先统一将 cl 初始化为 -1  
for i=1:ND  
  cl(i)=-1;  
end  
  
%% 在矩形区域内统计数据点（即聚类中心）的个数  
for i=1:ND  
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))  
     NCLUST=NCLUST+1;  
     cl(i)=NCLUST; %% 第 i 号数据点属于第 NCLUST 个 cluster  
     icl(NCLUST)=i;%% 逆映射,第 NCLUST 个 cluster 的中心为第 i 号数据点  
  end  
end  
%% 将其他数据点归类 (assignation)  
for i=1:ND  
  if (cl(ordrho(i))==-1)  
    cl(ordrho(i))=cl(nneigh(ordrho(i)));  
  end  
end  
%% 由于是按照 rho 值从大到小的顺序遍历,循环结束后, cl 应该都变成正的值了.   
  
%% 处理光晕点，halo这段代码应该移到 if (NCLUST>1) 内去比较好吧  
for i=1:ND  
  halo(i)=cl(i);  
end  
  
if (NCLUST>1)  
  
  % 初始化数组 bord_rho 为 0,每个 cluster 定义一个 bord_rho 值  
  for i=1:NCLUST  
    bord_rho(i)=0.;  
  end  
  
  % 获取每一个 cluster 中平均密度的一个界 bord_rho  
  for i=1:ND-1  
    for j=i+1:ND  
      %% 距离足够小但不属于同一个 cluster 的 i 和 j  
      if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))  
        rho_aver=(rho(i)+rho(j))/2.; %% 取 i,j 两点的平均局部密度  
        if (rho_aver>bord_rho(cl(i)))   
          bord_rho(cl(i))=rho_aver;  
        end  
        if (rho_aver>bord_rho(cl(j)))   
          bord_rho(cl(j))=rho_aver;  
        end  
      end  
    end  
  end  
  
  %% halo 值为 0 表示为 outlier  
  for i=1:ND  
    if (rho(i)<bord_rho(cl(i)))  
      halo(i)=0;  
    end  
  end  
  
end  
  
 %%
% for i=1:NCLUST  
%   nc=0; %% 用于累计当前 cluster 中数据点的个数  
%   nh=0; %% 用于累计当前 cluster 中核心数据点的个数  
%   for j=1:ND  
%     if (cl(j)==i)   
%       nc=nc+1;  
%     end  
%     if (halo(j)==i)   
%       nh=nh+1;  
%     end  
%   end  
% 
%   
% end  
%% 逐一处理每个 cluster  
cmap=colormap;  
for i=1:NCLUST  
   ic=int8((i*64.)/(NCLUST*1.));  
   subplot(2,1,1)  
   hold on  
   plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));  
end  


subplot(2,1,2)  
Y1 = PM(:,1:2);
plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');  
title ('2D Nonclassical multidimensional scaling','FontSize',15.0)  
xlabel ('X')  



% ylabel ('Y')  
for i=1:ND  
 A(i,1)=0.;  
 A(i,2)=0.;  
end  
kkk =0 ;
J = [];
for i=1:NCLUST  
  nn=0;  
  ic=int8((i*64.)/(NCLUST*1.));  
  for j=1:ND  
    if (halo(j)==i)  
      nn=nn+1;  
      A(nn,1)=Y1(j,1);  
      A(nn,2)=Y1(j,2);  
      J = [J j];
    end  
  end  
  
  for jj = 1:size(A(1:nn,1),1)
      kkk=kkk+1;
      labels(kkk) = i; 
  end
  hold on  
  plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));  
  
  
  
  
end 
X = data;
%%               Index
classLabelvector = PM(:,3:3);
classLabelvector = classLabelvector(J);
z = Nmi(labels,classLabelvector);
ARI=RandIndex(labels,classLabelvector);
[FMeasure,Accuracy] = FM(classLabelvector',labels);

Re = strcmp('euclidean', 'euclidean');
[DB,CH,KL,Han,st] = Valid_internal_deviation(X,labels,Re);
distM=squareform(pdist(X));
DI=Dunns(3,distM,labels)   ;
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,FMeasure,DB,DI);


[Entropy,Purity] = EnAndPur(classLabelvector',labels);
fprintf('the index is %f %f %f %f %f %f\n',z,ARI,Purity,FMeasure,DB,DI);
tic
toc

 %%
% lis = [z,ARI,Purity,FMeasure,DB,DI];
% fid = fopen('D:\\index\DPC_index.txt', 'a');
% for i=1:length(lis)
%    fprintf(fid, '%f\n ', lis(i));
% end
% 
%    fprintf(fid,'\r\n');
%  fclose(fid);