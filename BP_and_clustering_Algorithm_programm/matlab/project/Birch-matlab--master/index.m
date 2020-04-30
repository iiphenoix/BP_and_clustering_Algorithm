function idx=index(subclusters_,subcluster)
n=length(subclusters_);
for i=1:n
    if(subcluster.squared_sum_==subclusters_(i).squared_sum_)
        idx=i;
        break;
    end
end
end