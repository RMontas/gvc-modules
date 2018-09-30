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
        bitCounter = bitCounter + 1;
        if splitMergeBitsream(bitCounter) == 1 % merge
            bitCounter = bitCounter + 1;
            if(splitMergeBitsream(bitCounter)) == 0 % HOR
                bestDir = 2;
                currentPartitionH = currentPartitionH + 1;
            else % VER
                bestDir = 3;
                currentPartitionV = currentPartitionV + 1;
            end
        else
            bestDir = 1; % split
        end
        
        blockPartition(firstElY:(firstElY-1+currentPartitionV), firstElX:(firstElX-1+currentPartitionH)) = 1;
    end
    currentBlockPosAbs = [1 + bMin * (firstElY - 1)  bMin * (firstElY - 1 + currentPartitionV); ...
                          1 + bMin * (firstElX - 1)  bMin * (firstElX - 1 + currentPartitionH)];
    [imPartBlock] = drawRectangle(imPartBlock, currentBlockPosAbs(1,1), currentBlockPosAbs(2,1) ... 
                                             , currentPartitionV * bMin, currentPartitionH * bMin ...
                                             , sum(sum(imPartBlock(currentBlockPosAbs(1,1):currentBlockPosAbs(1,2),currentBlockPosAbs(2,1):currentBlockPosAbs(2,2)))) / (currentPartitionV*currentPartitionH*bMin*bMin));
   
end

end

