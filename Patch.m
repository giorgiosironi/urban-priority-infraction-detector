classdef Patch
    properties(SetAccess=private)
        histogram;
        area;
    end
    methods
        function obj = Patch(histogram, area)
            obj.histogram = histogram;
            obj.area = area;
        end
    end
end
