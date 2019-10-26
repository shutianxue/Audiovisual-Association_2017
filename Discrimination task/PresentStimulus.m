function stimuli=PresentStimulus(modality,delta,condition,order,locationR,window,windowRect,lineQB,lineQP)

%% ======= Inputs =======
% delta: the change of stimulus intensity
% condition: which reference point (B: 51 & 153; P: 200 & 600) and which staircase is in use
% order: the right answer (1:1st;2:2nd)
% locationR: which stimulus is the reference point (1:1st;2:2nd)
% trial: which trial is in process

%% ======= Parameters =======
presTime=1;    % presentation time of each stimulus, in sec
iti=1;         % "inter-stimulus interval", in secs.
fs=48000;     
baseRect = [0 0 300 300]; % size of image

[xCenter, yCenter] = RectCenter(windowRect);
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter); 

%% ======= Loop =======
if modality == 1          % visual stimuli (image)
    [stimuli]=prepVisuSti(condition,order,locationR,delta);
    presVisuSti(window,stimuli,centeredRect,presTime,iti,lineQB);
elseif modality == 2     % auditory stimuli (sound)
    [stimuli]=prepAudiSti(condition,order,locationR,delta);
    presAudiSti(window,fs,stimuli,presTime,iti,lineQP);
end



