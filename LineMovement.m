classdef LineMovement < handle
    properties
        halfWindow;
    end
    methods
        function obj = LineMovement(window)
            obj.halfWindow = floor(window / 2);
        end
        function positions = removeNoise(self, positions)
            for i=self.minPosition():self.maxPosition(positions)
                d = int16(zeros(1, 2));
                for j=self.start(i):self.stop(i)
                    d = d + positions{j}.displacementFromPrevious;
                end
                newDisplacement = d / self.window();
                deltaDisplacement = newDisplacement - positions{i}.displacementFromPrevious;
                areaFilter = LineMovementAreaFilter(deltaDisplacement);
                positions{i} = positions{i}.filter(areaFilter).changeDisplacement(newDisplacement);
            end
        end
    end
    methods(Access=private)
        function m = minPosition(self)
            m = self.halfWindow + 1;
        end
        function m = maxPosition(self, positions)
            m = size(positions, 1) - self.halfWindow;
        end
        function s = start(self, i)
            s = i - self.halfWindow;
        end
        function s = stop(self, i)
            s = i + self.halfWindow;
        end
        function w = window(self)
            w = self.halfWindow * 2 + 1;
        end
    end
end
