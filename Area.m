classdef Area < handle
    properties(SetAccess=private)
        minX;
        minY;
        maxX;
        maxY;
    end
    methods(Access=private)
        function obj = Area(minX, minY, maxX, maxY)
            obj.minX = uint16(minX);
            obj.minY = uint16(minY);
            if (maxX < minX)
                error(sprintf('maxX=%d is less than minX=%d', maxX, minX));
            end
            obj.maxX = uint16(maxX);
            if (maxX < minX)
                error(sprintf('maxY=%d is less than minY=%d', maxY, minY));
            end
            obj.maxY = uint16(maxY);
        end
    end
    methods(Static)
        function area = fromXYtoXY(x1, y1, x2, y2)
            area = Area(x1, y1, x2, y2);
        end
    end
    methods
        function c = getCentroid(self)
            c = [(self.minX + self.maxX) / 2, (self.minY + self.maxY) / 2];
        end
        function area = displace(self, dx, dy)
            area = Area.fromXYtoXY(int16(self.minX) + dx, int16(self.minY) + dy, int16(self.maxX) + dx, int16(self.maxY) + dy);
        end
        function areas = getNeighbors(self)
            areas = {self.getWestNeighbor(); self.getSouthNeighbor(); self.getEastNeighbor(); self.getNorthNeighbor()}; 
        end
        function area = getWestNeighbor(self)
            dy = - int16(self.sizeY());
            area = self.displace(0, dy);
        end
        function area = getSouthNeighbor(self)
            dx = int16(self.sizeX());
            area = self.displace(dx, 0);
        end
        function area = getEastNeighbor(self)
            dy = int16(self.sizeY());
            area = self.displace(0, dy);
        end
        function area = getNorthNeighbor(self)
            dx = - int16(self.sizeX());
            area = self.displace(dx, 0);
        end
        function s = sizeX(self)
            s = self.maxX - self.minX + 1;
        end
        function s = sizeY(self)
            s = self.maxY - self.minY + 1;
        end
        function imageData = cut(self, image)
            imageData = image(self.minX:self.maxX, self.minY:self.maxY);
        end
        function b = equals(self, another)
            b = self.minX == another.minX && self.minY == another.minY && self.maxX == another.maxX && self.maxY == another.maxY;
        end
    end
end
