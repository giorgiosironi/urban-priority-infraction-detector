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
            histograms = self.getForegroundAreas(frame, areaGroup);
            sizeOfGroup = size(histograms);
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
                    if (self.isValid(histograms, westX, westY) && self.isValid(histograms, northX, northY))
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
                    elseif (self.isValid(histograms, westX, westY))
                        labels(x, y) = labels(westX, westY);
                    elseif (self.isValid(histograms, northX, northY))
                        labels(x, y) = labels(northX, northY);
                    else
                        currentLabels = currentLabels + 1;
                        labels(x, y) = currentLabels;
                    end
                end
            end
            labels = self.unionOfEquivalences(labels, equivalences);
            objects = self.extractObjectsBySameLabel(labels, areaGroup);
        end
    end
    methods%(Access=private)
        function histograms = getForegroundAreas(self, frame, areaGroup)
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
        end
        function labels = unionOfEquivalences(self, labels, equivalences)
            for i=1:size(equivalences, 1)
                from = equivalences(i, 1);
                to = equivalences(i, 2);
                indexes = find(labels == from);
                labels(indexes) = to;
            end
        end
        function b = isValid(self, histograms, x, y)
            if (x <= 0|| y <= 0)
                b = 0;
                return;
            end
            b = ~isempty(histograms{x, y});
        end
        function objects = extractObjectsBySameLabel(self, labels, areaGroup)
            sizeOfGroup = size(areaGroup);
            objects = cell(0);
            for label=1:max(max(labels))
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
