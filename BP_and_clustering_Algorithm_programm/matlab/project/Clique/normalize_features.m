function normalized_data = normalize_features(data)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
normalized_data = data ;
number_of_features = size(normalized_data,2);



for f = 1:number_of_features
     normalized_data(:, f) =normalized_data(:, f)-( min(normalized_data(:, f)) - 0.00001);
     normalized_data(:, f) = vpa(normalized_data(:, f)) ;
     normalized_data(:, f) = normalized_data(:, f) *(1 / (max(normalized_data(:, f)) + 0.00001));
     normalized_data(:, f) = vpa(normalized_data(:, f)) ;
end
normalized_data = vpa(normalized_data);

end

