[C, L, LMap] = isolateComponents('../annotated_images');

%% Try simple color histogram
H = colorHist(C, 10);
data = [H L];

%% CNN work
run matconvnet-1.0-beta25/matlab/vl_setupnn % fix this for your setup
% path needed for MatConvNet's cnn_train
addpath('matconvnet-1.0-beta25/examples'); % fix this for your setup; an environment variable might be good, not sure 
% cnn_train wants images as a 4D array; resizing them to NxN for ease of use
N = 32;
C2 = zeros(N,N,3,numel(C), 'single');
for i = 1:numel(C)
    C2(:,:,:,i) = im2single(imresize(C{i}, [N N]));
end

C2 = C2 - mean(C2, 4); % Want all the means

classCount = size(LMap, 1);

n = numel(L);
sectional = uint32(n / 5);
last = sectional;
first = 1;
i = 1;
count = 0;
err = 0;
lastIteration = false;
while lastIteration == false
    % want to terminate after last is n, but still execute that time
    if last == n
        lastIteration = true;
    end

    indices = ones(size(L));
    indices(first:last) = 2; % validation indices
    [~, stats] = train(C2, L, classCount, indices);
    err = err + stats.val(end).top1err;
    count = count + 1;

    first = last + 1;
    last = last + sectional;
    if last > n
        last = n;
    end
end

avgAccuracy = 1 - err / count %#ok<NOPTS>
