classdef ObjectFinder < handle
    properties(SetAccess=private)
        areaGroupSelector;
        histogramStrategy;
        backgroundThreshold;
    end
    methods
        function obj = ObjectFinder(areaGroupSelector, histogramStrategy, backgroundThreshold)
            obj.areaGroupSelector = areaGroupSelector;
            obj.histogramStrategy = histogramStrategy;
            obj.backgroundThreshold = backgroundThreshold;
        end
        function objects = findIn(self, frame)
            areaGroup = self.areaGroupSelector.getAreaGroup(frame.getArea());
            sizeOfGroup = areaGroup.size();
            histograms = cell(sizeOfGroup);
            for x=1:sizeOfGroup(1)
                for y=1:sizeOfGroup(2)
                    patch = frame.cut(areaGroup.at(x, y));
                    histogram = self.histogramStrategy.fromPixelData(patch);
                    if (histogram.isValid(self.backgroundThreshold))
                        histograms{x, y} = histogram;
                    end
                end
            end
            labels = zeros(size(histograms));
            currentLabels = 0;
            for x=1:sizeOfGroup(1)
                for y=1:sizeOfGroup(2)
                    if (isempty(histograms{x, y}))
                        continue;
                    end
                    westX = x;
                    westY = y-1;
                    if (westY > 0)
                        if (~isempty(histograms{westX, westY})) 
                            labels(x, y) = labels(westX, westY);
                            continue;
                        end
                    end
                    northX = x-1;
                    northY = y;
                    if (northX > 0)
                        if (~isempty(histograms{northX, northY}))
                            labels(x, y) = labels(northX, northY);
                            continue;
                        end
                    end

                    labels(x, y) = currentLabels + 1;
                    currentLabels = currentLabels + 1;
                end
            end
            objects = cell(0);
            for label=1:currentLabels
                areas = cell(0);
                for x=1:sizeOfGroup(1)
                    for y=1:sizeOfGroup(2)
                        if (labels(x, y) == label)
                        end
                    end
                end
                objects = [objects; {TrackedObject(areas)}];
            end
        end
    end
end
