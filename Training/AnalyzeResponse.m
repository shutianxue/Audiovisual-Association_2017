function [correctness] = AnalyzeResponse(optSeq, answer)

%     optSeq   answer(win)  answer(mac) 
% 1     1       49             80
% 2     2       50             79

% OUTPUT: correctness
% incorrect = 0; correct = 1

if answer == -1
    correctness = 0;
end

% for windows
if  optSeq == answer-48
    correctness = 1;
else
    correctness = 0;
end
%}

%{
% for mac
answer1st=answer-79;
answer2nd=answer-77;

if optSeq==answer1st || optSeq==answer2nd
    correctness=1;
else
    correctness=0;
end
%}

    