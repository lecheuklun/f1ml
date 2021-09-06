function d = generateDesignMatrix(quali,strat,polySpec)
s = dummyvar(strat);
s = s(:,[2:end]);
x = [quali s];
d = x2fx(x,polySpec)
end