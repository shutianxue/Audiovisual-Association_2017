
function runExp_training(subjectID,condition,block)

% ----- Description -----
% Audiovisual association task
% This task aims to train subjects on different types of audiovisual associations: 
% Intuitive (IN)          Positive relationship between B and P
% Counterintuitive (CIN)  Negative
% Random (Rand)           Random pairing (as a control group)

% ----- Inputs -----
% condition: 1 = IN; 2 = CIN; 3 = Rand
% block: two-number input
%        1st number: 1 = day 1; 2 = day 2
%        2nd number: 1-4 indicating session #
% ----- outputs -----
% Parameter of quiz
        % column 1: stimulus;
        % column 2: target option;
        % column 3: non-target option;
        % column 4: number of attempts;
        % column 5: average response time
        
 
%% Safeguard
Screen('Preference', 'SkipSyncTests', 1);

%% ======== Screen Setup ========
PsychDefaultSetup(2);
screenNumber=max(Screen('Screens'));
HideCursor(screenNumber);
white = WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[xCenter, yCenter] = RectCenter(windowRect);

%% ======== Parameters ========
fs=48000;
repeNum=3;    % each pair repeats for 3 times

% 1. Timing
preTimeStimulus = 3;  % presentation time of stimuli, in sec
preTimeOption = 1;    % presentation time of options, in sec
pauseTime = 1;

% 2. Image and sound stimuli
baseRect = [0 0 300 300];
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter); 

pairNum=10;   % number of BP-pairs
% Luminance
lumInterval=25;
lumLower=10;
imageLum=lumLower:lumInterval:lumLower+lumInterval*(pairNum-1);
% Pitch
pitInterval=30;
pitLower=250;
soundPit=pitLower:pitInterval:pitLower+pitInterval*(pairNum-1);

% ------------------------------------------------------------
% determine stimuli based on condition
if condition == 2      % CIN condition
    imageLum=fliplr(imageLum);
elseif condition == 3  % random condtion
    % Only randomize image stimuli
    rng shuffle;
    randsequence=randperm(pairNum);
    for i=1:pairNum 
        rand_image(:,i)=imageLum(:,(randsequence(1,i)));
    end
    imageLum=rand_image;
end
% -------------------------------------------------------------

% summary and randomize:
image_sound=repmat([imageLum;soundPit],1,repeNum); % 2*30 matrix 
[~,trialN]=size(image_sound);

rng shuffle;
randsequence=randperm(trialN);
for i=1:trialN 
    rand_pair(:,i)=image_sound(:,(randsequence(i)));
end % randomized pairs: 'rand_pair' (2*30)

% 3. Inserted quiz
% 3.1 Sequence of visual/auditory stimulus
[quizSeq,stiImage,stiSound]=quizSequence(condition);
quizNum=length(quizSeq);
imageLumOpt = repmat (imageLum,1,10);
soundPitOpt = repmat (soundPit,1,10);

% 3.2 Construct optionBox
optionBox=10*pairNum;
rng shuffle;
randsequence=randperm(optionBox);  
for i=1:optionBox
    rand_lumOpt(:,i)=imageLumOpt(:,(randsequence(i))); 
    rand_pitOpt(i)=soundPitOpt(randsequence(i)); 
end 

% 3.3 Determine the modality of two options
opt_onetwo=repmat([1,2],1,round(quizNum/2));
opt_onetwo=opt_onetwo(1:quizNum);
rng shuffle;
optSeq=randperm(quizNum);
for i=1:quizNum
    rand_optSeq(i)=opt_onetwo(optSeq(i));
end 
        
% 4. Text
Screen('TextSize', window, 45);
lineInstruction1='You will now do some learning tasks.\n\n\nIn each trial, a pair of square and beep will be presented.\n\nThey start simultaneously and last for 3 seconds.\n\n\nPlease memorize the matching relationship of the brightness and pitch in each trial.\n\n\n\nSometimes you will meet a quiz after a pair presentation,\n\nwhich tests your memory of a pair you have encountered previously. \n\nYou will get clear instructions when you meet a quiz in the practice.\n\nIf your answer is correct, you will proceed to the next pair.\n\nIf your answer is incorrect, you will receive a negative feedback,\n\nthen re-memorize the pair and redo the quiz, until you give a correct answer.\n\n\n\nPress Any key to start practice.';
%lineInstruction2='Sometimes you will meet a quiz after a pair presentation,\n\nwhich tests your memory of a pair you have encountered previously. \n\nYou will get clear instructions when you meet a quiz in the practice.\n\nIf your answer is correct, you will proceed to the next pair.\n\nIf your answer is incorrect, you will receive a negative feedback,\n\nthen re-memorize the pair and redo the quiz, until you give a correct answer.\n\n\n\nPress Any key to start practice.';
%lineInstruction3='If your answer is correct, you will proceed to the next pair.\n\nIf your answer is incorrect, you will receive a negative feedback,\n\nthen re-memorize the pair and redo the quiz, until you give a correct answer.\n\n\n\nPress Any key to start practice.';
lineStartExp = 'Press any key to start experiment.';
line_attention='Please pay attention to this stimulus.';
lineAlert='Incorrect';
line_rememo = 'Please re-memorize this pair.';
lineQ_S = 'Which sound matches with the image?\n';
lineQ_I = 'Which image matches with the sound?\n'; 
lineLast = 'You have finished all trials in this session';

