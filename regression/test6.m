clear

[quali, strat, finish] = generateData("VIE");

%% workflow

for i=1:length(strat)
    [isChangeable(i), isFullWet(i), tyres(i,:), stints(i,:)] = parseOne(strat(i));
end

% visualise data
% [isChangeable' isFullWet' tyres stints]

dryInds = ~isFullWet & ~isChangeable;

quali = quali(dryInds,:);
tyres = tyres(dryInds,:);
stints = stints(dryInds,:);
finish = finish(dryInds,:);

%extra features:
stops = sum(stints~=0,2)-1;

%% save data

X = [quali tyres stints stops];
y = finish;

save('vietnam6.mat', 'X', 'y')


%% 

% run setup
degree = 5;
nFeatures = 10;
polyConfig = "";
categoricalInds = [2:5];
lambda = 1e-2;

% generate polySpec
polySpec = generatePolyCoeffs(degree,nFeatures,polyConfig,categoricalInds);

% design matrix
d = x2fx([quali tyres stints stops],polySpec);

% learn coefficients
B_ridge = ridge(finish,d(:,2:end),lambda,0);
% 
% % plot results
% plotPredictions(X_table.quali,X_table.finish,X_table.strat,polySpec,B_ridge);
% 
% get accuracy!
[acc0,acc1,acc2] = evaluateAccuracy(finish,d,B_ridge)

%% test on data!

qualiPos = 4;
% predictPosNew(qualiPos,"@53",polySpec,B_ridge)

% stratOptions = ["323" "233" "332" "@35" "@53" "@44" "4@4" "44@"];
stratOptions = ["322" "223" "232" "@43" "@34"];

for i=1:length(stratOptions)
    results(i) = predictPosNew(qualiPos,stratOptions(i),polySpec,B_ridge);
end

results


%% learning curves (make sure all data processed)

close all
clear B_ridge_kfold_mean score J_kfoldLoss acc0 acc1 acc2

% polySpec = generatePolySpec(0,3,1);
% lambda = 0;

M = length(quali);
inds = randperm(M);

acc0 = zeros(1,M);
acc1 = zeros(1,M);
acc2 = zeros(1,M);

% score = zeros(1,M);
J_kfoldLoss = zeros(2,M);

for i=M:M
    randomInds = inds(1:i);
    i
    [acc0(i), acc1(i), acc2(i), J_kfoldLoss(:,i)] = learningCurveNew(quali(randomInds),tyres(randomInds,:),stints(randomInds,:),stops(randomInds),finish(randomInds),polySpec,lambda);
end

score = mean([acc0;acc1]);

% subplot(1,2,1);
% hold on
% plot(J_kfoldLoss(1,:),'LineWidth',1)
% plot(J_kfoldLoss(2,:),'LineWidth',1)
% plot(movmean(J_kfoldLoss(2,:),5),'--','LineWidth',1)
% legend(["Jtrain","Jcv","Jcv moving average"])
% ylim([0 100])
% hold off
% 
% subplot(1,2,2);
% bar(score)
% ylim([0 1])
% 
% minJ = min(J_kfoldLoss(2,[3:end]))
% last = 0;
% avgScore = mean(score(end-last:end))
% minScore = min(score(end-last:end))
% maxScore = max(score(end-last:end))




