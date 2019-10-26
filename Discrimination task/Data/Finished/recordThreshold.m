function recordThreshold(Data,condition)
% brightness / pitch
% c1: condition
% c2: pre-test staircase 1 threshold
% c3: post-test staircase 1 threshold
% c4: pre-test staircase 2 threshold
% c5: post-test staircase 2 threshold

% only used the first time:
% recordB=zeros(100,5); recordP=zeros(100,5);save('RecordB','recordB');save('RecordP','recordP');

load('RecordB');
load('RecordP');

subjectID=str2num(Data.SubjectID);
modality=Data.modality;
block=Data.block;

recordB(subjectID,1)= condition;
recordP(subjectID,1)= condition;

if modality == 1
    recordB(subjectID,[block+1,block+3])=Data.Threshold(1:2,1);
    % display
    fprintf('Brightness threshold of subject #%d is:\n',subjectID);
    recordB(subjectID,:)
    save('RecordB','recordB');

elseif modality == 2
    recordP(subjectID,[block+1,block+3])=Data.Threshold(1:2,1);
    % display
    fprintf('Pitch threshold of subject #%d is:\n',subjectID);
    recordB(subjectID,:)
    save('RecordP','recordP');
end






    
   