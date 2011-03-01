classdef LabelsContainerFactory < handle
    methods
        function container = createContainer(self, height, width)
            container = LabelsContainer(height, width);
        end
    end
end
