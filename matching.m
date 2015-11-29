function songName = matching(testOption,clip,hashTable,songNameTable,gs,deltaTL,deltaTU,deltaF)
    %%%%%%%%%%%%%%%%% Hash Input Clip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clipTable = make_table(clip, gs, deltaTL, deltaTU, deltaF);
    clipHashTable = hash(clipTable);
    clipLength = size(clipHashTable, 1);
    databaseLength = size(hashTable,1);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %%%%%%%%%%%%%%%% Search for hashes in the database %%%%%%%%%%%%%%%%%%%%%%
   matchMatrix = [];
   for i = 1:clipLength
       clipHashRow = clipHashTable(i,:);
       clipHash = clipHashRow(1);
       
       for j = 1:databaseLength
           databaseHashRow = hashTable(j,:);
           databaseHash = databaseHashRow(1);
           
           %If there is a match, store it to matches
           if clipHash == databaseHash
               t1s = databaseHashRow(2);
               t1c = clipHashRow(2);
               to = t1s-t1c;
               songID = databaseHashRow(3);
               
               match = [to songID];
               matchMatrix = [matchMatrix; match];
           end
       end
   end
   
   %Find the mode of the to values
   toList = matchMatrix(:,1);
   toMode = mode(toList);
   
   %List of rows in matchMatrix with toMode
   toMatch = matchMatrix(matchMatrix(:,1)==toMode,:);
   songIDMode = mode(toMatch(:,2));
   
   songName = songNameTable(songIDMode);
   
end