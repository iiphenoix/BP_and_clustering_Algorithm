function candidates3 = self_join(prev_dim_dense_units, dim)
candidates = [];
candidates3 = [];
for ii = 1:length(prev_dim_dense_units(:,1,1))
    for jj = ii+1: length(prev_dim_dense_units(:,1,1))
        candidates2 = insert_if_join_condition(candidates, prev_dim_dense_units(ii,1,:), prev_dim_dense_units(jj,1,:), dim);
        if(length(candidates2)>0)
            candidates3 = [candidates3;candidates2];
        end
    end
end
function candidates = insert_if_join_condition(candidates, item, item2, current_dim)
    joined = [];
    a = [];
    b = [];
    for i = 1:length(item(1,1,:))
        a = [a item(1,1,i)];
    end
    
      for i = 1:length(item2(1,1,:))
        b = [b item2(1,1,i)];
      end
        joined = [a;b];
% 
%         for i = 1:size(joined,1)
%              for j = 1:size(joined,2)
%                  fprintf('%d ',joined(i,j));
%              end
%              fprintf('\n');
%         end
        
   dims = [];
   for i = 1:length(joined)
       dims = [dims joined(i,1)];
       dims = unique(dims);
      
   end
%      fprintf('kk%d ',dims);
%      fprintf('\n');
%    fprintf('*********');
%    fprintf('\ndim\n',dims);
%       fprintf('*********');
   if(length(dims) == current_dim)
       candidates = [candidates;joined];
   end

 
end

end