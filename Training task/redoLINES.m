function redoLINES(window,pauseTime,lineAlert,line_rememo)

% RED "Incorrect"
Screen('FillRect', window, [0 0 0]);
DrawFormattedText(window,lineAlert,'center','center',[1 0 0]);  
Screen('flip',window);
WaitSecs(pauseTime);

Screen('FillRect', window, [0 0 0]);Screen('flip',window);
WaitSecs(pauseTime);

% Please rememorize
DrawFormattedText(window,line_rememo,'center','center',[1 1 1]);  
Screen('flip',window);
WaitSecs(pauseTime);

Screen('FillRect', window, [0 0 0]);Screen('flip',window);
WaitSecs(pauseTime);
