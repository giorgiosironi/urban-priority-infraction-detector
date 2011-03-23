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
        function addKnownPosition(self, position, frame)
            self.positions = [self.positions; {position.getAreas()}];
            self.frames = [self.frames; frame];
        end
    end
    methods(Static)
        function o = fromKnownPosition(position, frame)
            o = Object({}, []); 
            o.addKnownPosition(position, frame);
        end
    end
end
