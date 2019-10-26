function [quizRecord]=SoundQuiz(condition,window,lineQ_I,line_attention,lineAlert,line_rememo, pauseTime,rand_pair,trialcount,centeredRect,preTimeOption,rand_lumOpt,optSeq,fs,stiLuminance,stiPitch,preTimeStimulus)

% accuracy: rate of correct choice made in the first attempt
%% ========= Prepare =========
% Sound (stimulus)
% Calcultate retroNumber (which stimulus prior to the last pair should be selected)
if condition == 3     % if it is a random condition
    retroNumber=0;    % the quiz is only about the prior pair
                      % (just to ensure that they are paying attention)
else 
    rng shuffle; retroNumber=randi(3,1); 
end
soundStimulus=rand_pair(2,trialcount-retroNumber);

% Image (option)
lumTarget=rand_pair(1,trialcount-retroNumber);
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

%% ========= Loop =========
flag = 1; % mark the existence of quiz
while flag==1
    % aisatsu
    Screen('FillRect', window, [0 0 0]);
    DrawFormattedText(window,line_attention,'center','center', [1 1 1]);
    Screen('flip',window);
    WaitSecs(pauseTime);

    Screen('FillRect', window, [0 0 0]); 
    Screen('flip',window);
    WaitSecs(pauseTime); 
    
    % Present sound stimulus
    y = sin(linspace(0, preTimeOption* soundStimulus *2*pi, round(preTimeOption*fs)));
    sound(y,fs);
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);
    
    quizRecord(1)=soundStimulus;                      % column 1: stimulus(sound)

    % Present image options
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

    quizRecord(2)=rand_pair(1,trialcount-retroNumber); % column 2: target (image)
    quizRecord(3)=rand_lumOpt(1,trialcount);           % column 3: option (image)

    %% Question 
    Screen('FillRect', window, [0 0 0]);
    DrawFormattedText(window,lineQ_I,'center','center', [1 1 1]);
    Screen('flip',window);

    %% Check response
    attemptNum=1;
    t0=GetSecs; 
    [answer, anstime]=getKey([49 50],2,t0); % ASCII codes
    respTime(attemptNum)=anstime;
    correctness= AnalyzeResponse(optSeq, answer);

    if correctness == 0 
        redoLINES(window,pauseTime,lineAlert,line_rememo);
        stiLuminance=lumTarget;
        stiPitch=soundStimulus;
        presentPair(fs,window,centeredRect,stiLuminance,stiPitch,preTimeStimulus);
        attemptNum=attemptNum+1;
    elseif correctness == 1  % if answer is right
        flag=0;
    end
    quizRecord(4)=attemptNum;     % column 4: number of attempts
    quizRecord(5)=mean(respTime); % column 5: average response time
end

