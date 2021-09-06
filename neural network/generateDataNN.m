function [X, y] = generateDataNN(race,wet)

[quali, strat, finish, drivers] = generateData(race);

m = length(strat);

isChangeable = zeros(m,1);
isFullWet = zeros(m,1);
tyres = zeros(m,4);
stints = zeros(m,4);
isHuman = zeros(m,2);

corruptInds = [];

for i=1:length(strat)
    [a, b, c, d] = parseOne(strat(i));
    
    if length(d) <= 4
        isChangeable(i) = a;
        isFullWet(i) = b;
        tyres(i,:) = c;
        stints(i,:) = d;        
    else
        corruptInds = [corruptInds i];
        continue
    end
end

isHuman(:,1) = contains(drivers,'*');
rivalInds = contains(drivers,'**');
isHuman(:,2) = rivalInds;
isHuman(rivalInds,1) = 0;

% driver
drivers = matchDrivers(drivers);

if wet
    filterInds = isFullWet;
else
    filterInds = ~isFullWet & ~isChangeable;
end

stops = sum(stints~=0,2)-1;

% X = [quali tyres stints stops isHuman];
X = [quali tyres stints stops isHuman drivers]; % branch B

% y = finish;
y = quali-finish; % branch C

X(~filterInds,:) = [];
y(~filterInds,:) = [];

X(corruptInds,:) = [];
y(corruptInds,:) = [];

end