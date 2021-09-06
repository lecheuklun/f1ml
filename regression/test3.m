load catMLt1.mat
load rusTest.mat

%% set data

% albon data set
alb_quali = track.ALBQ;
alb_finish = track.ALBR;
alb_strat = ["A" "B" "A" "A" "A" "A" "B" "A" "A" "A" "B" "B" "B" "B" "A" "B"]';

%remove the DNF
alb_quali(6,:) = [];
alb_finish(6,:) = [];
alb_strat(6,:) = [];

X_table = generateXTable(alb_quali,alb_strat,alb_finish);

% % retrieve data
% X_table = generateXTable(quali,strat,finish);

%% 

% polynomial coeffs
polySpec = generatePolySpec(0,3,1);

% design matrix
d = generateDesignMatrix(X_table.quali,X_table.strat,polySpec);

% learn coefficients
lambda=0;
B_ridge = ridge(X_table.finish,d(:,2:end),lambda,0);

% plot results
plotPredictions(X_table.quali,X_table.finish,X_table.strat,polySpec,B_ridge);

% get accuracy!
[acc0,acc1,acc2] = evaluateAccuracy(X_table.finish,d,B_ridge);

%% test lambdas

lambda = [0 1e-5 3e-5 1e-4 3e-4 1e-3 3e-3 1e-2, 3e-2, 0.1, 0.3, 1];

for i=1:length(lambda)
    B_ridge = ridge(X_table.finish,d(:,2:end),lambda(i),0);
    [acc0(i),acc1(i),acc2(i)] = evaluateAccuracy(X_table.finish,d,B_ridge);
end

barAcc = [acc0' acc1' acc2']
bar(barAcc)
ylim([0 1])
set(gca,'xticklabel',{'0','1e-5','3e-5','1e-4','3e-4','1e-3','3e-3','1e-2','3e-2','0.1','0.3','1'})
xlabel('Lambda')

%% test different poly coeffs

clear acc0 acc1 acc2

polySpecList = [0 3 1; 1 3 1; 2 3 1; 0 2 1; 1 2 1; 2 2 1]

for i=1:size(polySpecList,1)
    spec = polySpecList(i,:);
    
    m = generatePolySpec(spec(1),spec(2),spec(3));
    d = generateDesignMatrix(X_table.quali,X_table.strat,m);
    B_ridge = ridge(X_table.finish,d(:,2:end),0,0);

    [acc0(i),acc1(i),acc2(i)] = evaluateAccuracy(X_table.finish,d,B_ridge);
end


barAcc = [acc0' acc1' acc2']
bar(barAcc)
ylim([0 1])
set(gca,'xticklabel',{'cubic','cubic-noInt','c/q-intOnly','quad','quad-noInt','q/i-intOnly'})
xlabel('Polynomial')

%% cv partitioning

k = 10;

c = cvpartition(height(X_table), 'KFold',k);

polySpec = generatePolySpec(0,3,1);
d = generateDesignMatrix(X_table.quali,X_table.strat,polySpec);

lambda=0;

for i=1:k
    tinds = training(c,i);
    X_table_kfold = X_table(tinds,:);

    d_kfold = generateDesignMatrix(X_table_kfold.quali,X_table_kfold.strat,polySpec);
    B_ridge_kfold(:,i) = ridge(X_table_kfold.finish,d_kfold(:,2:end),lambda,0);
    evaluateAccuracy(X_table_kfold.finish,d_kfold,B_ridge_kfold(:,i));
    J(1,i) = linearRegCostFunction(d_kfold,X_table_kfold.finish,B_ridge_kfold(:,i),lambda);
    
    X_table_kfold_cv = X_table(~tinds,:);
    d_kfold_cv = generateDesignMatrix(X_table_kfold_cv.quali,X_table_kfold_cv.strat,polySpec);
    J(2,i) = linearRegCostFunction(d_kfold_cv,X_table_kfold_cv.finish,B_ridge_kfold(:,i),lambda);
end

B_ridge_kfold_mean = mean(B_ridge_kfold,2);
% plotPredictions(X_table.quali,X_table.finish,X_table.strat,m_poly31,B_ridge_kfold_mean);
[acc0,acc1,~] = evaluateAccuracy(X_table.finish,d,B_ridge_kfold_mean);
score = mean([acc0 acc1]);
J_kfoldLoss = mean(J,2);

%% Learning curves!!

polySpec = generatePolySpec(0,3,1);
lambda = 0;

[B_ridge_kfold_mean, score, J_kfoldLoss] = learningCurve(X_table,polySpec,lambda)

%% test lambda

close all

lambda = [0 1e-5 3e-5 1e-4 3e-4 1e-3 3e-3 1e-2, 3e-2, 0.1, 0.3, 1];

for i=1:length(lambda)
    [B_ridge_kfold_mean(:,i), score(i), J_kfoldLoss(:,i)] = learningCurve(X_table,polySpec,lambda(i));
end

subplot(1,2,1);
hold on
plot(1:length(lambda),J_kfoldLoss(1,:),'LineWidth',2)
plot(1:length(lambda),J_kfoldLoss(2,:),'LineWidth',2)
legend(["J_train","J_cv"])
hold off

subplot(1,2,2);
bar(score)
ylim([0 1])

%% test polynomial degree

close all
clear B_ridge_kfold_mean score J_kfoldLoss 

% polySpecList = [0 4 1; 1 4 1; 2 4 1; 0 3 1; 1 3 1; 2 3 1; 0 2 1; 1 2 1; 2 2 1];
polySpecList = [1 5 1; 1 4 1; 1 3 1; 1 2 1];

for i=1:size(polySpecList,1)
    spec = polySpecList(i,:);
    
    m = generatePolySpec(spec(1),spec(2),spec(3));
%     d = generateDesignMatrix(X_table.quali,X_table.strat,m);
    
    [~, score(i), J_kfoldLoss(:,i)] = learningCurve(X_table,m,0);
end

subplot(1,2,1);
hold on
plot(1:size(polySpecList,1),J_kfoldLoss(1,:),'LineWidth',2)
plot(1:size(polySpecList,1),J_kfoldLoss(2,:),'LineWidth',2)
legend(["J_train","J_cv"])
% ylim([0 100])
hold off

subplot(1,2,2);
bar(score)
ylim([0 1])

%% learning curve (test data)

close all

polySpec = generatePolySpec(0,3,1);
lambda = 0;

% M = height(X_table);
M = 15;
inds = randperm(M);

for i=3:M
    
    [B_ridge_kfold_mean(:,i), score(i), J_kfoldLoss(:,i)] = learningCurve(X_table(inds(1:i),:),polySpec,lambda);
end

subplot(1,2,1);
hold on
plot(J_kfoldLoss(1,:),'LineWidth',2)
plot(J_kfoldLoss(2,:),'LineWidth',2)
legend(["J_train","J_cv"])
ylim([0 10])
hold off

subplot(1,2,2);
bar(score)
ylim([0 1])



