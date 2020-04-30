 function [IDX, isnoise]=DBSCAN(X,epsilon,MinPts)
    C=0;
    n=size(X,1);
    IDX=zeros(n,1);
    D=pdist2(X,X);  %求欧式距离
    visited=zeros(n,1);
    isnoise=zeros(n,1);
    
    for i=1:n
        if visited(i)==0
            visited(i)=1;
            
            Neighbors=RegionQuery(i); %下标
            if length(Neighbors)<MinPts
                % X(i,:) is NOISE
                isnoise(i)=1;
            else
                C=C+1;
                ExpandCluster(i,Neighbors,C);
            end
            
        end
    end
    
    function ExpandCluster(i,Neighbors,C)
        IDX(i)=C;
        k = 1;
        while true
            j = Neighbors(k);
            
            if visited(j)==0
                visited(j)=1;
                Neighbors2=RegionQuery(j);
                if length(Neighbors2)>=MinPts
                    Neighbors=[Neighbors Neighbors2];   %#ok
                end
            end
            if IDX(j)==0
                IDX(j)=C;
            end
            
            k = k + 1;
            if k > length(Neighbors)
                break;
            end
        end
    end
    
    function Neighbors=RegionQuery(i)
        Neighbors=find(D(i,:)<=epsilon);
    end
end