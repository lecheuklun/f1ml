function driversLog = matchDrivers(drivers)
    grid = ["GIO" "GAS" "KVY" "VET" "LEC" "GRO" "MAG" "NOR" "SAI" "HAM" "BOT" "PER" "STR" "ALB" "VER" "RIC" "OCO" "LAT" "RUS"]; % all drivers minus RAI
    drivers = erase(drivers,'*');
    driversLog = drivers == grid;
end