function [B_ridge_kfold_mean, score, J_kfoldLoss] = learningCurve(X_table,polySpec,lambda)

k = 10;
if height(X_table) < 10
    k = height(X_table);
end

c = cvpartition(height(X_table), 'KFold',k);

d = generateDesignMatrix(X_table.quali,X_table.strat,polySpec);

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
end
