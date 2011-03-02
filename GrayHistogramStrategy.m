classdef GrayHistogramStrategy < handle
    properties(SetAccess=private)
        binsNumber;
    end
    methods
        function obj = GrayHistogramStrategy(binsNumber)
            obj.binsNumber = binsNumber;
        end
        function bin = assignBin(self, grayPixel)
            grayPixel = double(grayPixel);
            bin = ceil(grayPixel / 255 * self.binsNumber);
            correctIndex = find(bin == 0);
            bin(correctIndex) = 1;
        end
        function H = fromBinsData(self, binsData)
            H = GrayHistogram(binsData);
        end
    end
end
