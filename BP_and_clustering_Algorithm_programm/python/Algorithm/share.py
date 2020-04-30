import numpy as np
def Load():
    Synthesis = np.loadtxt("D:\DPC\Standard_DATA\Synthesis.txt")
    Aggregation = np.loadtxt("D:\DPC\Standard_DATA\Aggregation.txt")
    Compound = np.loadtxt("D:\DPC\Standard_DATA\Compound.txt")
    R15 = np.loadtxt("D:\DPC\Standard_DATA\R15.txt")
    Flame = np.loadtxt("D:\DPC\Standard_DATA\Flame.txt")
    Spiral = np.loadtxt("D:\DPC\Standard_DATA\spiral.txt")
    #data7 = np.loadtxt("D:\DPC\Standard_DATA\Synthesis.txt")
    return Synthesis,Aggregation,Compound,R15,Flame,Spiral

def Plot(data,typenum):
    import matplotlib
    import matplotlib.pyplot as plt
    import matplotlib.ticker as ticker
    # 解决可视化不能显示中文和符号问题:
    matplotlib.rcParams['font.sans-serif'] = ['SimHei']
    matplotlib.rcParams['font.family'] = 'sans-serif'
    matplotlib.rcParams['axes.unicode_minus'] = False
    N = len(data)
    a=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    colortype=['b','r','g','c','m','y','k','purple','palegreen','sienna',
               'lawngreen','darkred','navy','slategrey','orange']
    for i in range(N):
        for j in range(typenum):
            if (data[i,2] ==a[j]):
                plt.scatter(data[i, 0],data[i, 1], marker='*', color=colortype[j], label='First')

    plt.show()


