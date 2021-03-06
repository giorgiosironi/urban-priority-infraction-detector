classdef ExpansionTemplateUpdater
    properties
        validityStrategy; 
    end
    methods
        function obj = ExpansionTemplateUpdater(validityStrategy)
            obj.validityStrategy = validityStrategy;
        end
        function newObjects = updateTemplate(self, objects, foreground, histograms, detectedObjects)
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
                                    % is not sufficient: we must look at new objects also
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
            for i=1:size(detectedObjects, 1)
                isNew = true;
                for j=1:size(newObjects)
                    if (newObjects{j}.collidesWithObject(detectedObjects{i}))
                        isNew = false;
%                        sprintf('new object %d collides with object %d', j, i)
                    end
                end
                if (isNew)
                    newObjects = [newObjects; detectedObjects(i)];
                end
            end
        end
    end
end
