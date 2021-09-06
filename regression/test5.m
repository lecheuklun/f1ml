clear
load rusTest.mat

%% 

quali = track.RAIQ;
finish = track.RAIR;
strat = track.RAIStr

%% parse strategies

for i=1:length(strat)
    [isChangeable(i), isFullWet(i), tyres(i,:), stints(i,:)] = parseOne(track.RAIStr(i));
end

% visualise data
% [isChangeable' isFullWet' tyres stints]

%% filter dry

dryInds = ~isFullWet & ~isChangeable

quali = quali(dryInds,:);
tyres = tyres(dryInds,:);
stints = stints(dryInds,:);
finish = finish(dryInds,:);

%% workflow

% polynomial coeffs
polySpec = generatePolyCoeffs(3,9,"pure",[2:5]);

% design matrix
d = x2fx([quali tyres stints],polySpec)

% learn coefficients
lambda=0;
B_ridge = ridge(finish,d(:,2:end),lambda,0);
% 
% % plot results
% plotPredictions(X_table.quali,X_table.finish,X_table.strat,polySpec,B_ridge);
% 
% get accuracy!
[acc0,acc1,acc2] = evaluateAccuracy(finish,d,B_ridge)
