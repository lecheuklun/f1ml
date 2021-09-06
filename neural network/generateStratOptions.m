function stratOptions = generateStratOptions(track)

sixLaps = ["BEL"];
sevenLaps = ["VIE" "NET" "GBR" "SIN" "JAP"];
eightLaps = ["AUS" "BAH" "CHI" "AZE" "SPA" "MON" "CAN" "FRA" "HUN" "ITA" "RUS" "MEX" "USA" "BRA" "UAE"];
nineLaps = ["AUT"];

if sum(contains(sixLaps,track))==1
    stratOptions = ["222" "@33"]; % 6 lapper
elseif sum(contains(sevenLaps,track))==1
    stratOptions = ["322" "223" "232" "@43" "@34"]; % 7 lapper
elseif sum(contains(eightLaps,track))==1
    stratOptions = ["233" "323" "332"  "44" "44@" "4@4" "@44" "35@" "5@3" "4@22"]; % 8 lapper
elseif sum(contains(nineLaps,track))==1
    stratOptions = ["333" "@54"]; % 8 lapper
end

end