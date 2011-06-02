classdef MaxSpeedPositionFilter
    methods
        function newPositions = filterPositions(self, positions)
            maxDisplacementNorm = 0;
            for i=1:size(positions, 1)
                 currentNorm = norm(double(positions{i}.displacementFromPrevious));
                 if (currentNorm > maxDisplacementNorm)
                     maxDisplacementNorm = currentNorm;
                 end
            end
            newPositions = cell(0);
            newPositions{1} = positions{1};
            cumulativeDisplacement = int16([0 0]);
            for i=2:size(positions, 1)
                oldDisplacement = positions{i}.displacementFromPrevious;
                correctionFactor = maxDisplacementNorm / norm(double(oldDisplacement));
                newDisplacement = oldDisplacement * correctionFactor;
                correctionDelta = newDisplacement - oldDisplacement + cumulativeDisplacement;
                cumulativeDisplacement = cumulativeDisplacement + correctionDelta;
                newPosition = positions{i}.filter(LineMovementAreaFilter(correctionDelta));
                newPosition = ObjectPosition(newPosition.areas, newDisplacement);
                newPositions = [newPositions; {newPosition}];
            end
        end
    end
end
