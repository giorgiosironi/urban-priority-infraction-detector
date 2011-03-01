classdef PatchesSelector < handle
    properties(SetAccess=private)
        xQuantity;
        yQuantity;
    end
    methods
        function obj = PatchesSelector(xQuantity, yQuantity)
            obj.xQuantity = xQuantity;
            obj.yQuantity = yQuantity;
        end
        function result = getAreaGroup(self, area)
            areas = cell(self.xQuantity, self.yQuantity);
            xTotalSize = area.maxX - area.minX + 1;
            yTotalSize = area.maxY - area.minY + 1;
            xSize = ceil(xTotalSize / self.xQuantity);
            ySize = ceil(yTotalSize / self.yQuantity);
            for i=1:self.xQuantity
                for j=1:self.yQuantity
                    minX = area.minX + xSize * (i-1);
                    minY = area.minY + ySize * (j-1);
                    maxX = minX + xSize - 1;
                    maxY = minY + ySize - 1;
                    maxX = min(maxX, area.maxX);
                    maxY = min(maxY, area.maxY);
                    subArea = Area.fromXYtoXY(minX, minY, maxX, maxY);
                    areas{i, j} = subArea;
                end
            end
            result = AreaGroup(areas);
        end
    end
end
