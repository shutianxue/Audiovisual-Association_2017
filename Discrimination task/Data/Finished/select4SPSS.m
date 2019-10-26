function [Stair1,Stair2]=select4SPSS(modality)
% Input: recordB/P
% c1: subjectID
% c2: pre-test staircase 1 threshold
% c3: post-test staircase 1 threshold
% c4: pre-test staircase 2 threshold
% c5: post-test staircase 2 threshold

% output: stair1/stair2:
% c1: data (threshold)
% c2: condition (1,2,3)
% c3: pre/post (1/2)

if modality ==1 % brightness
    load RecordB.mat;
    record=recordB;
elseif modality==2
    load RecordP.mat;
    record=recordP;
end

effectiveData=record(record(:,1)~=0,:);
[numSubject,~]=size(effectiveData);
Stair1=[];
Stair2=[];

Stair1(1:numSubject,[1,2])=effectiveData(:,[1,2]);
Stair1(1:numSubject,3)=1;
Stair1(numSubject+1:numSubject*2,[1,2])=effectiveData(:,[1,3]);
Stair1(numSubject+1:numSubject*2,3)=2;

Stair2(1:numSubject,[1,2])=effectiveData(:,[1,4]);
Stair2(1:numSubject,3)=1;
Stair2(numSubject+1:numSubject*2,[1,2])=effectiveData(:,[1,5]);
Stair2(numSubject+1:numSubject*2,3)=2;

save('Threshold excel for SPSS','Stair1','Stair2');


