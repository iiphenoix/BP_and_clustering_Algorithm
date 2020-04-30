function clusters = get_clusters(dense_units, data, xsi)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
graph= build_graph_from_dense_units(dense_units);


fprintf('\n****dense****');
fprintf('% d',dense_units);
fprintf('*********');


fprintf('\n****graph******');
fprintf('% d',graph);
fprintf('*********');
% graph = [1     1     0     0;1 1 0 0;0 0 1 1;0 0 1 1 ]
% [ci sizes] = components(graph) ;
graph = sparse(graph);
[S,C] = graphconncomp(graph);
 component_list = C;
 number_of_components = S;
 clusters = cell(3,2);
for i = 1:number_of_components
    cluster_dense_units = dense_units(find(component_list == i),:,:);
    fprintf('****cluster_dense_units******')
    fprintf('%d ',size(cluster_dense_units));
    dimensions = [];
    for j = 1:size(cluster_dense_units,1)
        for k =1:size(cluster_dense_units,2)
            
              dimensions = [dimensions cluster_dense_units(j,k,1)];
              
        end
    end
    dimensions = unique(dimensions);
    cluster_data_point_ids = get_cluster_data_point_ids(data, cluster_dense_units, xsi);
    clusters{i,1} = cluster_dense_units;
    clusters{i,2} = dimensions;
    clusters{i,3} = length(cluster_data_point_ids);
    clusters{i,4} = cluster_data_point_ids';
%     fprintf('%f ', cluster_data_point_ids)
%     fprintf('\n');
%      clusters  = [clusters Cluster(cluster_dense_units,dimensions, cluster_data_point_ids)];
%     clusters = [cluster_dense_units;dimensions;length(cluster_data_point_ids);cluster_data_point_ids]
end
 fprintf(' %f ',dimensions);
end

