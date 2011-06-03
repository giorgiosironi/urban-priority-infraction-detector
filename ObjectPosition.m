classdef ObjectPosition < handle
    properties
        areas;
        displacementFromPrevious;
    end
    methods
        function obj = ObjectPosition(areas, displacement)
            assert(1 >= size(areas, 2));
            if (nargin < 2)
                displacement = [0 0];
            end
            obj.areas = areas;
            obj.displacementFromPrevious = int16(displacement);
        end
        function newPosition = filter(self, areaFilter)
            displacementStart = self.areas{1}.getCentroid();
            displacementStartArea = Area.singlePoint(displacementStart(1), displacementStart(2));
            displacementEnd = double(displacementStart) + double(self.displacementFromPrevious);
            displacementEndArea = Area.singlePoint(displacementEnd(1), displacementEnd(2));
            newDisplacement = [];
            displacementStartAreas = areaFilter.filterAreas({displacementStartArea});
            newStartArea = displacementStartAreas{1};
            displacementEndAreas = areaFilter.filterAreas({displacementEndArea});
            newEndArea = displacementEndAreas{1};
            newDisplacement = newEndArea.getCentroid() - newStartArea.getCentroid();

            areas = areaFilter.filterAreas(self.areas);
            newPosition = ObjectPosition(areas, newDisplacement);
        end
        function b = collidesWith(self, area)
            b = false;
            for j=1:size(self.areas, 1)
                if (self.areas{j}.collidesWith(area))
                    b = true;
                end
            end
        end
        function b = collidesWithPosition(self, anotherPosition)
            b = false;
            for j=1:size(anotherPosition.areas)
                if (self.collidesWith(anotherPosition.areas{j}))
                    b = true;
                end
            end
        end
        function p = changeDisplacement(self, displacement)
            p = ObjectPosition(self.areas, displacement);
        end
    end
end
