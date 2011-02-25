classdef SimpleComparator < handle
    methods
        function d = getDistance(self, firstHBins, secondHBins)
            firstHBins = firstHBins / norm(firstHBins);
            secondHBins = secondHBins / norm(secondHBins);
            difference = firstHBins - secondHBins;
            d = norm(difference);
        end
    end
end
