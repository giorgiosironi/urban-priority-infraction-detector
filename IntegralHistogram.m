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
            H = self.strategy.fromBinsData(squeeze(bins));
        end
        function s = size(self)
            s = size(self.content);
            s = s(1:2);
        end
    end
end
