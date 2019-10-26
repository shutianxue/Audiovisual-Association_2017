function [quizSeq,stiImage,stiSound]=quizSequence(condition)

if condition == 3 % random
    interval=[5 5 5 4 3 4 4]; % fewer quizzes for random condition
else
    interval=[4 3 4 3 5 3 3 3 2];
end

for m=1:length(interval)
   if m==1
       quiz_mid=interval(m);
   else
       quiz_mid=interval(m)+quiz_mid;
   end
   quizSeq(m)=quiz_mid;
end

odd=1:2:length(quizSeq);
even=2:2:length(quizSeq)-1;
stiImage=quizSeq(odd); % location of quiz when stimulus is image
stiSound=quizSeq(even); % location of quiz when stimulus is sound
