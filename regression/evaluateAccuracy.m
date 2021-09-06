function [acc0,acc1,acc2] = evaluateAccuracy(finish,d,betaCoeffs)

pred = round(d*betaCoeffs);

acc0 = sum(pred == finish)/length(pred);
% fprintf('Accuracy to exact place: %.f%%\n',acc0 * 100)
acc1 = sum(abs(pred-finish)<=1)/length(pred);
% fprintf('Accuracy to within 1 place: %.f%%\n',acc1 * 100)
acc2 = sum(abs(pred-finish)<=2)/length(pred);
% fprintf('Accuracy to within 2 places: %.f%%\n',acc2 * 100)

end