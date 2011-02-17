classdef StubFeatureTracker < handle
    properties(SetAccess=private)
        expectedInput;
        cannedResult;
    end
    methods
        function obj = StubFeatureTracker(expectedInput, cannedResult)
            obj.expectedInput = expectedInput;
            obj.cannedResult = cannedResult;
        end
        function result = extractTracks(self, frames)
            assertEqual(self.expectedInput, frames);
            result = self.cannedResult;
        end
    end
end
