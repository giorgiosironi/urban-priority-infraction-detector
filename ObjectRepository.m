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
        function objectsByTrajectory = clusterObjects(self, trajectories)
            objectsByTrajectory = cell(size(trajectories)); 
            for i=1:size(objectsByTrajectory, 1)
                objectsByTrajectory{i} = cell(0);
            end
            for j=1:size(self.objects)
                currentObject = self.objects{j};
                maximumFitness = 0;
                trajectory = 0;
                for i=1:size(trajectories, 1)
                    fitness = trajectories{i}.getFitness(currentObject);
                    if (fitness > maximumFitness)
                        maximumFitness = fitness;
                        trajectory = i;
                    end
                end
                objectsByTrajectory{trajectory} = [objectsByTrajectory{i}; {currentObject}];
            end
            for i=1:size(objectsByTrajectory, 1)
                objectsByTrajectory{i} = ObjectCluster(objectsByTrajectory{i});
            end
            objectsByTrajectory = ObjectClusters(objectsByTrajectory);
        end
    end
end
