classdef VoteMapThresholdStrategy
    properties
        threshold;
    end
    methods
        function obj = VoteMapThresholdStrategy(threshold)
            obj.threshold = threshold;
        end
        function estimate = combinePointVotes(self, votes)
            mask = find(votes > self.threshold);
            votes(mask) = self.threshold;
            estimate = sum(votes);
        end
    end
end
