
numberOfSample = 20; %输入样本数量
%取测试样本数量等于输入(训练集)样本数量，因为输入样本（训练集）容量较少，否则一般必须用新鲜数据进行测试
numberOfTestSample = 20; 
numberOfForcastSample = 2; 
numberOfHiddenNeure = 8;
inputDimension = 3;
outputDimension = 2;
%准备好训练集

%人数(单位：万人)
numberOfPeople=[20.55 22.44 25.37 27.13 29.45 30.10 30.96 34.06 36.42 38.09 39.13 39.99 41.93 44.59 47.30 52.89 55.73 56.76 59.17 60.63];
%机动车数(单位：万辆)
numberOfAutomobile=[0.6 0.75 0.85 0.9 1.05 1.35 1.45 1.6 1.7 1.85 2.15 2.2 2.25 2.35 2.5 2.6 2.7 2.85 2.95 3.1];
%公路面积(单位：万平方公里)
roadArea=[0.09 0.11 0.11 0.14 0.20 0.23 0.23 0.32 0.32 0.34 0.36 0.36 0.38 0.49 0.56 0.59 0.59 0.67 0.69 0.79];
%公路客运量(单位：万人)
passengerVolume = [5126 6217 7730 9145 10460 11387 12353 15750 18304 19836 21024 19490 20433 22598 25107 33442 36836 40548 42927 43462];
%公路货运量(单位：万吨)
freightVolume = [1237 1379 1385 1399 1663 1714 1834 4322 8132 8936 11099 11203 10524 11115 13320 16762 18673 20724 20803 21804];

%由系统时钟种子产生随机数
rand('state', sum(100*clock));

%输入数据矩阵
input = [numberOfPeople; numberOfAutomobile; roadArea];
%目标（输出）数据矩阵
output = [passengerVolume; freightVolume];

%对训练集中的输入数据矩阵和目标数据矩阵进行归一化处理
[sampleInput, minp, maxp, tmp, mint, maxt] = premnmx(input, output);

%噪声强度
noiseIntensity = 0.01;
%利用正态分布产生噪声
noise = noiseIntensity * randn(outputDimension, numberOfSample);
%给样本输出矩阵tmp添加噪声，防止网络过度拟合
sampleOutput = tmp + noise;

%取测试样本输入(输出)与输入样本相同，因为输入样本（训练集）容量较少，否则一般必须用新鲜数据进行测试
testSampleInput = sampleInput;
testSampleOutput = sampleOutput;

%最大训练次数
maxEpochs = 5000;

%网络的学习速率
learningRate = 0.035;

%训练网络所要达到的目标误差
error0 = 0.65*10^(-3);

%初始化输入层与隐含层之间的权值
W1 = 0.5 * rand(numberOfHiddenNeure, inputDimension) - 0.1;
%初始化输入层与隐含层之间的阈值
B1 = 0.5 * rand(numberOfHiddenNeure, 1) - 0.1;
%初始化输出层与隐含层之间的权值
W2 = 0.5 * rand(outputDimension, numberOfHiddenNeure) - 0.1;
%初始化输出层与隐含层之间的阈值
B2 = 0.5 * rand(outputDimension, 1) - 0.1;
%保存能量函数(误差平方和)的历史记录
errorHistory = [];

for i = 1:maxEpochs
    %隐含层输出
    hiddenOutput = logsig(W1 * sampleInput + repmat(B1, 1, numberOfSample));
    %输出层输出
    networkOutput = W2 * hiddenOutput + repmat(B2, 1, numberOfSample);
    %实际输出与网络输出之差
    error = sampleOutput - networkOutput;
    %计算能量函数(误差平方和)
    E = sumsqr(error);
    errorHistory = [errorHistory E];

    if E < error0
        break;
    end

    %以下依据能量函数的负梯度下降原理对权值和阈值进行调整
    delta2 = error;
    delta1 = W2' * delta2.*hiddenOutput.*(1 - hiddenOutput);

    dW2 = delta2 * hiddenOutput';
    dB2 = delta2 * ones(numberOfSample, 1);

    dW1 = delta1 * sampleInput';
    dB1 = delta1 * ones(numberOfSample, 1);

    W2 = W2 + learningRate * dW2;
    B2 = B2 + learningRate * dB2;

    W1 = W1 + learningRate * dW1;
    B1 = B1 + learningRate * dB1;
