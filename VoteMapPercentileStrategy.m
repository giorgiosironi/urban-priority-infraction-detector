classdef VoteMapPercentileStrategy
    properties
        percentile;
    end
    methods
        function obj = VoteMapPercentileStrategy(percentile)
            obj.percentile = percentile;
        end
        function estimate = combinePointVotes(self, votes)
            assert(size(votes, 1) > 1);
            votes = sort(votes);
            length = size(votes, 1);
            index = round(self.percentile / 100 * length);
            estimate = votes(index);
        end
    end
end
