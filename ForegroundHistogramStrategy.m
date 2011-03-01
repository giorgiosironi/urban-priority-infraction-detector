classdef ForegroundHistogramStrategy < handle
    methods
        function H = fromPixelData(self, pixel)
            H = ForegroundHistogram.fromImageData(pixel);
        end
    end
end