%% ======== Practice Loop ========
% this is only for 1st block on 1st day
if block == 11
    Screen('TextSize', window, 30);
    
    DrawFormattedText(window,lineInstruction1,200,'center', [1 1 1]);Screen('flip',window);
    KbWait;
    %Screen('FillRect', window, [0 0 0]);
    %DrawFormattedText(window,lineInstruction2,'center','center', [1 1 1]);Screen('flip',window);
    %KbWait;
    %Screen('FillRect', window, [0 0 0]);
    %DrawFormattedText(window,lineInstruction3,'center','center', [1 1 1]);Screen('flip',window);
    %KbWait(5);
    
    Screen('TextSize', window, 45);
    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    pause(pauseTime);

    practceNum=4;
    rand_pairPr=image_sound(:,[10,3,1,6]);

    for trialcount=1:practceNum
        stiLuminance=rand_pairPr(1,trialcount);
        stiPitch=rand_pairPr(2,trialcount);
        presentPair(fs,window,centeredRect,stiLuminance,stiPitch,preTimeStimulus);
    end
    Practice_Quiz(window,lineQ_S,line_attention,lineAlert,line_rememo,pauseTime,rand_pairPr,trialcount,centeredRect,preTimeOption,rand_pitOpt,optSeq,fs,stiLuminance,stiPitch,preTimeStimulus); 

    Screen('FillRect', window, [0 0 0]);Screen('flip',window);
    pause(pauseTime);
end

%% ======== Formal Exp Loop ========
DrawFormattedText(window,lineStartExp,'center','center', [1 1 1]);
Screen('flip',window);
KbWait;
Screen('FillRect', window, [0 0 0]);Screen('flip',window);
pause(pauseTime);

t=1;
% just for testing: trialN=4;
for trialcount=1:trialN
    % 1. Present the pair
    stiLuminance=rand_pair(1,trialcount);
    stiPitch=rand_pair(2,trialcount);
    presentPair(fs,window,centeredRect,stiLuminance,stiPitch,preTimeStimulus);
    
    % 2. Insert random quiz
    if any(trialcount == quizSeq)
        optSeq=rand_optSeq(t); % determine which option shows up first
        if any(trialcount == stiImage)
            [quizRecord]=ImageQuiz(condition,window,lineQ_S,line_attention,lineAlert,line_rememo,pauseTime,rand_pair,trialcount,centeredRect,preTimeOption,rand_pitOpt,optSeq,fs,stiLuminance,stiPitch,preTimeStimulus); 
            quizParameter(t,:)=quizRecord;
            t=t+1;
        elseif any(trialcount == stiSound)
            [quizRecord]=SoundQuiz(condition,window,lineQ_I,line_attention,lineAlert,line_rememo,pauseTime,rand_pair,trialcount,centeredRect,preTimeOption,rand_lumOpt,optSeq,fs,stiLuminance,stiPitch,preTimeStimulus);       
            quizParameter(t,:)=quizRecord;
            t=t+1;
        end
        
        accuracy=mean(quizParameter(:,4)==1);
        Screen('FillRect', window, [0 0 0]);Screen('flip',window);
        pause(pauseTime);
    end
end

%% Ending
Screen('FillRect', window, [0 0 0]);
DrawFormattedText(window,lineLast,'center','center',[0 1 1]);  
Screen('flip',window);
pause(1);

%% Record and save data
Data = CreateData(subjectID,condition,block,rand_pair,quizParameter,accuracy);
CreateDataFile(Data);

sca;
Screen('CloseAll');

%% check accuracy (for 2nd day)
if block==21
    AllAcc=[];
else
    load('AllAcc');
end

if block>20
    AllAcc(block-20)=accuracy; % collection of all accuracy on the 2nd day
    AccAcc=mean(AllAcc);       % accumulative accuracy
    fprintf('Accuracy of session#%d is%5.2f.\nAccumulative accuracy is%5.2f.\n',block-20,accuracy,AccAcc); 
end
save('AllAcc','AllAcc');
