classdef Object < handle
    properties
        positions;
        frames;
    end
    methods
        function obj = Object(positions, frames)
            obj.positions = positions;
            obj.frames = frames;
        end
    end
    methods(Static)
        function o = fromKnownPosition(position, frame)
            o = Object({position.getAreas()}, [frame]); 
        end
    end
end
