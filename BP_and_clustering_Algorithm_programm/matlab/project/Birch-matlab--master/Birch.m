classdef Birch < handle %�̳�handle��
    properties
        threshold;
        branching_factor;
        n_clusters;
        root_;
        dummy_leaf_;
        subcluster_centers_;
        subcluster_norms;
        subcluster_labels_;
    end
    methods
        function self=Birch(threshold, branching_factor, n_clusters)
            self.threshold = threshold;
            self.branching_factor = branching_factor;
            self.n_clusters = n_clusters;
        end
        function self=fit(self,X)
            THD = self.threshold;
            B = self.branching_factor;
            if self.branching_factor <= 1
                fprintf ('Branching_factor should be greater than one.');
            end
            [n_samples, n_features]= size(X);
            %只能�?��建完树！！！�?            %�?��建立的root节点是叶�?
            is_leaf=1;
            self.root_ = CFNode(THD, B, is_leaf,n_features);
            self.dummy_leaf_ = CFNode(THD, B, is_leaf,n_features); %用于记录叶子节点
            self.dummy_leaf_.next_leaf_=self.root_;
            self.root_.prev_leaf_=self.dummy_leaf_;
            for i=1:size(X,1)
                linear_sum=X(i,:);
                subcluster =CFSubcluster(linear_sum);
                split = self.root_.insert_cf_subcluster(subcluster);    
                if split
                    [new_subcluster1, new_subcluster2] =split_node(self.root_,THD,B);
                    %重写数据
                    delete(self.root_);
                    self.root_=CFNode(THD,B,0,n_features);
                    self.root_.append_subcluster(new_subcluster1);
                    self.root_.append_subcluster(new_subcluster2);
                end
            end
            leavies=self.get_leaves();
            centroids=[];
            for i=1:length(leavies)
                centroids=[centroids;leavies(i).centroids_];
            end
            self.subcluster_centers_ = centroids;
            self.global_clustering(X);
        end
        function leaves=get_leaves(self)
            %返回CFNode的叶子节�?            leaf_ptr =self.dummy_leaf_.next_leaf_ ;
            leaves = [];
            while length(leaf_ptr) ~=0
                leaves=[leaves,leaf_ptr];
                leaf_ptr = leaf_ptr.next_leaf_;
            end
        end
        function labels=predict(self,X)
            %         根据subcluster是的centroids，进行labels预测
            %         避免
            %         Avoid computation of the row norms of X.
            % 
            %         参数：X
            %         ----------
            %         返回：labels: ndarray�? 大小�?n_samples)
            reduced_distance =X*(self.subcluster_centers_)';
            reduced_distance = -2*reduced_distance;
            temp_norms=repmat(self.subcluster_norms,size(X,1),1);
            reduced_distance = temp_norms+reduced_distance;
            [tmp,index]=min(reduced_distance,[],2);
            labels=self.subcluster_labels_(index);
        end
        function global_clustering(self,X)
            %对fitting之后获得的subclusters进行global_clustering
            clusterer = self.n_clusters;
            centroids = self.subcluster_centers_;
            % 预处�?            not_enough_centroids = 0;
            if length(centroids) < self.n_clusters
                not_enough_centroids = 1;
            end
            %避免predict环节，重复运�?            self.subcluster_norms =dot((self.subcluster_centers_)',(self.subcluster_centers_)');
            if not_enough_centroids
                self.subcluster_labels_ = [1:1:length(centroids)];
                if not_enough_centroids
                    fprintf('Number of subclusters found (%f) by Birch is less than (%f). Decrease the threshold.',(length(centroids)), self.n_clusters);
                end
            else
                %对所有叶子节点的subcluster进行聚类，它将subcluster的centroids作为样本，并且找到最终的centroids.
                Z=linkage(self.subcluster_centers_,'ward');
                self.subcluster_labels_ =cluster(Z,clusterer);
            end
        end
    end
end
        
            
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        
