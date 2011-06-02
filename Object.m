classdef Object < handle
    properties
        positions;
        frames;
    end
    methods
        function obj = Object(positions, frames)
            assert(size(positions, 2) <= 1);
            assert(size(frames, 2) <= 1);
            assert(size(positions, 1) == size(frames, 1));
            obj.positions = positions;
            obj.frames = frames;
        end
        function addKnownSighting(self, sighting, frame)
            self.positions = [self.positions; {sighting.getPosition()}];
            self.frames = [self.frames; frame];
        end
        function b = passedFrom(self, area)
            b = false;
            for i=1:size(self.positions, 1)
                if (self.positions{i}.collidesWith(area))
                    b = true;
                end
            end
        end
        function object = filter(self, areaFilter)
            positions = {};
            for i=1:size(self.positions, 1)
                positions = [positions; {self.positions{i}.filter(areaFilter)}];
            end
            object = Object(positions, self.frames);
        end
        function object = filterPositions(self, positionsFilter)
            positions = {};
            for i=1:size(self.positions, 1)
                positions = positionsFilter.filterPositions(positions);
            end
            object = Object(positions, self.frames);
        end
        function object = modelMovement(self, movement)
            object = Object(movement.removeNoise(self.positions), self.frames);
        end
        function ds = getDisplacements(self)
            ds = [];
            for i=1:size(self.positions, 1)
                ds = [ds; self.positions{i}.displacementFromPrevious];
            end
        end
    end
    methods(Static)
        function o = fromKnownSighting(position, frame)
            o = Object({}, []); 
            o.addKnownSighting(position, frame);
        end
    end
end
