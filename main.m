function songName = main(testOption,clipName)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gs = 9;
    deltaTL = 3;
    deltaTU = 6;
    deltaF = 9;
    
    if (exist('hashTable.mat', 'file') == 0 && exist('songNameTable.mat','file') == 0)
            make_database(gs,deltaTL,deltaTU,deltaF);
        end

        load('hashTable.mat')
        load('songNameTable.mat')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if testOption == 1 
        full = load(clipName, '-mat');
        songName = matching(testOption, full, hashTable, songNameTable, gs, deltaTL, deltaTU, deltaF);
    else
        %load(clipName, '-mat');
        %sound(y, Fs);
        bitsPerSample = 8;
        channel = 1;
        recordTime = 10;
        Fs = 44100;
        recorder = audiorecorder(Fs,bitsPerSample,channel);% Declare recorder variable with some defined properties
        recordblocking(recorder,recordTime);% Record audio for the amount of "recordTime"
        song = getaudiodata(recorder);% Getting the audio date recorded by the variable "recorder"
        %save('customSong', 'y', 'Fs');
        save('customSong','song', 'Fs');
        customSong = load('customSong.mat');
        songName = matching(testOption, customSong, hashTable, songNameTable, gs, deltaTL, deltaTU, deltaF);
    end
end