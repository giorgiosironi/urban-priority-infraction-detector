classdef ObjectCluster < handle
    properties
        objects;
    end
    methods
        function obj = ObjectCluster(objects)
            obj.objects = objects;
        end
        function s = size(self)
            s = size(self.objects);
        end
        function object = at(self, index)
            object = self.objects{index};
        end
        function cluster = filter(self, areaFilter)
            objects = {};
            for i=1:size(self.objects, 1)
                objects = [objects; {self.objects{i}.filter(areaFilter)}];
            end
            cluster = ObjectCluster(objects);
        end
    end
end