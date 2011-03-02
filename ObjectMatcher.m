classdef ObjectMatcher < handle
    properties
        dissimilarityStrategy;
    end
    methods
        function obj = ObjectMatcher(strategy)
            obj.dissimilarityStrategy = strategy;
        end
        function matches = match(self, objectGroup, secondObjectGroup)
            matches = cell(0);
            for i=1:size(objectGroup, 1)
                objectToMatch = objectGroup{i};
                minimumCandidate = 0;
                minimumDissimilarity = 1000000;
                for j=1:size(secondObjectGroup, 1)
                    candidate = secondObjectGroup{j};
                    currentDissimilarity = objectToMatch.getDissimilarity(candidate, self.dissimilarityStrategy);
                    if (currentDissimilarity < minimumDissimilarity)
                        minimumDissimilarity = currentDissimilarity;
                        minimumCandidate = candidate;
                    end
                end
                matches = [matches; {objectToMatch minimumCandidate}];
            end
        end
    end
end
