function Data = CreateData(subjectID,condition,block,rand_pair,quizParameter,accuracy)
%Get screen specifications
Data.SubjectID = subjectID;
Data.block=block;
Data.condition=condition;
Data.BP_pair_presented=rand_pair;
Data.Parameter_of_quiz=quizParameter;
% quizRecord has 5 columns: 
    % column 1: stimuli parameter;
    % column 2: target_opt parameter; 
    % column 3: non_target_opt parameter; 
    % column 4: number of attemps
    % column 5: average response time
Data.Accuracy=accuracy;