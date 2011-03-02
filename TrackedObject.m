classdef TrackedObject < handle
    properties
        areas;
    end
    methods
        function obj = TrackedObject(areas)
            obj.areas = areas;
        end
        function d = getDissimilarity(self, anotherObject, strategy)
           d = strategy.computeDistance(self.areas, anotherObject.areas); 
        end
    end
end
