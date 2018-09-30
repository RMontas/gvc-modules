function [imPart, splitMergeBitsream] = splitMerge(im, bMin, bMax, th, useGradient)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dims = size(im);
b=1;
bCurrent = bMax;
while bCurrent > bMin
    dimsBlocks(b,1) = floor(dims(1) / bCurrent); % y
    dimsBlocks(b,2) = floor(dims(2) / bCurrent); % x
    bCurrent = bCurrent / 2;
    b = b + 1;
end

imGrad = double(im);
if useGradient
    imGrad = imgradient(im);
end
imGradNorm = (imGrad - min(min(imGrad))) / (max(max(imGrad)) - min(min(imGrad)));
splitMergeBitsream = 0;
bitCounter = 0;

for hb = 1:dimsBlocks(1,1)
    for wb = 1:dimsBlocks(1,2)
        %% current block info (ABS)
        currentBlockPosAbs = [1 + bMax * (hb - 1)  bMax * hb; ... 
                              1 + bMax * (wb - 1)  bMax * wb];
        currentBlock = imGradNorm(currentBlockPosAbs(1,1):currentBlockPosAbs(1,2), ... 
                                  currentBlockPosAbs(2,1):currentBlockPosAbs(2,2));      
        [bitCounter splitMergeBitsream] = splitMergeBlock(currentBlock, bMin, bMax, th, bitCounter, splitMergeBitsream);      
    end
end

imPart = imGradNorm;
[imPart] = spiltMergeParser(splitMergeBitsream, imPart, bMin, bMax, dimsBlocks(1,1), dimsBlocks(1,2));
%figure, imshow(imPart);
end

