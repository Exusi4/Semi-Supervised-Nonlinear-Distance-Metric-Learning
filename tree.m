clear;
clc
warning off


minsize=5;
T=10;
k0=5;
K_nearest=10;
train_rate=0.8;



%inport data
x=load('iono_x.mat');
x=x.ionosphere;
y=load('iono_y.mat');
y=y.G;




perm=randperm(size(x,1));
x_perm=x(perm,:);
y_perm=y(perm,:);
%separate training and test data
num_train=ceil(train_rate*size(x,1));
num_test=size(x,1)-num_train;
x_train=[[1:num_train]',x_perm(1:num_train,:)];
x_test=[[1:num_test]',x_perm(num_train+1:end,:)];
y_train=[[1:num_train]',y_perm(1:num_train)];
y_test=[[1:num_test]',y_perm(num_train+1:end)];
[n,d]=size(x_train);
dk=floor(d/3);    %dk is the number of selected features in each node.
%select must-link & cannot-link
perm1=randperm(n*ceil(1000/n));
perm2=randperm(n*ceil(1000/n));
constrain=[perm1(1:1000)',perm2(1:1000)'];
rep=find(constrain(:,1)==constrain(:,2));
while ~isempty(rep)
    for i=1:size(rep,1)
        constrain(rep(i),:)=[perm1(1000+i),perm2(1000+i)];
    end
    rep=find(constrain(:,1)==constrain(:,2));
end
constrain=rem(constrain,n)+1;
for i=1:1000
    if y(constrain(i,1))*y(constrain(i,2))==1
        constrain(i,3)=1;
    else
        constrain(i,3)=0;
    end
end
ML=constrain(constrain(:,3)==1,1:2);
CL=constrain(constrain(:,3)==0,1:2);

% set global variables
global W
W=zeros(n,dk+2,T);
global wn
wn=ones(1,T);
global Node
Node=zeros(T*n,6+n);
global noden
noden=1;
global leafn
leafn=1;
global Feature
Feature=zeros(T*n,dk+2);
global fn
fn=1;
global l
l=1;

%set t=1
for t=1:T
    l=1;
    setGlobalNode(t,l,0,n,0,0,(1:num_train)');
    %Build tree t
    BuildTree(t,x_train,ML,CL,minsize,dk);
end

%fast approxinate KNN
acc=zeros(K_nearest,1);
acc_KNN=zeros(K_nearest,1);
for k_nearest=1:K_nearest
    y_pre=zeros(num_test,1);
    for i=1:num_test
        x=x_test(i,:);
        neighbors=zeros(T,k0+1);
        for t=1:T
            Otl=TreeNeighbors(t,1,x,k0);
            neighbors(t,:)=[t Otl];
        end
        %disp(neighbors);
        nei=unique(reshape(neighbors(:,2:end),[],1));
        Distance=[nei zeros(size(nei,1),1)];
        for j=1:size(nei)
            Distance(j,2)=InferDistance(x_train(nei(j),:),x,T)/n;
        end
        %disp(Distance);
        [~,I]=sort(Distance(:,2));
        X_nearest=Distance(I(1:k_nearest),1);
        temp=sum(y_train(X_nearest,2));
        if temp>0
            y_pre(i)=1;
        else
            y_pre(i)=-1;
        end
    end
    acc(k_nearest)=sum(y_pre==y_test(:,2))/num_test;

    acc_KNN(k_nearest)=sum(knnclassify(x_test(:,2:end),x_train(:,2:end),y_train(:,2),k_nearest)==y_test(:,2))/num_test;
end
plot(1:K_nearest,acc,1:K_nearest,acc_KNN);
title('k nearest neighbour classification result')
xlabel('k')
ylabel('accuracy')
legend('HFD KNN','normal KNN')


   
