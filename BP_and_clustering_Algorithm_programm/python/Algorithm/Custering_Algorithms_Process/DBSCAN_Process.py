def pdist2(x, y):
    import numpy as np
    d1 = np.zeros((x.shape[0], x.shape[0]))
    for i in range(x.shape[0]):
        for j in range(y.shape[0]):
            a = x[i, :]
            b = y[j, :]
            d1[i, j] = np.sqrt(np.dot((a - b), (np.transpose(a - b))))
    return d1

def RegionQuery(i, D, epsilon):
    Neighbors = []
    for j in range(D.shape[1]):
        if (D[i, j] <= epsilon):
            Neighbors.append(j)
    return Neighbors

def ExpandCluster(i, Neighbors, C, IDX, visited, epsilon, MinPts, D):
    IDX[i] = C
    k = 0
    while (True):
        j = Neighbors[k]
        if (int(visited[j]) == 0):
            visited[j] = 1
            Neighbors2 = RegionQuery(j, D, epsilon)
            if (len(Neighbors2) >= MinPts):
                Neighbors.extend(Neighbors2)
        if (IDX[j] == 0):
            IDX[j] = C
        k = k + 1
        if (k > (len(Neighbors) - 1)):
            break
    return IDX

def DBSCAN(X, epsilon, MinPts):
    import numpy as np
    C = 0;
    n = X.shape[0]
    IDX = np.zeros((n, 1))
    D = pdist2(X, X)
    visited = np.zeros((n, 1))
    isnoise = np.zeros((n, 1))
    for i in range(n):
        if (int(visited[i]) == 0):
            visited[i] = 1
            Neighbors = RegionQuery(i, D, epsilon)
            if (len(Neighbors) < MinPts):
                isnoise[i] = 1
            else:
                C = C + 1
                IDX = ExpandCluster(i, Neighbors, C, IDX, visited, epsilon, MinPts, D)
    return IDX

import share
import  numpy as np
Synthesis,Aggregation,Compound,R15,Flame,Spiral = share.Load()
# X = Synthesis[:,0:2]
# X = Aggregation[:,0:2]
# X = Compound[:,0:2]
# X = Flame[:,0:2]
X = R15[:,0:2]
X = Spiral[:,0:2]


IDX1 = DBSCAN(X,3,4) #注意里面是float型
IDX1 = IDX1+1
data = np.zeros((X.shape[0],3))
data[:,2:3] = IDX1
data[:,:2] = X
share.Plot(data,15)