clear all;
I = imread('liftingbody.png');
bMin = 8;
bMax = 256;

%% no gradient
i = 1;
[imPart(:,:,i), quadtreeBitsream(:,i)] = quadTree(I, bMin, bMax, 0, 0);
bitstreamSize = size(quadtreeBitsream(:,i),1);
for th = 0.01:0.01:1
    i = i + 1;
    [imPart(:,:,i), quadtreeBitsreamTmp] = quadTree(I, bMin, bMax, th, 0);
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
[imPartGrad(:,:,i), quadtreeBitsreamGrad(:,i)] = quadTree(I, bMin, bMax, 0, 1);
bitstreamSizeGrad = size(quadtreeBitsreamGrad(:,i),1);
for th = 0.01:0.01:1
    i = i + 1;
    [imPartGrad(:,:,i), quadtreeBitsreamGradTmp] = quadTree(I, bMin, bMax, th, 1);
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
