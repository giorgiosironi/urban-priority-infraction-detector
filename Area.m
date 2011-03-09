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
            area = Area(int16(x1), int16(y1), int16(x2), int16(y2));
        end
        function area = fromDimensions(x, y)
            area = Area(int16(1), int16(1), int16(x), int16(y));
        end
    end
    methods
        function c = getCentroid(self)
            c = [(self.minX + self.maxX) / 2, (self.minY + self.maxY) / 2];
        end
        function area = displace(self, dx, dy)
            area = Area(self.minX + dx, self.minY + dy, self.maxX + dx, self.maxY + dy);
        end
        function areas = getNeighbors(self, wholeImageSize)
            if (nargin < 2)
                wholeImageSize = [10000 10000];
            end
            areas = {self.getWestNeighbor(); self.getSouthNeighbor(wholeImageSize(1)); self.getEastNeighbor(wholeImageSize(2)); self.getNorthNeighbor()}; 
            predicate = @(element) element == 0;
            areas(cellfun(predicate, areas)) = [];
        end
        function imageData = cut(self, image)
            imageData = image(self.minX:self.maxX, self.minY:self.maxY);
        end
        function b = equals(self, another)
            b = self.minX == another.minX && self.minY == another.minY && self.maxX == another.maxX && self.maxY == another.maxY;
        end
        function b = collidesWith(self, another)
            b = false;
            anotherFourCorners = another.getFourCorners();
            for i=1:4
                x = anotherFourCorners(i, 1);
                y = anotherFourCorners(i, 2);
                if (self.hasPoint(x, y))
                    b = true;
                end
            end
            selfFourCorners = self.getFourCorners();
            for i=1:4
                x = selfFourCorners(i, 1);
                y = selfFourCorners(i, 2);
                if (another.hasPoint(x, y))
                    b = true;
                end
            end
        end
    end
    methods(Access=private)
        function b = hasPoint(self, x, y)
            b = self.minX <= x && self.maxX >= x && self.minY <= y && self.maxY >= y;
        end
        function area = getWestNeighbor(self)
            dy = - int16(self.sizeY());
            if (dy + self.minY < 1)
                area = 0;
                return;
            end
            area = self.displace(0, dy);
        end
        function area = getSouthNeighbor(self, maximumX)
            dx = int16(self.sizeX());
            if (dx + self.maxX > maximumX)
                area = 0;
                return;
            end
            area = self.displace(dx, 0);
        end
        function area = getEastNeighbor(self, maximumY)
            dy = int16(self.sizeY());
            if (dy + self.maxY > maximumY)
                area = 0;
                return;
            end
            area = self.displace(0, dy);
        end
        function area = getNorthNeighbor(self)
            dx = - int16(self.sizeX());
            if (dx + self.minX < 1)
                area = 0;
                return;
            end
            area = self.displace(dx, 0);
        end
        function s = sizeX(self)
            s = self.maxX - self.minX + 1;
        end
        function s = sizeY(self)
            s = self.maxY - self.minY + 1;
        end
        function fourCorners = getFourCorners(self)
            fourCorners = [self.minX self.minY; self.minX self.maxY; self.maxX self.minY; self.maxX self.maxY];
        end
    end
end
