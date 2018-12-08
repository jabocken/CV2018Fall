[C, L, LMap] = isolateComponents('../annotated_images');

%% Try simple color histogram
H = colorHist(C, 10);
data = [H L];

%% CNN work
run /home/josh/src/matconvnet-1.0-beta25/matlab/vl_setupnn
% path needed for MatConvNet's cnn_train
addpath('/home/josh/src/matconvnet-1.0-beta25/examples')
% cnn_train wants images as a 4D array; resizing them to NxN for ease of use
N = 32;
C2 = zeros(N,N,3,numel(C), 'single');
for i = 1:numel(C)
    C2(:,:,:,i) = im2single(imresize(C{i}, [N N]));
end

C2 = C2 - mean(C2, 4); % Want all the means

classCount = size(LMap, 1);

starts = [1 93 186 280 373]; % manual setup because the last bit wasn't a good size
ends = [93 186 280 373 467];
count = numel(starts);
err = 0;
for i = 1:count
    rmdir data s % want each CNN to be fresh for the cross-validation

    indices = ones(size(L));
    indices(starts(i):ends(i)) = 2; % validation indices
    [~, stats] = train(C2, L, classCount, indices);
    err = err + stats.val(end).top1err;
end

avgAccuracy = 1 - err / count %#ok<NOPTS>
