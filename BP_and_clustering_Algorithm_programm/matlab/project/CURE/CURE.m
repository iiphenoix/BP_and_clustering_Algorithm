clear all;
close all;
clc;

%��������
PM=load('Standard_DATA\Synthesis.txt');
 PM=load('Standard_DATA\Aggregation.txt');
 PM=load('Standard_DATA\Compound.txt');
PM=load('Standard_DATA\Flame.txt');
PM=load('Standard_DATA\R15.txt');
PM=load('Standard_DATA\spiral.txt');
data = PM(:,1:2);

%curd ����
crs(1,:)=data(1,:);  %candidate reference set ��ѡ�ο���
number(1)=1;  %λ�ڵ�һ������ݸ���
N=1; %��ѡ�ο���ĸ���
Iterate=9;  %ѭ������
Radius=8; %����2
T=15; %ɸѡ�ο������ֵ
%class; %����

%���ɺ�ѡ�ο���
I=1;
data(1,:)=[];
while(I<Iterate)
PM=load('Standard_DATA\Synthesis.txt');
 PM=load('Standard_DATA\Aggregation.txt');
 PM=load('Standard_DATA\Compound.txt');
PM=load('Standard_DATA\Flame.txt');
PM=load('Standard_DATA\R15.txt');
PM=load('Standard_DATA\spiral.txt');
data = PM(:,1:2);
%%
   while(~isempty(data))
       i=1;
       while(i<=N)
           dis=Distance(crs(i,:),data(1,:));
           %dis=sqrt(sum((average(i,:)-data(1,:)).^2));
           if dis <=Radius;
               %snum(i,:)=data(1,:);
               crs(i,:)=(crs(i,:)*number(i)+data(1,:))/(number(i)+1);
               data(1,:)=[];
               number(i)=number(i)+1;
               break;
           else
               i=i+1;
           end
       end
       if i>N
           N=N+1;
           crs(N,:)=data(1,:);
           number(N)=1;
           data(1,:)=[];
       end
   end
   I=I+1;
end


%���ɲο���
%���ɲο����
%N��ʾ�ο������Ŀ,
i=1;
while(i<=N)
   if number(i)<T;
       number(i)=[];
       crs(i,:)=[];
       N=N-1;
   else
       i=i+1;
   end
end

%%
%�Բο��㾭�з���

%��һ�� ��������ͼ
tu=[1:N]';
tu(:,2)=0;
i=1;
while(i<=N)
    j=i+1;
    while(j<=N)
        dis=Distance(crs(i,:),crs(j,:));
        if dis<=2*Radius
            tu(i,2)=j;
            break;
        else
            j=j+1;
        end
    end
    if (j>N && tu(i,2)>0)
       j=1;
       while (j<=i)
          dis=Distance(crs(i,:),crs(j,:)); 
          if dis<=2*Radius
              k=2;
              while(tu(j,k)>0)
                 k=k+1; 
              end
             tu(j,k)=i;
             break;
          else
              j=j+1;
          end
       end
    else
        i=i+1;
    end
end
%%
%�ڶ��� ����ͼ�Ĺ�������������Ժ�ѡ�ο�����з���
k=1;%�ڼ���
i=1; %���
while(~isempty(tu))
    class(k,1)=tu(1,1);
    if tu(1,2)==0
        tu(1,:)=[];
    else
        i=2;
        j=sum(tu(1,:)>0);
        class(k,2:j)=tu(1,2:j);
        tu(1,:)=[];
        t=sum(class(k,:)>0);
        while i<=t
            m1=find(tu(:,1)==class(k,i));
            j=sum(tu(m1,:)>0);
            if j>1
                class(k,t+1:j+t-1)=tu(m1,2:j); 
                tu(m1,:)=[];
            else
                tu(m1,:)=[];
                break;
            end
            t=sum(class(k,:)>0);
           i=i+1;
        end
    end
    k=k+1;
    fprintf('%d',k);
end

%%
i=1;
while i<=N
    m=find(class==i);
    if length(m)>1
        l1=length(class(:,1));
        m1=rem(m(1),l1);
        j=2;
        while j<=length(m)
            m2=rem(m(j),l1);
            n2=fix(m(j)/l1);
            n1=sum(class(m1,:)>0);
            class(m1,n1:n1+n2)=class(m2,1:n2+1);
            j=j+1;
        end
        j=length(m);
        while j>1
           m2=rem(m(j),l1);
           class(m2,:)=[];
           j=j-1;
        end
    end
    i=i+1;
end

%%
%�ο��������ݵ�ӳ��
%��������
PM=load('Standard_DATA\Synthesis.txt');
 PM=load('Standard_DATA\Aggregation.txt');
 PM=load('Standard_DATA\Compound.txt');
PM=load('Standard_DATA\Flame.txt');
PM=load('Standard_DATA\R15.txt');
PM=load('Standard_DATA\spiral.txt');
data = PM(:,1:2);
M=length(class(:,1));
Mdata=length(data(:,1));
i=1;
while i<=Mdata
    j=1;
    while j<=N
        dis=Distance(crs(j,1:2),data(i,1:2)); 
        if dis<=Radius
            m=find(class==j);
            n=fix(m/M)+1;
            
              [len,nn] = size(n);
             if len >1
            data(i,3)=n(1);
             elseif len ==1
                  data(i,3) = n(1,1);
          
             elseif len == 0
                 fprintf('1');
                 
             end
            break;
        end
        j=j+1;
    end
    if j>N
       data(i,3)=0;
    end
   i=i+1;
end





%% �����ʾ����������

labels = data(:,3:3)+1;
clusterNum = max(labels);
for i = min(labels):clusterNum
    subCluster = data(find(labels == i),:);
    scatter(subCluster(:, 1), subCluster(:, 2),'fill');
    hold on  ;
    grid on;%��ʾ���
end

%%               FM-Index
classLabelvector = PM(:,3:3);
[TP,FN,FP,TN]=New_index(classLabelvector',labels');
FM=sqrt((TP/(TP+FP))*(TP/(TP+FN))); 
z = Nmi(labels,classLabelvector);
ARI=RandIndex(labels,classLabelvector);

% [Entropy,Purity,FMeasure,Accuracy] = Fm_Pur(classLabelvector',labels');
Re = strcmp('euclidean', 'euclidean');
[DB,CH,KL,Han,st] = Valid_internal_deviation(PM(:,1:2),labels,Re);
distM=squareform(pdist(PM(:,1:2)));
DI=Dunns(3,distM,labels);
% [FMeasure,Accuracy] = FM(classLabelvector',labels');
fprintf('the index is %f  %f %f  %f\n',z,ARI,DB,DI);
toc

%%
% lis = [z,ARI,Purity,FMeasure,DB,DI];
% fid = fopen('D:\\index\Cure_index.txt', 'a');
% for i=1:length(lis)
%    fprintf(fid, '%f\n ', lis(i));
% end
%    fprintf(fid,'\r\n');
%    
%     fclose(fid);