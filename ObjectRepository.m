classdef ObjectRepository < handle
    properties
        objects;
    end
    methods
        function initializeObjects(self, positions, frame)
            for i=1:size(positions, 1)
                newObject = Object.fromKnownPosition(positions{i}, frame);
                self.objects = [self.objects; {newObject}];
            end
        end
        function trackObjects(self, oldPositions, newPositions, newFrame)
            for i=1:size(oldPositions, 1)
                self.objects{i}.addKnownPosition(newPositions{i}, newFrame);
            end
        end
    end
end
