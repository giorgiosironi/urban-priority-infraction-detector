classdef LabelsContainer < handle
    properties
        content;
        equivalences;
        currentLabels = 0;
    end
    methods
        function obj = LabelsContainer(height, width)
            obj.content = zeros(height, width);
            obj.equivalences = [];
        end
        function label(self, x, y, labelValue)
            self.content(x, y) = labelValue;
        end
        function labelValue = at(self, x, y)
            labelValue = self.content(x, y);
        end
        function unionOf(self, firstLabel, secondLabel)
            self.unionOfEquivalences(firstLabel, secondLabel);
        end
        function labels = getLabels(self)
            labels = self.extractPositionsBySameLabel();
        end
        function label = newLabel(self)
            self.currentLabels = self.currentLabels + 1;
            label = self.currentLabels;
        end
    end
    methods(Access=private)
        function unionOfEquivalences(self, firstLabel, secondLabel)
            from = find(self.content == firstLabel);
            self.content(from) = secondLabel;
        end
        function labels = extractPositionsBySameLabel(self)
            sizeOfGroup = size(self.content);
            labels = cell(0);
            for label=1:max(max(self.content))
                positions = [];
                for x=1:sizeOfGroup(1)
                    for y=1:sizeOfGroup(2)
                        if (self.content(x, y) == label)
                            positions = [positions; x, y];
                        end
                    end
                end
                if (size(positions, 1) > 0)
                    labels = [labels; {positions}];
                end
            end
        end
    end
end
