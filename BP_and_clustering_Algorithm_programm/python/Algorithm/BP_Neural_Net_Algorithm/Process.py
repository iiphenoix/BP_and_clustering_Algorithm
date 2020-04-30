
# 一维数据归一化
def Normalization(x):
    return [2 * (float(i) - min(x)) / (max(x) - min(x)) - 1 for i in x]
# 多维数组归一化
def Normalizationall(data):
    datanor = []
    for i in range(0, data.shape[1]):
        datanor.append(Normalization(np.array(data.iloc[:, i:i + 1]).reshape(1, data.shape[0])[0]))
        # dataframe里取单列转成np.array也是二维的，长度*1，需要转换，否则datanor是三维数组
    return datanor
# 求每列数组的输入输出数据的最大最小值
def MinMax(Input, Output):
    minp = list(Input.min())
    maxp = list(Input.max())
    mint = list(Output.min())
    maxt = list(Output.max())
    return minp, maxp, mint, maxt
# 噪声处理
def Noiseman(outputDimension, numberOfSample, tmp, sampleInput, intensity, maxcircu, rate, error):
    noiseIntensity = intensity
    noise = noiseIntensity * np.random.randn(outputDimension, numberOfSample)
    sampleOutput = np.array(tmp) + noise
    # 取测试样本输入(输出)与输入样本相同，因为输入样本（训练集）容量较少，否则一般必须用新鲜数据进行测试
    testSampleInput = sampleInput
    testSampleOutput = sampleOutput
    maxEpochs = maxcircu
    learningRate = rate
    error0 = error
    return noiseIntensity, noise, sampleOutput, testSampleInput, testSampleOutput, maxEpochs, learningRate, error0
def Inverse_normal(x, j):
    return [((float(i) + 1) * (maxt[j] - mint[j])) / 2 + mint[j] for i in x]
# 迭代训练
def InterTrain(numberOfHiddenNeure, inputDimension, outputDimension, maxEpochs, sampleInput, numberOfSample,
               learningRate, testSampleInput, numberOfTestSample):
    import tensorflow as tf
    W1 = 0.5 * np.random.rand(numberOfHiddenNeure, inputDimension) - 0.1
    B1 = 0.5 * np.random.rand(numberOfHiddenNeure, 1) - 0.1
    W2 = 0.5 * np.random.rand(outputDimension, numberOfHiddenNeure) - 0.1
    B2 = 0.5 * np.random.rand(outputDimension, 1) - 0.1
    sess = tf.Session()
    errorHistory = []
    for i in range(1, maxEpochs):
        hiddenOutput = sess.run(tf.nn.sigmoid(np.dot(W1, sampleInput) + np.tile(B1, (1, numberOfSample))))
        # 输出层输出
        networkOutput = np.dot(W2, hiddenOutput) + np.tile(B2, (1, numberOfSample))
        # 实际输出与网络输出之差
        error = sampleOutput - networkOutput
        # 计算能量函数(误差平方和)
        E = np.sum(error ** 2)
        errorHistory.append(E)
        if E<error0:
            break
        # 以下依据能量函数的负梯度下降原理对权值和阈值进行调整
        delta2 = error
        delta1 = np.dot(np.transpose(W2), delta2) * hiddenOutput * (1 - hiddenOutput)
        dW2 = np.dot(delta2, np.transpose(hiddenOutput))
        dB2 = np.dot(delta2, np.ones((numberOfSample, 1)))
        dW1 = np.dot(delta1, np.transpose(sampleInput))
        dB1 = np.dot(delta1, np.ones((numberOfSample, 1)))
        W2 = W2 + np.dot(learningRate, dW2)
        B2 = B2 + np.dot(learningRate, dB2)
        W1 = W1 + np.dot(learningRate, dW1)
        B1 = B1 + np.dot(learningRate, dB1)
    # %对测试样本进行处理
    sess = tf.Session()
    testHiddenOutput = sess.run(tf.nn.sigmoid(np.dot(W1, testSampleInput) + np.tile(B1, (1, numberOfTestSample))))
    testNetworkOutput = np.dot(W2, testHiddenOutput) + np.tile(B2, (1, numberOfTestSample))
    # %还原网络输出层的结果(反归一化)
    a = [0] * len(testNetworkOutput)
    for j in range(len(testNetworkOutput)):
        a[j] = Inverse_normal(testNetworkOutput[j], j)
    return a, W1, W2, B1, B2, errorHistory

