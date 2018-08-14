function [imPart] = drawSquare(imPart, posY, posX, width)
%DRAWSQUARE Summary of this function goes here
%   Detailed explanation goes here

for y = 1:width
    for x = 1:width
        if y == 1 || x == 1
            imPart(posY + y - 1,posX + x - 1) = 1;
        end
    end
end

end

