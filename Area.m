classdef Area < handle
    properties(SetAccess=private)
        minX;
        minY;
        maxX;
        maxY;
    end
    methods(Access=private)
        function obj = Area(minX, minY, maxX, maxY)
            obj.minX = minX;
            obj.minY = minY;
            if (maxX < minX)
                error(sprintf('maxX=%d is less than minX=%d', maxX, minX));
            end
            obj.maxX = maxX;
            if (maxX < minX)
                error(sprintf('maxY=%d is less than minY=%d', maxY, minY));
            end
            obj.maxY = maxY;
        end
    end
    methods(Static)
        function area = fromXYtoXY(x1, y1, x2, y2)
            area = Area(x1, y1, x2, y2);
        end
    end
    methods
        function area = displace(self, dx, dy)
            area = Area.fromXYtoXY(self.minX + dx, self.minY + dy, self.maxX + dx, self.maxY + dy);
        end
        function imageData = cut(self, image)
            imageData = image(self.minX:self.maxX, self.minY:self.maxY);
        end
    end
end
