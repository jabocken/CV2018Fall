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
