function [stimuli]=prepAudiSti(condition,order,locationR,delta)
pitRefBox=[200,600];
pitRef=pitRefBox(condition);
pitTar=pitRef-(-1)^order*(-1)^locationR*delta;  % please refer to "prepVisuSti" for explanation

stimuli=[];
if locationR == 1      % 1st stimulus is reference point
    stimuli=[pitRef,pitTar];
elseif locationR == 2  % 1st stimulus is reference point
    stimuli=[pitTar,pitRef];
end

stimuli(3)=order;
