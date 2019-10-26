function plotData(Data)

smb{1} = '-*k';
smb{2} = '-*b';

figure, hold on

if Data.modality == 1       % Brightness
    lgdmtrx = {'Reference point=85','Reference point=170'};
    if Data.block == 1      % pre-test
        title('Brightness discrimination-pre');
    elseif Data.block == 2  % posttest
        title('Brightness discrimination-post');
    end
elseif Data.modality == 2   % Pitch
    lgdmtrx = {'Reference point=200','Reference point=600'};
    if Data.block == 1      % pre-test
        title('Pitch discrimination-pre');
    elseif Data.block == 2  % posttest
        title('Pitch discrimination-post');
    end
end

conditions=[1,2];

for m = 1:2 
    i = conditions(m);
    plot((1:size(Data.Data.PerCondition.StimVals{i},1))', Data.Data.PerCondition.StimVals{i}, smb{i});
    lgdmBox{m}=lgdmtrx{m};
end
legend(lgdmBox{1},lgdmBox{2});
xlabel('Trial');
ylabel('Stimulus Delta');