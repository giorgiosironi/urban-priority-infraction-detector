classdef HomographyEstimator
    methods
        function obj = HomographyEstimator
        end
        function T = getHomography(self, from, to)
            costMatrix = CostMatrix([]);
            for i=1:size(from, 1)
                costMatrix = costMatrix.combineWith(self.getCostMatrix(from(i, :), to(i, :)));
            end
            h = costMatrix.getMinimumVector();
            A = [h(1:3)'; h(4:6)'; h(7:9)']';
            T = maketform('projective', A);
        end
        function matrix = getCostMatrix(self, from, to)
            A = zeros(2, 9); 
            homogeneousFrom = [from(2) from(1) 1];
            homogeneousTo = [to(2) to(1) 1];
            A(1, 4:6) = -1 * homogeneousFrom;
            A(1, 7:9) = to(1) * homogeneousFrom;
            A(2, 1:3) = homogeneousFrom;
            A(2, 7:9) = -1 * to(2) * homogeneousFrom;
            matrix = CostMatrix(A);
        end
    end
end
