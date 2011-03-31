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
    end
end
