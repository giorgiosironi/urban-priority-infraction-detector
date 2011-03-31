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
    end
end
