classdef GrayHistogramStrategy
    properties(SetAccess=private)
        binsNumber;
    end
    methods
        function obj = GrayHistogramStrategy(binsNumber)
            obj.binsNumber = binsNumber;
        end
        function H = fromPixelData(self, pixel)
            H = GrayHistogram.fromImageData(pixel, self.binsNumber);
        end
    end
end
