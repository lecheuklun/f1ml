% settings
track = "AUT";
isWet = 0;

qualiPos = 9;
driver = "RAI";

%% 

[X,y] = generateDataNN(track,isWet);

%% 

f1net;

%% baseline

% round(pred);
% 
% pred(pred>24) = 24;
% pred(pred<1) = 1;
% 
% err = abs(y-pred');
% acc0 = length(err(err<0.5))/length(err)
% acc1 = length(err(err<1.5))/length(err)
% acc2 = length(err(err<2.5))/length(err)

%% C - y output now positions gained

size(pred)
pred = X(:,1) - pred';
pred(pred>24) = 24;
pred(pred<1) = 1;

err = abs((X(:,1)-y)-pred);
acc0 = length(err(err<0.5))/length(err)
acc1 = length(err(err<1.5))/length(err)
acc2 = length(err(err<2.5))/length(err)


%% 

stratOptions = generateStratOptions(track);
% stratOptions = ["223" "22@3"]

clear a b c d

m = length(stratOptions);
for i=1:m
    [~,~,c(i,:),d(i,:)] = parseOne(stratOptions(i));
end

strats = [qualiPos*ones(m,1) c d sum(d~=0,2)-1 ones(m,1) zeros(m,1) matchDrivers(driver).*ones(m,19)]; % me controlled
% strats = [qualiPos*ones(m,1) c d sum(d~=0,2)-1 zeros(m,1) zeros(m,1) matchDrivers(driver).*ones(m,19)]; % AI controlled

% preds = net(strats');
preds = ones(1,m)*qualiPos-net(strats');

% state
[best, bestInd] = min(preds);
best(best<1) = 1;
fprintf('Best strategy for P%d: %s - Predicted position: P%d',qualiPos,stratOptions(bestInd),round(best))

% correct extreme predictions
% preds = round(preds);
% preds(preds<1) = 1;
% preds(preds>24) = 24;

[stratOptions; round(preds,1)]
