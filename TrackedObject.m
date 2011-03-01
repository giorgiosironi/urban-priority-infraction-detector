classdef TrackedObject < handle
    properties
        areas;
    end
    methods
        function obj = TrackedObject(areas)
            obj.areas = areas;
        end
    end
end
