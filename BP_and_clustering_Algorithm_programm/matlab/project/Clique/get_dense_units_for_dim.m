function candidates2 = get_dense_units_for_dim(data, prev_dim_dense_units, dim, xsi, tau)
 candidate = self_join(prev_dim_dense_units, dim);
  candidates = {};
  kk = 1;
 for i = 1:size(candidate,1)/2
     candidates{i,1} = candidate(kk,:);
     candidates{i,2} = candidate(kk+1,:);
     kk = kk+2;
 end

   prune(candidates, prev_dim_dense_units);
projection = zeros(1,length(candidates));
 number_of_data_points = size(data,1);
 for dataIndex = 1:number_of_data_points
    for i = 1:length(candidates)
         if (is_data_in_projection(vpa(data(dataIndex,:)), candidates(i,:), xsi))
             projection(i) = projection(i) + 1;
     end
     end
 end
 fprintf('project %f  ',projection);

 is_dense = projection > tau * number_of_data_points;
%  
%  fprintf('****');
%  fprintf('%f ',is_dense);
%  fprintf('****');
%  k=0;
 k=0;
 candidates2 = {};
 for i = 1:length(is_dense)
     if(is_dense(i) == 1)
         k = k+1;
         for j = 1:length(candidates(i,:))
             candidates2{k,j} =candidates{i,j}; 
         end
         
     end
 end

end
