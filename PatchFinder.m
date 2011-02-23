classdef PatchFinder
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
        function voteMap = search(self, patch, image)
            voteMap = VoteMap();
            for dx=-1*self.maximumDx:self.maximumDx
                for dy=-1*self.maximumDy:self.maximumDy
                    candidateArea = patch.area.displace(dx, dy);
                    cut = candidateArea.cut(image);
                    candidateHistogram = GreyHistogram.fromImageData(cut, 2);
                    d = patch.histogram.getDistance(candidateHistogram, self.comparator);
                    voteMap.vote(dx, dy, d);
                end
            end
        end
    end
end