end

%下面对已经训练好的网络进行(仿真)测试

%对测试样本进行处理
testHiddenOutput = logsig(W1 * testSampleInput + repmat(B1, 1, numberOfTestSample));
testNetworkOutput =  W2 * testHiddenOutput + repmat(B2, 1, numberOfTestSample);
%还原网络输出层的结果(反归一化)
a = postmnmx(testNetworkOutput, mint, maxt);

%绘制测试样本神经网络输出和实际样本输出的对比图(figure(1))--------------------------------------
t = 1990:2009;

%测试样本网络输出客运量
a1 = a(1,:); 
%测试样本网络输出货运量
a2 = a(2,:);

figure(1);
subplot(2, 1, 1); plot(t, a1, 'ro', t, passengerVolume, 'b+');
legend('网络输出客运量', '实际客运量');
xlabel('年份'); ylabel('客运量/万人');
title('神经网络客运量学习与测试对比图');
grid on;

subplot(2, 1, 2); plot(t, a2, 'ro', t, freightVolume, 'b+');
legend('网络输出货运量', '实际货运量');
xlabel('年份'); ylabel('货运量/万吨');
title('神经网络货运量学习与测试对比图');
grid on;

%使用训练好的神经网络对新输入数据进行预测

%新输入数据(2010年和2011年的相关数据)
newInput = [73.39 75.55; 3.9635 4.0975; 0.9880 1.0268]; 

%利用原始输入数据(训练集的输入数据)的归一化参数对新输入数据进行归一化
newInput = tramnmx(newInput, minp, maxp);

newHiddenOutput = logsig(W1 * newInput + repmat(B1, 1, numberOfForcastSample));
newOutput = W2 * newHiddenOutput + repmat(B2, 1, numberOfForcastSample);
newOutput = postmnmx(newOutput, mint, maxt);

disp('预测2010和2011年的公路客运量分别为(单位：万人)：');
newOutput(1,:)
disp('预测2010和2011年的公路货运量分别为(单位：万吨)：');
newOutput(2,:)

%在figure(1)的基础上绘制2010和2011年的预测情况-------------------------------------------------
figure(2);
t1 = 1990:2011;

subplot(2, 1, 1); plot(t1, [a1 newOutput(1,:)], 'ro', t, passengerVolume, 'b+');
legend('网络输出客运量', '实际客运量');
xlabel('年份'); ylabel('客运量/万人');
title('神经网络客运量学习与测试对比图(添加了预测数据)');
grid on;

subplot(2, 1, 2); plot(t1, [a2 newOutput(2,:)], 'ro', t, freightVolume, 'b+');
legend('网络输出货运量', '实际货运量');
xlabel('年份'); ylabel('货运量/万吨');
title('神经网络货运量学习与测试对比图(添加了预测数据)');
grid on;

%观察能量函数(误差平方和)在训练神经网络过程中的变化情况------------------------------------------
figure(3);

n = length(errorHistory);
t3 = 1:n;
plot(t3, errorHistory, 'r-');

%为了更加清楚地观察出能量函数值的变化情况，这里我只绘制前100次的训练情况

xlim([1 100]);
xlabel('训练过程');
ylabel('能量函数值');
title('能量函数(误差平方和)在训练神经网络过程中的变化图');
grid on;

c = NNA2_tool();
%未加噪声且使用神经网络工具箱与加了噪音的算法过程进行比较-------------------------------------------------
figure(4);
t1 = 1990:2011;

subplot(2, 1, 1); 
plot(t1, [a1 newOutput(1,:)], 'ro', t, passengerVolume, 'b+');hold on
plot(t1,c(1,:),'g*');
legend('网络输出客运量', '实际客运量','未去噪音的模型值');

xlabel('年份'); ylabel('客运量/万人');
title('神经网络客运量学习各种值的比较');
grid on;

subplot(2, 1, 2); plot(t1, [a2 newOutput(2,:)], 'ro', t, freightVolume, 'b+');hold on
plot(t1,c(2,:),'g*');
legend('网络输出货运量', '实际货运量','未去噪音的模型值');
xlabel('年份'); ylabel('货运量/万吨');
title('神经网络货运量学习各种值的比较)');
grid on;

