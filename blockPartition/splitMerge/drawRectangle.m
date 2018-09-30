function [imPart] = drawRectangle(imPart, posY, posX, height, width, paint)

for y = 1:height
    for x = 1:width
        if y == 1 || x == 1
            imPart(posY + y - 1,posX + x - 1) = 1;
        else
           % imPart(posY + y - 1,posX + x - 1) = paint;
        end
    end
end

end