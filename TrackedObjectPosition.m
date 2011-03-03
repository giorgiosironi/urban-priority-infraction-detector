classdef TrackedObjectPosition < handle
    properties
        patches;
    end
    methods
        function obj = TrackedObjectPosition(patches)
            obj.patches = patches;
        end
    end
end
