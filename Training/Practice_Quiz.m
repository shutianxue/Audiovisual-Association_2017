function Practice_Quiz(window,lineQ_S,line_attention,lineAlert,line_rememo, pauseTime,rand_pairPr,trialcount,centeredRect,preTimeOption,rand_pitOpt,optSeq,fs,stiLuminance,stiPitch,preTimeStimulus)

%% ========= Prepare =========
% Image (stimulus)
lumStimulus=rand_pairPr(1,trialcount);
% Sound (option)
soundTarget=rand_pairPr(2,trialcount);
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

    % Present sound options
    DrawFormattedText(window,'Here are two options.','center','center', [1 1 1]);
    Screen('flip',window);
    WaitSecs(pauseTime);
    
    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    
    sound(yNon, fs);  
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);

    sound(ytarget, fs);  
    WaitSecs(preTimeOption);
    WaitSecs(pauseTime);

    %% Question 
    Screen('FillRect', window, [0 0 0]);
    lineAnswers='\nPress "1" for choosing the 1st option.\n\nPress "2" for choosing the 2nd option';
    DrawFormattedText(window,[lineQ_S,lineAnswers],'center','center', [1 1 1]);
    Screen('flip',window);

    %% Check response
    t0=GetSecs; 
    [answer, ~]=getKey([49 50],2,t0); % ASCII codes
    correctness= AnalyzeResponse(2, answer);
    
    if correctness == 0 
        redoLINES(window,pauseTime,lineAlert,line_rememo);
        stiLuminance=lumStimulus;
        stiPitch=soundTarget;
        presentPair(fs,window,centeredRect,stiLuminance,stiPitch,preTimeStimulus);
    elseif correctness == 1  % if answer is right
        flag=0;
    end
end

