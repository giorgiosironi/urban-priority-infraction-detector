classdef Frame < handle
    properties(SetAccess=private)
        content;
    end
    methods
        function obj = Frame(content)
            obj.content = content;
        end
        function area = getArea(self)
            dimensions = size(self.content);
            area = Area.fromXYtoXY(1, 1, dimensions(1), dimensions(2));
        end
        function result = cut(self, area)
            result = area.cut(self.content);
        end
    end
    methods(Static)
        function frame = fromFile(path)
            content = imread(path);
            frame = Frame(content);
        end
    end
end
