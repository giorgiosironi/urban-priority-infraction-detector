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
        function totalMap = sum(maps, threshold)
            offsets = maps{1}.offsets;
            distances = zeros(size(maps{1}.distances));
            for i=1:size(maps, 1)
                currentDistances = maps{i}.distances;
                if (nargin > 1)
                    mask = currentDistances > threshold;
                    currentDistances(mask) = threshold;
                end
                distances = distances + currentDistances;
            end
            totalMap = VoteMap(offsets, distances);
        end
    end
end
