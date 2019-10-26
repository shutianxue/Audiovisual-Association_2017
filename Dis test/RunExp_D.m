
function RunExp_D(subjectID, block, trials, trialsPr, nconditions, conditions,modality)

trialN=size(trials,1);
%% ============ Screen    
PsychDefaultSetup(2);
screenNumber=max(Screen('Screens'));
HideCursor(screenNumber);
black = BlackIndex(screenNumber);
[window,windowRect] = PsychImaging('OpenWindow', screenNumber, black);

Screen('TextSize', window, 45);
lineInstructionB='This task aims to test your discrimination of brightness.\n\n\nIn each trial you will be presented with two grayscale squares, which show up sequentially.\n\nYou need to judge which square is HIGHER in brightness by pressing 1 or 2 on the keyboard.\n\n   -Press "1" if you think the first one is brighter.\n\n   -Press "2" if you think the second one is brighter.\n\n*Two stimuli are ensured to be different.\n\n\nYou have to make a response within 5 seconds.\n\n\n\nPress Any key to start practices.';
lineInstructionP='This task aims to test your discrimination of pitch.\n\n\nThis task is basically identical to the last task in structure.\n\nThis time you will hear beeps from earphone.\n\nYou need to choose the beep HIGHER in pitch by pressing 1 or 2.\n\n\n\nPress Any key to start practices.';
lineExp='If you are ready,\n\nPress any key to start formal experiment.';
lineQB='Which image is brighter?';
lineQP='Which sound is higher in pitch?';
lineRest='You can have a rest now.\n\nPress any key to continue.';
lineEnd='You have finished all tasks.\n\nThank you for your participation!';

presTime=1; % presentation duration of each stimulus, in secs
iti=1;      % pause betwee each trial, in secs

%% Data
% Create Data Structure
Data = CreateData(subjectID,block,modality,nconditions,conditions,presTime);

%Get Initial Parameters
[StimValInit, MaxTtest,MinTtest,InitGuess] = GetParams(modality);

%Initialize staircases for practice
for j = 1:nconditions
    q(j) = CreateQuest(InitGuess);
end
    
%% ======= Run practice trials (only for pre-test) =======
if block == 1
    % Show instruction
    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    Screen('TextSize', window, 30);
    if modality==1
        DrawFormattedText(window,lineInstructionB,200,'center', [1 1 1]);Screen('flip',window);
    elseif modality ==2
        DrawFormattedText(window,lineInstructionP,200,'center', [1 1 1]);Screen('flip',window);
    end
    KbWait;
    Screen('FillRect', window, [0 0 0]);Screen('flip',window);pause(1);
    Screen('TextSize', window, 45);

    p=size(trialsPr,1);
    % just for testing: p=1;
    for trialcount = 1:p
        % Extract trial parameters
        order = trialsPr(trialcount,1); 
        condition = trialsPr(trialcount,2);  
        locationR = trialsPr(trialcount,3);

        % Check if first trial
        if size(Data.Practice.PerCondition.StimVals{condition}, 1) == 0
            tTest=StimValInit;
        else
            tTest = min(MaxTtest,QuestQuantile(q(condition)));
            %tTest = max(MinTtest,min(MaxTtest,QuestQuantile(q(condition))));
        end

        % check if square is too dark
        if modality ==1 && 51-10^tTest<10^MinTtest
            tTest=log10(51-10^MinTtest);
        end

        stimval = 10^tTest;
        delta=stimval;

        % Present stimulus (because this is trial, no need to add "stimulusRecord")
        PresentStimulus(modality,delta,condition,order,locationR,window,windowRect,lineQB,lineQP); 

        % Record response
        t0=GetSecs;
        [answer, anstime] = getKey([49 50], 2, t0); 
        correctness = AnalyzeResponse(order, answer);
        anstime=anstime-t0;

        Screen('FillRect', window, [0 0 0]); 
        Screen('flip',window);
        WaitSecs(iti); 

        % Update Staircase Structure
        q(condition) = QuestUpdate(q(condition),tTest,correctness);
        % feed in "tTest"!, not "10^tTest" !!!

        % Update Practice Data
        Data.Practice.PerCondition.StimVals{condition} = [Data.Practice.PerCondition.StimVals{condition}; stimval];
    end   

    % Get initial test values from practice trials
    for a = 1:Data.Nthresholds
        b = conditions(a);
        prtTest = min(MaxTtest,QuestQuantile(q(b)));   % max tTest = 4 (since max stimval = 10000)
        Data.InitialTest(b) = 10^prtTest;
    end

    clear Data.Practice
