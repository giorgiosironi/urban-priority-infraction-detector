classdef RectificationAreaFilter < handle
    properties
        T;
    end
    methods
        function obj = RectificationAreaFilter(T)
            obj.T = T;
        end
        function areas = filterAreas(self, areas)
            for i=1:size(areas, 1)
                areas{i} = areas{i}.transform(self.T);
            end
        end
    end
end
