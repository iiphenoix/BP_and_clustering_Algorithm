function point_ids = get_cluster_data_point_ids(data, cluster_dense_units, xsi)
%UNTITLED9 此处显示有关此函数的摘要
%   此处显示详细说明
point_ids = [];
[m,n,l] = size(cluster_dense_units);
for i  = 1:m
    tmp_ids = 1:length(data);
    for j = 1:n
        feature_index = cluster_dense_units(i,j,1);
        range_index = cluster_dense_units(i,j,2);
        a = floor(vpa(rem(vpa(data(:, feature_index+1) * xsi) , xsi)));
        if(a==0)
            a=1;
        end
        tt = find(a   ==range_index  );
% %         fprintf(' %d  ',tt);
        
%         fprintf(' %d  ',tmp_ids);
        tmp_ids = intersect(tmp_ids,tt);
    end
     point_ids = union(point_ids,tmp_ids);
     point_ids = unique(point_ids);
    
end
%  fprintf(' %d  ',point_ids);

end

