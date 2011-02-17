classdef ObjectFinder < handle
    properties(SetAccess=private)
        tracker;
        grouper;
    end
    methods
        function obj = ObjectFinder(tracker, grouper)
            obj.tracker = tracker;
            obj.grouper = grouper;
        end
        function objects = getMovingObjects(self, frames) 
            tracks = self.tracker.extractTracks(frames);
            objects = self.grouper.group(tracks);
        end
    end
end

