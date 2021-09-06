% quali P2, strat 332

qualiPos = 2;
stratOptions = ["233" "323" "332" "44@" "4@4" "@44"];

for i=1:length(stratOptions)
    [~,~,c(i,:),d(i,:)] = parseOne(stratOptions(i));
end

strats = [2*ones(length(stratOptions),1) c d sum(d~=0,2)-1];

preds = round(net(strats'));

[stratOptions; preds]

% race = [2 0 0 0 0 3 3 2 0 2]
% predOne = net(race')