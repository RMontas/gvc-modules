function [bitCounter, quadtreeBitsream] = quadTreeBlock(blk, bMin, bMax, bCurrent, th, currentQuadtreeBlockPosAbs, bitCounter, quadtreeBitsream)
%% QUADTREEBLOCK Summary 
% Block parition using quadtree (similar to HEVC) but limited to power of 2
% square blocks --- recursive function
%% 

if bCurrent > bMin
    if max(max(blk)) - min(min(blk)) >= th
        % split
        %disp(strcat("bCurrent = ", num2str(bCurrent)))
        %disp("SPLIT")
        bitCounter = bitCounter + 1;
        quadtreeBitsream(bitCounter) = 1;
        for yb = 1:2
            for xb = 1:2
                %% current quadtree block info (REL)
                currentQuadtreeBlockPosRel = [1 + (bCurrent/2) * (yb - 1)  yb * (bCurrent/2); ...
                                              1 + (bCurrent/2) * (xb - 1)  xb * (bCurrent/2)];
                %disp(strcat("X = ",num2str(currentQuadtreeBlockPosRel(2,1)) ...
                %           ," Y = ", num2str(currentQuadtreeBlockPosRel(1,1))));
                %% current quadtree block info (ABS)
                currentQuadtreeBlockPosAbs = [currentQuadtreeBlockPosAbs(1,1) + currentQuadtreeBlockPosRel(1,1) - 1  currentQuadtreeBlockPosAbs(1,1) + currentQuadtreeBlockPosRel(1,1) - 2 + bCurrent/2; ...
                                              currentQuadtreeBlockPosAbs(2,1) + currentQuadtreeBlockPosRel(2,1) - 1  currentQuadtreeBlockPosAbs(2,1) + currentQuadtreeBlockPosRel(2,1) - 2 + bCurrent/2];
                %disp(strcat("X = ",num2str(currentQuadtreeBlockPosAbs(2,1)) ...
                %           ," Y = ", num2str(currentQuadtreeBlockPosAbs(1,1))));
                %%
                [bitCounter, quadtreeBitsream] = quadTreeBlock( ... 
                              blk(currentQuadtreeBlockPosRel(1,1):currentQuadtreeBlockPosRel(1,2), ...
                                  currentQuadtreeBlockPosRel(2,1):currentQuadtreeBlockPosRel(2,2)),...
                              bMin, bMax, bCurrent/2, th, ...
                              currentQuadtreeBlockPosAbs, ...
                              bitCounter, quadtreeBitsream);
                
            end
        end
    else
        %disp("DO NOT SPLIT")
        bitCounter = bitCounter + 1;
        quadtreeBitsream(bitCounter) = 0;
    end
end

end


