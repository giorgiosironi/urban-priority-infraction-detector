classdef IntegralHistogramFactory < handle
    methods
        function integralH = buildFromImage(self, singleHistograms, strategy)
            bins = size(singleHistograms(1, 1).bins, 1);
            content = zeros([size(singleHistograms) bins]);
            for x=1:size(singleHistograms, 1)
                for y=1:size(singleHistograms, 2)
                    total = singleHistograms(x, y).bins;
                    if (x-1 > 0)
                        total = total + squeeze(content(x-1, y, :));
                    end
                    if (y-1 > 0)
                        total = total + squeeze(content(x, y-1, :));
                    end
                    if (x-1 > 0 && y-1 > 0)
                        total = total - squeeze(content(x-1, y-1, :));
                    end
                    content(x, y, :) = total;
                end
            end
            integralH = IntegralHistogram(content, strategy);
        end
    end
end
