function [StimValInit, MaxTtest, MinTtest,InitGuess] = GetParams(modality)
if modality == 1               % Visual
    MaxTtest = log10(255);        % Max stimulus magnitude
    MinTtest=log10(10);           % Min stimulus magnitude
    StimValInit = log10(250);     % initial test value (need to be relatively easy)
    InitGuess = 40;               % prior threshold estimate

elseif modality == 2           % Auditory
    MaxTtest=log10(800);
    MinTtest=log10(100);
    StimValInit = log10(40);      
    InitGuess = 4;
end