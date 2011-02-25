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
            bottomRight = self.content(area.maxX, area.maxY, :);
            topLeft = self.content(area.minX - 1, area.minY - 1, :);
            topRight = self.content(area.minX - 1, area.maxY, :);
            bottomLeft = self.content(area.maxX, area.minY - 1, :);
            bins = bottomRight + topLeft - topRight - bottomLeft;
            H = self.strategy.fromBinsData(squeeze(bins));
        end
    end
end
