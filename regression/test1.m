load catMLt1.mat

X_table = table(quali, strat, finish);


%% set categorical

X_table.strat = categorical(X_table.strat)


%% fit model

fit = fitlm(X_table, 'linear') % options: linear, quadratic, polyijk

% can utilise x2fx with lasso/ridge function!!!


%% scatter plot

plotFitLm(X_table.quali, X_table.finish, X_table.strat, fit)


%% predict

qualiPos = 12;

stratA = round(feval(fit,qualiPos,'A'))
stratB = round(feval(fit,qualiPos,'B'))

% need confidence score lol

%% anova

% anova(fit)

% could potentially 

%% regression??

% strat = categorical(strat)
% X = [quali strat]
% Y = finish

% lambda = 0:.01:.5;
% [B,S] = lasso(X_table,'Lambda',lambda);

%% effect
% plotEffects(fit)

%% hard coding categorical variables

% linear coeffs
% intercept: 0.451, quali:0.436, strat_B:3.46

strat_dummyvar = dummyvar(categorical(strat))

X = [quali strat_dummyvar(:,2)]

Y = finish

fit = fitlm(X,Y)

%% hard coding polynomials

fit_poly = fitlm(X_table,'quadratic')

% poly_coeffs = fit_poly.Coefficients.Estimate

%% x2fx

D = x2fx(X,'quadratic') % note col 6 is same as col 3
fit_poly_hard = fitlm(D, Y) % x6 = 0!!! (linear dependence taken into acc)

%% 

mdl = fitlm(X_table,'linear') % best at F = 1.99 lol

plotFitLm(X_table.quali, X_table.finish, X_table.strat, mdl)

mdl2 = fitlm(X_table,'purequadratic') % F = 1.24

plotFitLm(X_table.quali, X_table.finish, X_table.strat, mdl2)

%% 

fitlm(X_table,'poly31')

m = fullfact([4 4])-1
m(sum(m,2)>3,:) = []
m(m(:,2)>1,:) = []

d = x2fx(X, m)

mdl3 = fitlm(d(:,2:end), finish) % yay! same but jumbled coeffs order
B = mdl3.Coefficients.Estimate
% i think fitlm adds an intercept term

plotFitLm(X_table.quali, X_table.finish, X_table.strat, mdl3) % falls over

%% manual plot poly31

q = (min(X_table.quali):max(X_table.quali));

figure()
gscatter(X_table.quali,X_table.finish,X_table.strat,'br','xo')

q_A = [q' zeros(length(q),1)]
d = x2fx(q_A,m)
line(q,feval(mdl3,d(:,2:end)),'Color','b','LineWidth',2)

q_B = [q' ones(length(q),1)]
d = x2fx(q_B,m)
line(q,feval(mdl3,d(:,2:end)),'Color','r','LineWidth',2)


%% 


function plotFitLm(quali, finish, strat, model)

q = (min(quali):max(quali));

figure()
gscatter(quali,finish,strat,'br','xo')
line(q, feval(model,q,'A'),'Color','b','LineWidth',2)
line(q, feval(model,q,'B'),'Color','r','LineWidth',2)

end



