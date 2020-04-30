import numpy as np
import share
Synthesis,Aggregation,Compound,R15,Flame,Spiral = share.Load()
x = Synthesis[:,0:2]
def dist(i,x):
    [m,n] = x.shape
    D = sum(np.transpose(((np.ones((m,1))*i)-x)*(np.ones((m,1))*i - x)))
    if( n ==1):
        D=abs(np.transpose(( (np.ones((m,1))*i) -x)))
    return D

def optics(x, k):
    [m, n] = x.shape
    RD = (np.ones((1, m)) * 10) ** 10
    RD = RD[0]
    CD = [0] * m
    for i in range(m):
        D = sorted(dist(x[i, :], x))
        CD[i] = D[k]
    order = []
    seeds = np.arange(m)
    ind =0

    while (len(seeds) >1):  # 后面删除
        if(len(seeds) ==1):
            print(seeds)
        ob = seeds[ind]
        seeds = list(seeds)
        del (seeds[ind])
        seeds = np.array(seeds)
        order.append(ob)
        mm = np.max([np.ones((1, len(seeds)))[0] * CD[ob], dist(x[ob, :], x[seeds, :])], axis=0)
        ii = (RD[seeds]) > mm
        for i in range(len(ii)):
            if (ii[i] == True):
                RD[seeds[ii]] = mm[ii]
        i1 = np.min(RD[list(seeds)])  # 内容
        ind = RD[list(seeds)].argsort()[0]
    order.append(seeds[0])
    RD[0] = np.max(RD[1:m]) + 0.1 * np.max(RD[1:m])


    return RD, CD, order

def plotFeature(data,labels):
    clusterNum = len(set(labels))
    fig = plt.figure()
    scatterColors = ['black', 'blue', 'green', 'yellow', 'red', 'purple', 'orange', 'brown']
    ax = fig.add_subplot(111)
    for i in range(-1, clusterNum):
        colorSytle = scatterColors[i % len(scatterColors)]
        subCluster = data[np.where(labels == i)]
        ax.scatter(subCluster[:, 0], subCluster[:, 1], c=colorSytle, s=12)
    plt.show()

RD, CD, order = optics(x,5)

import matplotlib.pyplot as plt
plt.subplot(4,1,1)
plt.plot(RD[order][:500])

plt.subplot(4,1,2)
plt.plot(RD[order][500:1000])
X = [100,200,300,400,500]
group_labels1 = [600, 700,800,900,1000]
plt.xticks(X, group_labels1, rotation=0)
plt.subplot(4,1,3)
plt.plot(RD[order][1000:1500])
group_labels2 = ['1100', '1200','1300','1400','1500']
plt.xticks(X, group_labels2, rotation=0)
plt.subplot(4,1,4)
plt.plot(RD[order][1500:1980])
group_labels3 = ['1600', '1700','1800','1900','2000']
plt.xticks(X, group_labels3, rotation=0)
plt.show()


m,n = x.shape
reach_distIds=np.where(RD[order] <= 5)[0]
pre=reach_distIds[0]-1
clusterId=0
labels=np.full((m,),-1)
for current in reach_distIds:
    # 正常来说：current的值的值应该比pre的值多一个索引。如果大于一个索引就说明不是一个类别
    if(current-pre!=1):
        clusterId=clusterId+1
    labels[order[current]]=clusterId
    pre=current
plotFeature(x,labels)

