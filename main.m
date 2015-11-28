function songName = main(testOption,clipName)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gs = 9;
    deltaTL = 3;
    deltaTU = 6;
    deltaF = 9;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    make_database(gs,deltaTL,deltaTU,deltaF);
    load('hashTable.mat')
    load('songNameTable.mat')
    
    songName = matching(testOption, clipName, hashTable, songNameTable, gs, deltaTL, deltaTU, deltaF)
    
end