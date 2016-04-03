function ST = inexact()
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
    
    time_gran = 1000;    % simulate 100 steps to simulate the price in T days
    tDiff = T/time_gran;% t_i+1 - t_i

    logS_t = zeros(1, time_gran);
    logS_t(1) = log(S0);
    for i = 2:time_gran
        Z = randn();
        N = poissrnd(lambda*(tDiff));
        % Generate M
        logY = normrnd(a, b^2, 1, N);     % 1 * N
        M = sum(logY); 
        logS_t(i) = logS_t(i-1) + ...
                    (r - 0.5 * sigma^2) * tDiff + ...
                    sigma * sqrt(tDiff) * Z + M;

    end
    S_t = exp(logS_t);
    ST = S_t(time_gran);
