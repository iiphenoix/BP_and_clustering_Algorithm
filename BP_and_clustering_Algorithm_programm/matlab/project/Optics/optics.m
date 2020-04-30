function [RD,CD,order,labels,kkk]=optics(x,k)
[m,n]=size(x);
CD=zeros(1,m);
RD=ones(1,m)*10^10;
for i=1:m 
D=sort(dist(x(i,:),x));
CD(i)=D(k+1); 
end
order=[];
seeds=[1:m];
ind=1;

while ~isempty(seeds)
ob=seeds(ind); 
seeds(ind)=[]; 
order=[order ob];
mm=max([ones(1,length(seeds))*CD(ob);dist(x(ob,:),x(seeds,:))]);
ii=(RD(seeds))>mm;
RD(seeds(ii))=mm(ii);
[i1 ind]=min(RD(seeds));
end 
RD(1)=max(RD(2:m))+.1*max(RD(2:m));
plot(RD(order));



reach_distIds=find(RD(order) <= k);
pre=reach_distIds(1)-1;
clusterId=1;
labels=ones(1,m)*(-1);
for i  = 1:length(reach_distIds)
    current = reach_distIds(i);
    if(current - pre ~= 1)
        clusterId=clusterId+1;
    end
     labels(order(current))=clusterId;
     pre = current;
    
end

end

