classdef VoteMap < handle
    properties(SetAccess=private)
        offsets; 
        distances;
    end
    methods
        function obj = Patch()
            obj.offsets = [];
            obj.distances = [];
        end
        function vote(self, dx, dy, distance)
            self.offsets = [self.offsets; dx dy];
            self.distances = [self.distances; distance];
        end
    end
end
