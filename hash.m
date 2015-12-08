function hashTable = hash(table)
    %h(f_1,f_2,t_2-t_1 )=(t_2-t_1 ) 2^16+f_1 2^8+f_2
    numRows = size(table,1);
    numCols = size(table,2);
    %Hash table will have the same numRows and 3 cols
    
    %Generate hash table row by row
    
    %If there are 5 elements per row,the we have a songID
    if numCols == 5
        hashTable = zeros(numRows, 3);
        for i = 1:numRows
            oldRow = table(i,:);
            
            f1 = oldRow(1) - 1;
            f2 = oldRow(2) - 1;
            t1 = oldRow(3);
            deltaT = oldRow(4);
            songID = oldRow(5);
            
            hashValue = (deltaT * 2^16) + (f1*2^8) + f2;
            
            newRow = [hashValue t1 songID];
            
            %Append new row to hash table
            hashTable(i,:) = newRow;
        end
    else %This is a sample clip with 4 cols
        hashTable = zeros(numRows, 2);
        for i = 1:numRows
            oldRow = table(i,:);
            
            f1 = oldRow(1) - 1;
            f2 = oldRow(2) - 1;
            t1 = oldRow(3);
            deltaT = oldRow(4);
            
            hashValue = (deltaT * 2^16) + (f1*2^8) + f2;
            
            newRow = [hashValue, t1];
            
            %Append new row to hash table
            hashTable(i,:) = newRow;
            
        end
        
    end
end