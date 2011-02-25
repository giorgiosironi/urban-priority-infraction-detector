classdef BackgroundRemover < handle
    properties
        maximumDistance;
        backgroundValue;
    end
    methods
        function obj = BackgroundRemover(maximumDistance, backgroundValue)
            obj.maximumDistance = maximumDistance;
            if (nargin == 2)
                obj.backgroundValue = backgroundValue;
            else
                obj.backgroundValue = 0;
            end
        end
        function video = filter(self, video)
            background = median(video, 4);
            videoLength = size(video, 4);
            channels = size(video, 3);
            for i=1:videoLength
                mask = (abs(video(:, :, :, i) - background) <= self.maximumDistance);
                for j=1:channels
                    channelsMask(:, :, j) = mask;
                end
                bg = channelsMask .* self.backgroundValue;
                fg = ~channelsMask .* video(:, :, :, i);
                video(:, :, :, i) = bg + fg;
            end
        end
    end
end
