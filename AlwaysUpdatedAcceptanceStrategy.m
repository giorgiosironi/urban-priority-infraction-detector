classdef AlwaysUpdatedAcceptanceStrategy < handle
    methods
        function b = isTransitionAcceptable(self, oldHistogram, newHistogram)
            b = true;               
        end
    end
end
