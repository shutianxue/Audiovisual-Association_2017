function [quizRecord]=ImageQuiz(condition,window,lineQ_S,line_attention,lineAlert,line_rememo, pauseTime,rand_pair,trialcount,centeredRect,preTimeOption,rand_pitOpt,optSeq,fs,stiLuminance,stiPitch,preTimeStimulus)

% accuracy: rate of correct choice made in the first attempt
%% ========= Prepare =========
% Image (stimulus)
% Calcultate retroNumber (which stimulus prior to the last pair should be selected)
if condition == 3     % if it is a random condition
    retroNumber=0;    % the quiz is only about the prior pair
                      % (just to ensure that they are paying attention)
else 
    rng shuffle; retroNumber=randi(3,1); 
end
lumStimulus=rand_pair(1,trialcount-retroNumber);

% Sound (option)
soundTarget=rand_pair(2,trialcount-retroNumber);
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
flag = 1; % mark the existence of quiz
attemptNum=1;
while flag==1
    % aisatsu
    Screen('FillRect', window, [0 0 0]);
    DrawFormattedText(window,line_attention,'center','center', [1 1 1]);
    Screen('flip',window);
    WaitSecs(pauseTime);

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
    if optSeq == 1     % 1st option is target
        sound(ytarget, fs);  
        WaitSecs(preTimeOption);
        WaitSecs(1);

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

    quizRecord(2)=rand_pair(2,trialcount-retroNumber); % column 2: target (sound)
    quizRecord(3)=rand_pitOpt(1,trialcount);           % column 3: option (sound)

    %% Question 
    Screen('FillRect', window, [0 0 0]);
    DrawFormattedText(window,lineQ_S,'center','center', [1 1 1]);
    Screen('flip',window);

    %% Check response
    t0=GetSecs; 
    [answer, anstime]=getKey([49 50],2,t0); % ASCII codes
    respTime(attemptNum)=anstime;
    correctness= AnalyzeResponse(optSeq, answer);

    if correctness == 0 
        redoLINES(window,pauseTime,lineAlert,line_rememo);
        stiLuminance=lumStimulus;
        stiPitch=soundTarget;
        presentPair(fs,window,centeredRect,stiLuminance,stiPitch,preTimeStimulus);
        attemptNum=attemptNum+1;
    elseif correctness == 1  % if answer is right
        flag=0;
    end
    
    quizRecord(4)=attemptNum;     % column 4: number of attempts
    quizRecord(5)=mean(respTime); % column 5: average response time
end

