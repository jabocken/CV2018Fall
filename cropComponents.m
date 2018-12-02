function components = cropComponents(groundTruth, image)
%CROPCOMPONENTS Crops components from a full image based on ground truth
compArrays = {
    groundTruth.LabelData.R{1}
	groundTruth.LabelData.C{1}
	groundTruth.LabelData.H{1}
	groundTruth.LabelData.D{1}
	groundTruth.LabelData.L{1}
	groundTruth.LabelData.I{1}
};
labels = {'R' 'C' 'H' 'D' 'L' 'I'};
n = numel(compArrays);

count = 0;
for i = 1:n
    count = count + size(compArrays{i}, 1);
end
components = cell(count, 2);

ij = 1;
for i = 1:n
    for j = 1:size(compArrays{i}, 1)
        components{ij,2} = labels{i};
        im = imcrop(image, compArrays{i}(j,:));
        im = imresize(im, [32 32]);
        components{ij,1} = im;

        ij = ij + 1;
    end
end
end
