
function quest_D(subjectID, modality, block)

% ----- Description -----
% Discrimination test
% On each trial, observers were presented with two stimuli (either image/sound) sequentially
% Then, they have to judge which stimulus is higher in brightness/pitch.
% Stimuli distance is adjusted according to QUEST.

% ----- Inputs -----
% subjectID    three-letter subject identifier (e.g. 001, 002)
% modality:    1=visual; 2=auditory
% block        1=pre-test; 2=post-test

%% Safeguard
Screen('Preference', 'SkipSyncTests', 1);

%% Staircase setting
conditions = [1;2];                 % 2 conditions of staircase, each is assigned one reference point
                                    % 1=51; 2=153
nconditions = size(conditions,1);   % Number of staircase

order = [1;2];                      % order of right answer(1:first; 2:second)
norders= size(order,1);             % Number of order

locationR=[1;2];                    % location of reference point in two stimuli(1:first; 2:second)
nlocationRs=size(locationR,1);      % Number of location


%% Prepare practice trials
% Number of trials per staircase
numTrialsPr = 4;
ntrialsPr = numTrialsPr/norders/nlocationRs; 

trialRow = 1;
for t=1:ntrialsPr
    for c=1:nconditions
        for o=1:norders 
            for l=1:nlocationRs
                trialsPr(trialRow,1)= conditions(c);
                trialsPr(trialRow,2)= order(o);
                trialsPr(trialRow,3)= locationR(l);
                trialRow=trialRow+1;
            end
        end
    end
end 

% randomize [trialsPr] 
random=randperm(size(trialsPr,1));
j=1;
for i=random
    trialsPr2(j,:)=trialsPr(i,:);
    j=j+1;
end
trialsPr=trialsPr2;
clear trialsPr2;

%% Prepare formal exp trials
% we split trials by staircase (i.e., reference point), which is [condition]
% we have 2 conditions, each contains 60 trials.
numTrials = 60;  

% 2 factors: [order] & [locationR]
% thus, each staircase should contain trials marked by different order and locationR
ntrials = numTrials/norders/nlocationRs; 

trialRow = 1;
for t=1:ntrials
    for c=1:nconditions
        for o=1: norders
            for l=1:nlocationRs
                trials(trialRow,1)= conditions(c);
                trials(trialRow,2)= order(o);
                trials(trialRow,3)= locationR(l);
                trialRow=trialRow+1;
            end
        end
    end
end

% randomize [trials]
random=randperm(size(trials,1));
j=1;
for i=random
    trials2(j,:)=trials(i,:);
    j=j+1;
end
trials=trials2;
% trials has 3 columns: order,condition,locationR
clear trials2;

%% Run Experiment
RunExp_D(subjectID, block, trials, trialsPr, nconditions, conditions, modality)
