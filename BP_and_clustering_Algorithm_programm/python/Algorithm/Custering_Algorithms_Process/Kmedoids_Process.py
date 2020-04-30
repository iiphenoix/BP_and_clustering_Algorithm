import numpy as np
import random
import share
Synthesis, Aggregation, Compound, R15, Flame, Spiral = share.Load()
CC_init = Synthesis[:, 0:2]
CC = CC_init

k = 5
[num, n] = CC.shape
C_temp = np.zeros((k, 2))  # 默认为0.0
a = [0, 0]
[num, n] = CC.shape


#if (k < num):
randC = np.arange(num)
random.shuffle(randC)
randC = random.sample(list(randC), 5)
for i in range(k):
    C_temp[i, :] = CC[randC[i], :]



for j in range(k):
    CC[randC[j], :] = np.zeros((1, 2))
row = [i for i, x in enumerate(list(CC[:, 0])) if x == 0.0]
CC = list(CC)
for i in range(len(row)):
    del (CC[i])

cluster = [0] * k
for m in range(k):
    cluster[m] = C_temp[m]



for i in range(num - k):
    minValue = 1000000
    minNum = -1
    for j in range(k):
        CC = np.array(CC)
        if (minValue > np.sqrt((CC[i, 0] - C_temp[j, 0]) * (CC[i, 0] - C_temp[j, 0]) + (CC[i, 1] - C_temp[j, 1]) * (
                CC[i, 1] - C_temp[j, 1]))):
            minValue = np.sqrt((CC[i, 0] - C_temp[j, 0]) * (CC[i, 0] - C_temp[j, 0]) + (CC[i, 1] - C_temp[j, 1]) * (
                    CC[i, 1] - C_temp[j, 1]))
            minNum = j

    cluster[minNum] = np.vstack((cluster[minNum], CC[i]))
flag = 1
count = 0

while (flag == 1):
    randC = np.arange(num - k)
    random.shuffle(randC)
    randC = randC[0]
    o_random = CC[randC, :]
    recordN = 0

    for i in range(k):
        for j in range(len(cluster[i])):
            cc = cluster[i][j, :]
            cc = cc - o_random
            if (list(cc) == a):
                recordN = i
                break

    CC = list(CC)
    del (CC[randC])

    o = cluster[recordN][0, :]
    o_rand_sum = 0
    o_sum = 0
    CC = np.array(CC)
    for i in range(len(CC)):
        o_rand_sum = o_rand_sum + np.sqrt(
            (CC[i, 0] - o_random[0]) * (CC[i, 0] - o_random[0]) + (CC[i, 1] - o_random[1]) * (
                    CC[i, 1] - o_random[1]))

        o_sum = o_sum + np.sqrt(
            (CC[i, 0] - o[0]) * (CC[i, 0] - o[0]) + (CC[i, 1] - o[1]) * (CC[i, 1] - o[1]))

    if (o_rand_sum < o_sum):

        cluster[recordN][0, :] = o_random
        CC = np.vstack((CC, o))
        for i in range(k):
            c = cluster[i][0, :]
            cluster[i] = []
            cluster[i] = c

        for i in range(num - k):

            minValue = 1000000
            minNum = -1
            for j in range(k):
                if (minValue > np.sqrt(
                        (CC[i, 0] - C_temp[j, 0]) * (CC[i, 0] - C_temp[j, 0]) + (CC[i, 1] - C_temp[j, 1]) * (
                                CC[i, 1] - C_temp[j, 1]))):
                    minValue = np.sqrt(
                        (CC[i, 0] - C_temp[j, 0]) * (CC[i, 0] - C_temp[j, 0]) + (CC[i, 1] - C_temp[j, 1]) * (
                                    CC[i, 1] - C_temp[j, 1]));
                    minNum = j
            cluster[minNum] = np.vstack((cluster[minNum], CC[i, :]))
    else:
        CC = np.vstack((CC, o_random))
        flag = 0
    count = count + 1;



def plot(k):
    import matplotlib.pyplot as plt
    colortype=['b','r','g','c','m','y','k','purple','palegreen','sienna','lawngreen','darkred','navy','slategrey','orange']
    for i in range(k):
        plt.scatter(cluster[i][:,0],cluster[i][:,1], marker='*', color=colortype[i], label='First')
    plt.show()

plot(5)



