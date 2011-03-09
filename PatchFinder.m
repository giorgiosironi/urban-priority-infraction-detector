classdef PatchFinder < handle
    properties(SetAccess=private)
        maximumDx;
        maximumDy;
        step;
        comparator;
    end
    methods
        function obj = PatchFinder(maximumDx, maximumDy, step, comparator)
            obj.maximumDx = maximumDx;
            obj.maximumDy = maximumDy;
            obj.step = step;
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
            dx = self.getMinimumDx();
            while (dx <= self.maximumDx)
                dy = self.getMinimumDy();
                while (dy <= self.maximumDy)
                    candidateArea = patch.area.displace(dx, dy);
                    candidateHistogram = histograms.getHistogram(candidateArea);
                    d = patch.histogram.getDistance(candidateHistogram, self.comparator);
                    voteMap.vote(dx, dy, d);
                    dy = dy + self.step;
                end
                dx = dx + self.step;
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
        function dx = getMinimumDx(self)
            dx = -1*self.maximumDx + mod(self.maximumDx, self.step);
        end
        function dy= getMinimumDy(self)
            dy = -1*self.maximumDy + mod(self.maximumDy, self.step);
        end
    end
end
