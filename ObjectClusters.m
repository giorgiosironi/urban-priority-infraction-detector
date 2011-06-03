classdef ObjectClusters < handle
    properties
        clusters;
    end
    methods
        function obj = ObjectClusters(clusters)
            obj.clusters = clusters;
        end
        function s = size(self)
            s = size(self.clusters);
        end
        function cluster = at(self, index)
            cluster = self.clusters{index};
        end
        function clusters = filter(self, areaFilter)
            clusters = {};
            for i=1:size(self.clusters, 1)
                clusters = [clusters; {self.clusters{i}.filter(areaFilter)}];
            end
            clusters = ObjectClusters(clusters);
        end
        function clusters = filterPositions(self, positionsFilter)
            clusters = {};
            for i=1:size(self.clusters, 1)
                clusters = [clusters; {self.clusters{i}.filterPositions(positionsFilter)}];
            end
            clusters = ObjectClusters(clusters);
        end
        function collidedObjects = detectCollisions(self)
            objects = {};
            for i=1:size(self.clusters, 1)
                objects = [objects; self.clusters{i}.objects];
            end
            for i=1:size(objects, 1)
                for j=1:size(objects, 1)
                    if (objects{i}.collidesWith(objects{j})) 
                        collidedObjects = {objects{i}; objects{j}};
                    end
                end
            end
        end
        function clusters = modelMovement(self, movement)
            clusters = {};
            for i=1:size(self.clusters, 1)
                clusters = [clusters; {self.clusters{i}.modelMovement(movement)}];
            end
            clusters = ObjectClusters(clusters);
        end
    end
end
