function [acc0, acc1, acc2, J_kfoldLoss] = learningCurveNew(quali,tyres,stints,stops,finish,polySpec,lambda)

k = 10;
m = length(quali);
if m < 10
    k = m;
end

c = cvpartition(m, 'KFold',k);

d = x2fx([quali tyres stints stops],polySpec);

for i=1:k
    tinds = training(c,i);

    d_kfold = x2fx([quali(tinds) tyres(tinds,:) stints(tinds,:) stops(tinds)],polySpec);
    B_ridge_kfold(:,i) = ridge(finish(tinds),d_kfold(:,2:end),lambda,0);
    evaluateAccuracy(finish(tinds),d_kfold,B_ridge_kfold(:,i));
    J(1,i) = linearRegCostFunction(d_kfold,finish(tinds),B_ridge_kfold(:,i),lambda);
    
    d_kfold_cv = x2fx([quali(~tinds) tyres(~tinds,:) stints(~tinds,:) stops(~tinds)],polySpec);
    J(2,i) = linearRegCostFunction(d_kfold_cv,finish(~tinds),B_ridge_kfold(:,i),lambda);
end

B_ridge_kfold_mean = mean(B_ridge_kfold,2);
% plotPredictions(X_table.quali,X_table.finish,X_table.strat,m_poly31,B_ridge_kfold_mean);
[acc0,acc1,acc2] = evaluateAccuracy(finish,d,B_ridge_kfold_mean);
score = mean([acc0 acc1]);
J_kfoldLoss = mean(J,2);
end
