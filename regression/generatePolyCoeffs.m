function m = generatePolyCoeffs(deg,nFeatures,polyType,cinds)
% before: poly31 -> a,b

    m = fullfact((deg+1)*ones(1,nFeatures))-1;
    m(sum(m,2)>deg,:) = [];
    
    for i=1:length(cinds)
        m(m(:,cinds(i))>1,:) = [];
    end
        
    if polyType == "pure"
        m(sum(m > 0,2) > 1,:) = [];
    elseif polyType == "interaction"
        m(sum(m == deg,2) == 1, :) = [];
    end
    
end