def Plot(a):
    import matplotlib
    import matplotlib.pyplot as plt
    import matplotlib.ticker as ticker
    # 解决可视化不能显示中文和符号问题:
    matplotlib.rcParams['font.sans-serif'] = ['SimHei']
    matplotlib.rcParams['font.family'] = 'sans-serif'
    matplotlib.rcParams['axes.unicode_minus'] = False
    plt.figure(figsize=(12, 10))
    plt.rcParams['figure.dpi'] = 180  # 分辨率
    plt.subplot(2, 1, 1)
    plt.plot(t, a[0], 'ro',label="网络输出客运量")
    plt.plot(t, passengerVolume, 'b+',label="实际客运量'")
    plt.legend(loc='best')
    plt.xlabel('年份')
    plt.ylabel('客运量/万人')
    plt.title('神经网络客运量学习与测试对比图')
    plt.gca().xaxis.set_major_formatter(ticker.FormatStrFormatter('%d')) #使X轴为整数
    plt.subplot(2, 1, 2)
    plt.plot(t, a[1], 'ro', label="网络输出货运量")
    plt.plot(t, freightVolume, 'b+',label = "实际货运量")
    plt.legend(loc='best')
    plt.xlabel('年份')
    plt.ylabel('货运量/万吨')
    plt.title('神经网络货运量学习与测试对比图')
    plt.gca().xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
    plt.show()



from pandas import Series,DataFrame
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
numberOfSample = 20#输入样本数量
numberOfTestSample = 20
numberOfForcastSample = 2
numberOfHiddenNeure = 8
inputDimension = 3
outputDimension = 2
numberOfPeople=[20.55, 22.44, 25.37, 27.13, 29.45, 30.10 ,30.96, 34.06, 36.42 ,38.09, 39.13,
                39.99, 41.93 ,44.59 ,47.30 ,52.89, 55.73 ,56.76 ,59.17 ,60.63]
numberOfAutomobile=[0.6, 0.75 ,0.85, 0.9, 1.05 ,1.35 ,1.45 ,1.6 ,1.7, 1.85 ,2.15 ,2.2 ,2.25,
                    2.35, 2.5 ,2.6, 2.7 ,2.85, 2.95 ,3.1]
roadArea=[0.09, 0.11 ,0.11, 0.14, 0.20, 0.23, 0.23, 0.32, 0.32, 0.34, 0.36, 0.36 ,0.38 ,0.49,
          0.56 ,0.59 ,0.59 ,0.67, 0.69, 0.79]
passengerVolume = [5126, 6217, 7730 ,9145 ,10460 ,11387 ,12353, 15750, 18304, 19836, 21024, 19490, 20433 ,
                   22598, 25107 ,33442, 36836 ,40548, 42927 ,43462]
freightVolume = [1237, 1379, 1385, 1399, 1663, 1714 ,1834, 4322, 8132, 8936, 11099 ,11203, 10524, 11115 ,
                 13320 ,16762 ,18673 ,20724, 20803 ,21804]
data ={'numberOfPeople':numberOfPeople,
       'numberOfAutomobile':numberOfAutomobile,
       'roadArea':roadArea,
}
data2={
    'passengerVolume':passengerVolume,
    'freightVolume':freightVolume,
}
Input = pd.DataFrame(data)
Output = pd.DataFrame(data2)
t=[]
for i in range(1990,2010):
    t.append(i)
t1=[]
for i in range(1990,2012):
    t1.append(i)
