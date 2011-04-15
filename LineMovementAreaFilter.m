classdef LineMovementAreaFilter < handle
    properties
        displacementCorrection;
    end
    methods
        function obj = LineMovementAreaFilter(displacementCorrection)
            obj.displacementCorrection = displacementCorrection;
        end
        function areas = filterAreas(self, areas)
            for i=1:size(areas, 1)
                areas{i} = areas{i}.displace(self.displacementCorrection(1), self.displacementCorrection(2));
            end
        end
    end
end

