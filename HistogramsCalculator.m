classdef HistogramsCalculator < handle
    properties
        strategy;
        factory;
    end
    methods
        function obj = HistogramsCalculator(strategy, factory)
            obj.strategy = strategy;
            obj.factory = factory;
        end
        function integralH = createIntegralHistogram(self, inputImage)
            singlePixelHistograms = self.strategy.getEmptyHistogram();
            for x=1:size(inputImage, 1)
                for y=1:size(inputImage, 2)
                    singlePixelHistograms(x, y) = self.strategy.fromPixelData(inputImage(x, y));
                end
                sprintf('created single histogram for line x=%d', x)
            end
            integralH = self.factory.buildFromImage(singlePixelHistograms);
        end
    end
end
