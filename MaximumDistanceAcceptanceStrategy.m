classdef MaximumDistanceAcceptanceStrategy < handle
    properties
        comparator;
        maximumDistance;
    end
    methods
        function obj = MaximumDistanceAcceptanceStrategy(comparator, maximumDistance)
            obj.comparator = comparator;
            obj.maximumDistance = maximumDistance;
        end
        function b = isTransitionAcceptable(self, oldHistogram, newHistogram)
            if (oldHistogram.getDistance(newHistogram, self.comparator) < self.maximumDistance) 
                b = true;               
            else
                b = false;
            end
        end
    end
end
