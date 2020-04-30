def Train(data, N, pattern, center, rad):
    [m, n] = data.shape
    while (1):
        import pandas as pd
        distence = np.zeros((1, N))[0]
        num = np.zeros((1, N))[0]
        new_center = np.zeros((N, n))
        for x in range(m):
            for y in range(0, N):
                distence[y] = np.linalg.norm(data[x, :] - center[y, :], ord=1)
            temp = distence.min()
            a = list(distence).index(temp)

            pattern[x, n] = a

        k = 0
        for y in range(N):
            for x in range(m):
                if (pattern[x, n] == y):
                    new_center[y, :] = new_center[y, :] + pattern[x, 0:n]

                    num[y] = num[y] + 1

            new_center[y, :] = new_center[y, :] / num[y]

            if (np.linalg.norm(new_center[y, :] - center[y, :], ord=1) < 0.1):
                k = k + 1

        if (k == N):
            for i in range(len(pattern)):
                pattern[i:i + 1, 2:3] = pattern[i:i + 1, 2:3] + 1
            return pattern

        else:
            center = new_center

import share
import numpy as np
import numpy as np
import random
Synthesis,Aggregation,Compound,R15,Flame,Spiral=share.Load()
data=Synthesis[:,0:2]
#share.Plot(R15,15)
N = 5
[m,n] = data.shape
pattern = np.zeros((m,n+1))
center=np.zeros((N,n))
pattern[:,0:n]=data[:,:]
rad = random.sample(list(data),5)
for i in range(len(center)):
    rad[i] = list(rad[i])
center = np.array(rad)
pattern = Train(data,N,pattern,center,rad)
share.Plot(pattern,5)