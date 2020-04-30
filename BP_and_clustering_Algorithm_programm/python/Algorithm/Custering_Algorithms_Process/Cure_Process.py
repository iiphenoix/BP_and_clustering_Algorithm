import share
import  numpy as np
Synthesis,Aggregation,Compound,R15,Flame,Spiral = share.Load()
data = Synthesis[:,0:2]
data = Aggregation[:,0:2]
data = Compound[:,0:2]
data = Flame[:,0:2]
data = R15[:,0:2]
data = Spiral[:,0:2]


crs = []  # list数组型
crs.append(data[0, :])
N = 0  # 候选参考点的个数
number = []  # list数组型
number.append(1)
Iterate = 4  # 循环次数
# Radius = 1.4  # 距离2
# T = 12  # 筛选参考点的阈值
# 生成候选参考点
Radius = 2 # 距离2
T = 15 # 筛选参考点的阈值


I = 1
data = list(data)
del ((data[0]))
data = np.array(data)

def Distance(average, data):
    dis = np.sqrt(sum((average - data) * (average - data)))
    return dis

while (I < Iterate):
    data = Synthesis[:, 0:2]
    data = Aggregation[:, 0:2]
    data = Compound[:, 0:2]
    data = Flame[:, 0:2]
    data = R15[:, 0:2]
    data = Spiral[:, 0:2]



    while (len(data) >= 1):
        # for kk in range(10):
        i = 0
        while (i <= N):
            dis = Distance(np.array(crs)[i, :], data[0, :])
            if (dis <= Radius):
                crs = np.array(crs)
                crs[i, :] = (np.array(crs)[i, :] * number[i] + data[0, :]) / (number[i] + 1)
                crs = list(crs)
                data = list(data)
                del (data[0])
                data = np.array(data)
                number[i] = number[i] + 1
                break
            else:
                i = i + 1
        if (i > N):
            N = N + 1
            crs.append(data[0, :])
            number.append(1)
            data = list(data)
            del (data[0])
            data = np.array(data)

    I = I + 1

i = 0
while (i <= N):
    if (number[i] < T):
        del (number[i])
        del (crs[i])
        N = N - 1
    else:
        i = i + 1

# 第一步 画出无向图
tu = np.arange(1, N + 2)
tu = list(tu)
tu2 = [0] * (N + 1)
tu = np.transpose(np.array([tu, tu2]))
i = 0
while (i <= N):
    j = i + 1
    while (j <= N):
        dis = Distance(crs[i], crs[j])
        if (dis <= 2 * Radius):
            tu[i, 1] = j + 1
            break
        else:
            j = j + 1
    if (j > N & tu[i, 1] > 0):
        j = 0;
        while (j <= i):
            dis = Distance(crs[i], crs[j])
            if (dis <= 2 * Radius):
                k = 1
                while (tu[j, k] > 0):
                    k = k + 1
                tu[j, k] = i
                break
            else:
                j = j + 1
    else:
        i = i + 1

    # 第一步 画出无向图
tu = np.arange(1, N + 2)
tu = list(tu)
tu2 = [0] * (N + 1)
tu = np.transpose(np.array([tu, tu2]))
i = 0
while (i <= N):
    j = i + 1
    while (j <= N):
        dis = Distance(crs[i], crs[j])
        if (dis <= 2 * Radius):
            tu[i, 1] = j + 1
            break
        else:
            j = j + 1
    if (j > N & tu[i, 1] > 0):
        j = 0;
        while (j <= i):
            dis = Distance(crs[i], crs[j])
            if (dis <= 2 * Radius):
                k = 1
                while (tu[j, k] > 0):
                    k = k + 1
                tu[j, k] = i
                break
            else:
                j = j + 1
    else:
        i = i + 1

    # 第二步 利用图的广度优先搜索，对候选参考点进行分类
