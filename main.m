function songName = main(testOption,clipName)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gs = 9;
    deltaTL = 3;
    deltaTU = 6;
    deltaF = 9;
    
%     if (exist('hashTable.mat', 'file') == 0 && exist('songNameTable.mat','file') == 0)
%             make_database(gs,deltaTL,deltaTU,deltaF);
%     end

        load('hashTable.mat');
        load('songNameTable.mat');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if testOption == 1 
        full = load(clipName, '-mat');
%         song = full.y;
%         song = butterFilter(song, full.Fs);
%         full.y = song;
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
        recordedSong = getaudiodata(recorder);% Getting the audio date recorded by the variable "recorder"
        %save('customSong', 'y', 'Fs');
        
        %Filter sound using a notch filter
        %y = butterFilter(recordedSong,Fs);
        y = notchFilter(recordedSong, Fs);
        save('customSong','y', 'Fs');
        customSong = load('customSong.mat');
        
        songName = matching(testOption, customSong, hashTable, songNameTable, gs, deltaTL, deltaTU, deltaF);
    end
end