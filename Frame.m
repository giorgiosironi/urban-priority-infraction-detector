classdef Frame < handle
    properties(SetAccess=private)
        content;
    end
    methods
        function obj = Frame(content)
            assert(size(content, 1) > 0);
            assert(size(content, 2) > 0);
            obj.content = content;
        end
        function area = getArea(self)
            dimensions = size(self.content);
            area = Area.fromXYtoXY(1, 1, dimensions(1), dimensions(2));
        end
        function result = cut(self, area)
            result = area.cut(self.content);
        end
        function frame = removeObjects(self, objects)
            content = self.content;
            for i=1:size(objects, 1)
                for j=1:size(objects{i}.patches)
                    area = objects{i}.patches{j}.area;
                    content(area.minX:area.maxX, area.minY:area.maxY) = -1;
                end
            end
            frame = Frame(content);
        end
    end
    methods(Static)
        function frame = fromFile(path)
            content = imread(path);
            frame = Frame(content);
        end
    end
end
