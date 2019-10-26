function [stimuli]=prepVisuSti(condition,order,locationR,delta)
lumRefBox=[85,170];
stimulusRef=lumRefBox(condition); % matrix of reference point
% determine the stimulus based on reference point and order
stimulusTar=lumRefBox(condition)-(-1)^order*(-1)^locationR*delta;
% e.g., if order=1(1st is target), locationR=1(1st is also reference point), lumTarget=lumRef-delta, choose 1st
%       if order=2, locationR=2,lumTarget=lumRef-delta, choose 2nd

stimuli=[];
if locationR == 1      % 1st stimulus is reference point
    stimuli=[stimulusRef,stimulusTar];
elseif locationR == 2  % 2nd stimulus is reference point
    stimuli=[stimulusTar,stimulusRef];
end

stimuli(3)=order;

