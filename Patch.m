classdef Patch < handle
    properties(SetAccess=private)
        histogram;
        area;
    end
    methods
        function obj = Patch(histogram, area)
            obj.histogram = histogram;
            obj.area = area;
        end
        function b = coversSameAs(self, anotherPatch)
            b = self.area.equals(anotherPatch.area);
        end
        function b = coversExactly(self, area)
            b = self.area.equals(area);
        end
    end
end
