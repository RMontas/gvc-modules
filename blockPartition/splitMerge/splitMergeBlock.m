function [bitCounter, splitMergeBitsream] = splitMergeBlock(im, bMin, bMax, th, bitCounter, splitMergeBitsream)
%UNTITLED Summary of this function goes here
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
    while bestDir > 1  
        currentBlockPosAbs = [1 + bMin * (firstElY - 1)  bMin * (firstElY - 1 + currentPartitionV); ...
                              1 + bMin * (firstElX - 1)  bMin * (firstElX - 1 + currentPartitionH)];
        currentBlockMergeHorPosAbs = [1 + bMin * (firstElY - 1)  bMin * (firstElY - 1 + currentPartitionV); ...
                                      1 + bMin * (firstElX - 1)  bMin * (firstElX + currentPartitionH)];
        currentBlockMergeVerPosAbs = [1 + bMin * (firstElY - 1)  bMin * (firstElY + currentPartitionV); ...
                                      1 + bMin * (firstElX - 1)  bMin * (firstElX - 1 + currentPartitionH)];
        currentBlock = im(currentBlockPosAbs(1,1):currentBlockPosAbs(1,2), ...
                          currentBlockPosAbs(2,1):currentBlockPosAbs(2,2));
        cannotDoMergeHor = 0;
        cannotDoMergeVer = 0;
        if firstElX + currentPartitionH <= numEl % check (ymax,xmax) && (ymin, xmax) 
            if blockPartition(currentBlockMergeHorPosAbs(1,2)/bMin,currentBlockMergeHorPosAbs(2,2)/bMin) == 0 && ...
               blockPartition(firstElY,currentBlockMergeHorPosAbs(2,2)/bMin) == 0
                currentBlockMergeHor = im(currentBlockMergeHorPosAbs(1,1):currentBlockMergeHorPosAbs(1,2), ...
                                          currentBlockMergeHorPosAbs(2,1):currentBlockMergeHorPosAbs(2,2));
                varMergeHor = max(max(currentBlockMergeHor)) - min(min(currentBlockMergeHor));
            else
                cannotDoMergeHor = 1;
                varMergeHor = -1;
            end
        else
            cannotDoMergeHor = 1;
            varMergeHor = -1;
        end
        if firstElY + currentPartitionV <= numEl
            if blockPartition(currentBlockMergeVerPosAbs(1,2)/bMin,currentBlockMergeVerPosAbs(2,2)/bMin) == 0 && ...
               blockPartition(currentBlockMergeVerPosAbs(1,2)/bMin,firstElX) == 0
            currentBlockMergeVer = im(currentBlockMergeVerPosAbs(1,1):currentBlockMergeVerPosAbs(1,2), ...
                currentBlockMergeVerPosAbs(2,1):currentBlockMergeVerPosAbs(2,2));
            varMergeVer = max(max(currentBlockMergeVer)) - min(min(currentBlockMergeVer));
            else
                cannotDoMergeVer = 1;
                varMergeVer = -1;
            end
        else
            cannotDoMergeVer = 1;
            varMergeVer = -1;
        end
        
        varCurrent = max(max(currentBlock)) - min(min(currentBlock));
        
        [sortedVar varIdx] = sort([varCurrent varMergeHor varMergeVer]);
        
        bestDir = 1;
        for i=3:-1:1
            if sortedVar(i) < th && sortedVar(i) >= 0
                bestDir = varIdx(i);
                break;
            end
        end
        
        % no merge
        if bestDir == 1
            bitCounter = bitCounter + 1;
            splitMergeBitsream(bitCounter) = 0;
        end
        % merge hor
        if bestDir == 2
            bitCounter = bitCounter + 2;
            splitMergeBitsream(bitCounter - 1) = 1;
            splitMergeBitsream(bitCounter) = 0;
            currentPartitionH = currentPartitionH + 1;
        end
        % merge ver
        if bestDir == 3
            bitCounter = bitCounter + 2;
            splitMergeBitsream(bitCounter - 1) = 1;
            splitMergeBitsream(bitCounter) = 1;
            currentPartitionV = currentPartitionV + 1;
        end
        
        blockPartition(firstElY:(firstElY-1+currentPartitionV), firstElX:(firstElX-1+currentPartitionH)) = 1;
        
    end

end

end

