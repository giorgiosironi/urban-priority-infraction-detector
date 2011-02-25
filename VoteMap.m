classdef VoteMap < handle
    properties(SetAccess=private)
        offsets; 
        distances;
    end
    methods
        function obj = VoteMap(offsets, distances)
            if (nargin < 2)
                offsets = [];
                distances = [];
            end
            obj.offsets = offsets;
            obj.distances = distances;
        end
        function vote(self, dx, dy, distance)
            self.offsets = [self.offsets; dx dy];
            self.distances = [self.distances; distance];
        end
    end
    methods(Static)
        function totalMap = combine(maps, combinationStrategy)
            offsets = maps{1}.offsets;
            distancesPerOffset = zeros(size(maps{1}.distances));
            for j=1:size(offsets, 1)
                dx = offsets(j, 1);
                dy = offsets(j, 2);
                distancesPerPatch = zeros(size(maps));
                for i=1:size(maps, 1)
                    distancesPerPatch(i) = maps{i}.distances(j);
                end
                distancesPerOffset(j) = combinationStrategy.combinePointVotes(distancesPerPatch);
            end
            totalMap = VoteMap(offsets, distancesPerOffset);
        end
    end
end
