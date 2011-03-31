classdef HistogramsTemplateUpdater < handle
    properties(SetAccess=private)
        acceptanceStrategy;
    end
    methods
        function obj = HistogramsTemplateUpdater(acceptanceStrategy)
            obj.acceptanceStrategy = acceptanceStrategy;
        end
        function newObject = updateTemplate(self, object, histograms)
            newPatches = cell(0);
            for i=1:size(object.patches, 1)
                oldPatch = object.patches{i};
                if (~histograms.getImageArea().contains(oldPatch.area))
                    newPatches = [newPatches; {oldPatch}];
                    continue;
                end
                oldHistogram = oldPatch.histogram;
                newHistogram = histograms.getHistogram(oldPatch.area);
                if (self.acceptanceStrategy.isTransitionAcceptable(oldHistogram, newHistogram))
                    newPatches = [newPatches; {Patch(newHistogram, oldPatch.area)}];
                else
                    newPatches = [newPatches; {oldPatch}];
                end
            end
            newObject = ObjectSighting(newPatches);
        end
    end
end
