function plotPredictions(quali,finish,strat,polySpec,betaCoeffs)

close all

figure()
gscatter(quali,finish,strat,'br','xo')

q = (min(quali):max(quali));

q_A = [q' zeros(length(q),1)];
d = x2fx(q_A,polySpec);
line(q,d*betaCoeffs,'Color','b','LineWidth',2)

q_B = [q' ones(length(q),1)];
d = x2fx(q_B,polySpec);
line(q,d*betaCoeffs,'Color','r','LineWidth',2)

%{
function plotPredictions(quali,finish,strat,polySpec,betaCoeffs)

close all

figure()
gscatter(quali,finish,strat,'br','xo')

q = (min(quali):max(quali));

q_A = [q' zeros(length(q),2)];
d = x2fx(q_A,polySpec)
line(q,d*betaCoeffs,'Color','b','LineWidth',2)

q_B = [q' ones(length(q),1) zeros(length(q),1)];
d = x2fx(q_B,polySpec);
line(q,d*betaCoeffs,'Color','r','LineWidth',2)

q_C = [q' zeros(length(q),1) ones(length(q),1)];
d = x2fx(q_C,polySpec);
line(q,d*betaCoeffs,'Color','g','LineWidth',2)

end
%}

end