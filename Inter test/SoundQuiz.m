function [quizRecord]=SoundQuiz(window,lineQ_I,lineAlert, lineCorrect,pauseTime,rand_pair,rand_optSeq,trialcount,centeredRect,preTimeOption,rand_lumOpt,fs)

% accuracy: rate of correct choice made in the first attempt
%% ========= Prepare =========
% Sound (stimulus)
PitStimulus=rand_pair(2,trialcount);

% Image (option)
lumTarget=rand_pair(1,trialcount);
lumOption=rand_lumOpt(trialcount);
check=1; % stimulus and options are under examination
t=trialcount;
while check==1
    if lumTarget==lumOption
        lumOption=rand_lumOpt(t+1);
        t=t+1;
    else 
        check=0;
    end
end

% blank
Screen('FillRect', window, [0 0 0]);
Screen('flip',window);
WaitSecs(pauseTime); 

% Present sound stimulus
y = sin(linspace(0, preTimeOption* PitStimulus *2*pi, round(preTimeOption*fs)));
sound(y, fs);  
WaitSecs(preTimeOption);
WaitSecs(pauseTime);

quizRecord(1)=PitStimulus;                      % column 1: stimulus(sound)

% Present image options
optSeq= rand_optSeq(trialcount);
if optSeq == 1     % 1st option is target
    Screen('FillRect',window,repmat(lumTarget,3,1)./255,centeredRect);
    Screen('Flip', window);
    WaitSecs(preTimeOption);

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    WaitSecs(pauseTime);

    Screen('FillRect',window,repmat(lumOption,3,1)./255,centeredRect);
    Screen('Flip', window);
    WaitSecs(preTimeOption);

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    WaitSecs(pauseTime);

elseif optSeq == 2 % 2nd option is target
    Screen('FillRect',window,repmat(lumOption,3,1)./255,centeredRect);
    Screen('Flip', window);
    WaitSecs(preTimeOption);

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    WaitSecs(pauseTime);

    Screen('FillRect',window,repmat(lumTarget,3,1)./255,centeredRect);
    Screen('Flip', window);
    WaitSecs(preTimeOption);

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    WaitSecs(pauseTime);
end

quizRecord(2)=lumTarget;   % column 2: target (image)
quizRecord(3)=lumOption;   % column 3: option (image)

%% Question 
Screen('FillRect', window, [0 0 0]);
DrawFormattedText(window,lineQ_I,'center','center', [1 1 1]);
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

