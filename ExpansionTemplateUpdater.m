classdef ExpansionTemplateUpdater
    properties
        validityStrategy; 
    end
    methods
        function obj = ExpansionTemplateUpdater(validityStrategy)
            obj.validityStrategy = validityStrategy;
        end
        function newObjects = updateTemplate(self, objects, foreground, histograms)
            newObjects = cell(0);
            for i=1:size(objects, 1)
                newPatches = cell(0);
                for j=1:size(objects{i}.patches)
                    candidateAreas = objects{i}.patches{j}.area.getNeighbors(histograms.size());
                    for k=1:size(candidateAreas, 1)
                        candidateArea = candidateAreas{k};
                        candidatePortion = foreground.cut(candidateArea);
                        if (self.validityStrategy.isValid(candidatePortion))
                            inAnotherObject = false;
                            for l=1:size(objects, 1)
                                if (l ~= i && objects{l}.collidesWith(candidateArea))
                                    % we look in old objects
                                    % should suffice as new patches are only the ones entering the frame
                                    inAnotherObject = true;
                                end
                            end
                            if (~inAnotherObject)
                                newPatch = Patch(histograms.getHistogram(candidateArea), candidateArea);
                                newPatches = [newPatches; {newPatch}];
                            end
                        end
                    end
                end
                newObjects = [newObjects; {objects{i}.addPatches(newPatches)}];
            end
        end
    end
end
