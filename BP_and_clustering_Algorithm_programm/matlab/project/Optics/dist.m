function [D]=dist(i,x)
[m,n]=size(x);
D=sum((((ones(m,1)*i)-x).^2)');
if n==1
D=abs((ones(m,1)*i-x))';
end