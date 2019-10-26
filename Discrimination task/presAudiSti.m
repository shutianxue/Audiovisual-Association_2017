function presAudiSti(window,fs,stimuli,presTime,iti,lineQP)
y1=sin(linspace(0, presTime * stimuli(1)*2*pi,round(presTime*fs)));
sound(y1,fs);
WaitSecs(presTime);
WaitSecs(iti);

y2=sin(linspace(0, presTime * stimuli(2)*2*pi,round(presTime*fs)));
sound(y2,fs);
WaitSecs(presTime);

% Display question
DrawFormattedText(window,lineQP,'center','center',[1 1 1]);
Screen('flip',window);
