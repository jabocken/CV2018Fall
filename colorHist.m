function hists = colorHist(ims, bins)
%COLORHIST Calculates color histograms for images

% each channel has its own bin count
hists = zeros(numel(ims), bins * 3);

for i = 1:numel(ims)
    im = ims(:,:,:,i);
    hr = histcounts(im(:,:,1), bins);
    hg = histcounts(im(:,:,2), bins);
    hb = histcounts(im(:,:,3), bins);

    hists(i,:) = [hr hg hb];
end
