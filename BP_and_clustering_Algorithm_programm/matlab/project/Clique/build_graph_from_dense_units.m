function  graph = build_graph_from_dense_units(dense_units)
%UNTITLED8 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

graph = eye(length(dense_units));
for i = 1:length(dense_units)
    for j = 1:length(dense_units)
        graph(i,j) = get_edge(dense_units(i,:,:), dense_units(j,:,:));
%          fprintf('**%f %f **\n',i,j);
    
    end
end



end

