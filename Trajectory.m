classdef Trajectory < handle
    properties
        areas;
    end
    methods
        function obj = Trajectory(areas)
            obj.areas = areas;
        end
        function f = getFitness(self, object)
            total = size(self.areas, 1);
            passedFrom = 0;
            for i=1:total
                if (object.passedFrom(self.areas{i}))
                    passedFrom = passedFrom + 1;
                end
            end
            f = passedFrom / total;
        end
    end
end
