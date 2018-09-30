function [imPart] = spiltMergeParser(splitMergeBitsream, imPart, bMin, bMax, dimsBlocksY, dimsBlocksX)
%SPILTMERGEPARSER Summary of this function goes here
%   Detailed explanation goes here

bitCounter = 1;
for hb = 1:dimsBlocksY
    for wb = 1:dimsBlocksX
        imPart = drawSquare(imPart, 1 + (hb-1)*bMax, 1 + (wb-1)*bMax, bMax);
        imPartBlock = imPart(1 + (hb-1)*bMax : hb*bMax, 1 + (wb-1)*bMax : wb*bMax);
        [imPartBlock, bitCounter] = splitMergeParserBlock(splitMergeBitsream, imPartBlock, bitCounter, bMin, bMax);
        imPart(1 + (hb-1)*bMax : hb*bMax, 1 + (wb-1)*bMax : wb*bMax) = imPartBlock;
    end
end


end

