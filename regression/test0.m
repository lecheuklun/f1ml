% CATEGORICAL

load carsmall

%% 

% Weight
% MPG
% Model_Year

%% 

figure()
gscatter(Weight, MPG, Model_Year, 'bgr', 'x.o')
title('MPG vs. Weight, Grouped by Model Year')

%% 

cars = table(MPG, Weight, Model_Year);
cars.Model_Year = categorical(cars.Model_Year); % categorical arrays!!!

% proposed model
% E(MPG) = beta0 + beta1*Weight + beta2* I[1976] + beta3* I[1982] +
% beta4* Weight* I[1976] + beta5* Weight *I[1982]

%% 

fit = fitlm(cars, 'MPG~Weight*Model_Year')

% beta0 = 37.4
% beta1 = -0.006
% beta2 = 4.69
% etc

%% 

w = linspace(min(Weight), max(Weight));

figure()
gscatter(Weight,MPG,Model_Year,'bgr','x.o')
line(w, feval(fit,w,'70'),'Color','b','LineWidth',2)
line(w,feval(fit,w,'76'),'Color','g','LineWidth',2)
line(w,feval(fit,w,'82'),'Color','r','LineWidth',2)
title('Fitted Regression Lines by Model Year')

%% test for different slopes

anova(fit)

% highest pValue = 0.0072, reject null hypothesis at 0.05 sig level
% test statistic (F) 5.226??
% numerator degrees of freedom is 2 -> no of coeffs in null hypothesis??

% sufficient evidence that slopes are not equal for all three model years


%% make a prediction

min(Weight) % 1795

% prediciton of MPG for car weight 1795kg, from 1970
prediction = feval(fit,min(Weight),'70') % 26.9


%% NON LINEAR

load carbig

X = [Horsepower, Weight];
y = MPG;
modelfun = @(b,x)b(1) + b(2)*x(:,1).^b(3) + ...
    b(4)*x(:,2).^b(5) +b(6)*x(:,1).*x(:,2)
beta0 = [0 0 0 0 0 0];
opts = statset('TolFun',1e-10);
mdl = fitnlm(X,y,modelfun,beta0,'Options',opts)

% modelfun = @(b,x)b(1) + b(2)*x(:,1).^b(3) + ...
%     b(4)*x(:,2).^b(5);
% beta0 = [-50 500 -1 500 -1];
% mdl = fitnlm(X,y,modelfun,beta0)




%% plotEffects

load carsmall
lm = LinearModel.fit([Weight Cylinders],MPG)
plotEffects(lm)







