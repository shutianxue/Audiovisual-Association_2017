function q = CreateQuest(InitGuess)tGuess = log10 (InitGuess);   % prior threshold estimatetGuessSD = 3;                 % SD assigned to that guesspThreshold = 0.82;            % threshold criterion expressed as probability of response==1beta = 3.5;                   % parameters of a Weibull psychometric functiondelta = 0.01;                 % same as abovegamma = 0.5;                  % same as abovegrain = 0.01;                 % the quantization (step size) of the internal tablerange = 5;                    % the intensity difference between the largest and smallest intensity that the internal table can storeq = QuestCreate (tGuess, tGuessSD, pThreshold, beta, delta, gamma, grain, range);