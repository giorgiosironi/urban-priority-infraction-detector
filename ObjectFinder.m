classdef ObjectFinder < handle
    properties(SetAccess=private)
        areaGroupSelector;
        foregroundValidityStrategy;
        labelsContainerFactory;
    end
    methods
        function obj = ObjectFinder(areaGroupSelector, foregroundValidityStrategy, labelsContainerFactory)
            obj.areaGroupSelector = areaGroupSelector;
            obj.foregroundValidityStrategy = foregroundValidityStrategy;
            obj.labelsContainerFactory = labelsContainerFactory;
        end
        function objects = findInForeground(self, frame, integralHistogram)
            areaGroup = self.areaGroupSelector.getAreaGroup(frame.getArea());
            foregroundAreas = self.getForegroundAreas(frame, areaGroup);
            sizeOfGroup = areaGroup.size();
            labels = self.labelsContainerFactory.createContainer(sizeOfGroup(1), sizeOfGroup(2));
            for x=1:sizeOfGroup(1)
                for y=1:sizeOfGroup(2)
                    if (foregroundAreas(x, y) == 0)
                        continue;
                    end
                    westX = x;
                    westY = y-1;
                    northX = x-1;
                    northY = y;
                    if (self.isValid(foregroundAreas, westX, westY) && self.isValid(foregroundAreas, northX, northY))
                        firstLabel = labels.at(westX, westY);
                        secondLabel = labels.at(northX, northY);
                        if (firstLabel ~= secondLabel) 
                            labels.label(x, y, firstLabel);
                            labels.unionOf(firstLabel, secondLabel);
                        else 
                            labels.label(x, y, firstLabel);
                        end
                    elseif (self.isValid(foregroundAreas, westX, westY))
                        labels.label(x, y, labels.at(westX, westY));
                    elseif (self.isValid(foregroundAreas, northX, northY))
                        labels.label(x, y, labels.at(northX, northY));
                    else
                        labels.label(x, y, labels.newLabel());
                    end
                end
            end
            objects = self.extractObjectsBySameLabel(labels, areaGroup, integralHistogram);
        end
    end
    methods(Access=private)
        function foregroundAreas = getForegroundAreas(self, frame, areaGroup)
            sizeOfGroup = areaGroup.size();
            foregroundAreas = zeros(sizeOfGroup);
            for x=1:sizeOfGroup(1)
                for y=1:sizeOfGroup(2)
                    area = areaGroup.at(x, y);
                    image = frame.cut(area);
                    if (self.foregroundValidityStrategy.isValid(image))
                        foregroundAreas(x, y) = 1;
                    end
                end
            end
        end
        function b = isValid(self, foregroundAreas, x, y)
            if (x <= 0|| y <= 0)
                b = false;
                return;
            end
            b = foregroundAreas(x, y);
        end
        function objects = extractObjectsBySameLabel(self, labelsContainer, areaGroup, integralHistogram)
            labels = labelsContainer.getLabels();
            objects = cell(0);
            for i=1:size(labels, 1)
                positions = labels{i};
                patches = cell(0);
                for j=1:size(positions, 1)
                    x = positions(j, 1);
                    y = positions(j, 2);
                    area = areaGroup.at(x, y);
                    histogram = integralHistogram.getHistogram(area);
                    patches = [patches; {Patch(histogram, area)}];
                end
                if (size(patches, 1) > 0)
                    objects = [objects; {ObjectSighting(patches)}];
                end
            end
        end
    end
end
