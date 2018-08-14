I = imread('liftingbody.png');

%% no gradient
i = 1;
[imPart(:,:,i), quadtreeBitsream(:,i)] = quadTree(I, 1, 512, 0, 0);
bitstreamSize = size(quadtreeBitsream(:,i),1);
for th = 0.01:0.01:1
    i = i + 1;
    [imPart(:,:,i), quadtreeBitsreamTmp] = quadTree(I, 1, 512, th, 0);
    quadtreeBitsream(1:size(quadtreeBitsreamTmp'),i) = quadtreeBitsreamTmp;
    bitstreamSize(i) = size(quadtreeBitsreamTmp',1);
end

i = 101;
figure
for th = 1:-0.01:0
    imshow(imPart(:,:,i));
    pause(0.1)
    i = i - 1;
end

%% using gradient
i = 1;
[imPartGrad(:,:,i), quadtreeBitsreamGrad(:,i)] = quadTree(I, 1, 512, 0, 1);
bitstreamSizeGrad = size(quadtreeBitsreamGrad(:,i),1);
for th = 0.01:0.01:1
    i = i + 1;
    [imPartGrad(:,:,i), quadtreeBitsreamGradTmp] = quadTree(I, 1, 512, th, 1);
    quadtreeBitsreamGrad(1:size(quadtreeBitsreamGradTmp'),i) = quadtreeBitsreamGradTmp;
    bitstreamSizeGrad(i) = size(quadtreeBitsreamGradTmp',1);
end

i = 101;
figure
for th = 1:-0.01:0
    imshow(imPartGrad(:,:,i));
    pause(0.1)
    i = i - 1;
end

figure
plot(0:0.01:1,bitstreamSize)
hold
plot(0:0.01:1,bitstreamSizeGrad,'k')
legend('Var', 'Var(Grad)')
ylabel('Size (bits)')
xlabel('Threshold = max(currentBlock) - min(currentBlock) >= th')
