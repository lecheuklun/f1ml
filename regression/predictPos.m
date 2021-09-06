function pred = predictPos(qualiPos,isStratB,polySpec,betaCoeffs)
d_test = x2fx([qualiPos,isStratB],polySpec);
pred = round(d_test*betaCoeffs);
end
