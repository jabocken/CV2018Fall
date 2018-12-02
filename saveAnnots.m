function saveAnnots(rectangles, filename)
%SAVEANNOTS Saves rectangle table to file
% struct2table doesn't seem to work here so we have to do it more manually
p = [rectangles.Position];
varNames = {'xmin', 'ymin', 'width', 'height'};
posTable = array2table(reshape(p, 4, [])', 'VariableNames', varNames);

label = {rectangles.Label}';
labelTable = table(label);

writetable([posTable labelTable], filename)

end
