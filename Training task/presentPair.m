function presentPair(fs,window,centeredRect,stiLuminance,stiPitch,preTimeStimulus)

% present the image
Screen('FillRect',window,repmat(stiLuminance,1,3)./255,centeredRect);
Screen('Flip', window);

% play the sound (concurrently)
y = sin(linspace(0, preTimeStimulus * stiPitch*2*pi, round(preTimeStimulus*fs)));
sound(y, fs);  
WaitSecs(preTimeStimulus);

% blank
Screen('FillRect', window, [0 0 0]);
Screen('flip',window);
WaitSecs(1);