classdef StubTrackGrouper
    properties
        expectedInput;
        cannedResult;
    end
    methods
        function obj = StubTrackGrouper(expectedInput, cannedResult)
            obj.expectedInput = expectedInput;
            obj.cannedResult = cannedResult;
        end
        function objects = group(self, tracks)
            assertEqual(self.expectedInput, tracks);
            objects = self.cannedResult;
        end
    end
end
