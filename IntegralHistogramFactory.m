classdef IntegralHistogramFactory < handle
    properties
        strategy;
    end
    methods
        function obj = IntegralHistogramFactory(strategy)
            obj.strategy = strategy;
        end
        function integralH = buildFromImage(self, image)
            bins = self.strategy.assignBin(image);
            content = zeros([size(image) self.strategy.binsNumber]);
            for x=1:size(bins, 1)
                for y=1:size(bins, 2)
                    content(x, y, bins(x, y)) = 1;
                    if (x-1 > 0)
                        content(x, y, :) = content(x, y, :) + content(x-1, y, :);
                    end
                    if (y-1 > 0)
                        content(x, y, :) = content(x, y, :) + content(x, y-1, :);
                    end
                    if (x-1 > 0 && y-1 > 0)
                        content(x, y, :) = content(x, y, :) - content(x-1, y-1, :);
                    end
                end
            end
            integralH = IntegralHistogram(content, self.strategy);
        end
    end
end
