classdef BackgroundRemover < handle
    properties
        maximumDistance;
    end
    methods
        function obj = BackgroundRemover(maximumDistance)
            obj.maximumDistance = maximumDistance;
        end
        function video = filter(self, video)
            background = median(video, 4);
            for i=1:size(video, 4)
                mask = abs(video(:, :, :, i) - background) > self.maximumDistance;
                video(:, :, :, i) = video(:, :, :, i) .* mask;
            end
        end
    end
end
