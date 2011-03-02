classdef CornersObjectDistanceStrategy
    methods
        function d = computeDistance(self, firstAreas, secondAreas)
            corners = double(self.getMinimumBoundingRectangle(firstAreas));
            secondCorners = double(self.getMinimumBoundingRectangle(secondAreas));
            d = norm(corners - secondCorners);
        end
    end
    methods(Access=private)
        function corners = getMinimumBoundingRectangle(self, areas)
            minimum = areas{1}.getCentroid();
            minX = minimum(1);
            minY = minimum(2);
            maximum = areas{1}.getCentroid();
            maxX = maximum(1);
            maxY = maximum(2);
            for i=1:size(areas)
                current = areas{i}.getCentroid();
                x = current(1);
                y = current(2);
                if (x < minX)
                    minX = x;
                end
                if (y < minY)
                    minY = y;
                end
                if (x > maxX)
                    maxX = x;
                end
                if (y > maxY)
                    maxY = y;
                end
            end
            corners = [minX minY maxX maxY];
        end
    end
end
