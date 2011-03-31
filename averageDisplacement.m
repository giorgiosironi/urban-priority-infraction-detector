function displacement = averageDisplacement(positions)
displacement = int16([0 0]);
for i=1:size(positions, 1)
    displacement = displacement + positions{i}.displacementFromPrevious;
end
displacement = displacement / size(positions, 1);
