# MATLAB F1 Neural Network Strategy Predictor 

A neural network that uses supervised learning on past races to predict a driver's finishing position!

The net achieved 81% accuracy (to +/- 2 positions), compared to 57% with polynomial regression.

https://www.hutch.io/our-games/f1-clash/

## Neural network
To run code, run neural-network/test7.m on the editor on MATLAB! Requires Deep Learning Toolbox.

Inputs: 
* Track (e.g. Austria, input as 'AUT')
* Wet/dry race
* Qualifying position (e.g. P7)
* Driver (e.g. Raikonnen, input as 'RAI')
* Chosen strategy (e.g. '32@4@' signifies soft 3 laps, hard 2 laps, hard 4 laps)

Output:
* Predicted finishing position

## Polynomial regression
To run code, run regression/test6.m on the editor.

Inputs:
* Track (e.g. Vietnam, input as 'VIE')
* Ensure strategy options (line 62) are correct
