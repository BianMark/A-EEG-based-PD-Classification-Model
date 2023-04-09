clc;
clear;
warning('off');
TotalCycle = 10; % do TotalCycle times 10-fold cross validation for each K to get the average value
%% input the psd data
data = [];
data = [data;importdata('PSD_6s\hc1021_6s.mat')];   % 12hc 12pd
data = [data;importdata('PSD_6s\hc1041_6s.mat')];
data = [data;importdata('PSD_6s\hc1061_6s.mat')];
data = [data;importdata('PSD_6s\hc1081_6s.mat')];
data = [data;importdata('PSD_6s\hc1101_6s.mat')];
data = [data;importdata('PSD_6s\hc1111_6s.mat')];
data = [data;importdata('PSD_6s\hc1191_6s.mat')];
data = [data;importdata('PSD_6s\hc1201_6s.mat')];
data = [data;importdata('PSD_6s\hc1211_6s.mat')];
data = [data;importdata('PSD_6s\hc1231_6s.mat')];
data = [data;importdata('PSD_6s\hc1291_6s.mat')];
data = [data;importdata('PSD_6s\hc1351_6s.mat')];

data = [data;importdata('PSD_6s\pd1001_6s.mat')];
data = [data;importdata('PSD_6s\pd1021_6s.mat')];
data = [data;importdata('PSD_6s\pd1031_6s.mat')];
data = [data;importdata('PSD_6s\pd1091_6s.mat')];
data = [data;importdata('PSD_6s\pd1101_6s.mat')];
data = [data;importdata('PSD_6s\pd1151_6s.mat')];
data = [data;importdata('PSD_6s\pd1201_6s.mat')];
data = [data;importdata('PSD_6s\pd1251_6s.mat')];
data = [data;importdata('PSD_6s\pd1261_6s.mat')];
data = [data;importdata('PSD_6s\pd1311_6s.mat')];
data = [data;importdata('PSD_6s\pd1571_6s.mat')];
data = [data;importdata('PSD_6s\pd1661_6s.mat')];

[N,M] = size(data); % N is the total segments
%% Normalization: newData=(oldData-minValue)/(maxValue-minValue);
minValue = min(data); % get the max and min of each col
maxValue = max(data);
data = (data-repmat(minValue,N,1))./(repmat(maxValue-minValue,N,1));
%% 10-fold cross validation
TP = 0; TN = 0; FP = 0; FN = 0;
Accuracy = zeros(1,10);
Sentivity = zeros(1,10);
Specificity = zeros(1,10);
Accuracy_for_K = [];
Sentivity_for_K = [];
Specificity_for_K = [];
Total_Accuracy_for_K = [];
Total_Sentivity_for_K = [];
Total_Specificity_for_K = [];
l=1;
PreditClass = [];

for NumForAve = 1:TotalCycle
indices = crossvalind('Kfold', N, 10);
for K = 1:1:15 % the hyperparameter of kNN
% for K = 7  get the AUC and ROC when the hyperparameter equals 7
for k = 1 : 10
    test = (indices == k); % get the index of the test data
    TestNum = sum(test); % the numbers of test datas for each k
    train = ~test; % get the index of the train data
    
    test_data = data(test,1:M-1);
    test_label = zeros(TestNum,2);
    test_label(:,1) = data(test,M);

   
    train_data = data(train,1:M-1);
    train_label = data(train,M);

    for i=1:TestNum
    %idx=KNN(train_data,train_label,test_data(i,:),K);
    [idx,test_label(i,2)]=kNN_P(train_data,train_label,test_data(i,:),K);
    %fprintf('The true class is:%d\n',test_label(i,1));
        if(test_label(i,1)==idx)
            if(idx==1)
                TP = TP + 1;
            end
            if(idx==0)           
                TN = TN + 1;
            end
        end

        if(test_label(i,1)~=idx)
            if(idx==1)
                FP = FP + 1;
            end
            if(idx==0) 
                FN = FN + 1;
            end
        end
    end
    Accuracy(1,k) = (TP + TN)/(TP + TN + FP + FN);
    Sentivity(1,k) = (TP)/(TP + FN);
    Specificity(1,k) = (TN)/(TN + FP);
    TN=0; TP=0; FP=0; FN=0;
    PreditClass = [PreditClass;test_label];
end
Accuracy_for_K = [Accuracy_for_K,mean(Accuracy)];
Sentivity_for_K = [Sentivity_for_K,mean(Sentivity)];
Specificity_for_K = [Specificity_for_K,mean(Specificity)];
l = l + 1;
end
Total_Accuracy_for_K = [Total_Accuracy_for_K;Accuracy_for_K];
Total_Sentivity_for_K = [Total_Sentivity_for_K;Sentivity_for_K];
Total_Specificity_for_K = [Total_Specificity_for_K;Specificity_for_K];
Accuracy_for_K = [];
Sentivity_for_K = [];
Specificity_for_K = [];
[PX, PY, Auc] = calculate_roc(PreditClass(:,2)', PreditClass(:,1)');disp(Auc);
end
%% plot the curve of K and ROC
ave_Accuracy_for_K = mean(Total_Accuracy_for_K,1);
ave_Sentivity_for_K = mean(Total_Sentivity_for_K,1);
ave_Specificity_for_K = mean(Total_Specificity_for_K,1);
maxAcc = max(Total_Accuracy_for_K);
minAcc = min(Total_Accuracy_for_K);
x=1:1:15;
hold on
figure(1);
plot(x,ave_Accuracy_for_K,'r')
plot(x,ave_Sentivity_for_K,'b')
plot(x,ave_Specificity_for_K,'g')
figure(2);
plot(PX,PY);
xlabel('False positive rate');
ylabel('True positive rate'); 