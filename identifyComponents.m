[C, L, LMap] = isolateComponents('../annotated_images');

%% Try simple color histogram
H = colorHist(C, 10);
data = [H L];

%% CNN work
run matconvnet-1.0-beta25/matlab/vl_setupnn % fix this for your setup
% path needed for MatConvNet's cnn_train
addpath('matconvnet-1.0-beta25/examples'); % fix this for your setup; an environment variable might be good, not sure 
% cnn_train wants images as a 4D array; resizing to NxN for ease of use
N = 32;
C2 = zeros(N,N,3,numel(C), 'single');
for i = 1:numel(C)
    C2(:,:,:,i) = im2single(imresize(C{i}, [N N]));
end

C2 = C2 - mean(C2, 4); % Want all the means

classCount = size(LMap, 1);
indices = ones(size(L));
indices(1:uint32(numel(L) / 5)) = 2; % first 1/5th is validation set
[net, stats] = train(C2, L, classCount, indices);
% cnn_train generates figure showing error rates
