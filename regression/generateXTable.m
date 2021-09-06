function X_table = generateXTable(quali,strat,finish)
X_table = table(quali,strat,finish);
X_table.strat = categorical(X_table.strat);
end
