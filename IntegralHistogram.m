classdef IntegralHistogram < handle
    properties
        content;
    end
    methods
        function obj = IntegralHistogram(sizeX, sizeY)
            obj.content = cell(sizeX, sizeY);
        end
        function setSingleHistogram(self, x, y, H)
            self.content{x, y} = H;
        end
        function H = getHistogram(self, area)
            H = self.content{area.maxX, area.maxY} - self.content{area.minX - 1, area.maxY} - self.content{area.maxX, area.minY - 1} + self.content{area.minX - 1, area.minY - 1};
        end
    end
end
