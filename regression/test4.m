load catMLt1.mat
load rusTest.mat

%% set data

% albon data set
alb_quali = track.ALBQ;
alb_finish = track.ALBR;
alb_strat = ["C" "B" "C" "A" "A" "A" "C" "C" "A" "A" "B" "B" "B" "B" "A" "C"]';

%remove the DNF
alb_quali(6,:) = [];
alb_finish(6,:) = [];
alb_strat(6,:) = [];

X_table = generateXTable(alb_quali,alb_strat,alb_finish);

% % retrieve data
% X_table = generateXTable(quali,strat,finish);



%% 

% polynomial coeffs
polySpec = generatePolyCoeffs(3,3,"",[2 3]);

% design matrix
d = generateDesignMatrix(X_table.quali,X_table.strat,polySpec)

% learn coefficients
lambda=0;
B_ridge = ridge(X_table.finish,d(:,2:end),lambda,0);

% plot results
plotPredictions(X_table.quali,X_table.finish,X_table.strat,polySpec,B_ridge);

% get accuracy!
[acc0,acc1,acc2] = evaluateAccuracy(X_table.finish,d,B_ridge);

%% 