sampleInput = Normalizationall(Input)
tmp = Normalizationall(Output)
minp,maxp,mint,maxt = MinMax(Input,Output)
noiseIntensity,noise,sampleOutput,testSampleInput,testSampleOutput,maxEpochs,learningRate,error0 = Noiseman(outputDimension,numberOfSample,tmp,sampleInput,0.01,5000,0.035,0.65*10**(-3))
#调用的（输出数据的纬度（神经网络的输出节点个数），输入样本数量，输出数据的归一化数据，输入数据的归一化数据，噪声强度，迭代次数，网络学习速率，训练网络所要达到的目标误差）
#返回的数据（噪声强度，利用正态分布产生的噪声，样本输出矩阵tmp添加噪声，测试样本的输入数据，测试样本的输出数据）
a,W1,W2,B1,B2,errorHistory = InterTrain(numberOfHiddenNeure,inputDimension,outputDimension,maxEpochs,sampleInput,numberOfSample,learningRate,testSampleInput, numberOfTestSample)
#调用的数据（神经网络的隐层数量，输入样本个数，输出样本个数，迭代次数，归一化后的输入数据，输入样本数量，网络学习速率，测试集样本的输入数据，测试集样本的输入数据，测试集样本的数量）
#返回：输出的最后的结果
Plot(a)
def Normalization2(x, j):
    return [2 * (float(i) - minp[j]) / (maxp[j] - minp[j]) - 1 for i in x]

def Predict(numberOfForcastSample, W1, W2, B1, B2):
    import tensorflow as tf
    sess = tf.Session()
    newInput = [[73.39, 75.55], [3.9635, 4.0975], [0.9880, 1.0268]]
    # newInput = []*len(newInput)
    # %利用原始输入数据(训练集的输入数据)的归一化参数对新输入数据进行归一化
    for k in range(len(newInput)):
        newInput[k] = Normalization2(newInput[k], k)
    newHiddenOutput = sess.run(tf.nn.sigmoid(np.dot(W1, newInput) + np.tile(B1, (1, numberOfForcastSample))))
    newOutput = np.dot(W2, newHiddenOutput) + np.tile(B2, (1, numberOfForcastSample))
    for k in range(len(newOutput)):
        newOutput[k] = Inverse_normal(newOutput[k], k)
    return newOutput
newOutput = Predict(numberOfForcastSample,W1,W2,B1,B2)
a[0].extend(newOutput[0])
a[1].extend(newOutput[1])


def Plot2(t1, a, t, passengerVolume, freightVolume):
    import matplotlib
    import matplotlib.pyplot as plt
    import matplotlib.ticker as ticker
    # 解决可视化不能显示中文和符号问题:
    matplotlib.rcParams['font.sans-serif'] = ['SimHei']
    matplotlib.rcParams['font.family'] = 'sans-serif'
    matplotlib.rcParams['axes.unicode_minus'] = False
    plt.figure(figsize=(12, 10))
    plt.rcParams['figure.dpi'] = 80  # 分辨率
    plt.subplot(2, 1, 1)
    plt.plot(t1, a[0], 'ro', label="网络输出客运量")
    plt.plot(t, passengerVolume, 'b+', label="实际客运量")
    plt.legend(loc='best')
    plt.xlabel('年份')
    plt.ylabel('客运量/万人');
    plt.title('神经网络客运量学习与测试对比图(添加了预测数据)');

    plt.subplot(2, 1, 2)

    plt.xlabel('年份')
    plt.ylabel('货运量/万吨');
    plt.title('神经网络货运量学习与测试对比图(添加了预测数据)');
    plt.plot(t1, a[1], 'ro', label="网络输出客运量")
    plt.plot(t, freightVolume, 'b+', label="实际客运量")
    plt.legend(loc='best')
    plt.show()

Plot2(t1,a,t,passengerVolume,freightVolume)


n = len(errorHistory)
t3=[]
for i in range(1,n+1):
    t3.append(i)
def plot3():
    plt.plot(t3, errorHistory, 'r-')
    plt.xlim((1 ,100))
    plt.xlabel('训练过程')
    plt.ylabel('能量函数值')
    plt.title('能量函数(误差平方和)在训练神经网络过程中的变化图')
    plt.show()

plot3()