function [dis]=Distance(average ,data)
    dis=sqrt(sum((average-data).^2));
end