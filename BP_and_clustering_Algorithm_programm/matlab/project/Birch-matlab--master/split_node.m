function [new_subcluster1, new_subcluster2]=split_node(node, threshold, branching_factor) 
%-------------------当空间不足时，需要分裂---------------
%     1.两个空的节点和两个空的subcluster被初始化.
%     2.建立subclusters的点对距离.
%     3.根据最近距离的subcluster，更新空的节点和subcluster.
%     4.两个节点更新为两个subcluster的孩子节点.
new_subcluster1 = CFSubcluster([]);
new_subcluster2 = CFSubcluster([]);
is_leaf=node.is_leaf;
n_features=node.n_features;
new_node1 = CFNode(threshold, branching_factor,is_leaf,n_features);
new_node2 = CFNode(threshold, branching_factor, is_leaf,n_features);
new_subcluster1.child_ = new_node1;
new_subcluster2.child_ = new_node2;
if node.is_leaf
     if size(node.prev_leaf_,1)~=0
        node.prev_leaf_.next_leaf_ = new_node1;
     end
    new_node1.prev_leaf_ = node.prev_leaf_;
    new_node1.next_leaf_ = new_node2;
    new_node2.prev_leaf_ = new_node1;
    new_node2.next_leaf_ = node.next_leaf_;
    if size(node.next_leaf_,1)~=0
        node.next_leaf_.prev_leaf_ = new_node2;
    end
end

h=dist(node.centroids_,(node.centroids_)');
distance =h.^2;
[~,S]=max(distance(:));  %先求一维，再转换坐标
[farthest_idx(1),farthest_idx(2)]= ind2sub(size(distance),S);
node1_dist=distance(farthest_idx(1),:);
node2_dist = distance(farthest_idx(2),:); 
node1_closer = node1_dist <= node2_dist;
for i=1:length(node.subclusters_)
    idx=i;
    subcluster=node.subclusters_(i);
    if node1_closer(idx)
        new_node1.append_subcluster(subcluster);
        new_subcluster1.update(subcluster);
    else
        new_node2.append_subcluster(subcluster);
        new_subcluster2.update(subcluster);
    end
end
end