function err = CreateDataFile(Data)% !! make sure that there is a folder named "Data" in the current pathGradient = 'COA';% Record the Date of expData.Date = fix(clock);Data.Folder = ['Data' filesep ];  %Data.Filename = sprintf('%s-%01d-%01d-%04d-%02d-%02d.mat', ...    Data.SubjectID,Data.condition,Data.block, Data.Date(1), Data.Date(2), Data.Date(3));% Display data struct after the experimentDatahome = pwd;err = 0;try	cd(Data.Folder);    save(Data.Filename,'Data');	cd(home);catch    err = 1;	cd(home);    fprintf('Cannot create data file "%s"\n', [ Data.Folder Data.Filename ]);    return;end[fid, mesg] = fopen([ Data.Folder Data.Filename ], 'r');if fid >= 0    fclose(fid);else    err = 2;	cd(home);    fprintf('%s\n', mesg);    fprintf('"%s"\n', [ Data.Folder Data.Filename ]);    return;end