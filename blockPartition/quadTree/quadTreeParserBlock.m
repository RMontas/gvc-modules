function [imPartBlock, bitCounter] = quadTreeParserBlock(quadtreeBitsream, imPartBlock, bitCounter, bMin, bCurrent)
%QUADTREEBLOCKPARSER Summary of this function goes here
%   Detailed explanation goes here

if bCurrent > bMin
    bitCounter = bitCounter + 1;
    if quadtreeBitsream(bitCounter)
        bCurrent = bCurrent / 2;
        for y = 1:2
            for x = 1:2
                imPartBlock = drawSquare(imPartBlock, 1 + bCurrent * (y - 1), 1 + bCurrent * (x - 1), bCurrent);
                imPartSubBlock = imPartBlock(1 + bCurrent * (y - 1) : y * bCurrent, 1 + bCurrent * (x - 1): x * bCurrent);
                [imPartSubBlock, bitCounter] = quadTreeParserBlock(quadtreeBitsream, imPartSubBlock, bitCounter, bMin, bCurrent);
                imPartBlock(1 + bCurrent * (y - 1) : y * bCurrent, 1 + bCurrent * (x - 1): x * bCurrent) = imPartSubBlock;
            end
        end
    end
end

end

