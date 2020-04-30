classdef CFSubcluster < handle
    properties
        linear_sum;
        n_samples_;
        centroid_;
        squared_sum_;
        linear_sum_;
        sq_norm_;
        child_;
    end
    methods
        function self=CFSubcluster(sample)
            if size(sample,1)==0
                self.n_samples_ = 0;
                self.squared_sum_ = 0.0;
                %self.linear_sum_ =[0.0 0.0 0.0];
                self.linear_sum_ =[0.0 0.0];
            else
                self.n_samples_ = 1;
                self.centroid_ =sample;
                self.linear_sum_ =sample;
                self.squared_sum_ =dot(self.linear_sum_,self.linear_sum_);
                self.sq_norm_ =self.squared_sum_;
            end
            self.child_ =[];
        end
        function update(self, subcluster)
            self.n_samples_ = self.n_samples_+subcluster.n_samples_;
            self.linear_sum_ =self.linear_sum_+subcluster.linear_sum_;
            self.squared_sum_ = self.squared_sum_ +subcluster.squared_sum_;
            self.centroid_ = self.linear_sum_ / self.n_samples_;
            self.sq_norm_ =dot(self.centroid_, self.centroid_); %返回俩俩距离
        end
        function T=merge_subcluster(self, nominee_cluster, threshold)  
            %�?��是否可以合并，条件符合就合并.
            new_ss = self.squared_sum_ + nominee_cluster.squared_sum_;
            new_ls = self.linear_sum_ + nominee_cluster.linear_sum_;
            new_n = self.n_samples_ + nominee_cluster.n_samples_;
            new_centroid = (1 / new_n) * new_ls;
            new_norm = dot(new_centroid, new_centroid);
            dot_product = (-2 * new_n) * new_norm;
            sq_radius = (new_ss + dot_product) / new_n + new_norm;
            if sq_radius <= threshold ^2
                self.n_samples_= new_n; 
                self.linear_sum_=new_ls;
                self.squared_sum_=new_ss;
                self.centroid_=new_centroid;
                self.sq_norm_=new_norm;
                T=1;
                return;
            else
                T=0;
                return;
            end
        end
    end
end


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
