function pred = predictPosNew(qualiPos,stratStr,polySpec,betaCoeffs)
[~,~,tyres,stints] = parseOne(stratStr);
stops = sum(stints~=0,2);
d_test = x2fx([qualiPos tyres stints stops],polySpec);
% d_test*betaCoeffs
pred = round(d_test*betaCoeffs);
end
