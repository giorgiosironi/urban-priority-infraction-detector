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
            equivalences = [];
            for x=1:sizeOfGroup(1)
                for y=1:sizeOfGroup(2)
                    if (isempty(histograms{x, y}))
                        continue;
                    end
                    westX = x;
                    westY = y-1;
                    northX = x-1;
                    northY = y;
                    if (westY > 0 && northX > 0)
                        if (~isempty(histograms{westX, westY}) && ~isempty(histograms{northX, northY}))
                            firstLabel = labels(westX, westY);
                            secondLabel = labels(northX, northY);
                            if (firstLabel ~= secondLabel) 
                                minimumLabel = min(firstLabel, secondLabel);
                                maximumLabel = max(firstLabel, secondLabel);
                                labels(x, y) = minimumLabel;
                                equivalences = [equivalences; minimumLabel, maximumLabel];
                            else 
                                labels(x, y) = firstLabel;
                            end
                            continue;
                        end
                    end
                    if (westY > 0)
                        if (~isempty(histograms{westX, westY})) 
                            labels(x, y) = labels(westX, westY);
                            continue;
                        end
                    end
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
            for i=1:size(equivalences, 1)
                from = equivalences(i, 1);
                to = equivalences(i, 2);
                indexes = find(labels == from);
                labels(indexes) = to;
            end
            labels
            objects = cell(0);
            for label=1:currentLabels
                areas = cell(0);
                for x=1:sizeOfGroup(1)
                    for y=1:sizeOfGroup(2)
                        if (labels(x, y) == label)
                            areas = [areas; {areaGroup.at(x, y)}];
                        end
                    end
                end
                if (size(areas, 1) > 0)
                    objects = [objects; {TrackedObject(areas)}];
                end
            end
        end
    end
end
