function c = NNA2_tool()
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

%�������ݾ���
input = [numberOfPeople; numberOfAutomobile; roadArea];
%Ŀ�꣨��������ݾ���
output = [passengerVolume; freightVolume];

P = input;
T = output;
[p1,minp,maxp,t1,mint,maxt]=premnmx(P,T);
%��������
net=newff(minmax(P),[3,8,2],{'logsig','logsig','purelin'},'trainlm');
%����ѵ������
net.trainParam.epochs = 5000;
%�����������
net.trainParam.goal=0.65*10^(-3);
%ѵ������
[net,tr]=train(net,p1,t1);

newInput = [73.39 75.55; 3.9635 4.0975; 0.9880 1.0268];
a =newInput;

num = size(P,2);
num2 = size(a,2);
for i = 1:num2
    P(:,num+i) = a(:,i);
end
a = P;

% a2 =newInput;
a=premnmx(a);
% a2=premnmx(a2);
%���뵽�����������
b=sim(net,a);
% b2=sim(net,a2);
%���õ������ݷ���һ���õ�Ԥ������
c=postmnmx(b,mint,maxt);
% c2=postmnmx(b2,mint,maxt);
end
