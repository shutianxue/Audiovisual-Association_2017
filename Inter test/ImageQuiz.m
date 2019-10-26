function [quizRecord]=ImageQuiz(window,lineQ_S,lineAlert,lineCorrect, pauseTime,rand_pair,rand_optSeq,trialcount,centeredRect,preTimeOption,rand_pitOpt,fs)

% accuracy: rate of correct choice made in the first attempt
%% ========= Prepare =========
% Image (stimulus)
lumStimulus=rand_pair(1,trialcount);

% Sound (option)
soundTarget=rand_pair(2,trialcount);
soundOption=rand_pitOpt(trialcount);
check=1; % stimulus and options are under examination
t=trialcount;
while check==1
    if soundTarget==soundOption
        soundOption=rand_pitOpt(t+1);
        t=t+1;
    else 
        check=0;
    end
end

ytarget = sin(linspace(0, preTimeOption* soundTarget *2*pi, round(preTimeOption*fs)));
yNon = sin(linspace(0, preTimeOption* soundOption *2*pi, round(preTimeOption*fs)));

%% ========= Loop =========
% blank
Screen('FillRect', window, [0 0 0]); %fill the entire window
Screen('flip',window);
WaitSecs(pauseTime); 

% Present image stimulus
Screen('FillRect',window,repmat(lumStimulus,3,1)./255,centeredRect);
Screen('Flip', window);
WaitSecs(preTimeOption);

Screen('FillRect', window, [0 0 0]);Screen('flip',window);
WaitSecs(pauseTime); 

quizRecord(1)=lumStimulus;                      % column 1: stimulus(image)

% Present sound options
optSeq= rand_optSeq(trialcount);
if optSeq == 1     % 1st option is target
    sound(ytarget, fs);  
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);

    sound(yNon, fs);  
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);
    
elseif optSeq == 2 % 2nd option is target
    sound(yNon, fs);  
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);

    sound(ytarget, fs);  
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);
end

quizRecord(2)=rand_pair(2,trialcount);     % column 2: target (sound)
quizRecord(3)=rand_pitOpt(1,trialcount);   % column 3: option (sound)

%% Question 
Screen('FillRect', window, [0 0 0]);
DrawFormattedText(window,lineQ_S,'center','center', [1 1 1]);
Screen('flip',window);

%% Check response
t0=GetSecs; 
[answer, anstime]=getKey([49 50],2,t0); % ASCII codes
correctness= AnalyzeResponse(optSeq, answer);

if correctness == 0 
    % RED "Incorrect"
    Screen('FillRect', window, [0 0 0]);
    DrawFormattedText(window,lineAlert,'center','center',[1 0 0]);  
    Screen('flip',window);
    pause(pauseTime/2);

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    pause(pauseTime/2);

    correctCount=0;
elseif correctness == 1  % if answer is right
    % Green "Correct"
    Screen('FillRect', window, [0 0 0]);
    DrawFormattedText(window,lineCorrect,'center','center',[0 1 0]);  
    Screen('flip',window);
    pause(pauseTime/2);

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    pause(pauseTime/2);

    correctCount=1;
end    
    quizRecord(4)=correctCount;          % column 4: whether the answer is correct (0 for incorrect, 1 for correct)
    quizRecord(5)=anstime;               % column 5: RT

