classdef ObjectSighting < handle
    properties
        patches;
        displacementFromPrevious;
    end
    methods
        function obj = ObjectSighting(patches, displacement)
            assert(1 >= size(patches, 2));
            obj.patches = patches;
            obj.displacementFromPrevious = int16(displacement);
        end
        function newPosition = move(self, dx, dy, limits)
            if (nargin == 3)
                limits = [10000 10000];
            end
            imageArea = Area.fromDimensions(limits(1), limits(2));
            newPatches = cell(0);
            for i=1:size(self.patches, 1)
                patch = self.patches{i};
                oldHistogram = patch.histogram;
                newArea = patch.area.displace(dx, dy);
                if (newArea.collidesWith(imageArea))
                    newPatches = [newPatches; {Patch(oldHistogram, newArea)}];
                end
            end
            newPosition = ObjectSighting(newPatches, [dx dy]);
        end
        function b = isOutOfImage(self)
            b = size(self.patches, 1) == 0;
        end
        function newSighting = addPatches(self, patches)
            newSighting = ObjectSighting.withoutDuplicates([self.patches; patches], self.displacementFromPrevious);
        end
        function position = getPosition(self)
            position = ObjectPosition(self.getAreas(), self.displacementFromPrevious);
        end
        function b = collidesWith(self, area)
            b = false;
            for i=1:size(self.patches, 1)
                if (self.patches{i}.area.collidesWith(area))
                    b = true;
                end
            end
        end
        function b = collidesWithObject(self, another) 
            b = false;
            for i=1:size(another.patches, 1)
                if (self.collidesWith(another.patches{i}.area))
                    b = true;
                end
            end
        end
        function areas = getAreas(self)
            areas = cell(0);
            for i=1:size(self.patches, 1)
                areas = [areas; {self.patches{i}.area}];
            end
        end
    end
    methods(Static)
        function newSighting = newSighting(patches)
            newSighting = ObjectSighting(patches, [0 0]);
        end
        function position = withoutDuplicates(patches, displacementFromPrevious)
            toDelete = [];
            for i=1:size(patches, 1)
                for j=i+1:size(patches, 1)
                    if (patches{i}.coversSameAs(patches{j})) 
                        toDelete = [toDelete; j];
                    end
                end
            end
            patches(toDelete) = [];
            position = ObjectSighting(patches, displacementFromPrevious);
        end
    end
end
