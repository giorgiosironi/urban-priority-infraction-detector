classdef CostMatrix < handle
    properties (SetAccess = private, GetAccess = public)
        A;
    end
    methods
        function obj = CostMatrix(A)
            obj.A = A;
        end
        function resultingMatrix = combineWith(self, anotherCostMatrix)
            newMatrix = [self.A; anotherCostMatrix.A];
            resultingMatrix = CostMatrix(newMatrix);
        end
        function vector = getMinimumVector(self)
            [U, D, V] = svd(self.A);
            vector = V(:, end);
        end
    end
end
