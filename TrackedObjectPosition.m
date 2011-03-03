classdef TrackedObjectPosition < handle
    properties
        patches;
    end
    methods
        function obj = TrackedObjectPosition(patches)
            assert(1 == size(patches, 2));
            assert(size(patches, 1) > 0);
            obj.patches = patches;
        end
        function newPosition = move(self, dx, dy)
            newPatches = cell(0);
            for i=1:size(self.patches, 1)
                patch = self.patches{i};
                oldHistogram = patch.histogram;
                newArea = patch.area.displace(dx, dy);
                newPatches = [newPatches; {Patch(oldHistogram, newArea)}];
            end
            newPosition = TrackedObjectPosition(newPatches);
        end
    end
end
