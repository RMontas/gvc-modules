clear all;
I = imread('liftingbody.png');
bMin = 4;
bMax = 512;

%% no gradient
i = 1;
[imPart(:,:,i), splitMergeBitsream(:,i)] = splitMerge(I, bMin, bMax, 0, 0);
bitstreamSize = size(splitMergeBitsream(:,i),1);
for th = 0.01:0.01:1
    i = i + 1;
    [imPart(:,:,i), splitMergeBitsreamTmp] = splitMerge(I, bMin, bMax, th, 0);
    splitMergeBitsream(1:size(splitMergeBitsreamTmp'),i) = splitMergeBitsreamTmp;
    bitstreamSize(i) = size(splitMergeBitsreamTmp',1);
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
[imPartGrad(:,:,i), splitMergeBitsreamGrad(:,i)] = splitMerge(I, bMin, bMax, 0, 1);
bitstreamSizeGrad = size(splitMergeBitsreamGrad(:,i),1);
for th = 0.01:0.01:1
    i = i + 1;
    [imPartGrad(:,:,i), splitMergeBitsreamGradTmp] = splitMerge(I, bMin, bMax, th, 1);
    splitMergeBitsreamGrad(1:size(splitMergeBitsreamGradTmp'),i) = splitMergeBitsreamGradTmp;
    bitstreamSizeGrad(i) = size(splitMergeBitsreamGradTmp',1);
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
