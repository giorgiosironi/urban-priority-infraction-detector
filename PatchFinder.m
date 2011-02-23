classdef PatchFinder
    properties(SetAccess=private)
        maximumDx;
        maximumDy;
        comparator;
        binsNumber;
    end
    methods
        function obj = PatchFinder(maximumDx, maximumDy, comparator, binsNumber)
            obj.maximumDx = maximumDx;
            obj.maximumDy = maximumDy;
            obj.comparator = comparator;
            obj.binsNumber = 2;
            if (nargin > 3)
                obj.binsNumber = binsNumber;
            end
        end
    end
    methods
        % this will become: search(self, patch, cumulativeHistogram[WithWeightingDecorator]
        function voteMap = search(self, patch, image)
            voteMap = VoteMap();
            for dx=-1*self.maximumDx:self.maximumDx
                for dy=-1*self.maximumDy:self.maximumDy
                    candidateArea = patch.area.displace(dx, dy);
                    % this will become: cumulativeH.getHistogram(candidateArea)
                    cut = candidateArea.cut(image);
                    candidateHistogram = GrayHistogram.fromImageData(cut, self.binsNumber);
                    d = patch.histogram.getDistance(candidateHistogram, self.comparator);
                    voteMap.vote(dx, dy, d);
                end
            end
        end
    end
end