end


%% ===== Run Experimental Trials =====
% Reset staircases
clear q
for j = 1:nconditions
    q(j) = CreateQuest(InitGuess);
end

DrawFormattedText(window,lineExp,'center','center', [1 1 1]);Screen('flip',window);
KbWait;
Screen('FillRect', window, [0 0 0]); Screen('flip',window);
WaitSecs(iti);

% JUST for TESTING:trialN=10;
for trialcount= 1:trialN
    % Extract trial parameters
    order = trials(trialcount,1); 
    condition = trials(trialcount,2); 
    locationR=trials(trialcount,3);
    
    % Check if first experimental trial -- use InitialTest value from practice trials
    if size(Data.Data.PerCondition.StimVals{condition}, 1) == 0
        if block ==1 % for pre-test
            tTest = log10(Data.InitialTest(condition));
        else         % for post-test
            tTest = StimValInit;
        end
    else 
        tTest = min(MaxTtest,QuestQuantile(q(condition)));
        %tTest = max(MinTtest,min(MaxTtest,QuestQuantile(q(condition))));
    end
    
    % check if square is too dark
    if modality ==1 && 51-10^tTest<10^MinTtest
        tTest=log10(51-10^MinTtest);
    end
    
    stimval = 10^tTest;
    delta=stimval;

    % Time to rest (3 in total, every 40 trials)
    if trialcount==trialN/3+1 || trialcount==trialN/3*2+1
        DrawFormattedText(window,lineRest,'center','center',[0 1 1]); Screen('flip',window);
        KbWait();
        Screen('FillRect', window, [0 0 0]); 
        Screen('flip',window);
        WaitSecs(iti);
    end
    
    % Present stimulus
    stimuli=PresentStimulus(modality,delta,condition,order,locationR,window,windowRect,lineQB,lineQP);    
    stimuliRecord(trialcount,:)=stimuli;  % 3 columns: 1st and 2nd stimulus, order

    % Record response
    t0=GetSecs;                                
    [answer, anstime] = getKey([49 50], 2, t0); 
    [correctness] = AnalyzeResponse(order,answer); 
    anstime=anstime-t0;

    Screen('FillRect', window, [0 0 0]); 
    Screen('flip',window);
    WaitSecs(iti/2); 
    
    % Update Staircase Structure
    q(condition) = QuestUpdate(q(condition),tTest,correctness);

    % Update Data structure
    Data = UpdateData(Data, delta, correctness, anstime, condition, order);  

end

Data.stimuliRecord=stimuliRecord;

%% Ending
DrawFormattedText(window,lineEnd,'center','center',[0 1 1]);Screen('flip',window);
WaitSecs(2);
Screen('CloseAll');

%% Get thresholds and print
fprintf('\n');
for m = 1:Data.Nthresholds %=2
    i = conditions(m);
    t = min(MaxTtest, QuestMean(q(i))); 
    Data.Threshold(i) = 10^t;
    fprintf('Threshold Estimate = %7.3f  (%s)\n', Data.Threshold(i), char(Data.ThresholdName(i)));
    Data.ThresholdConfidenceInterval(i,1) = max(0, 10^QuestQuantile(q(i),0.025));
    Data.ThresholdConfidenceInterval(i,2) = min(10^MaxTtest, 10^QuestQuantile(q(i),0.975));
    fprintf('95%% Confidence Interval (%7.4f, %7.3f)\n', ...
        Data.ThresholdConfidenceInterval(i,1), Data.ThresholdConfidenceInterval(i,2));
end
fprintf('\n');

%% Save Data
CreateDataFile(Data)

ShowCursor; 