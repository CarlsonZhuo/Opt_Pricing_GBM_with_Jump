function ST = exact()
    % Inexact Method for simulating Markov Jump Process
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

    tau = [];
    % Init tau
    U = rand();
    R = - log(U) / lambda;
    tau = [tau, R];

    while tau(end) < T
        Z = randn();
        logY = normrnd(a, b^2);
        logS_tau_jp1 = logS_tau(end) + (r - 0.5 * sigma^2) * R + ...
                       sigma * sqrt(R) * Z + logY;
        logS_tau = [logS_tau, logS_tau_jp1];

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
    Z = randn();
    wDiff = sqrt(tDiff) * Z;
    ST = exp(logS_tau(end)) * exp((r - 0.5 * sigma^2) * tDiff + sigma * wDiff);
