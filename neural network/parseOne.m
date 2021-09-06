function [isChangeable, isFullWet, tyres, stints] = parseOne(strat)
    isChangeable = 0;
    isFullWet = 0;
    tyres = zeros(1,4);
    stints = zeros(1,4);
    
    strat = char(strat);
    
    if contains(strat,'$')
        isChangeable = 1;
        if strat(1) == '$'
            isFullWet = 1;
            isChangeable = 0;
        end
    end
    
    stints = str2double(regexp(strat,'\d','match'));
    if length(stints) < 4
        stints(length(stints)+1:4) = 0;
    end
    
    if ~isChangeable & ~isFullWet % is dry!
    if ~contains(strat,'@')
        return
    end
       
    if strat(1) == '@'
        tyres = double(stints ~= 0);
        return
    end
    
    inds = [];
    counter = 1;
    for i=1:length(strat)
        if strat(i) == '@'
            inds(counter-1) = counter-1;
        else
            counter = counter + 1;
        end
    end
    tyres(find(inds>0)) = 1;
    
    
%     isChangeable
%     isFullWet
%     tyres
%     stints
end