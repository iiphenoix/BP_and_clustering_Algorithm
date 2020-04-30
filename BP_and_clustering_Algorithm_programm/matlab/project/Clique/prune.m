function prune(candidates, prev_dim_dense_units)
%UNTITLED13 此处显示有关此函数的
flag = 0;

kk = size(prev_dim_dense_units,1);
tt =  size(prev_dim_dense_units,2);
bb =  size(prev_dim_dense_units,3);
for i = 1:kk
    for j = 1:tt
        for k =1:bb
    dim_dense_units{i,j}(k) = prev_dim_dense_units(i,j,k);
        end
    end
end
for i = 1:length(candidates)
    for j = 1:size(candidates,2)
        
        for t =1:size(dim_dense_units,1)
            for k = 1:size(dim_dense_units,2)
                if(candidates{i,j} == dim_dense_units{t,k})
                    continue;
                else
                    candidates(i) = [];
                    flag =1;
                end          
        end
        end
    end
    if(flag == 1)
        break;
        flag = 0;
    end
end

