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
%% ���ﲻ���ǶԽ���Ԫ��  
for i=1:N  
  ii=xx{1}(i);
  jj=xx{2}(i);
  dist(ii,jj)=xx{3}(i);
  dist(jj,ii)=xx{3}(i);
end  
  
%% ȷ�� dc  
  
percent=3.0;  

% 
%  PREFORMATTED
%  TEXT
% 

  
position=round(N*percent/100); %% round ��һ���������뺯��  
sda = sort(xx{3});  %% �����о���ֵ����������  
dc=sda(position);  
%  2.3162
  dc = 1.7444
%% ����ֲ��ܶ� rho (���� Gaussian ��)  

  
%% ��ÿ�����ݵ�� rho ֵ��ʼ��Ϊ��  
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
  
  
%% ������������ֵ���������ֵ�����õ����о���ֵ�е����ֵ  
maxd=max(max(dist));   
  
%% �� rho ���������У�ordrho ������  
[rho_sorted,ordrho]=sort(rho,'descend');  
   
%% ���� rho ֵ�������ݵ�  
delta(ordrho(1))=-1.;  
nneigh(ordrho(1))=0;  
  
%% ���� delta �� nneigh ����  
for ii=2:ND  
   delta(ordrho(ii))=maxd;  
   for jj=1:ii-1  
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))  
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));  
        nneigh(ordrho(ii))=ordrho(jj);   
        %% ��¼ rho ֵ��������ݵ����� ordrho(ii) ��������ĵ�ı�� ordrho(jj)  
     end  
   end  
end  
  
%% ���� rho ֵ������ݵ�� delta ֵ  
delta(ordrho(1))=max(delta(:));  
  
%% ����ͼ  
  


  
%% ѡ��һ��Χס�����ĵľ���  

  
%% ÿ̨�����������ĸ�����ֻ��һ����������Ļ�����ľ������ 0  
%% >> scrsz = get(0,'ScreenSize')  
%% scrsz =  
%%            1           1        1280         800  
%% 1280 �� 800 ���������õļ�����ķֱ��ʣ�scrsz(4) ���� 800��scrsz(3) ���� 1280  
scrsz = get(0,'ScreenSize');  
  
%% ��Ϊָ��һ��λ�ã��о���û����ô auto �� :-)  
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);  
  
%% ind �� gamma �ں��沢û���õ�  
for i=1:ND  
  ind(i)=i;   
  gamma(i)=rho(i)*delta(i);  
end  
  
%% ���� rho �� delta ����һ����ν�ġ�����ͼ��  
  
subplot(2,1,1)  
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');  
title ('Decision Graph','FontSize',15.0)  
xlabel ('\rho')  
ylabel ('\delta')  
  
subplot(2,1,1)  
rect = getrect(1);   
%% getrect ��ͼ��������ȡһ���������� rect �д�ŵ���  
%% �������½ǵ����� (x,y) �Լ����ؾ��εĿ�Ⱥ͸߶�  
rhomin=rect(1);  
deltamin=rect(2); %% ���߳������Ǹ� error������ 4 ��Ϊ 2 ��!  
  
%% ��ʼ�� cluster ����  
NCLUST=0;  
  
%% cl Ϊ������־���飬cl(i)=j ��ʾ�� i �����ݵ�����ڵ� j �� cluster  
%% ��ͳһ�� cl ��ʼ��Ϊ -1  
for i=1:ND  
  cl(i)=-1;  
end  
  
%% �ھ���������ͳ�����ݵ㣨���������ģ��ĸ���  
for i=1:ND  
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))  
     NCLUST=NCLUST+1;  
     cl(i)=NCLUST; %% �� i �����ݵ����ڵ� NCLUST �� cluster  
     icl(NCLUST)=i;%% ��ӳ��,�� NCLUST �� cluster ������Ϊ�� i �����ݵ�  
  end  
end  
%% ���������ݵ���� (assignation)  
for i=1:ND  
  if (cl(ordrho(i))==-1)  
    cl(ordrho(i))=cl(nneigh(ordrho(i)));  
  end  
end  
%% �����ǰ��� rho ֵ�Ӵ�С��˳�����,ѭ��������, cl Ӧ�ö��������ֵ��.   
  
%% ������ε㣬halo��δ���Ӧ���Ƶ� if (NCLUST>1) ��ȥ�ȽϺð�  
for i=1:ND  
  halo(i)=cl(i);  
end  
  
if (NCLUST>1)  
  
  % ��ʼ������ bord_rho Ϊ 0,ÿ�� cluster ����һ�� bord_rho ֵ  
  for i=1:NCLUST  
    bord_rho(i)=0.;  
  end  
  
  % ��ȡÿһ�� cluster ��ƽ���ܶȵ�һ���� bord_rho  
  for i=1:ND-1  
    for j=i+1:ND  
      %% �����㹻С��������ͬһ�� cluster �� i �� j  
      if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))  
        rho_aver=(rho(i)+rho(j))/2.; %% ȡ i,j �����ƽ���ֲ��ܶ�  
        if (rho_aver>bord_rho(cl(i)))   
          bord_rho(cl(i))=rho_aver;  
        end  
        if (rho_aver>bord_rho(cl(j)))   
          bord_rho(cl(j))=rho_aver;  
        end  
      end  
    end  
  end  
  
  %% halo ֵΪ 0 ��ʾΪ outlier  
  for i=1:ND  
    if (rho(i)<bord_rho(cl(i)))  
      halo(i)=0;  
    end  
  end  
  
end  
  
 %%
% for i=1:NCLUST  
%   nc=0; %% �����ۼƵ�ǰ cluster �����ݵ�ĸ���  
%   nh=0; %% �����ۼƵ�ǰ cluster �к������ݵ�ĸ���  
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
%% ��һ����ÿ�� cluster  
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