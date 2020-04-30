import share
import  numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets.samples_generator import make_blobs
from sklearn.cluster import Birch

Synthesis,Aggregation,Compound,R15,Flame,Spiral = share.Load()
# X = Synthesis[:,0:2]
# X = Aggregation[:,0:2]
# X = Compound[:,0:2]
# X = Flame[:,0:2]
# X = R15[:,0:2]
X = Spiral[:,0:2]


threshold = 1
branching_factor = 10 # 定义优化参数字典，字典中的key值必须是分类算法的函数的参数名
clf = Birch(n_clusters = 3,threshold=threshold,branching_factor=branching_factor)
clf.fit(X)
y_pred = clf.predict(X)
plt.scatter(X[:, 0], X[:, 1], c=y_pred)
plt.show()