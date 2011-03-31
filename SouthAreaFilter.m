classdef SouthAreaFilter < handle
    methods
        function newAreas = filterAreas(self, areas)
            newAreas = {};
            for candidate=1:size(areas, 1)
                south = true;
                candidateC = areas{candidate}.getCentroid();
                for antagonist=1:size(areas, 1)
                    antagonistC = areas{antagonist}.getCentroid();
                    if (self.areNorthSouth(candidateC, antagonistC)) 
                        south = false;
                    end
                end
                if (south)
                    newAreas = [newAreas; areas(candidate)];
                end
            end
        end
    end
    methods(Access=private)
        function b = areNorthSouth(self, firstC, secondC)
            b = firstC(2) == secondC(2) && firstC(1) < secondC(1);
        end
    end
end
