function p = pricing_CV(STs, strike_Price)
	global r;
    global sigma;       % Daily Volitility
	global T;
    global lambda;      % intensity in one day
    global a;
    global b;
    global S0;
    
    
	prices = exp(-r*T) * max(STs - strike_Price, 0);
	X = prices;
% 	Y = exp(-r*T) * log(STs);
%     mean_Y = exp(-r*T) * (log(S0) + (r - 0.5 * sigma^2)*T + a/lambda);
    Y = exp(-r*T) * STs;
    mean_Y = exp(lambda*exp(a+0.5*b^2) - lambda) * S0;

	B_nominator = (X - mean(X)) * (Y - mean(Y))';
	B_denominator = (Y - mean(Y)) * (Y - mean(Y))';
	B = B_nominator / B_denominator;

	p = mean(X - B * (Y - mean_Y));