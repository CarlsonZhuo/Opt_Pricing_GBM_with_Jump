function [Y_ST, ST] = exact()
    % Inexact Method for simulating Markov Jump Process with variance reduction
    % All the notation are inline with the notation in the lecture slides,
    % unless otherwise specify

    global T;           % Days
    global r;           % Risk free rate
    global sigma;       % Daily Volitility
    global lambda;      % intensity in one day
    global a;
    global b;           % a, b are parameter to generate Y
    global S0;

    logS_tau = [];
    logS_tau = [logS_tau, log(S0)];

    Y = [];
    Y = [Y, log(S0)];

    tau = [];
    % Init tau
    U = rand();
    R = - log(U) / lambda;
    tau = [tau, R];

    while tau(end) < T
        U1 = rand;
        U2 = rand;
        Z1 = sqrt(-2 * log(U1)) * sin(2 * pi * U2);
        Z2 = sqrt(-2 * log(1 - U1)) * sin(2 * pi * (1 - U2));

        logY = normrnd(a, b^2);
        logS_tau_jp1 = logS_tau(end) + (r - 0.5 * sigma^2) * R + ...
                       sigma * sqrt(R) * Z1 + logY;
        logS_tau = [logS_tau, logS_tau_jp1];

        Y_jp1 = Y(end) + (r - 0.5 * sigma^2) * R + ...
                sigma * sqrt(R) * Z2 + logY;
        Y = [Y, Y_jp1];

        % Find the next jumpping point
        U = rand();
        R = - log(U) / lambda;
        tau_jp1 = tau(end) + R;
        tau = [tau, tau_jp1];
    end

    % Perform the inexact method
    if length(tau) == 1 && tau(end) < T
        tDiff = T - tau(end);
    elseif length(tau) == 1 && tau(end) > T
        tDiff = T;
    else
        tDiff = T - tau(end-1);
    end

    U1 = rand;
    U2 = rand;
    Z1 = sqrt(-2 * log(U1)) * sin(2 * pi * U2);
    Z2 = sqrt(-2 * log(1 - U1)) * sin(2 * pi * (1 - U2));

    wDiff = sqrt(tDiff) * Z1;
    ST = exp(logS_tau(end)) * exp((r - 0.5 * sigma^2) * tDiff + sigma * wDiff);

    wDiff = sqrt(tDiff) * Z2;
    Y_ST = exp(Y(end)) * exp((r - 0.5 * sigma^2) * tDiff + sigma * wDiff);
