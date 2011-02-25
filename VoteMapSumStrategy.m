classdef VoteMapSumStrategy
    methods
        function estimate = combinePointVotes(self, votes)
            estimate = sum(votes);
        end
    end
end
