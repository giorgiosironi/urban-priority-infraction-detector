classdef ObjectRepository < handle
    properties
        objects;
    end
    methods
        function initializeObjects(self, sightings, frame)
            for i=1:size(sightings, 1)
                newObject = Object.fromKnownSighting(sightings{i}, frame);
                self.objects = [self.objects; {newObject}];
            end
        end
        function trackObjects(self, oldSightings, newSightings, newFrame)
            oldObjectsNumber = size(oldSightings, 1);
            for i=1:oldObjectsNumber
                self.objects{i}.addKnownSighting(newSightings{i}, newFrame);
            end
            newObjectsNumber = size(newSightings, 1) - size(oldSightings, 1);
            for i=oldObjectsNumber+1:oldObjectsNumber+newObjectsNumber
                newObject = Object.fromKnownSighting(newSightings{i}, newFrame);
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
