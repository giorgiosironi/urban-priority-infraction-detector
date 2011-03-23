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
            oldObjectsNumber = size(oldPositions, 1);
            for i=1:oldObjectsNumber
                self.objects{i}.addKnownPosition(newPositions{i}, newFrame);
            end
            newObjectsNumber = size(newPositions, 1) - size(oldPositions, 1);
            for i=oldObjectsNumber+1:oldObjectsNumber+newObjectsNumber
                newObject = Object.fromKnownPosition(newPositions{i}, newFrame);
                self.objects = [self.objects; {newObject}];
            end
        end
    end
end
