function [correctness] = AnalyzeResponse(optSeq, answer)

%     optSeq   answer(win)  answer(mac) 
% 1     1       49             80
% 2     2       50             79

% OUTPUT: correctness
% incorrect = 0; correct = 1

if  optSeq == answer-48
    correctness = 1;
else
    correctness = 0;
end

if answer == -1
    correctness = 0;
end
    