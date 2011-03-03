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
        function newPosition = addPatches(self, patches)
            newPosition = TrackedObjectPosition.withoutDuplicates([self.patches; patches]);
        end
        function b = collidesWith(self, area)
            b = false;
            for i=1:size(self.patches, 1)
                if (self.patches{i}.area.collidesWith(area))
                    b = true;
                end
            end
        end
    end
    methods(Static)
        function position = withoutDuplicates(patches)
            toDelete = [];
            for i=1:size(patches, 1)
                for j=i+1:size(patches, 1)
                    if (patches{i}.coversSameAs(patches{j})) 
                        toDelete = [toDelete; j];
                    end
                end
            end
            patches(toDelete) = [];
            position = TrackedObjectPosition(patches);
        end
    end
end
