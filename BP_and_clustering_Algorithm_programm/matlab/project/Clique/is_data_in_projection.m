    function tf = is_data_in_projection(tuple, candidate, xsi)
        for k  = 1:size(candidate,2)
            dim=candidate(1,k);
              
            element = vpa(tuple(dim{1}(1)+1));
%             fprintf('element %f  ',element);
            
            if(floor(vpa(mod(vpa(element * xsi) , xsi))) ~= dim{1}(2));
                tf = 0;
                return;
            end
        end
    tf = 1;
end