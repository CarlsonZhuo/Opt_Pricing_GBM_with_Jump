% Since the lecture slides did not give names for the two methods, 
% I name the method mentioned in page 6 of the slides as the inexact method,
% since we also have simulate the continuous time interval with discrete time fragment.
% And I name the method mentioned in page 7 of the slides as the exact method. 
% The exact method is given at page 138 of the textbook - simulating at Fixed Date.
% The inexact method is given at page 140 of the textbook - Simulating Jump Times.

global T;           % Days
global r;           % Risk free rate
global sigma;       % Daily Volitility
global lambda;      % intensity in one day
global a;
global b;           % a, b are parameter to generate Y
global S0;

T = 100;            
r = 0.0001;         
sigma = 0.05;       
lambda = 0.1;
a = 0;
b = 0.2;
S0 = 1000;

nbSamplePath = 10000;
strike_Price = 1000;

STs_inexact = zeros(1, nbSamplePath);
for i=1:nbSamplePath
    STs_inexact(i) = inexact();
end
% Pricing without variance reduction
prices_inexact = exp(-r*T) * max(STs_inexact - strike_Price, 0);
mean_prices_inexact = mean(prices_inexact)


STs_exact = zeros(1, nbSamplePath);
for i=1:nbSamplePath
    STs_exact(i) = exact();
end
% Pricing without variance reduction
prices_exact = exp(-r*T) * max(STs_exact - strike_Price, 0);
mean_prices_exact = mean(prices_exact)
