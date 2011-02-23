classdef GrayHistogram
    properties(SetAccess=private)
        bins;
    end
    methods
        function obj = GrayHistogram(bins)
            obj.bins = bins;
        end
    end
    methods(Static)
        function H = fromImageData(imagePatch, binsNumber)
            bins = zeros(binsNumber, 1);
            for i=1:size(imagePatch, 1)
                for j=1:size(imagePatch, 2)
                    bin = ceil(imagePatch(i, j) / 255 * binsNumber);
                    if (bin == 0) 
                        bin = 1;
                    end
                    bins(bin) = bins(bin) + 1;
                end
            end
            H = GrayHistogram(bins);
        end
    end
    methods
        function H = plus(first, second)
            H = GrayHistogram(first.bins + second.bins);
        end
        function H = minus(first, second)
            H = GrayHistogram(first.bins - second.bins);
        end
        function d = getDistance(self, anotherHistogram, comparator)
            d = comparator.getDistance(self.bins, anotherHistogram.bins);
        end
    end
end
