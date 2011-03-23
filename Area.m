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
            image = Area.fromDimensions(wholeImageSize(1), wholeImageSize(2));
            areas = {self.getWestNeighbor(); self.getSouthNeighbor(); self.getEastNeighbor(); self.getNorthNeighbor()}; 
            predicate = @(element) ~image.contains(element);
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
                if (self.expand(1).hasPoint(x, y))
                    b = true;
                end
            end
            selfFourCorners = self.getFourCorners();
            for i=1:4
                x = selfFourCorners(i, 1);
                y = selfFourCorners(i, 2);
                if (another.expand(1).hasPoint(x, y))
                    b = true;
                end
            end
        end
        function b = contains(self, anotherArea)
            b = anotherArea.minX >= self.minX && anotherArea.minY >= self.minY && anotherArea.maxX <= self.maxX && anotherArea.maxY <= self.maxY;
        end
        function a = limit(self, containerArea)
            minX = max(self.minX, containerArea.minX);
            minY = max(self.minY, containerArea.minY);
            maxX = min(self.maxX, containerArea.maxX);
            maxY = min(self.maxY, containerArea.maxY);
            a = Area.fromXYtoXY(minX, minY, maxX, maxY);
        end
    end
    methods(Access=private)
        function b = hasPoint(self, x, y)
            b = self.minX <= x && self.maxX >= x && self.minY <= y && self.maxY >= y;
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
        function fourCorners = getFourCorners(self)
            fourCorners = [self.minX self.minY; self.minX self.maxY; self.maxX self.minY; self.maxX self.maxY];
        end
        function a = expand(self, length)
            a = Area.fromXYtoXY(self.minX - length, self.minY - length, self.maxX + length, self.maxY + length);
        end
    end
end
