classdef ExpansionTemplateUpdater
    properties
        validityStrategy; 
    end
    methods
        function obj = ExpansionTemplateUpdater(validityStrategy)
            obj.validityStrategy = validityStrategy;
        end
        function objects = updateTemplate(self, objects, foreground, histograms)
            for i=1:size(objects, 1)
                newPatches = cell(0);
                for j=1:size(objects{i}.patches)
                    candidateArea = objects{i}.patches{j}.area.getWestNeighbor();
                    % for each candidateArea
                    candidatePortion = foreground.cut(candidateArea);
                    if (self.validityStrategy.isValid(candidatePortion))
                        newPatch = Patch(histograms.getHistogram(candidateArea), candidateArea);
                        newPatches = [newPatches; {newPatch}];
                    end
                end
                objects{i} = objects{i}.addPatches(newPatches);
            end
        end
    end
end
