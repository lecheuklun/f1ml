%{

test 2 aims

- normalisation: better performance?
- regularisation

%}

load catMLt1.mat

%% normalisation

[quali_norm, mu, sigma] = featureNormalise(quali)

X_table = table(quali_norm, strat, finish);

X_table.strat = categorical(X_table.strat)

fit = fitlm(X_table, 'linear') % options: linear, quadratic, polyijk

%{
same as previous: conclusion: no benefit from feature normalisation?!?!

increases tStat, decreases pValue of intercept term (but overall p-value
still constant)
%}

%% lasso regularisation: set up

strat_dummyvar=dummyvar(X_table.strat)

X = [quali strat_dummyvar(:,2)]

m = fullfact([3 3])-1;
m(sum(m,2)>2,:) = [];
m(m(:,2)>1,:) = []

d = x2fx(X, m)

%% 

lambda = 0;
B_lasso = lasso(d(:,2:end),finish,'Lambda',lambda)

% coeffs different??? cyclic coordinate descent?

B_ridge = ridge(finish,d(:,2:end),lambda,0)

% yay coeffs same! use ridge lol


%% manual plot poly31

X_table = table(quali, strat, finish)
X_table.strat = categorical(X_table.strat)

q = (min(quali):max(X_table.quali));

figure()
gscatter(X_table.quali,X_table.finish,X_table.strat,'br','xo')

q_A = [q' zeros(length(q),1)]
d = x2fx(q_A,m)
line(q,feval(mdl3,d(:,2:end)),'Color','b','LineWidth',2)

q_B = [q' ones(length(q),1)]
d = x2fx(q_B,m)
line(q,feval(mdl3,d(:,2:end)),'Color','r','LineWidth',2)

%% same as above, but with coeffs array instead of mdl3

close all

figure()
gscatter(X_table.quali,X_table.finish,X_table.strat,'br','xo')

q_A = [q' zeros(length(q),1)]
d = x2fx(q_A,m)
line(q,d*B,'Color','b','LineWidth',2)

q_B = [q' ones(length(q),1)]
d = x2fx(q_B,m)
line(q,d*B,'Color','r','LineWidth',2)



%% manual plot poly31 with B_ridge, lambda=0

close all

X_table = generateXTable(quali, strat, finish)

% generate design matrix for poly31
d_poly31 = generateDesignMatrix(X_table.quali, X_table.strat, generatePolySpec())

% learn coeffs
lambda=0
B_ridge = ridge(finish,d_poly31(:,2:end),lambda,0)

% plot results
plotPredictions(X_table.quali,X_table.finish,X_table.strat,m,B_ridge)


%% as above with lambda=0.001

% close figure 2

lambda = 1e-3;
B_ridge = ridge(finish, d_poly31(:,2:end),lambda,0);

% plot results
plotPredictions(X_table.quali,X_table.finish,X_table.strat,m,B_ridge)

%% predict, with lambda=0.001

pred = round(d_poly31*B_ridge);

accuracy_0 = sum(pred == X_table.finish)/size(pred,1);
fprintf('Accuracy to exact place: %.f%%\n',accuracy_0 * 100)
accuracy_1 = sum(abs(pred-X_table.finish)<=1)/size(pred,1);
fprintf('Accuracy to within 1 place: %.f%%\n',accuracy_1 * 100)
accuracy_2 = sum(abs(pred-X_table.finish)<=2)/size(pred,1);
fprintf('Accuracy to within 2 places: %.f%%\n',accuracy_2 * 100)


%% predict single race

pred = predict(4,1,m,B_ridge)

%% REAL LIFE DATA: predict ALB w/ 2 strats

alb_quali = track.ALBQ;
alb_finish = track.ALBR;
alb_strat = ["A" "B" "A" "A" "A" "A" "B" "A" "A" "A" "B" "B" "B" "B" "A" "B"]';

%remove the DNF
alb_quali(6,:) = [];
alb_finish(6,:) = [];
alb_strat(6,:) = [];

X_table = generateXTable(alb_quali,alb_strat,alb_finish);

% generate design matrix for poly31
d_poly31 = generateDesignMatrix(X_table.quali, X_table.strat, generatePolySpec());

% learn coeffs
lambda=1e-3;
B_ridge = ridge(X_table.finish,d_poly31(:,2:end),lambda,0);

% plot results
plotPredictions(X_table.quali,X_table.finish,X_table.strat,m,B_ridge)







%% functions (LOCAL TO TEST2)


function pred = predict(qualiPos,isStratB,polySpec,betaCoeffs)
d_test = x2fx([qualiPos,isStratB],polySpec);
pred = round(d_test*betaCoeffs);
end


function plotPredictions(quali,finish,strat,polySpec,betaCoeffs)

close all

figure()
gscatter(quali,finish,strat,'br','xo')

q = (min(quali):max(quali));

q_A = [q' zeros(length(q),1)];
d = x2fx(q_A,polySpec);
line(q,d*betaCoeffs,'Color','b','LineWidth',2)

q_B = [q' ones(length(q),1)];
d = x2fx(q_B,polySpec);
line(q,d*betaCoeffs,'Color','r','LineWidth',2)

end

function X_table = generateXTable(quali,strat,finish)
X_table = table(quali,strat,finish);
X_table.strat = categorical(X_table.strat);
end


function m = generatePolySpec()
m = fullfact([4 4])-1;
m(sum(m,2)>3,:) = [];
m(m(:,2)>1,:) = []; % removes all I(B)^2 & I(B)^3
end

function d = generateDesignMatrix(quali,strat,polySpec)
s = dummyvar(strat);
s = s(:,2);
x = [quali s];
d = x2fx(x,polySpec);
end



