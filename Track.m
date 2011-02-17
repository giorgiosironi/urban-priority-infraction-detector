classdef Track
    properties(SetAccess=private)
        xProgression;
        yProgression;
    end
    methods(Access=private)
        function obj = Track(xProgression, yProgression)
            obj.xProgression = xProgression;
            obj.yProgression = yProgression;
        end
    end
    methods(Static)
        function movement = fromXYtoXY(x1, y1, x2, y2)
            movement = Track([x1; x2], [y1; y2]);
        end
    end
end
