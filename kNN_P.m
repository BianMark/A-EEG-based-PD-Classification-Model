function [ idx , Possibility ] = kNN_P( trainData,trainClass,testData,K )
[N,M]=size(trainData);

%compute the dist
dist=zeros(N,1);
for i=1:N
    dist(i,:)=norm(trainData(i,:)-testData);
end

%sort the dist
[Y,I]=sort(dist,1);   
K=min(K,length(Y));


labels=trainClass(I);

idx = mode(labels(1:K)); 
Possibility = (sum(labels(1:K))./K); %Possibility is probability that the prediction is true
%fprintf('This test data belongs to class:%d  ',idx);
