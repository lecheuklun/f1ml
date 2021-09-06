races = ["AUS" "BAH" "CHI" "VIE" "NET" "AZE" "SPA" "MON" "CAN" "FRA" "AUT" "GBR" "HUN" "BEL" "ITA" "SIN" "RUS" "JAP" "MEX" "USA" "BRA" "UAE"]

for i=1:length(races)
%     i
    howMany(i) = howManyRaces(races(i));
end

% howMany

[races;howMany]