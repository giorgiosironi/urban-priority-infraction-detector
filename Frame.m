classdef Frame < handle
    properties(SetAccess=private)
        content;
    end
    methods
        function obj = Frame(content)
            obj.content = content;
        end
    end
    methods(Static)
        function frame = fromFile(path)
            content = imread(path);
            frame = Frame(content);
        end
    end
end
