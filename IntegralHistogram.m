classdef IntegralHistogram < handle
    properties
        content;
    end
    methods
        function obj = IntegralHistogram(sizeX, sizeY)
            obj.content = cell(sizeX, sizeY);
        end
        function setCumulativeHistogramAt(self, x, y, H)
            self.content{x, y} = H;
        end
        function setPixel(self, x, y, singlePixelH)
            total = singlePixelH;
            if (x-1 > 0)
                total = total + self.content{x-1, y};
            end
            if (y-1 > 0)
                total = total + self.content{x, y-1};
            end
            if (x-1 > 0 && y-1 > 0)
                total = total - self.content{x-1, y-1};
            end
            self.content{x, y} = total;
        end
        function H = getHistogram(self, area)
            H = self.content{area.maxX, area.maxY} - self.content{area.minX - 1, area.maxY} - self.content{area.maxX, area.minY - 1} + self.content{area.minX - 1, area.minY - 1};
        end
    end
end
