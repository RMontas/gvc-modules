function [imPart, quadtreeBitsream] = quadTree(im, bMin, bMax, th, useGradient)
%% QUADTREE Summary 
% Block parition using quadtree (similar to HEVC) but limited to power of 2
% square blocks 
%% 

dims = size(im);
b=1;
bCurrent = bMax;
while bCurrent > bMin
    dimsBlocks(b,1) = floor(dims(1) / bCurrent); % y
    dimsBlocks(b,2) = floor(dims(2) / bCurrent); % x
    bCurrent = bCurrent / 2;
    b = b + 1;
end

%imGrad = imgradient(im);
imGrad = double(im);
if useGradient
    imGrad = imgradient(im);
end
imGradNorm = (imGrad - min(min(imGrad))) / (max(max(imGrad)) - min(min(imGrad)));
%max(block(:)) - min(block(:)) >= th
quadtreeBitsream = 0;
bitCounter = 0;

for hb = 1:dimsBlocks(1,1)
    for wb = 1:dimsBlocks(1,2)
        %% current block info (ABS)
        currentBlockPosAbs = [1 + bMax * (hb - 1)  bMax * hb; ... 
                              1 + bMax * (wb - 1)  bMax * wb];
        %disp(strcat("X = ",num2str(currentBlockPosAbs(2,1))," Y = ", num2str(currentBlockPosAbs(1,1))));
        %%  
        currentBlock = imGradNorm(currentBlockPosAbs(1,1):currentBlockPosAbs(1,2), ... 
                                  currentBlockPosAbs(2,1):currentBlockPosAbs(2,2));      
        if bMax > bMin
            if max(max(currentBlock)) - min(min(currentBlock)) >= th
                % split
                %disp("SPLIT")
                bitCounter = bitCounter + 1;
                quadtreeBitsream(bitCounter) = 1;
                for yb = 1:2
                    for xb = 1:2
                        %% current quadtree block info (REL)
                        currentQuadtreeBlockPosRel = [1 + (bMax/2) * (yb - 1)  yb * (bMax/2); ...
                                                      1 + (bMax/2) * (xb - 1)  xb * (bMax/2)];
                        %disp(strcat("X = ",num2str(currentQuadtreeBlockPosRel(2,1)) ...
                        %           ," Y = ", num2str(currentQuadtreeBlockPosRel(1,1))));
                        %% current quadtree block info (ABS)
                        currentQuadtreeBlockPosAbs = [currentBlockPosAbs(1,1) + currentQuadtreeBlockPosRel(1,1) - 1  currentBlockPosAbs(1,1) + currentQuadtreeBlockPosRel(1,1) - 2 + bMax/2; ...
                                                      currentBlockPosAbs(2,1) + currentQuadtreeBlockPosRel(2,1) - 1  currentBlockPosAbs(2,1) + currentQuadtreeBlockPosRel(2,1) - 2 + bMax/2];
                        %disp(strcat("X = ",num2str(currentQuadtreeBlockPosAbs(2,1)) ...
                        %           ," Y = ", num2str(currentQuadtreeBlockPosAbs(1,1))));
                        %%
                        [bitCounter, quadtreeBitsream] = quadTreeBlock( ... 
                                      currentBlock(currentQuadtreeBlockPosRel(1,1):currentQuadtreeBlockPosRel(1,2), ... 
                                                   currentQuadtreeBlockPosRel(2,1):currentQuadtreeBlockPosRel(2,2)),...
                                      bMin, bMax, bMax/2, th, ...
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
end

[imPart] = quadTreeParser(quadtreeBitsream, imGradNorm, bMin, bMax, dimsBlocks(1,1), dimsBlocks(1,2)); 

end


