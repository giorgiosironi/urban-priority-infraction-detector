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
        function a = getArea(self)
            a = Area.fromDimensions(size(self.content, 1), size(self.content, 2));
        end
        function result = cut(self, area)
            result = area.cut(self.content);
        end
        function frame = removeObjects(self, objects)
            content = self.content;
            for i=1:size(objects, 1)
                for j=1:size(objects{i}.patches)
                    area = objects{i}.patches{j}.area.limit(self.getArea());
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
