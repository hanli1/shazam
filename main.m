function songName = main(testOption,clipName)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gs = 9;
    deltaTL = 3;
    deltaTU = 6;
    deltaF = 9;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %If the hastables and 
    if (exist('hashTable.mat', 'file') == 0 && exist('songNameTable.mat','file') == 0)
        make_database(gs,deltaTL,deltaTU,deltaF);
    end
    
    load('hashTable.mat')
    load('songNameTable.mat')
    
    songName = matching(testOption, clipName, hashTable, songNameTable, gs, deltaTL, deltaTU, deltaF);
    
    
end