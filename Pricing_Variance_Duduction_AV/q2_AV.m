% Since the lecture slides did not give names for the two methods, 
% I name the method mentioned in page 6 of the slides as the inexact method,
% since we also have simulate the continuous time interval with discrete time fragment.
% And I name the method mentioned in page 7 of the slides as the exact method. 
% The exact method is given at page 138 of the textbook - simulating at Fixed Date.
% The inexact method is given at page 140 of the textbook - Simulating Jump Times.

tic;
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
lambda = 0;
a = 0;
b = 0.02;
S0 = 1000;

nbRep = 50;
nbSamplePath = 1000;
strike_Price = 1000;

price_inexact_naive = zeros(1, nbRep);
price_exact_naive = zeros(1, nbRep);
price_inexact_AV = zeros(1, nbRep);
price_exact_AV = zeros(1, nbRep);

for i=1:nbRep
    tic;
    info = strcat('current_round: ', num2str(i), '/', num2str(nbRep))
    
    STs_inexact = zeros(1, nbSamplePath);
    Y_STs_inexact = zeros(1, nbSamplePath);
    for j=1:nbSamplePath
        [Y_ST, ST] = inexact_AV();
        STs_inexact(j) = ST;
        Y_STs_inexact(j) = Y_ST;
    end
    Xi = mean(exp(-r*T) * max(STs_inexact - strike_Price, 0));
    Yi = mean(exp(-r*T) * max(Y_STs_inexact - strike_Price, 0));
    price_inexact_naive(i) = Xi;
    price_inexact_AV(i) = 0.5*Xi + 0.5*Yi;
    

    STs_exact = zeros(1, nbSamplePath);
    Y_STs_exact = zeros(1, nbSamplePath);
    for j=1:nbSamplePath
    	[Y_ST, ST] = exact_AV();
        STs_exact(j) = ST;
        Y_STs_exact(j) = Y_ST;
    end
    % Pricing with variance reduction
    Xi = mean(exp(-r*T) * max(STs_exact - strike_Price, 0));
    Yi = mean(exp(-r*T) * max(Y_STs_exact - strike_Price, 0));   
    price_exact_naive(i) = Xi;
    price_exact_AV(i) = 0.5*Xi + 0.5*Yi;
    
    toc;
end

mean_price_inexact_AV = mean(price_inexact_AV)
mean_price_inexact_naive = mean(price_inexact_naive)
mean_price_exact_AV = mean(price_exact_AV)
mean_price_exact_naive = mean(price_exact_naive)

var_price_inexact_AV = var(price_inexact_AV)
var_price_inexact_naive = var(price_inexact_naive)
var_price_exact_AV = var(price_exact_AV)
var_price_exact_naive = var(price_exact_naive)
toc;
