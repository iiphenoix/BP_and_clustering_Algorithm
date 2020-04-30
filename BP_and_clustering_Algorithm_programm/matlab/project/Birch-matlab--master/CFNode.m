classdef CFNode < handle
    properties
        threshold; %浮点型，判断一个新的subcluster是否可以归入一个CFSubcluster.
        branching_factor; %整型，每个节点最多拥有的subclusters.
        is_leaf;  %bool型，需要判断每一个CFNode是否是叶子节点，方便后期返回最终的subclusters.
        n_features; % 整型，特征数.
        subclusters_; % 在特定CFNode中存储的subclusters的数组列表.
        init_centroids_; %大小为(branching_factor + 1, n_features),记录中心点.
        init_sq_norm_; % 大小为(branching_factor + 1)
        prev_leaf_; % CFNode型，当叶子节点条件满足时，此属性有用.
        next_leaf_; % CFNode型，当叶子节点条件满足时，此属性有用，遍历最后的subclusters.
        centroids_;
        squared_norm_;
    end
    methods
        function self=CFNode(threshold, branching_factor, is_leaf, n_features)
            self.threshold = threshold;
            self.branching_factor = branching_factor;
            self.is_leaf = is_leaf;
            self.n_features = n_features;
            self.subclusters_ = [];
            self.init_centroids_ =zeros((branching_factor + 1),n_features);
            self.init_sq_norm_ =zeros((branching_factor + 1),1);
            self.squared_norm_ = [];
            self.prev_leaf_=[];
            self.next_leaf_=[];
        end
        function append_subcluster(self,subcluster)
            n_samples=length(self.subclusters_);
            self.subclusters_=[self.subclusters_,subcluster];
            self.init_centroids_((n_samples+1),:) = subcluster.centroid_;
            self.init_sq_norm_(n_samples+1) = subcluster.sq_norm_;
            %扩容
            self.centroids_ = self.init_centroids_(1:(n_samples+1),:);
            self.squared_norm_ = self.init_sq_norm_(1:(n_samples+1));
        end
        function update_split_subclusters(self, subcluster,new_subcluster1, new_subcluster2)
            %从一个节点去掉一个subcluster，再添加两个subcluster.
            %ind = self.subclusters_.index(subcluster); %找到索引位置
            ind=index(self.subclusters_,subcluster);%?????????????????????
            self.subclusters_(ind) = new_subcluster1;
            self.init_centroids_(ind,:) = new_subcluster1.centroid_;
            self.init_sq_norm_(ind) = new_subcluster1.sq_norm_;
            self.append_subcluster(new_subcluster2);
        end
        function T=insert_cf_subcluster(self,subcluster)
            %插入一个新的subcluster.
            if length(self.subclusters_)==0
                self.append_subcluster(subcluster);
                T=0;
                return;
            end
            %首先，在树中遍历寻找与当前subcluster最近的subclusters，再将subcluster插入到此处.
            dist_matrix = self.centroids_*(subcluster.centroid_)'; %dot矩阵相乘
            dist_matrix = -2*dist_matrix;
            dist_matrix = dist_matrix+self.squared_norm_;
            [tmp,closest_index]=min(dist_matrix); %返回最小值及其下标索引
            closest_subcluster = self.subclusters_(closest_index); %距当前点最近的subclusters集
            % 如果closest_subcluster有孩子节点，递归遍历
            if (length(closest_subcluster.child_)~=0)
               split_child= closest_subcluster.child_.insert_cf_subcluster(subcluster);
                if ~ split_child
                    %如果孩子节点没有分裂，仅需要更新closest_subcluster
                   closest_subcluster.update(subcluster);
                   self.init_centroids_(closest_index,:) = self.subclusters_(closest_index).centroid_;
                   self.init_sq_norm_(closest_index) = self.subclusters_(closest_index).sq_norm_;
                   T=0;
                   return;
                else
                    %如果发生了分割，需要重新分配孩子节点中的subclusters，并且在其父节点中添加一个subcluster.
                     [new_subcluster1, new_subcluster2]= split_node(closest_subcluster.child_, self.threshold, self.branching_factor);
                     self.update_split_subclusters(closest_subcluster, new_subcluster1, new_subcluster2);
                     if length(self.subclusters_) > self.branching_factor
                         T=1;
                         return;
                     end
                     T=0;
                     return;
                end
            else
                %没有孩子节点
                merged= closest_subcluster.merge_subcluster(subcluster, self.threshold);
                self.subclusters_(closest_index)= closest_subcluster; %回写更新
                if merged
                    %更新操作
                    self.init_centroids_(closest_index,:) =closest_subcluster.centroid_;
                    self.init_sq_norm_(closest_index) = closest_subcluster.sq_norm_;
                    T=0;
                    return;
                else if length(self.subclusters_) < self.branching_factor
                        %待插入点和任何节点相距较远
                        self.append_subcluster(subcluster);
                        T=0;
                        return;
                    else
                        self.append_subcluster(subcluster);
                        T=1;
                        return;
                    end
                end
            end
        end
    end
end
