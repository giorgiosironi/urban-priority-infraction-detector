classdef IntegralHistogram < handle
    properties
        content;
    end
    methods
        function obj = IntegralHistogram(content)
            obj.content = content;
        end
        function H = getHistogram(self, area)
            H = self.content(area.maxX, area.maxY) - self.content(area.minX - 1, area.maxY) - self.content(area.maxX, area.minY - 1) + self.content(area.minX - 1, area.minY - 1);
        end
    end
end
