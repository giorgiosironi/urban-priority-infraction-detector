classdef ObjectFinder < handle
    properties(SetAccess=private)
        areaGroupSelector;
        histogramStrategy;
        backgroundThreshold;
        labelsContainerFactory;
    end
    methods
        function obj = ObjectFinder(areaGroupSelector, histogramStrategy, backgroundThreshold, labelsContainerFactory)
            obj.areaGroupSelector = areaGroupSelector;
            obj.histogramStrategy = histogramStrategy;
            obj.backgroundThreshold = backgroundThreshold;
            obj.labelsContainerFactory = labelsContainerFactory;
        end
        function objects = findIn(self, frame)
            areaGroup = self.areaGroupSelector.getAreaGroup(frame.getArea());
            histograms = self.getForegroundAreas(frame, areaGroup);
            sizeOfGroup = size(histograms);
            labels = self.labelsContainerFactory.createContainer(sizeOfGroup(1), sizeOfGroup(2));
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
                        firstLabel = labels.at(westX, westY);
                        secondLabel = labels.at(northX, northY);
                        if (firstLabel ~= secondLabel) 
                            labels.label(x, y, firstLabel);
                            labels.unionOf(firstLabel, secondLabel);
                        else 
                            labels.label(x, y, firstLabel);
                        end
                    elseif (self.isValid(histograms, westX, westY))
                        labels.label(x, y, labels.at(westX, westY));
                    elseif (self.isValid(histograms, northX, northY))
                        labels.label(x, y, labels.at(northX, northY));
                    else
                        labels.label(x, y, labels.newLabel());
                    end
                end
            end
            objects = self.extractObjectsBySameLabel(labels, areaGroup, histograms);
        end
    end
    methods(Access=private)
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
        function b = isValid(self, histograms, x, y)
            if (x <= 0|| y <= 0)
                b = 0;
                return;
            end
            b = ~isempty(histograms{x, y});
        end
        function objects = extractObjectsBySameLabel(self, labelsContainer, areaGroup, histograms)
            labels = labelsContainer.getLabels();
            objects = cell(0);
            for i=1:size(labels, 1)
                positions = labels{i};
                patches = cell(0);
                for j=1:size(positions, 1)
                    x = positions(j, 1); %JJJJJ
                    y = positions(j, 2); % JJJJ
                    patches = [patches; {Patch(histograms{x, y}, areaGroup.at(x, y))}];
                end
                if (size(patches, 1) > 0)
                    objects = [objects; {TrackedObjectPosition(patches)}];
                end
            end
        end
    end
end
