function [DB,CH,KL,Han,st] = valid_internal_deviation(data,labels,dtype)
% cluster validity indices based on deviation

[nrow,nc] = size(data);
labels = double(labels);
k=max(labels);
if dtype == 1
   [st,sw,sb,cintra,cinter] = valid_sumsqures(data,labels,k);
else
   [st,sw,sb,cintra,cinter] = valid_sumpearson(data,labels,k);
end
ssw = trace(sw);
ssb = trace(sb);

if k > 1
% Davies-Bouldin
  R = zeros(k);
  dbs=zeros(1,k);
  for i = 1:k
    for j = i+1:k
      if cinter(i,j) == 0 
         R(i,j) = 0;
      else
         R(i,j) = (cintra(i) + cintra(j))/cinter(i,j);
      end
    end
    dbs(i) = max(R(i,:));
  end
  DB = mean(dbs(1:k-1));
  
  CH = ssb/(k-1); 
else
  CH =ssb; 
  DB = NaN;
  Dunn = NaN; 
end

CH = (nrow-k)*CH/ssw;    % Calinski-Harabasz
Han = ssw;                        % component of Hartigan
KL = (k^(2/nc))*ssw;         % component of Krzanowski-Lai
function [T, W, B, Sintra, Sinter] = valid_sumpearson(data,labels,k)
% within-, between-cluster and total sum of squares
% Sintra/Sinter: centroid diameter/linkage distance based on Pearson correlation

C = mean(data);
R = similarity_pearsonC(data', C');
T = R*R';

W = 0;
Sintra = zeros(1,k);
Sinter = zeros(k,k);
for i = 1:k
   Ui = find(labels == i);
   ni = length(Ui);
   if ni > 1
      datai = data(Ui,:);
      C = mean(datai);
      R = similarity_pearsonC(datai', C'); % distances to cluster center
      Sintra(i) = mean(R); 
      W = W + R*R';
   end
   % distances between cluster centers
  for j = i+1:k
     Ui = find(labels == j);
     ni = length(Ui);
     if ni > 0
        datai = data(Ui,:);
        if ni == 1
          Cj = datai;
        else
          Cj = mean(datai);
        end
        Sinter(i,j) = similarity_pearsonC(Cj', C');
     end
  end
end

B = T - W;


end
function [T, W, B, Sintra, Sinter] = valid_sumsqures(data,labels,k)
%   data:    a matrix with each column representing a variable.
%   labels: a vector indicating class labels
%   W         within-group sum of squares and cross-products
%   B           between-group sum of squares and cross-products
%   T           total sum of squares and cross-products
% Sintra & Sinter: centroid diameter & linkage distance

if (size(labels, 1) == 1)
    labels = labels'; 
end

[ncase,m] = size(data);

% computing the Total sum of squares matrix
Dm = mean(data);
Dm = data - Dm(ones(ncase,1),:); 
T = Dm'*Dm;

% computing within sum of squares matrix
W = zeros(size(T));
Dm = zeros(k,m);
Sintra = zeros(1,k);
for i = 1:k
   if k > 1
      Cindex = find(labels == i);
   else
      Cindex = 1:ncase;
   end
   nk = length(Cindex);
   if nk > 1
      dataC = data(Cindex,:);
      m = mean(dataC);
      Dm(i,:) = m;
      dataC = dataC - repmat(m,nk,1);  %m(ones(nk,1),:)
      W = W + dataC'*dataC;
      dataC = sum(dataC.^2,2);
      Sintra(i) = mean(sqrt(dataC));  % distances to cluster center
   end
end

B = T - W;

% distances between cluster centers
Sinter = zeros(k,k);
if k > 1
for i = 1:k
  for j = i+1:k
     m = abs(Dm(i,:) - Dm(j,:));
     Sinter(i,j) = sqrt(sum(m.^2));
     Sinter(j,i) = Sinter(i,j);
  end
end
end
end


end

