function presVisuSti(window,stimuli,centeredRect,presTime,iti,lineQB)

Screen('FillRect',window,repmat(stimuli(1),3,1)./255,centeredRect);
%Screen('FrameRect',window,[1 1 1],centeredRect+1,3);
Screen('Flip', window);
WaitSecs(presTime);  

Screen('FillRect', window, [0 0 0]); 
Screen('flip',window);
WaitSecs(iti); 

% 2nd image
Screen('FillRect',window,repmat(stimuli(2),3,1)./255,centeredRect);
%Screen('FrameRect',window,[1 1 1],centeredRect+1,3);
Screen('Flip', window);
WaitSecs(presTime); % maintain the image on screen

Screen('FillRect', window, [0 0 0]); 
Screen('flip',window);
WaitSecs(iti); 

% Display question
DrawFormattedText(window,lineQB,'center','center',[1 1 1]);
Screen('flip',window);