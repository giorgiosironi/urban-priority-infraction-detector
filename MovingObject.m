classdef MovingObject
    properties(SetAccess=private)
        frames;
        centroids;
    end
    methods
        function obj = MovingObject(frames, centroids)
            obj.frames = frames;
            obj.centroids = centroids;
        end
    end
end
