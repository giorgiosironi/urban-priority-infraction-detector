classdef IntegralHistogramFactory < handle
    methods
        function integralH = buildFromImage(self, singleHistograms)
            if (isnumeric(singleHistograms))
                content = zeros(size(singleHistograms));
            else
                content = singleHistograms.empty();
            end
            for x=1:size(singleHistograms, 1)
                for y=1:size(singleHistograms, 2)
                    total = singleHistograms(x, y);
                    if (x-1 > 0)
                        total = total + content(x-1, y);
                    end
                    if (y-1 > 0)
                        total = total + content(x, y-1);
                    end
                    if (x-1 > 0 && y-1 > 0)
                        total = total - content(x-1, y-1);
                    end
                    content(x, y) = total;
                end
            end
            integralH = IntegralHistogram(content);
        end
    end
end
