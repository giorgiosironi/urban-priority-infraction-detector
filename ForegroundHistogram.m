classdef ForegroundHistogram < handle
    properties(SetAccess=private)
        background;
        foreground;
    end
    methods(Static)
        function H = fromImageData(imagePatch)
            if (size(imagePatch, 1) == 0 || size(imagePatch, 2) == 0)
                error('The image is empty.')
            end
            bins = zeros(2, 1);
            bins(1) = sum(sum(imagePatch < 0));
            bins(2) = sum(sum(imagePatch >= 0));
            H = ForegroundHistogram(bins(1), bins(2));
        end
    end
    methods
        function obj = ForegroundHistogram(background, foreground)
            obj.background = background;
            obj.foreground = foreground;
        end
        function valid = isValid(self, threshold)
            if (self.percentualOfBackground() <= threshold)
                valid = 1;
            else
                valid = 0;
            end
        end
        function H = plus(first, second)
            H = ForegroundHistogram(first.bins + second.bins);
        end
        function H = minus(first, second)
            H = ForegroundHistogram(first.bins - second.bins);
        end
    end
    methods(Access=private)
        function percentual = percentualOfBackground(self)
            percentual = self.background / (self.foreground + self.background) * 100;
        end
    end
end
