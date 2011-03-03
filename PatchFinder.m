classdef PatchFinder < handle
    properties(SetAccess=private)
        maximumDx;
        maximumDy;
        comparator;
    end
    methods
        function obj = PatchFinder(maximumDx, maximumDy, comparator)
            obj.maximumDx = maximumDx;
            obj.maximumDy = maximumDy;
            obj.comparator = comparator;
        end
    end
    methods
        function voteMap = search(self, patch, histograms)
            if (self.isNotDisplaceable(patch.area, histograms.size()))
                voteMap = false;
                return;
            end
            voteMap = VoteMap();
            for dx=-1*self.maximumDx:self.maximumDx
                for dy=-1*self.maximumDy:self.maximumDy
                    candidateArea = patch.area.displace(dx, dy);
                    candidateHistogram = histograms.getHistogram(candidateArea);
                    d = patch.histogram.getDistance(candidateHistogram, self.comparator);
                    voteMap.vote(dx, dy, d);
                end
            end
        end
    end
    methods(Access=private)
        function b = isNotDisplaceable(self, area, imageSize)
            b = false;
            if (area.minX - self.maximumDx < 1)
                b = true;
            end
            if (area.minY - self.maximumDy < 1)
                b = true;
            end
            if (area.maxX + self.maximumDx > imageSize(1))
                b = true;
            end
            if (area.maxY+ self.maximumDy > imageSize(2))
                b = true;
            end
        end
    end
end
