
track = readtable('russia.csv');

%% process data: remove NaNs

idx = isnan(track.WetQ);
track(idx,:) = [];

%% remove averages & last five cols

track(end-1:end,:) = [];
track(:,end-4:end) = [];

%% crude (lumped) strat model:

track.RAIStr = categorical(track.RAIStr);
track.ALBStr = categorical(track.ALBStr);

%% fix DNFs

track.RAIR = string(track.RAIR);
idx = track.RAIR == "DNF";
track.RAIR(idx) = "24";
track.RAIR = double(track.RAIR);

track.ALBR = string(track.ALBR);
idx = track.ALBR == "DNF";
track.ALBR(idx) = "24";
track.ALBR = double(track.ALBR);

%% 

save rusTest.mat track