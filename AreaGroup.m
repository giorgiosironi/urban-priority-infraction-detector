classdef AreaGroup < handle
    properties
        rectangle;
    end
    methods
        function obj = AreaGroup(rectangle)
            obj.rectangle = rectangle;
        end
        function area = at(self, x, y)
            area = self.rectangle{x, y};
        end
        function s = size(self)
            s = size(self.rectangle);
        end
    end
end
