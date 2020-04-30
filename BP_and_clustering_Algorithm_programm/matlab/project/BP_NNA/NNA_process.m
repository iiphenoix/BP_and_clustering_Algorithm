
numberOfSample = 20; %������������
%ȡ��������������������(ѵ����)������������Ϊ����������ѵ�������������٣�����һ��������������ݽ��в���
numberOfTestSample = 20; 
numberOfForcastSample = 2; 
numberOfHiddenNeure = 8;
inputDimension = 3;
outputDimension = 2;
%׼����ѵ����

%����(��λ������)
numberOfPeople=[20.55 22.44 25.37 27.13 29.45 30.10 30.96 34.06 36.42 38.09 39.13 39.99 41.93 44.59 47.30 52.89 55.73 56.76 59.17 60.63];
%��������(��λ������)
numberOfAutomobile=[0.6 0.75 0.85 0.9 1.05 1.35 1.45 1.6 1.7 1.85 2.15 2.2 2.25 2.35 2.5 2.6 2.7 2.85 2.95 3.1];
%��·���(��λ����ƽ������)
roadArea=[0.09 0.11 0.11 0.14 0.20 0.23 0.23 0.32 0.32 0.34 0.36 0.36 0.38 0.49 0.56 0.59 0.59 0.67 0.69 0.79];
%��·������(��λ������)
passengerVolume = [5126 6217 7730 9145 10460 11387 12353 15750 18304 19836 21024 19490 20433 22598 25107 33442 36836 40548 42927 43462];
%��·������(��λ�����)
freightVolume = [1237 1379 1385 1399 1663 1714 1834 4322 8132 8936 11099 11203 10524 11115 13320 16762 18673 20724 20803 21804];

%��ϵͳʱ�����Ӳ��������
rand('state', sum(100*clock));

%�������ݾ���
input = [numberOfPeople; numberOfAutomobile; roadArea];
%Ŀ�꣨��������ݾ���
output = [passengerVolume; freightVolume];

%��ѵ�����е��������ݾ����Ŀ�����ݾ�����й�һ������
[sampleInput, minp, maxp, tmp, mint, maxt] = premnmx(input, output);

%����ǿ��
noiseIntensity = 0.01;
%������̬�ֲ���������
noise = noiseIntensity * randn(outputDimension, numberOfSample);
%�������������tmp�����������ֹ����������
sampleOutput = tmp + noise;

%ȡ������������(���)������������ͬ����Ϊ����������ѵ�������������٣�����һ��������������ݽ��в���
testSampleInput = sampleInput;
testSampleOutput = sampleOutput;

%���ѵ������
maxEpochs = 5000;

%�����ѧϰ����
learningRate = 0.035;

%ѵ��������Ҫ�ﵽ��Ŀ�����
error0 = 0.65*10^(-3);

%��ʼ���������������֮���Ȩֵ
W1 = 0.5 * rand(numberOfHiddenNeure, inputDimension) - 0.1;
%��ʼ���������������֮�����ֵ
B1 = 0.5 * rand(numberOfHiddenNeure, 1) - 0.1;
%��ʼ���������������֮���Ȩֵ
W2 = 0.5 * rand(outputDimension, numberOfHiddenNeure) - 0.1;
%��ʼ���������������֮�����ֵ
B2 = 0.5 * rand(outputDimension, 1) - 0.1;
%������������(���ƽ����)����ʷ��¼
errorHistory = [];

for i = 1:maxEpochs
    %���������
    hiddenOutput = logsig(W1 * sampleInput + repmat(B1, 1, numberOfSample));
    %��������
    networkOutput = W2 * hiddenOutput + repmat(B2, 1, numberOfSample);
    %ʵ��������������֮��
    error = sampleOutput - networkOutput;
    %������������(���ƽ����)
    E = sumsqr(error);
    errorHistory = [errorHistory E];

    if E < error0
        break;
    end

    %�����������������ĸ��ݶ��½�ԭ���Ȩֵ����ֵ���е���
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

%������Ѿ�ѵ���õ��������(����)����

