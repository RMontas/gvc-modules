function [imPartBlock, bitCounter] = splitMergeParserBlock(splitMergeBitsream, imPartBlock, bitCounter, bMin, bMax)
%SPLITMERGEPARSERBLOCK Summary of this function goes here
%   Detailed explanation goes here

numEl = bMax / bMin;
blockPartition = zeros(numEl, numEl);

while sum(sum(blockPartition)) < numEl * numEl
    
    foundFirst = 0;
    for j = 1:numEl
        for i = 1:numEl
            if foundFirst == 0 && blockPartition(j,i) == 0
                firstElX = i;
                firstElY = j;
                foundFirst = 1;
            end
        end
    end
    
    bestDir = 2;
    currentPartitionH = 1;
    currentPartitionV = 1;
    while bestDir > 1 % while merge
        if splitMergeBitsream(bitCounter)
            
        end
    end
   
end

end

