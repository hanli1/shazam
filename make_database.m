function make_database(gs,deltaTL,deltaTU,deltaF)

%%%%%%%%%%%%%%% Read Songs In Database and make table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Files = what('songDatabase/');  
    matFiles = Files.mat;  
    
    %Store Song Names into an array
    numSongs = length(matFiles);
    databaseFiles = cell(numSongs, 1);
    songNameTable = cell(numSongs, 1);
    
    database = [];  %Database of tables
    %Generate database by calling make_table for each song
    for i = 1:numSongs
        fileName = matFiles{i};
        toRead = ['songDatabase/', fileName];
        databaseFiles{i,1} = toRead;   %Array of song names
        songNameTable{i,1} = fileName;
        
        %Make Database.The SongID is the index of the song in databaseFiles
        table = make_table(toRead, gs, deltaTL, deltaTU, deltaF);
        %Generate new column of songID to append to table
        colSongID = repmat(i, size(table,1), 1);
        table = [table colSongID];
        
        %Append table to database
        database = [database;table];
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%% Create Hash Table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Apply Hash function and convert database to 3 columns
    hashTable = hash(database);
    save 'hashTable.mat' hashTable;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Save SongNameTable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save 'songNameTable.mat' songNameTable;
end