%�Բ����������д���
testHiddenOutput = logsig(W1 * testSampleInput + repmat(B1, 1, numberOfTestSample));
testNetworkOutput =  W2 * testHiddenOutput + repmat(B2, 1, numberOfTestSample);
%��ԭ���������Ľ��(����һ��)
a = postmnmx(testNetworkOutput, mint, maxt);

%���Ʋ������������������ʵ����������ĶԱ�ͼ(figure(1))--------------------------------------
t = 1990:2009;

%���������������������
a1 = a(1,:); 
%���������������������
a2 = a(2,:);

figure(1);
subplot(2, 1, 1); plot(t, a1, 'ro', t, passengerVolume, 'b+');
legend('�������������', 'ʵ�ʿ�����');
xlabel('���'); ylabel('������/����');
title('�����������ѧϰ����ԶԱ�ͼ');
grid on;

subplot(2, 1, 2); plot(t, a2, 'ro', t, freightVolume, 'b+');
legend('�������������', 'ʵ�ʻ�����');
xlabel('���'); ylabel('������/���');
title('�����������ѧϰ����ԶԱ�ͼ');
grid on;

%ʹ��ѵ���õ�����������������ݽ���Ԥ��

%����������(2010���2011����������)
newInput = [73.39 75.55; 3.9635 4.0975; 0.9880 1.0268]; 

%����ԭʼ��������(ѵ��������������)�Ĺ�һ�����������������ݽ��й�һ��
newInput = tramnmx(newInput, minp, maxp);

newHiddenOutput = logsig(W1 * newInput + repmat(B1, 1, numberOfForcastSample));
newOutput = W2 * newHiddenOutput + repmat(B2, 1, numberOfForcastSample);
newOutput = postmnmx(newOutput, mint, maxt);

disp('Ԥ��2010��2011��Ĺ�·�������ֱ�Ϊ(��λ������)��');
newOutput(1,:)
disp('Ԥ��2010��2011��Ĺ�·�������ֱ�Ϊ(��λ�����)��');
newOutput(2,:)

%��figure(1)�Ļ����ϻ���2010��2011���Ԥ�����-------------------------------------------------
figure(2);
t1 = 1990:2011;

subplot(2, 1, 1); plot(t1, [a1 newOutput(1,:)], 'ro', t, passengerVolume, 'b+');
legend('�������������', 'ʵ�ʿ�����');
xlabel('���'); ylabel('������/����');
title('�����������ѧϰ����ԶԱ�ͼ(�����Ԥ������)');
grid on;

subplot(2, 1, 2); plot(t1, [a2 newOutput(2,:)], 'ro', t, freightVolume, 'b+');
legend('�������������', 'ʵ�ʻ�����');
xlabel('���'); ylabel('������/���');
title('�����������ѧϰ����ԶԱ�ͼ(�����Ԥ������)');
grid on;

%�۲���������(���ƽ����)��ѵ������������еı仯���------------------------------------------
figure(3);

n = length(errorHistory);
t3 = 1:n;
plot(t3, errorHistory, 'r-');

%Ϊ�˸�������ع۲����������ֵ�ı仯�����������ֻ����ǰ100�ε�ѵ�����

xlim([1 100]);
xlabel('ѵ������');
ylabel('��������ֵ');
title('��������(���ƽ����)��ѵ������������еı仯ͼ');
grid on;

c = NNA2_tool();
%δ��������ʹ�������繤����������������㷨���̽��бȽ�-------------------------------------------------
figure(4);
t1 = 1990:2011;

subplot(2, 1, 1); 
plot(t1, [a1 newOutput(1,:)], 'ro', t, passengerVolume, 'b+');hold on
plot(t1,c(1,:),'g*');
legend('�������������', 'ʵ�ʿ�����','δȥ������ģ��ֵ');

xlabel('���'); ylabel('������/����');
title('�����������ѧϰ����ֵ�ıȽ�');
grid on;

subplot(2, 1, 2); plot(t1, [a2 newOutput(2,:)], 'ro', t, freightVolume, 'b+');hold on
plot(t1,c(2,:),'g*');
legend('�������������', 'ʵ�ʻ�����','δȥ������ģ��ֵ');
xlabel('���'); ylabel('������/���');
title('�����������ѧϰ����ֵ�ıȽ�)');
grid on;

