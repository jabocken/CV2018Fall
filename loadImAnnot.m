function [annots] = loadImAnnot(imfile,annotfile)
%LOADIMANNOT Load image with component annotations and display

annotTable = readtable(annotfile);
position = table2array(annotTable(:,1:4));
label = table2array(annotTable(:,5));

im = imread(imfile);
imshow(im)

for i = 1:size(annotTable, 1) % loop needed for drawrectangle
    annots(i) = drawrectangle('Position', position(i,:), 'Label', label{i}); %#ok<AGROW>
end

end
