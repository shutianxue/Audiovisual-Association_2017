
function runExp_inter(subjectID,condition,block)

% ----- Description -----
% Intermediate-level test
% In this task, subjects are tested on the "intermediate" of the 10 
% brightness-pitch pairs that were adopted in the previous training sessions.
% This task aims to ensure that subjects have successfully formed BP-association in the training session.
% The design is nasically similar to inserted quiz in training session.
% Practice (4) + Experiment

% ----- Inputs ------
% condition: 1 = IN; 2 = CIN; 3 = Rand
% block: 1 = day1; 2 = day2

% ----- Record ------
% Parameter_of_quiz: simulus | option 1 (target)| option 2 | correctness | RT

%% Safeguard
Screen('Preference', 'SkipSyncTests', 1);

%% ======== Screen Setup ========
PsychDefaultSetup(2);
screenNumber=max(Screen('Screens'));
HideCursor(screenNumber);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[xCenter, yCenter] = RectCenter(windowRect);

%% ======== Parameters ========
fs=48000;

% 1. Image and sound stimuli
baseRect = [0 0 300 300];
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter); 
pairNum=10;  % number of BP-pairs
  
% Luminance
lumInterval=25;
lumLower=0;
lumLower=lumLower+round(lumInterval/2);
imageLumInter=lumLower:lumInterval:lumLower+lumInterval*(pairNum-1);

% Pitch
pitInterval=30;
pitLower=250;
pitLower=pitLower+round(pitInterval/2);
soundPitInter=pitLower:pitInterval:pitLower+pitInterval*(pairNum-1);

% determine stimuli based on condition
repeNum=2;    % each pair repeats twice

if condition == 2      % CIN condition
    imageLumInter=fliplr(imageLumInter);
elseif condition == 3   % random condtion
    % Only randomize image stimuli
    rng shuffle;
    randsequence=randperm(pairNum);
    for i=1:pairNum 
        rand_image(:,i)=imageLumInter(:,(randsequence(1,i)));
    end
    imageLumInter=rand_image;
end

% summary and randomize:
image_sound=repmat([imageLumInter;soundPitInter],1,repeNum); % 2*30 matrix 
[~,trialN]=size(image_sound);

rng shuffle;
randsequence=randperm(trialN);
for i=1:trialN 
    rand_pair(:,i)=image_sound(:,(randsequence(i)));
end % randomized pairs: 'rand_pair' (2*30)

% 2. Quiz (for every pair)
% 2.1 Construct optionBox
optionBox=10*pairNum;
imageLumOpt = repmat (imageLumInter,1,10);
soundPitOpt = repmat (soundPitInter,1,10);
rng shuffle;
randsequence=randperm(optionBox);  
for i=1:optionBox
    rand_lumOpt(:,i)=imageLumOpt(:,(randsequence(i))); 
    rand_pitOpt(:,i)=soundPitOpt(randsequence(i)); 
end 

% 2.2 Determine the modality of two options
opt_onetwo=repmat([1,2],round(trialN/2));
opt_onetwo=opt_onetwo(1:trialN);
rng shuffle;
optSeq=randperm(trialN);
for i=1:trialN
    rand_optSeq(i)=opt_onetwo(optSeq(i));
end 

% 3. Text
lineStartExp='This part tests your learning of pairs.\n\n\nThe format of quiz in this test is the same with the one in the learning task.\n\nYou will also get feedback to your answer.\n\nBut if you answer incorrectly, you DON''T have to redo the test.\n\nThis part does not have practice.\n\n\nPress any key to start experiment.';
lineAlert='Incorrect';
lineCorrect='Correct';
lineQ_S = 'Which sound matches with the image?';
lineQ_I = 'Which image matches with the sound?'; 
lineLast = 'You have finished all tasks.\n\nThank you!';

% 4. Timing
preTimeOption = 1;    % presentation time of options, in sec
pauseTime = 1;


%% ========== Loop (formal exp) ==========
Screen('TextSize', window, 30);
DrawFormattedText(window,lineStartExp,200,'center', [1 1 1]);
Screen('flip',window);
KbWait;
Screen('FillRect', window, [0 0 0]);Screen('flip',window);
pause(pauseTime);
Screen('TextSize', window, 45);
% determine whether the stimulus is image or sound
rng shuffle;
stiImage=sort(randperm(trialN,trialN/2));

t=1;
% just for testing:trialN=1;
for trialcount=1:trialN
    if any(trialcount == stiImage)
        [quizRecord]=ImageQuiz(window,lineQ_S,lineAlert,lineCorrect,pauseTime,rand_pair,rand_optSeq, trialcount,centeredRect,preTimeOption,rand_pitOpt,fs); 
        quizParameter(trialcount,:)=quizRecord;
        t=t+1;
    else
        [quizRecord]=SoundQuiz(window,lineQ_I,lineAlert,lineCorrect,pauseTime,rand_pair,rand_optSeq, trialcount,centeredRect,preTimeOption,rand_lumOpt,fs);      
        quizParameter(trialcount,:)=quizRecord;
        t=t+1;
    end
    
end
accuracy=sum(quizParameter(:,4))/trialN;

%% Ending
Screen('FillRect', window, [0 0 0]);
DrawFormattedText(window,lineLast,'center','center',[0 1 1]);  
Screen('flip',window);
pause(3);

%% Record and save data
Data = CreateData(subjectID,condition,block,rand_pair,quizParameter,accuracy);
CreateDataFile(Data);

sca;
Screen('CloseAll');

