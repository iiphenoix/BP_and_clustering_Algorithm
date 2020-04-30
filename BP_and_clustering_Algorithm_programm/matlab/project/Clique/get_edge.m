
function  t = get_edge(node1, node2)
      dim = size(node1,2);

    distance = 0;
    for i = 1:dim
        if(node1(1,i,1) ~= node2(1,i,1) )
            t = 0;
             return;
        end
        distance = distance+vpa(abs(node1(1,i,2) - node2(1,i,2)));
        distance = vpa(distance);
        if(vpa(distance)>1)
            t = 0;
            return;
        end
          
    end
    t = 1;
    
    
end