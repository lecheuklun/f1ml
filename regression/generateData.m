function [quali, strat, finish] = generateData(race)

data = readtable('raceData.csv');

% race = "VIE";

inds = [];
for i=1:width(data)
    if string(data{1,i}) == race
        inds = [inds i];
    end
end

%% 

strat = data{[2:25],inds+1};
sizeStrat = size(strat);
strat = reshape(strat,[size(strat,1)*size(strat,2) 1]);

quali = data{[2:25],inds+2};
quali = reshape(quali,[size(quali,1)*size(quali,2) 1]);

finish = [1:24]';
finish = finish .* ones(24,sizeStrat(2));
finish = reshape(finish,[size(quali,1)*size(quali,2) 1]);

end