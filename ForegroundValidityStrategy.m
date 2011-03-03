classdef ForegroundValidityStrategy < handle
    properties(SetAccess=private)
        backgroundThreshold;
    end
    methods
        function obj = ForegroundValidityStrategy(backgroundThreshold)
            obj.backgroundThreshold = backgroundThreshold;
        end
        function b = isValid(self, imagePortion)
            if (size(imagePortion, 1) == 0 || size(imagePortion, 2) == 0)
                error('The image is empty.')
            end
            backgroundCount = double(sum(sum(imagePortion < 0)));
            totalCount = double(size(imagePortion, 1) * size(imagePortion, 2));
            b = backgroundCount / totalCount * 100 < self.backgroundThreshold;
        end
    end
end
