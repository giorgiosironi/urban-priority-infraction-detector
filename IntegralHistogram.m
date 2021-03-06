classdef IntegralHistogram < handle
    properties(SetAccess=private)
        content;
        contentSize;
        strategy;
    end
    methods
        function obj = IntegralHistogram(content, strategy)
            obj.content = content;
            obj.contentSize = size(content);
            obj.strategy = strategy;
        end
        function H = getHistogram(self, area)
            bins = self.content(area.maxX, area.maxY, :);
            if (area.minX > 1 && area.minY > 1)
                bins = bins + self.content(area.minX - 1, area.minY - 1, :);
            end
            if (area.minX > 1)
                bins = bins - self.content(area.minX - 1, area.maxY, :);
            end
            if (area.minY > 1)
                bins = bins - self.content(area.maxX, area.minY - 1, :);
            end
%            binsSize = size(bins);
%            newBins = zeros(binsSize(3));
            H = self.strategy.fromBinsData(bins(:));
        end
        function s = size(self)
            s = size(self.content);
            s = s(1:2);
        end
        function a = getImageArea(self)
            a = Area.fromDimensions(size(self.content, 1), size(self.content, 2));
        end
    end
end
