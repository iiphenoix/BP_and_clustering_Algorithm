function one_dim_dense_units = get_one_dim_dense_units(data, tau, xsi)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
number_of_data_points = size(data,1);
number_of_features = size(data,2);
projection = zeros(xsi, number_of_features);

for f = 1:number_of_features
    for element = data(:,f)'
        projection(fix(mod(element * xsi,xsi))+1, f) =  projection(fix(mod(element * xsi,xsi))+1, f) + 1;
    end
end

is_dense = projection > tau * number_of_data_points;
 kk = 0;
 for f = 1:number_of_features
    for unit = 1:xsi
        if is_dense(unit, f)
            kk = kk + 1;
        end
    end
 end
 
 one_dim_dense_units  = zeros(kk,1,2);
 nn =0;
 for f = 1:number_of_features
    for unit = 1:xsi
        nn = nn + 1;
        if is_dense(unit, f)
    one_dim_dense_units(nn:nn,1:2) = [f unit]; 
%     fprintf('%f %f \n',f,unit);
    end
    end
% one_dim_dense_units = one_dim_dense_units -1;
% fprintf('*****%f  ',one_dim_dense_units);
 end
end
