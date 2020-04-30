function [clusters1,clusters2,dense_units,dense_units2] = run_clique( data,xsi,tau )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

dense_units = get_one_dim_dense_units(data, tau, xsi);
dense_units = dense_units -1;
 fprintf(' %f',dense_units);
clusters1 = get_clusters(dense_units, data, xsi);
current_dim = 2;
number_of_features = size(data,2);

% while (current_dim <= number_of_features) && (length(dense_units(:,1,1)) > 0)
dense_units1 = get_dense_units_for_dim(data, dense_units, current_dim, xsi, tau);

% m,n = size(dense_units);
m = length(dense_units1);
n = length(dense_units1(1,:));
for i = 1:m
    a = [];
    for j = 1:n
        a = [a;dense_units1{i,j}]; 
    end
    dense_units2(:,:,i) = a ;
end
dense_units2 = permute(dense_units2,[3,1,2]);
% dense_units2 = permute(dense_units2,[1,3,2])
fprintf('***dense_units2******');
fprintf(' %d  ',dense_units2);
fprintf('*********');
%    for cluster  = get_clusters(dense_units, data, xsi) 
      clusters2 = get_clusters(dense_units2, data, xsi) ;
   end
%     current_dim = current_dim+1;
    
% end



% clusters = dense_units;