k = 0
i = 0
clas = np.zeros((10000, 10000))
while (len(tu) >= 1):

    clas[k, 0] = tu[0, 0]
    if (tu[0, 1] == 0):
        tu = list(tu)
        del (tu[0])
        tu = np.array(tu)
    else:
        i = 1
        j = sum(tu[0, :] > 0)
        # clas = np.array(clas)
        clas[k, 1:j] = tu[0, 1:j]
        # clas = list(clas)
        tu = list(tu)
        del (tu[0])
        tu = np.array(tu)
        t = sum(clas[k, :] > 0)
        while (i <= (t - 1)):

            print(i,k,t)
            if(clas[k, i] in list(tu[:, 0])):
                m1 = list(tu[:, 0]).index(clas[k, i])
                j = sum(tu[m1, :] > 0)
                if (j > 1):
                    # clas = np.array(clas)
                    clas[k, t:j + t-1] = tu[m1, 1:j]
                    # clas = list(clas)
                    tu = list(tu)
                    del (tu[m1])
                    tu = np.array(tu)
                else:
                    tu = list(tu)
                    del (tu[m1])
                    tu = np.array(tu)
                    break

            t = sum(clas[k, :] > 0)
            i = i + 1
    k = k + 1




cl = []
for i in range(len(clas)):
    if (int(clas[i, 0]) == 0 & int(clas[i, 1]) == 0 & int(clas[i, 2]) == 0):
        continue
    else:
        cl.append(clas[i])
del clas
clas = cl


#参考点与数据的映射
#导入数据
i = 1
clas = np.array(clas)
while (i <= N + 1):
    m = []
    nn = 0
    for ii in range(len(clas[0])):
        for j in range(len(clas)):
            nn = nn + 1
            if (int(clas[j, ii]) == i):
                m.append(nn)

    if (len(m) > 1):
        l1 = len(clas[:, 0])
        m1 = m[0] % l1
        j = 2
        while (j <= len(m)):
            m2 = m[j - 1] % l1
            n2 = int(m[j - 1] / l1)
            n1 = sum(clas[m1 - 1, :] > 0)
            clas[m1 - 1, n1 - 1:n1 + n2] = clas[m2 - 1, 0:n2 + 1]
            j = j + 1
        j = len(m)
        while (j > 1):
            m2 = m[j - 1] % l1
            clas = list(clas)
            del (clas[m2 - 1])
            clas = np.array(clas)
            j = j - 1
    i = i + 1

data1 = Synthesis[:,0:2]
data1 = Aggregation[:,0:2]
data1 = Compound[:,0:2]
data1 = Flame[:,0:2]
data1 = R15[:,0:2]
data1 = Spiral[:,0:2]





data = np.zeros((len(data1), 3))
data[:, :2] = data1

M = len(clas[:, 0])
Mdata = len(data[:, 0])
i = 0
crs = np.array(crs)

clas1 = []
for ii in range(len(clas[0])):
    for jj in range(len(clas)):
        clas1.append(int(clas[jj, ii]))

while (i < Mdata):
    j = 0
    while (j <= N):
        dis = Distance(crs[j, 0:2], data[i, 0:2])

        if (dis <= Radius ):
            if( (j+1) in clas1):
                m = clas1.index(j + 1) + 1
                n = int(m / M) + 1
                data[i, 2] = n
                break
        j = j + 1
    if (j > N):
        data[i, 2] = -1
    i = i + 1

#最后显示聚类后的数据
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
# 解决可视化不能显示中文和符号问题:
matplotlib.rcParams['font.sans-serif'] = ['SimHei']
matplotlib.rcParams['font.family'] = 'sans-serif'
matplotlib.rcParams['axes.unicode_minus'] = False
for i in range(Mdata ):
    if (data[i,2]==1):
        plt.plot(data[i,0],data[i,1],'r.')
    elif (data[i,2]==2):
        plt.plot(data[i,0],data[i,1],'g.')
    elif (data[i,2]==3):
        plt.plot(data[i,0],data[i,1],'b.')
    elif (data[i,2]==4):
        plt.plot(data[i,0],data[i,1],'k.')
    elif( data[i,2]==5):
        plt.plot(data[i,0],data[i,1],'y.')
    elif (data[i,2]==6):
        plt.plot(data[i,0],data[i,1],'k.')
    else:
        plt.plot(data[i,0],data[i,1],'ro')
#
# for i in range(N):
#     if (i==0):
#         plt.plot(crs[i,0],crs[i,1],'r*')
#     elif (i==1):
#         plt.plot(crs[i,0],crs[i,1],'g*')
#     elif (i==2):
#         plt.plot(crs[i,0],crs[i,1],'b*')
#     elif(i==3):
#         plt.plot(crs[i,0],crs[i,1],'c*')
#     elif(i==4):
#         plt.plot(crs[i,0],crs[i,1],'y*')
#     else:
#         plt.plot(crs[i,0],crs[i,1],'k*')
plt.show()
