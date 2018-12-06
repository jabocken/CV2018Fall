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
% Not doing cross-validation right now, just using 1/5th for testing right
% now
indices = ones(size(L));
indices(1:uint32(numel(L) / 5)) = 2; % first 1/5th is validation set
[net, stats] = train(C2, L, classCount, indices);
% cnn_train generates figure showing error rates


function [net, stats] = train(C, L, classCount, indices)
opts.train.numEpochs = 75; % too many epochs results in overfitting
opts.train.continue = true;
opts.train.gpus = 1;
opts.train.learningRate = 0.01;

use_gpu = ~isempty(opts.train.gpus);

% Create network (see HELP VL_SIMPLENN)
f = 0.01;
net.layers = cell(6,1);
net.layers{1} = struct('type', 'conv', ...
                       'weights', {{f*randn(5,5,3,5, 'single'), zeros(1,5, 'single')}});
net.layers{2} = struct('type', 'pool', ...
                       'method', 'max', ...
                       'pool', [2 2], ...
                       'stride', 2);
net.layers{3} = struct('type', 'conv', ...
                       'weights', {{f*randn(5,5,5,10, 'single'), zeros(1,10, 'single')}});
net.layers{4} = struct('type', 'pool', ...
                       'method', 'max', ...
                       'pool', [2 2], ...
                       'stride', 2);
net.layers{5} = struct('type', 'conv', ...
                       'weights', {{f*randn(5,5,10,classCount, 'single'), zeros(1,classCount, 'single')}});
net.layers{6} = struct('type', 'softmaxloss');

[net, stats] = cnn_train(net, {C L}, @(imdb, batch) getBatch(imdb, batch, use_gpu), ...
  'train', find(indices == 1), 'val', find(indices == 2), opts.train);
end


function [images, labels] = getBatch(imdb, batch, use_gpu)
%GETBATCH return a given set of images (and their labels) from imdb
%   If the dataset was too large to fit in memory, getBatch could load
%   images from disk instead (with indexes given in 'batch').
images = imdb{1}(:,:,:,batch);
labels = imdb{2}(batch);

if use_gpu
  images = gpuArray(images);
end
end
