function plotMovement(positions)
markers = '.ox+*sdv^<>ph';
for i=1:size(positions, 1)
    hold on;
    for j=1:size(positions{i}.areas, 1)
        area = positions{i}.areas{j};
        centroid = area.getCentroid();
        plot(centroid(2), centroid(1), markers(i));
    end
    pause(5);
end

