function [C, L, LMap] = isolateComponents(imgPath)
% NOTE: I screwed up a bit with the ground truths -- the data sources
% point to other files. Suppress the warning since it's not needed.
warning('off', 'vision:groundTruth:badImageFiles');

F = dir(fullfile(imgPath, '*.jpg'));
fNumStrs = replace({F.name}, '.jpg', '');
fNums = sort(cellfun(@str2num, fNumStrs));

C = {};
L = {};
for num = fNums
   
    % Get image
    imgName = fullfile(imgPath, strcat(num2str(num), '.jpg'));
    img = imread(imgName);
    
    % Get ground truth
    gTruthName = fullfile(imgPath, strcat(num2str(num), '_gtruth.mat'));
    G = load(gTruthName, 'gTruth');
    
    % Crop components
    [c, l] = cropComponents(G.gTruth, img);
    C = [C; c];
    L = [L; l];

end

% Remove empty cells
% TODO: why are these empty?
mask = ~cellfun(@isempty, C);
C = C(mask);
L = L(mask);

% Map components to integers for easier classification
uniqueL = unique(L);
LMap = containers.Map();
for k = 1:numel(uniqueL)
    LMap(uniqueL{k}) = k;
end
L = cell2mat(values(LMap, L));
end


function [C, L] = cropComponents(G, I)
%CROPCOMPONENTS Crops components from a full image based on ground truth

    % Get labels for image
    labels = G.LabelDefinitions.Name;
    
    % Crop components for each label
    C = {};
    L = [];
    for label = labels'
        % Get locations
        locs = cell2mat(G.LabelData{:, label});
        numC = size(locs, 1);
        
        % Create cell arrays
        c = cell(numC, 1);
        l = cell(numC, 1);
        
        % Fill cell arrays
        for idx = 1:numC
            c{idx} = imcrop(I, locs(idx, :));
            l(idx) = label;
        end      
        
        % Concatenate with final arrays
        C = [C; c];
        L = [L; l];
    end
end
